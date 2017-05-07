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
 * Returns the auction of a certain product
 * @param $productId
 * @return mixed
 */
function getAuctionIdFromProduct($productId){
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id 
    						FROM auction
    						WHERE auction.product_id = ?');
  $stmt->execute(array($productId));
  return $stmt->fetch()['id'];
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
 * Returns the product categories
 * @param $productId
 * @return array
 */
function getProductCategories($productId){
  global $conn;
  $stmt = $conn->prepare('SELECT category.name
                            FROM category
                            INNER JOIN product_category ON category.id = product_category.category_id 
                            WHERE product_category.product_id = ?');
  $stmt->execute(array($productId));
  $result = $stmt->fetchAll();
  return $result;
}

function getImage($imageId){
  global $conn;
  $stmt = $conn->prepare('SELECT *
                            FROM image
                            WHERE id = ?');
  $stmt->execute(array($imageId));
  $result = $stmt->fetch();
  return $result;
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
 * Returns the product characteristics
 *
 * @param $productId
 *
 * @return mixed
 */
function getProductCharacteristics($productId){
  global $conn;
  $stmt = $conn->prepare('SELECT unnest(characteristics::text[]) from product where id = ?');
  $stmt->execute(array($productId));
  return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
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
 * Checks if the category given exists in the respective table
 * @param $category
 * @return mixed
 */
function validCategory($category){
  global $conn;
  $stmt = $conn->prepare('SELECT * 
                          FROM category
                          WHERE name = ?');
  $stmt->execute(array($category));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Verifies if the image record exists in the database
 * @param $imageId
 * @param $productId
 * @param $originalName
 *
 * @return bool
 */
function validProductImage($imageId, $productId, $originalName){
  global $conn;
  $stmt = $conn->prepare('SELECT * 
                          FROM image
                          WHERE id = ? AND product_id = ? AND original_name = ?');
  $stmt->execute(array($imageId, $productId, $originalName));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Returns the id of the table with category name equal to the given on
 * @param $category
 * @return mixed
 */
function getCategoryId($category){
  global $conn;
  $stmt = $conn->prepare('SELECT id 
                          FROM category
                          WHERE name = ?');
  $stmt->execute(array($category));
  $result = $stmt->fetch();
  return $result['id'];
}

/**
 * Verifies if the data exists in the answer table
 * @param $answerId
 * @param $userId
 * @return bool
 */
function isAnswerCreator($answerId, $userId){
  global $conn;
  $stmt = $conn->prepare('SELECT * from answer
                            WHERE id = ? AND user_id = ?');
  $stmt->execute(array($answerId, $userId));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Verifies if the question data exists in the question table
 * @param $questionId
 * @param $userId
 * @return bool
 */
function isQuestionCreator($questionId, $userId){
  global $conn;
  $stmt = $conn->prepare('SELECT * from question
                            WHERE id = ? AND question.user_id = ?');
  $stmt->execute(array($questionId, $userId));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Retrieves a question
 * @param $id
 *
 * @return mixed
 */
function getQuestion($id){
  global $conn;
  $stmt = $conn->prepare('SELECT * from question WHERE id = ?');
  $stmt->execute(array($id));
  return $stmt->fetch();
}

/**
 * Retrieves an answer
 * @param $id
 *
 * @return mixed
 */
function getAnswer($id){
  global $conn;
  $stmt = $conn->prepare('SELECT * from answer WHERE id = ?');
  $stmt->execute(array($id));
  return $stmt->fetch();
}

/**
 * Returns the product images
 * @param $productId
 *
 * @return array
 */
function getProductImages($productId){
  global $conn;
  $stmt = $conn->prepare('SELECT * from image WHERE product_id = ?;');
  $stmt->execute(array($productId));
  return $stmt->fetchAll();
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
                          FROM auction as originalAuction, auction as similarAuction, product as originalProduct, product as similarProduct,
                          product_category as pc1, product_category as pc2
                          WHERE originalAuction.id = :original_auction_id
                          AND originalAuction.product_id = originalProduct.id
                          AND similarAuction.product_id = similarProduct.id
                          AND originalProduct.id = pc1.product_id
                          AND similarProduct.id = pc2.product_id
                          AND pc2.category_id = pc1.category_id
                          AND originalProduct.id != similarProduct.id
                          LIMIT 8');
  $stmt->bindParam('original_auction_id', $auctionId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns an array with the original names of the current images
 * @param $productId
 * @return array
 */
function getProductImagesOriginalNames($productId){
  global $conn;
  $stmt = $conn->prepare('SELECT image.original_name
                            FROM image
                            WHERE product_id = ?');
  $stmt->execute(array($productId));
  return $stmt->fetchAll(PDO::FETCH_COLUMN, 0);
}

/**
 * Places a bid on the respective auction, if the user's amount is larger than the auction's current bid
 * @param $amount
 * @param $bidderId
 * @param $auctionId
 * @return string
 * @internal param $amountId
 */
function bid($amount, $bidderId, $auctionId) {
  global $conn;

  $conn->beginTransaction();
  $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');

  $stmt = $conn->prepare('SELECT amount as balance FROM "user" WHERE "user".id = ?;');
  $stmt->execute(array($bidderId));
  $result = $stmt->fetch();
  $balance = $result['balance'];

  // Calculates the difference between the last bid and the current one.
  $stmt = $conn->prepare('SELECT amount
                          FROM bid
                          WHERE user_id = :user_id
                            AND auction_id = :auction_id
                          ORDER BY id DESC
                          LIMIT 1');
  $stmt->bindParam('user_id', $bidderId);
  $stmt->bindParam('auction_id', $auctionId);
  $stmt->execute();
  $alreadyBiddedAmount = $stmt->fetch()['amount'];

  $amountDiff = $amount;
  if($alreadyBiddedAmount > 0)
    $amountDiff = $amount - $alreadyBiddedAmount;

  if ($balance >= $amountDiff) {
    $stmt = $conn->prepare('INSERT INTO bid (amount, date, user_id, auction_id) 
                                VALUES (:amount, now(), :user_id, :auction_id)');
    $stmt->bindParam('amount', $amount);
    $stmt->bindParam('user_id', $bidderId);
    $stmt->bindParam('auction_id', $auctionId);
    $stmt->execute();

    $stmt = $conn->prepare('UPDATE "user"
                                SET amount = amount - :amount_bid
                                WHERE "user".id = :user_id;');
    $stmt->bindParam('amount_bid', $amountDiff);
    $stmt->bindParam('user_id', $bidderId);
    $stmt->execute();

    $conn->commit();
    return "Success 201 Created: Bet was correctly recorded.";
  }
  else {
    $conn->commit();
    return "Success 203: Insufficient funds. You don't have the necessary amount to place a new bid.";
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
    $elapsedQuestionSeconds = strtotime(date('Y-m-d H:m')) - strtotime($questions[$i]['date']);
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
    $elapsedAnswerSeconds = strtotime(date('Y-m-d H:m')) - strtotime($questions[$i]["answer_date"]);
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

/**
 * Returns the number of questions asked by an user in a given auction
 * @param $auctionId
 * @param $userId
 */
function getNumberQuestions($auctionId, $userId){
  global $conn;
  $stmt = $conn->prepare('SELECT count(*)
                            FROM question
                            WHERE auction_id = ? AND user_id = ?');
  $stmt->execute(array($auctionId, $userId));
  return $stmt->fetch()['count'];
}

/* ========================== INSERTS  ========================== */

/**
 * Adds a new auction to the database
 * @param $productName
 * @param $description
 * @param $condition
 * @param $category1
 * @param $category2
 * @param $userId
 * @param $startBid
 * @param $startDate
 * @param $endDate
 * @param $type
 * @param $quantity
 * @param $questionsSection
 * @param $notificationsEnabled
 * @param $characteristics
 */
function createAuction($productName, $description, $condition, $category1, $category2, $userId, $startBid, $startDate, $endDate, $type, $quantity, $questionsSection, $notificationsEnabled, $characteristics){
  global $conn;

  $conn->beginTransaction();
  $conn->exec('SET TRANSACTION ISOLATION LEVEL READ COMMITTED');

  $stmt = $conn->prepare('INSERT INTO product(name, description, condition)
                            VALUES(?, ?, ?) RETURNING id');
  $stmt->execute(array($productName, $description, $condition));
  $productId = $stmt->fetch()['id'];

  if(strlen($characteristics) != 0){
    $stmt = $conn->prepare('UPDATE product set characteristics = ? where id = ?;');
    $stmt->execute(array($characteristics, $productId));
  }

  if($category1 != NULL){
    $stmt = $conn->prepare('INSERT INTO product_category(product_id, category_id)
                            VALUES(?, ?)');
    $stmt->execute(array($productId, $category1));
  }

  if($category2 != NULL){
    $stmt = $conn->prepare('INSERT INTO product_category(product_id, category_id)
                            VALUES(?, ?)');
    $stmt->execute(array($productId, $category2));
  }

  $stmt = $conn->prepare('INSERT INTO auction(product_id, user_id, start_bid, curr_bid, start_date, end_date, date, type, quantity, questions_section)
                            VALUES(?, ?, ?, ?, ?, ?, now(), ?, ?, ?) RETURNING id');
  $stmt->execute(array($productId, $userId, $startBid, $startBid, $startDate, $endDate, $type, $quantity, $questionsSection));
  $auctionId = $stmt->fetch()['id'];

  $stmt = $conn->prepare('INSERT INTO watchlist(auction_id, user_id, date, notifications)
                            VALUES(?, ?, now(), ?)');
  $stmt->execute(array($auctionId, $userId, $notificationsEnabled));

  $conn->commit();
  return $auctionId;
}

/**
 * Adds a new product to the database
 * @param $productName
 * @param $description
 * @param $condition
 */
function createProduct($productName, $description, $condition){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO product(name, description, condition)
                            VALUES(?, ?, ?)');
  $stmt->execute(array($productName, $description, $condition));
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

/**
 * Creates an auction report
 * @param $auctionId
 * @param $message
 */
function createAuctionReport($auctionId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO auction_report(date, message, auction_id)
                            VALUES(now(), :message, :auction_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('auction_id', $auctionId);
  $stmt->execute();
}

/**
 * Creates a new product-category association
 * @param $productId
 * @param $categoryId
 */
function createProductCategory($productId, $categoryId){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO product_category(product_id, category_id)
                            VALUES(?, ?)');
  $stmt->execute(array($productId, $categoryId));
}

/**
 * Adds a picture associated to a product
 *
 * @param $productId
 * @param $extension
 * @param $caption
 * @param $name
 * @return mixed
 */
function addProductPicture($productId, $extension, $caption, $name){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO image(product_id, filename, description, original_name)
                            VALUES(?, ?, ?, ?) returning id');
  $stmt->execute(array($productId, '', $caption, $name));
  $imageId = $stmt->fetch()['id'];

  $stmt = $conn->prepare('update image set filename = ? where id = ?');
  $stmt->execute(array($imageId . '.' . $extension, $imageId));
  return $imageId;
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

/**
 * Updates the question section option
 * @param $auctionId
 * @param $qaSection
 */
function updateAuctionQA($auctionId, $qaSection){
  global $conn;
  $stmt = $conn->prepare('UPDATE auction
                            SET questions_section = ?
                            WHERE id = ?');
  $stmt->execute(array($qaSection, $auctionId));
}

/**
 * Updates the notifications option
 * @param $auctionId
 * @param $userId
 * @param $notificationsEnabled
 */
function updateWatchlistNotifications($auctionId, $userId, $notificationsEnabled){
  global $conn;
  $stmt = $conn->prepare('UPDATE watchlist
                            SET notifications = ?
                            WHERE auction_id = ? AND user_id = ?');
  $stmt->execute(array($notificationsEnabled, $auctionId, $userId));
}

/**
 * Updates an auction
 * @param $auctionId
 * @param $basePrice
 * @param $quantity
 * @param $startDate
 * @param $endDate
 * @param $auctionType
 */
function updateAuction($auctionId, $basePrice, $quantity, $startDate, $endDate, $auctionType){
  global $conn;
  $stmt = $conn->prepare('UPDATE auction
                            SET start_bid = ?, curr_bid = ?, quantity = ?, start_date = ?, end_date = ?, type = ? 
                            WHERE id = ?');
  $stmt->execute(array($basePrice, $basePrice, $quantity, $startDate, $endDate, $auctionType, $auctionId));
}

/**
 * Updates a product
 * @param $productId
 * @param $productName
 * @param $description
 * @param $condition
 * @param $characteristics
 */
function updateProduct($productId, $productName, $description, $condition, $characteristics){
  global $conn;
  if(strlen($characteristics) > 0){
    $stmt = $conn->prepare('UPDATE product
                            SET name = ?, description = ?, condition = ?, characteristics = ? 
                            WHERE id = ?');
    $stmt->execute(array($productName, $description, $condition, $characteristics, $productId));
  }else{
    $stmt = $conn->prepare('UPDATE product
                            SET name = ?, description = ?, condition = ?
                            WHERE id = ?');
    $stmt->execute(array($productName, $description, $condition, $productId));
  }
}

/* ========================== DELETES  ========================== */

/**
 * Delete auction.
 * @param $auctionId
 */
function deleteAuctionAdmin($auctionId){
  global $conn;

  $stmt = $conn->prepare('SELECT DISTINCT ON ("user".amount) "user".amount as amount
                          FROM "user"
                          JOIN bid ON "user".id = bid.user_id
                          JOIN auction ON bid.auction_id = auction.id
                          WHERE auction.id = :auction_id
                          ORDER BY bid.date DESC
                          LIMIT 1');
  $stmt->bindParam('auction_id', $auctionId);
  $stmt->execute();
  $wastedAmount = $stmt->fetch()['amount'];

  $stmt->prepare('UPDATE "user"
                  SET amount = amount + :wasted_amount');
  $stmt->bindParam('wasted_amount', $wastedAmount);
  $stmt->execute();

  $stmt = $conn->prepare('DELETE FROM auction
                          WHERE id = ?');
  $stmt->execute(array($auctionId));
}

function deleteAuction($auctionId){
  global $conn;
  $stmt = $conn->prepare('DELETE FROM auction
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

/**
 * Delete the product categories
 * @param $productId
 */
function deleteProductCategories($productId){
  global $conn;
  $stmt = $conn->prepare('DELETE FROM product_category
                            WHERE product_id = :id');
  $stmt->bindParam('id', $productId);
  $stmt->execute();
}

/**
 * Deletes the product image
 * @param $imageId
 */
function deleteProductPicture($imageId){
  global $conn;
  $stmt = $conn->prepare('DELETE FROM image
                            WHERE id = :id');
  $stmt->bindParam('id', $imageId);
  $stmt->execute();
}