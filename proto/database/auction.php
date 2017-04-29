<?php

/* ========================== SELECTS  ========================== */

/**
 * Returns an auction with the specified id.
 * @param $auctionId
 * @return mixed
 */
function getAuction($auctionId){
  global $conn;
  $stmt = $conn->prepare('SELECT * 
    						FROM auction 
    						WHERE auction.id = ?');
  $stmt->execute(array($auctionId));
  return $stmt->fetch();
}

/**
 * Returns the info about the auction in the user's watchlist
 * @param $userId
 * @param $auctionId
 * @return mixed
 */
function getWatchlistInfo($userId, $auctionId){
  global $conn;
  $stmt = $conn->prepare('SELECT * 
    						FROM watchlist
    						WHERE watchlist.user_id = ? AND watchlist.auction_id = ?');
  $stmt->execute(array($userId, $auctionId));
  return $stmt->fetch();
}

/**
 * Returns the product related to the given auction id
 * @param $auctionId
 * @return mixed
 */
function getAuctionProduct($auctionId){
  global $conn;
  $stmt = $conn->prepare('
                          SELECT product.*
                            FROM product
                            JOIN auction ON auction.product_id = product.id
                            WHERE auction.id = ?;');
  $stmt->execute(array($auctionId));
  return $stmt->fetch();
}

/**
 * Returns the product name
 * @param $productId
 * @return mixed
 */
function getProductName($productId){
  global $conn;
  $stmt = $conn->prepare('
                          SELECT product.name
                            FROM product
                            WHERE product.id = ?;');
  $stmt->execute(array($productId));
  $result = $stmt->fetch();
  return $result['name'];
}

/**
 * Checks if the auction type given exists in the auction_type enum
 * @param $auctionType
 * @return mixed
 */
function validAuctionType($auctionType){
  global $conn;
  $stmt = $conn->prepare('SELECT ? = ANY (SELECT unnest(enum_range(NULL::auction_type))::text)');
  $stmt->execute(array($auctionType));
  return $stmt->fetch()['?column?'];
}

/**
 * Verifies if an user is the owner of the given auction
 * @param $userId
 * @param $auctionId
 * @return bool
 */
function isOwner($userId, $auctionId){
  global $conn;
  $stmt = $conn->prepare('SELECT * from auction
                            WHERE auction.id = ? AND auction.user_id = ?');
  $stmt->execute(array($auctionId, $userId));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Checks if the category given exists in the category_type enum
 * @param $category
 * @return mixed
 */
function validCategory($category){
    global $conn;
    $stmt = $conn->prepare('SELECT ? = ANY (SELECT unnest(enum_range(NULL::category_type))::text)');
    $stmt->execute(array($category));
    return $stmt->fetch()['?column?'];
}

/**
 * Returns the last product id inserted
 * @return mixed
 */
function getLastProductID(){
    global $conn;
    $stmt = $conn->prepare('SELECT MAX(id) FROM product');
    $stmt->execute();
    return $stmt->fetch()['max'];
}

/**
 * Returns the last auction id inserted
 * @return mixed
 */
function getLastAuctionID(){
    global $conn;
    $stmt = $conn->prepare('SELECT MAX(id) FROM auction');
    $stmt->execute();
    return $stmt->fetch()['max'];
}

/**
 * Returns the last 5 bidders of an auction
 * @param $auctionId
 * @return array
 */
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

/**
 * Returns the total number of bids placed in an auction
 * @param $auctionId
 * @return mixed
 */
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

/**
 * Returns the users who bid on the auction
 * @param $auctionId
 * @return array
 */
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

/**
 * Returns the winner of an auction, if the auction is closed
 * @param $auctionId
 * @return mixed
 */
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

/**
 * Returns similar auctions to the given one
 * @param $auctionId
 * @return array
 */
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

/**
 * Places a bid on the respective auction, if the user's amount is larger than the auction's current bid
 * @param $amountId
 * @param $bidderId
 * @param $auctionId
 * @return string
 */
function bid($amountId, $bidderId, $auctionId) {
  global $conn;

  $conn->beginTransaction();
  $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');

  $stmt = $conn->prepare('SELECT amount as balance FROM "user" WHERE "user".id = ?;');
  $stmt->execute(array($bidderId));
  $result = $stmt->fetch();
  $balance = $result['balance'];

  if ($balance >= $amountId) {

    $stmt = $conn->prepare('INSERT INTO bid (amount, date, user_id, auction_id) 
                                VALUES (:amount, now(), :user_id, :auction_id)');
    $stmt->bindParam('amount', $amountId);
    $stmt->bindParam('user_id', $bidderId);
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();

    $stmt = $conn->prepare('UPDATE "user"
                                SET amount = amount - :amount_bid
                                WHERE "user".id = :user_id;');
    $stmt->bindParam('amount_bid', $auctionId);
    $stmt->bindParam('user_id', $bidderId);
    $stmt->execute();

    $conn->commit();
    return "Success 201 Created: Bet was correctly recorded.";
  }
  else {
    $conn->commit();
    return "Success 203: Insufficient funds.";
  }
}

/**
 * For the given auction, returns all the questions and respective answers
 * @param $auctionId
 * @return array
 */
function getQuestionsAnswers($auctionId){
  global $conn;

  $conn->beginTransaction();
  $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');

  $stmt = $conn->prepare('SELECT "user".username as user_username, "user".id as user_id, "user".profile_pic, question.message, question.date, question.id
                            FROM question
                            JOIN "user" ON question.user_id = "user".id
                            JOIN auction ON question.auction_id = auction.id
                            WHERE auction_id = :auction_id
                            ORDER BY question.date DESC');
  $stmt->bindParam('auction_id', $auctionId);
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

/**
 * Function that uses a transaction to create a new answer, and sends a notification to the answered user
 * @param $answerMessage
 * @param $questionId
 * @param $userId
 * @param $auctionId
 * @return string
 */
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

/* ========================== INSERTS  ========================== */

/**
 * Adds a new auction to the database
 * @param $productId
 * @param $userId
 * @param $startBid
 * @param $startDate
 * @param $endDate
 * @param $type
 * @param $quantity
 * @param $questionsSection
 */
function createAuction($productId, $userId, $startBid, $startDate, $endDate, $type, $quantity, $questionsSection){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO auction(product_id, user_id, start_bid, curr_bid, start_date, end_date, date, type, quantity, questions_section)
                            VALUES(?, ?, ?, ?, ?, ?, now(), ?, ?, ?)');
  $stmt->execute(array($productId, $userId, $startBid, $startBid, $startDate, $endDate, $type, $quantity, $questionsSection));
}

/**
 * Adds a new product to the database
 * @param $category
 * @param $productName
 * @param $description
 * @param $condition
 */
function createProduct($category, $productName, $description, $condition){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO product(type, name, description, condition)
                            VALUES(?, ?, ?, ?)');
  $stmt->execute(array($category, $productName, $description, $condition));
}

/**
 * Creates a new question associated to the given auction
 * @param $message
 * @param $userId
 * @param $auctionId
 */
function createQuestion($message, $userId, $auctionId) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO question(date, message, user_id, auction_id)
                            VALUES(now(), :message, :user_id, :auction_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('user_id', $userId);
  $stmt->bindParam('auction_id', $auctionId);
  $stmt->execute();
}

/**
 * Creates a new answer associated to the respective question
 * @param $message
 * @param $userId
 * @param $questionId
 * @return bool
 */
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

/**
 * Adds a new question report to the database
 * @param $questionId
 * @param $message
 */
function createQuestionReport($questionId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO question_report(date, message, question_id)
                            VALUES(now(), :message, :question_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('question_id', $questionId);
  $stmt->execute();
}

/**
 * Adds a new answer report to the database
 * @param $answerId
 * @param $message
 */
function createAnswerReport($answerId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO answer_report(date, message, answer_id)
                            VALUES(now(), :message, :answer_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('answer_id', $answerId);
  $stmt->execute();
}

/* ========================== UPDATES  ========================== */

/**
 * Updates the question message
 * @param $questionId
 * @param $updatedMessage
 */
function editQuestion($questionId, $updatedMessage) {
  global $conn;
  $stmt = $conn->prepare('UPDATE question
                            SET message = :updated_message
                            WHERE id = :id');
  $stmt->bindParam('updated_message', $updatedMessage);
  $stmt->bindParam('id', $questionId);
  $stmt->execute();
}

/**
 * Updates the answer message
 * @param $answerId
 * @param $updatedMessage
 */
function editAnswer($answerId, $updatedMessage) {
  global $conn;
  $stmt = $conn->prepare('UPDATE answer
                            SET message = :updated_message
                            WHERE id = :id');
  $stmt->bindParam('updated_message', $updatedMessage);
  $stmt->bindParam('id', $answerId);
  $stmt->execute();
}

/* ========================== DELETES  ========================== */

/**
 * Delete auction.
 * @param $auctionId
 */
function deleteAuction($auctionId){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                            FROM auction
                            WHERE id = ?');
  $stmt->execute(array($auctionId));
}

/**
 * Deletes the question with the specified id
 * @param $questionId
 */
function deleteQuestion($questionId) {
  global $conn;
  $stmt = $conn->prepare('DELETE FROM question
                            WHERE id = :id');
  $stmt->bindParam('id', $questionId);
  $stmt->execute();
}

/**
 * Deletes the answer with the specified id
 * @param $answerId
 */
function deleteAnswer($answerId) {
  global $conn;
  $stmt = $conn->prepare('DELETE FROM answer
                            WHERE id = :id');
  $stmt->bindParam('id', $answerId);
  $stmt->execute();
}