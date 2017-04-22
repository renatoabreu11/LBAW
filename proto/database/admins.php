<?php

function adminExists($username, $password){
    global $conn;
    $stmt = $conn->prepare('SELECT * FROM admin where username = ?');
    $stmt->execute(array($username));
    $result = $stmt->fetch();
    return ($result !== false && password_verify($password, $result["hashed_pass"]));
}

function getAdminID($username) {
    global $conn;
    $stmt = $conn->prepare('SELECT admin.id
                                    FROM admin
                                    WHERE username = ?');
    $stmt->execute(array($username));
    $result = $stmt->fetch();
    return $result['id'];
}

function validAdmin($username, $id){
    global $conn;
    $stmt = $conn->prepare('SELECT *
                                    FROM admin
                                    WHERE username = ? AND id = ?');
    $stmt->execute(array($username, $id));
    $result = $stmt->fetch();
    return $result !== false;
}

function createAdmin($username, $password, $email){
    global $conn;
    $options = ['cost' => 12];
    $stmt = $conn->prepare('INSERT INTO admin (username, hashed_pass, email) VALUES (?, ?, ?)');
    $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
    $stmt->execute(array($username, $encryptedPass, $email));
}

function getCategories(){
    global $conn;
    $stmt = $conn->prepare('SELECT unnest(enum_range(NULL::category_type))::text');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function getAnswerReports(){
    global $conn;
    $stmt = $conn->prepare(
        'SELECT answer_report.message, answer.id AS answer_id, "user".username, answer_report.date
                    FROM answer_report
                    JOIN answer ON answer_report.answer_id = answer.id
                    JOIN "user" ON answer.user_id = "user".id
                    ORDER BY DATE DESC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function getQuestionReports(){
    global $conn;
    $stmt = $conn->prepare(
        'SELECT question_report.message, question.id AS question_id, "user".username, question_report.date
                    FROM question_report
                    JOIN question ON question_report.question_id = question.id
                    JOIN "user" ON question.user_id = "user".id
                    ORDER BY DATE DESC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function getReviewReports(){
    global $conn;
    $stmt = $conn->prepare(
        'SELECT review_report.message, review.id, "user".username
                    FROM review_report
                    JOIN review ON review_report.review_id = review.id
                    JOIN bid ON review.bid_id = bid.id
                    JOIN "user" ON bid.user_id = "user".id
                    ORDER BY review_report.date DESC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function getAuctionReports(){
    global $conn;
    $stmt = $conn->prepare(
        'SELECT *
                    FROM auction_report
                    ORDER BY auction_report.date DESC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function getUserReports(){
    global $conn;
    $stmt = $conn->prepare(
        'SELECT user_report.*, "user".username
                    FROM user_report
                    INNER JOIN "user" ON user_report.user_id = "user".id
                    ORDER BY user_report.date DESC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function createCategory($title){
    global $conn;
    $stmt = $conn->prepare(
        'ALTER TYPE category_type ADD VALUE :title');
    $stmt->bindParam('title', $title);
    $stmt->execute();
}

function deleteUserReport($report_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                                FROM user_report WHERE id=?');
    $stmt->execute(array($report_id));
}

function deleteAuctionReport($report_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                                FROM auction_report WHERE id=?');
    $stmt->execute(array($report_id));
}

function deleteAnswerReport($report_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                                FROM answer_report WHERE id=?');
    $stmt->execute(array($report_id));
}

function deleteQuestionReport($report_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                                FROM question_report WHERE id=?');
    $stmt->execute(array($report_id));
}

function deleteReviewReport($report_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                                FROM review_report WHERE id=?');
    $stmt->execute(array($report_id));
}