<?php

function getAuction($auction_id){
    global $conn;
    $stmt = $conn->prepare('SELECT * 
    						FROM auction 
    						WHERE auction.id = ?');
    $stmt->execute(array($auction_id));
    return $stmt->fetch();
}

function getAuctionProduct($auction_id){
    global $conn;
    $stmt = $conn->prepare('
                          SELECT *
                            FROM product
                            JOIN auction ON auction.product_id = product.id
                            WHERE auction.id = ?;');
    $stmt->execute(array($auction_id));
    return $stmt->fetch();
}

function getProductName($product_id){
    global $conn;
    $stmt = $conn->prepare('
                          SELECT product.name
                            FROM product
                            WHERE product.id = ?;');
    $stmt->execute(array($product_id));
    $result = $stmt->fetch();
    return $result['name'];
}


function bid($amount_bid, $bidder_id, $auction_id) {
    global $conn;

    $conn->beginTransaction();
    $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');
    
    $stmt = $conn->prepare('SELECT amount as balance FROM "user" WHERE "user".id = ?;');
    $stmt->execute(array($bidder_id));
    $result = $stmt->fetch();
    $balance = $result['balance'];

    if ($balance >= $amount_bid) {
  
        $stmt = $conn->prepare('INSERT INTO bid (amount, date, user_id, auction_id) 
                                VALUES (:amount, now(), :user_id, :auction_id)');
        $stmt->bindParam('amount', $amount_bid);
        $stmt->bindParam('user_id', $bidder_id);
        $stmt->bindParam('auction_id', $auction_id);
        $stmt->execute();

        $stmt = $conn->prepare('UPDATE "user"
                                SET amount = amount - :amount_bid
                                WHERE "user".id = :user_id;');
        $stmt->bindParam('amount_bid', $amount_bid);
        $stmt->bindParam('user_id', $bidder_id);
        $stmt->execute();

        $conn->commit();
        return "Bet was correctly recorded.";
    }
    else {
        $conn->commit();
        return "Error: insufficient funds.";
    }
}

function getQuestionsAnswers($auction_id){
    global $conn;

    $conn->beginTransaction();
    $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');

    $stmt = $conn->prepare('SELECT * FROM question WHERE auction_id = ?;');
    $stmt->execute(array($auction_id));
    $questions = $stmt->fetchAll();

    for ($i = 0; $i < count($questions); $i++){
        $question_id = $questions[$i]['id'];
        $stmt = $conn->prepare('SELECT * FROM answer WHERE question_id = ?;');
        $stmt->execute(array($question_id));
        $answer = $stmt->fetch();
        $questions[$i]["answer"] = $answer;
    }
    $conn->commit();
    return $questions;
}

function answerQuestion($answerMessage, $questionId, $userId, $auctionId) {
    global $conn;

    $conn->beginTransaction();
    $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');

    // Insert new answer.
    $stmt = $conn->prepare('INSERT INTO answer(date, message, question_id, user_id, auction_id)
                            VALUES(now(), :message, :question_id, :user_id, :auction_id)');
    $stmt->bindParam('message', $answerMessage);
    $stmt->bindParam('question_id', $questionId);
    $stmt->bindParam('user_id', $userId);
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();

    // Send notification to the question answered user.
    $stmt = $conn->prepare('SELECT user_id
                            FROM question
                            WHERE id = :question_id');
    $stmt->bindParam('question_id', $questionId);
    $stmt->execute();
    $result = $stmt->fetch();
    $doubtUser = $result['user_id'];

    $stmt = $conn->prepare('SELECT notifications
                            FROM watchlist
                            WHERE user_id = :user_id
                            AND auction_id = :auction_id');
    $stmt->bindParam('user_id', $doubtUser);
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();
    $result = $stmt->fetch();
    $notificationsEnabled = $result['notifications'];

    if($notificationsEnabled) {
        $stmt = $conn->prepare("INSERT INTO notification(message, type, user_id, is_new, date)
                                VALUES('Your question at the auction was answered!',
                                        'Answer',
                                        :user_id,
                                        TRUE,
                                        now())");
        $stmt->bindParam('user_id', $doubtUser);
        $stmt->execute();

        $conn->commit();
        return 'Success: answer was posted and question user has received a notification.';
    } else {
        $conn->commit();
        return 'Success: answer was posted, but question user has disabled notifications.';
    }
}

function getRecentBidders($auctionId) {
    global $conn;
    $stmt = $conn->prepare('SELECT "user".username, "user".id, bid.amount, bid.date
                            FROM "user"
                            JOIN bid ON "user".id = bid.user_id
                            JOIN auction ON bid.auction_id = auction.id
                            WHERE auction.id = :auction_id
                            ORDER BY bid.amount DESC
                            LIMIT 5');
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();
    return $stmt->fetchAll();
}

function getTotalNumBids($auctionId) {
    global $conn;
    $stmt = $conn->prepare('SELECT count(*) as total
                            FROM bid
                            JOIN auction ON bid.auction_id = auction.id
                            WHERE auction.id = :auction_id');
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();
    return $stmt->fetch()['total'];
}

function getBidders($auctionId) {
    global $conn;
    $stmt = $conn->prepare('SELECT DISTINCT ON ("user".username) "user".username
                            FROM "user"
                            JOIN bid ON "user".id = bid.user_id
                            JOIN auction ON bid.auction_id = auction.id
                            WHERE auction.id = :auction_id');
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();
    return $stmt->fetchAll();
}

function getWinningUser($auctionId) {
    global $conn;
    $stmt = $conn->prepare('SELECT "user".username as user_username, "user".id as user_id
                            FROM "user"
                            JOIN bid ON bid.user_id = "user".id
                            JOIN auction ON auction.id = bid.auction_id
                            WHERE auction.id = :auction_id');
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();
    return $stmt->fetch();
}