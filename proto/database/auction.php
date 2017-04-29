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
    return "success: bet was correctly recorded.";
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

  $stmt = $conn->prepare('SELECT "user".username as user_username, "user".id as user_id, "user".profile_pic, question.message, question.date, question.id
                            FROM question
                            JOIN "user" ON question.user_id = "user".id
                            JOIN auction ON question.auction_id = auction.id
                            WHERE auction_id = :auction_id
                            ORDER BY question.date DESC');
  $stmt->bindParam('auction_id', $auction_id);
  $stmt->execute();
  $questions = $stmt->fetchAll();

  for ($i = 0; $i < count($questions); $i++) {
    // Determines if a question can be edited.
    $elapsedQuestionSeconds = time() - strtotime($questions[$i]['date']) - 3600;        // Minus 3600  because of time zone errors.
    $editTimeAllowed = 900;     //900 = 15 minutes * 60 seconds.
    if($elapsedQuestionSeconds <= $editTimeAllowed)
      $questions[$i]['can_edit'] = true;
    else $questions[$i]['can_edit'] = false;

    $question_id = $questions[$i]['id'];
    $stmt = $conn->prepare('SELECT answer.message, answer.date, answer.id
                                FROM answer
                                WHERE question_id = :question_id');
    $stmt->bindParam('question_id', $question_id);
    $stmt->execute();
    $answer = $stmt->fetch();

    $questions[$i]["answer_message"] = $answer['message'];
    $questions[$i]["answer_date"] = $answer['date'];
    $questions[$i]["answer_id"] = $answer['id'];

    // Determines if an answer can be edited.
    $elapsedAnswerSeconds = time() - strtotime($answer['date']) - 3600;
    if($elapsedAnswerSeconds <= $editTimeAllowed)
      $questions[$i]['answer_can_edit'] = true;
    else $questions[$i]['answer_can_edit'] = false;
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

function validCategory($category){
  global $conn;
  $stmt = $conn->prepare('SELECT ? = ANY (SELECT unnest(enum_range(NULL::category_type))::text)');
  $stmt->execute(array($category));
  return $stmt->fetch()['?column?'];
}

function createProduct($category, $product_name, $description, $condition){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO product(type, name, description, condition)
                            VALUES(?, ?, ?, ?)');
  $stmt->execute(array( $category, $product_name, $description, $condition));
}

function getLastProductID(){
  global $conn;
  $stmt = $conn->prepare('SELECT MAX(id) FROM product');
  $stmt->execute();
  return $stmt->fetch()['max'];
}

function getLastAuctionID(){
  global $conn;
  $stmt = $conn->prepare('SELECT MAX(id) FROM auction');
  $stmt->execute();
  return $stmt->fetch()['max'];
}

function validAuctionType($auction_type){
  global $conn;
  $stmt = $conn->prepare('SELECT ? = ANY (SELECT unnest(enum_range(NULL::auction_type))::text)');
  $stmt->execute(array($auction_type));
  return $stmt->fetch()['?column?'];
}

function getSimilarAuctions($auctionId) {
  global $conn;
  $stmt = $conn->prepare('SELECT similarAuction.id, similarProduct.name, (SELECT image.filename
                                                                            FROM image
                                                                            WHERE similarProduct.id = image.product_id
                                                                            LIMIT 1
                                                                            ) AS image
                            FROM auction originalAuction
                            JOIN auction similarAuction ON originalAuction.id != similarAuction.id
                            JOIN product originalProduct ON originalAuction.product_id = originalProduct.id
                            JOIN product similarProduct ON similarAuction.product_id = similarProduct.id
                            WHERE similarAuction.type = originalAuction.type
                            AND similarProduct.type && originalProduct.type
                            AND originalAuction.id = :original_auction_id
                            LIMIT 8');
  $stmt->bindParam('original_auction_id', $auctionId);
  $stmt->execute();
  return $stmt->fetchAll();
}

function isOwner($user_id, $auction_id){
  global $conn;
  $stmt = $conn->prepare('SELECT * from auction
                            WHERE auction.id = ? AND auction.user_id = ?');
  $stmt->execute(array($auction_id, $user_id));
  $result = $stmt->fetch();
  return $result !== false;
}

/************************************* INSERTS *************************************/

function createAuction($product_id, $user_id, $start_bid, $start_date, $end_date, $type, $quantity, $questions_section){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO auction(product_id, user_id, start_bid, curr_bid, start_date, end_date, date, type, quantity, questions_section)
                            VALUES(?, ?, ?, ?, ?, ?, now(), ?, ?, ?)');
  $stmt->execute(array($product_id, $user_id, $start_bid, $start_bid, $start_date, $end_date, $type, $quantity, $questions_section));
}

function createWatchlist($auction_id, $user_id, $notifications){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO watchlist(auction_id, user_id, date, notifications)
                            VALUES(?, ?, now(), ?)');
  $stmt->execute(array($auction_id, $user_id, $notifications));
}

function createQuestion($message, $userId, $auctionId) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO question(date, message, user_id, auction_id)
                            VALUES(now(), :message, :user_id, :auction_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('user_id', $userId);
  $stmt->bindParam('auction_id', $auctionId);
  $stmt->execute();
}

function createAnswer($message, $userId, $questionId) {
  global $conn;

  // First it verifies if the question already has an anwser (security reasons).
  $stmt = $conn->prepare('SELECT count(*)
                            FROM answer
                            JOIN question ON answer.question_id = question.id
                            WHERE question.id = :question_id');
  $stmt->bindParam('question_id', $questionId);
  $stmt->execute();
  $isValid = $stmt->fetch()['count'];

  if(!$isValid == 0)
    return false;

  $stmt = $conn->prepare('INSERT INTO answer(date, message, question_id, user_id)
                            VALUES(now(), :message, :question_id, :user_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('question_id', $questionId);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();

  return true;
}

function createQuestionReport($questionId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO question_report(date, message, question_id)
                            VALUES(now(), :message, :question_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('question_id', $questionId);
  $stmt->execute();
}

function createAnswerReport($answerId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO answer_report(date, message, answer_id)
                            VALUES(now(), :message, :answer_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('answer_id', $answerId);
  $stmt->execute();
}

/************************************* DELETES *************************************/

function deleteQuestion($questionId) {
  global $conn;
  $stmt = $conn->prepare('DELETE FROM question
                            WHERE id = :id');
  $stmt->bindParam('id', $questionId);
  $stmt->execute();
}

function deleteAnswer($answerId) {
  global $conn;
  $stmt = $conn->prepare('DELETE FROM answer
                            WHERE id = :id');
  $stmt->bindParam('id', $answerId);
  $stmt->execute();
}

/************************************* EDITS *************************************/

function editQuestion($questionId, $updatedMessage) {
  global $conn;
  $stmt = $conn->prepare('UPDATE question
                            SET message = :updated_message
                            WHERE id = :id');
  $stmt->bindParam('updated_message', $updatedMessage);
  $stmt->bindParam('id', $questionId);
  $stmt->execute();
}

function editAnswer($answerId, $updatedMessage) {
  global $conn;
  $stmt = $conn->prepare('UPDATE answer
                            SET message = :updated_message
                            WHERE id = :id');
  $stmt->bindParam('updated_message', $updatedMessage);
  $stmt->bindParam('id', $answerId);
  $stmt->execute();
}
