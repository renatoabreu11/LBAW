<?php

/* ========================== SELECTS  ========================== */

/**
 * Verifies if an admin exists
 * @param $username
 * @param $password
 * @return bool
 */
function adminExists($username, $password){
  global $conn;
  $stmt = $conn->prepare('SELECT * FROM admin where username = ?');
  $stmt->execute(array($username));
  $result = $stmt->fetch();
  return ($result !== false && password_verify($password, $result["hashed_pass"]));
}

/**
 * Returns the admin id to the respective admin's id
 * @param $username
 * @return mixed
 */
function getAdminID($username) {
  global $conn;
  $stmt = $conn->prepare('SELECT admin.id
                                    FROM admin
                                    WHERE username = ?');
  $stmt->execute(array($username));
  $result = $stmt->fetch();
  return $result['id'];
}

/**
 * Checks if the records exist in the database
 * @param $username
 * @param $id
 * @return bool
 */
function validAdmin($username, $id){
  global $conn;
  $stmt = $conn->prepare('SELECT *
                                    FROM admin
                                    WHERE username = ? AND id = ?');
  $stmt->execute(array($username, $id));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Return all feedback given by users
 * * @return array
 */
function getFeedback(){
  global $conn;
  $stmt = $conn->prepare('SELECT feedback.*, "user".username, "user".profile_pic
                            FROM feedback
                            INNER JOIN "user" ON feedback.user_id = "user".id
                            ORDER BY DATE DESC;');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all categories
 * @return array
 */
function getCategories(){
  global $conn;
  $stmt = $conn->prepare('SELECT unnest(enum_range(NULL::category_type))::text');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all auction types
 * @return array
 */
function getAuctionTypes(){
  global $conn;
  $stmt = $conn->prepare('SELECT unnest(enum_range(NULL::auction_type))::text');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all answer reports
 * @return array
 */
function getAnswerReports(){
  global $conn;
  $stmt = $conn->prepare(
    'SELECT answer_report.*, "user".username, "user".id as user_id
                    FROM answer_report
                    JOIN answer ON answer_report.answer_id = answer.id
                    JOIN "user" ON answer.user_id = "user".id
                    ORDER BY DATE DESC;');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all question reports
 * @return array
 */
function getQuestionReports(){
  global $conn;
  $stmt = $conn->prepare(
    'SELECT question_report.*, "user".username, "user".id as user_id
                    FROM question_report
                    JOIN question ON question_report.question_id = question.id
                    JOIN "user" ON question.user_id = "user".id
                    ORDER BY DATE DESC;');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all review reports
 * @return array
 */
function getReviewReports(){
  global $conn;
  $stmt = $conn->prepare(
    'SELECT review_report.*, "user".username, "user".id as user_id
                    FROM review_report
                    JOIN review ON review_report.review_id = review.id
                    JOIN bid ON review.bid_id = bid.id
                    JOIN "user" ON bid.user_id = "user".id
                    ORDER BY review_report.date DESC;');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Return all auction reports
 * @return array
 */
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

/**
 * Return all user reports
 * @return array
 */
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

/* ========================== INSERTS  ========================== */

/**
 * Creates a new admin
 * @param $username
 * @param $password
 * @param $email
 */
function createAdmin($username, $password, $email){
  global $conn;
  $options = ['cost' => 12];
  $stmt = $conn->prepare('INSERT INTO admin (username, hashed_pass, email) VALUES (?, ?, ?)');
  $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
  $stmt->execute(array($username, $encryptedPass, $email));
}

/**
 * Creates a new category
 * @param $title
 */
function createCategory($title){
  global $conn;
  $stmt = $conn->prepare(
    'ALTER TYPE category_type ADD VALUE :title');
  $stmt->bindParam('title', $title);
  $stmt->execute();
}

/* ========================== UPDATES  ========================== */

/* ========================== DELETES  ========================== */

/**
 * Delete a record from the feedback table
 * @param $id
 */
function deleteFeedback($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                            FROM feedback
                            WHERE id = ?');
  $stmt->execute(array($id));
}

/**
 * Delete a record from the user reports table
 * @param $id
 */
function deleteUserReport($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM user_report WHERE id=?');
  $stmt->execute(array($id));
}

/**
 * Delete a record from the auction reports table
 * @param $id
 */
function deleteAuctionReport($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM auction_report WHERE id=?');
  $stmt->execute(array($id));
}

/**
 * Delete a record from the answer reports table
 * @param $id
 */
function deleteAnswerReport($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM answer_report WHERE id=?');
  $stmt->execute(array($id));
}

/**
 * Delete a record from the question reports table
 * @param $id
 */
function deleteQuestionReport($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM question_report WHERE id=?');
  $stmt->execute(array($id));
}

/**
 * Delete a record from the review reports table
 * @param $id
 */
function deleteReviewReport($id){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM review_report WHERE id=?');
  $stmt->execute(array($id));
}