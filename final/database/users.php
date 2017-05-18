<?php

/* ========================== SELECTS  ========================== */

/**
 * Selects the top ten ranking users, accordingly to their rating
 * @return array
 */
function getTopTenRankingUsers() {
  global $conn;
  $stmt = $conn->prepare('SELECT "user".id, "user".username, "user".rating
                                FROM "user"
                                WHERE "user".rating IS NOT NULL
                                ORDER BY rating DESC
                                LIMIT 10;');
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the user that has the given email
 * @param $userEmail
 * @return mixed
 */
function getUserByEmail($userEmail){
    global $conn;
    $stmt = $conn->prepare('SELECT *
                                FROM "user"
                                WHERE email=:user_email');
    $stmt->bindParam('user_email', $userEmail);
    $stmt->execute();
    return $stmt->fetch();
}

/**
 * Returns the username of the user that has the given email
 * @param $userEmail
 * @return mixed
 */
function getUserUsername($userEmail){
    global $conn;
    $stmt = $conn->prepare('SELECT "user".username
                                FROM "user"
                                WHERE email=:user_email');
    $stmt->bindParam('user_email', $userEmail);
    $stmt->execute();
    return $stmt->fetch()['username'];
}

/**
 * Returns the column from the table "user" that has the given primary key
 * @param $userId
 * @return mixed
 */
function getUser($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT *
                                FROM "user"
                                WHERE id=:user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetch();
}

/**
 * Returns the user_id of the user that has the username equal to the given one
 * @param $username
 * @return mixed
 */
function getUserID($username) {
  global $conn;
  $stmt = $conn->prepare('SELECT "user".id
                                    FROM "user"
                                    WHERE username = ?');
  $stmt->execute(array($username));
  $result = $stmt->fetch();
  return $result['id'];
}

/**
 * Returns all the users stored in the database
 * @return array
 */
function getAllUsers(){
  global $conn;
  $stmt = $conn->prepare('SELECT *
                                FROM "user" 
                                ORDER BY id ASC');
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the city and country of the user selected
 * @param $userId
 * @return mixed
 */
function getCityAndCountry($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT city.name as city_name, city.id as city_id, country.name as country_name, country.id as country_id
                                FROM "user"
                                JOIN city ON "user".city_id = city.id
                                JOIN country ON city.country_id = country.id
                                WHERE "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetch();
}

/**
 * Returns the credit of an user.
 * @param $userId
 * @return credit of user
 */
function getCreditOfUser($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT amount
                          FROM "user"
                          WHERE "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['amount'];
}

/**
 * Returns the number of bets in game of an user.
 * @param $userId
 * @return number of bets in game of user
 */
function getBetsOnGame($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT COUNT(*)
                          FROM bid, "user", auction
                          WHERE bid.user_id = "user".id
                          AND bid.auction_id = auction.id
                          AND bid.amount = auction.curr_bid
                          AND state = \'Open\'
                          AND "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['count'];
}

/**
 * Returns the value of bets in game of an user.
 * @param $userId
 * @return value of bets in game of user
 */
function getValBetsOnGame($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT SUM(bid.amount)
                          FROM bid, "user", auction
                          WHERE bid.user_id = "user".id
                          AND bid.auction_id = auction.id
                          AND bid.amount = auction.curr_bid
                          AND state = \'Open\'
                          AND "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['sum'];
}

/**
 * Returns the number of auctions created by an user
 * @param $userId
 * @return mixed
 */
function getNumTotalAuctions($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT COUNT(*)
                                FROM auction
                                JOIN "user" ON auction.user_id = "user".id
                                WHERE "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['count'];
}

/**
 * Returns the info about the active auctions of an user
 * @param $userId
 * @return array
 */
function getActiveAuctions($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT product.name, (
                                SELECT image.filename
                                FROM image
                                WHERE image.product_id = product.id
                                LIMIT 1
                                ) AS image, product.description, auction.*
                                FROM auction
                                JOIN product ON auction.product_id = product.id
                                JOIN "user" ON auction.user_id = "user".id
                                WHERE state IN (\'Open\', \'Closed\')
                                AND "user".id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns all the reviews made to a user.
 * @param $userId
 * @return array
 */
function getReviews($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT review.rating, buyer.id as reviewer_id, buyer.username AS reviewer_username, review.date, product.name as product_name, review.message, auction.id as auction_id, 
                                    (SELECT image.filename 
                                    FROM image
                                    WHERE product.id = image.product_id 
                                    LIMIT 1) as image_filename
                                FROM review
                                INNER JOIN bid ON review.bid_id = bid.id
                                INNER JOIN auction ON bid.auction_id = auction.id
                                INNER JOIN "user" buyer ON bid.user_id = buyer.id
                                INNER JOIN product ON auction.product_id = product.id
                                INNER JOIN "user" seller ON auction.user_id = seller.id
                                WHERE seller.id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns all the auctions that user has won.
 * @param $userId
 * @return array
 */
function getWins($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT product.name as product_name, product.description, auction.id as auction_id, auction.start_bid, auction.curr_bid, auction.end_date, seller.username as seller_username, seller.id as seller_id, bid.id as bid_id,
                                    (SELECT image.filename 
                                    FROM image
                                    WHERE product.id = image.product_id 
                                    LIMIT 1) as image_filename
                                FROM auction
                                JOIN product ON auction.product_id = product.id
                                JOIN bid ON auction.id = bid.auction_id
                                AND auction.curr_bid = bid.amount
                                JOIN "user" winner ON bid.user_id = winner.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                WHERE now() > auction.end_date
                                AND winner.id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the bid id's of the won auctions that were already reviewed by the user.
 * Used to compare bid id's with the won auction, in order to determine if it's possible
 * to write a review to that auction.
 * @param $userId
 * @return array
 */
function getWonReviews($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT DISTINCT bid.id as bid_id
                                FROM auction
                                JOIN bid ON auction.id = bid.auction_id
                                AND auction.curr_bid = bid.amount
                                JOIN "user" winner ON bid.user_id = winner.id
                                JOIN review ON bid.id = review.bid_id
                                WHERE winner.id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns all the users the user is following.
 * @param $followingUserId
 * @return array
 */
function getFollowingUsers($followingUserId) {
  global $conn;
  $stmt = $conn->prepare('SELECT us1.id, us1.profile_pic, us1.name, us1.username
                                FROM follow
                                INNER JOIN "user" us1 ON follow.user_followed_id = us1.id
                                INNER JOIN "user" us2 ON follow.user_following_id = us2.id
                                WHERE us2.id = :following_user_id');
  $stmt->bindParam('following_user_id', $followingUserId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 review made by the user.
 * @param $userId
 * @return array
 */
function getLastReviews($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT review.id AS review_id, auction.id AS auction_id, seller.username AS seller_username, seller.id as seller_id, review.date
                                FROM review
                                JOIN bid ON review.bid_id = bid.id
                                JOIN auction ON bid.auction_id = auction.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                JOIN "user" own ON bid.user_id = own.id
                                WHERE own.id = :user_id
                                ORDER BY review.date DESC
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 bids made by the user.
 * @param $userId
 * @return array
 */
function getLastBids($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT bid.amount, auction.id AS auction_id, bid.date, seller.id as seller_id, seller.username as seller_username
                                FROM bid
                                INNER JOIN "user" own ON bid.user_id = own.id
                                JOIN auction ON bid.auction_id = auction.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                WHERE own.id = :user_id
                                ORDER BY bid.date DESC
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 followed users.
 * @param $userId
 * @return array
 */
function getLastFollows($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT followed.username AS followed_username, followed.id as followed_id, follow.date
                                FROM follow
                                JOIN "user" followed ON follow.user_followed_id = followed.id
                                JOIN "user" following ON follow.user_following_id = following.id
                                WHERE following.id = :user_id
                                ORDER BY follow.date
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 wins.
 * @param $userId
 * @return array
 */
function getLastWins($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.end_date, seller.username as seller_username, auction.id as auction_id, seller.id as seller_id
                                FROM auction
                                JOIN bid ON auction.id = bid.auction_id AND auction.curr_bid = bid.amount
                                JOIN "user" winner ON bid.user_id = winner.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                WHERE now() > auction.end_date
                                AND winner.id = :user_id
                                ORDER BY auction.end_date DESC
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 question posted by the user.
 * @param $userId
 * @return array
 */
function getLastQuestions($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT own.username AS own_username, question.id AS question_id, auction.id AS auction_id, seller.username AS seller_username, question.date
                                FROM question
                                JOIN "user" own ON question.user_id = own.id
                                JOIN auction ON question.auction_id = auction.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                WHERE own.id = :user_id
                                ORDER BY question.date DESC
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns the last 2 auctions added to the watchlist.
 * @param $userId
 * @return array
 */
function getLastWatchlistAuctions($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT "user".username, auction.id, product.name, watchlist.date
                                FROM watchlist
                                JOIN "user" ON watchlist.user_id = "user".id
                                JOIN auction ON watchlist.auction_id = auction.id
                                JOIN product ON auction.product_id = product.id
                                WHERE "user".id = :user_id
                                ORDER BY watchlist.date DESC
                                LIMIT 2');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Makes the user follow another user.
 * Insert in the database.
 * @param $followingUserId
 * @param $followedUserId
 */
function followUser($followingUserId, $followedUserId) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO follow
                                VALUES (:followed_user_id, :following_user_id, now())');
  $stmt->bindParam('following_user_id', $followingUserId);
  $stmt->bindParam('followed_user_id', $followedUserId);
  $stmt->execute();
}

/**
 * Return 1 if the 'followingUserId' is following 'followedUserId'.
 * Return 0 otherwise.
 * @param $followingUserId
 * @param $followedUserId
 * @return mixed
 */
function getIsFollowing($followingUserId, $followedUserId) {
  global $conn;
  $stmt = $conn->prepare('SELECT count(*)
                                FROM follow
                                WHERE user_followed_id = :followed_user_id
                                AND user_following_id = :following_user_id');
  $stmt->bindParam('followed_user_id', $followedUserId);
  $stmt->bindParam('following_user_id', $followingUserId);
  $stmt->execute();
  return $stmt->fetch();
}

/**
 * Returns the user password
 * @param $userId
 * @return mixed
 */
function getPassword($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT hashed_pass
                                FROM "user"
                                WHERE id = :user_id');
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['hashed_pass'];
}

/**
 * Returns all countries in the database.
 */
function getAllCountries() {
  global $conn;
  $stmt = $conn->prepare('SELECT name, id
                                FROM country
                                ORDER BY name ASC');
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Returns all cities in the database.
 */
function getAllCities() {
  global $conn;
  $stmt = $conn->prepare('SELECT name, country_id, id
                                FROM city
                                ORDER BY name ASC');
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Verifies if an user exists in the database
 * @param $username
 * @param $password
 * @return bool
 */
function userExists($username, $password){
  global $conn;
  $stmt = $conn->prepare('SELECT * FROM "user" WHERE "user".username = ?');
  $stmt->execute(array($username));
  $result = $stmt->fetch();
  return ($result !== false && password_verify($password, $result["hashed_pass"]));
}

/**
 * Verifies if the info in the parameters is associated with any user
 * @param $username
 * @param $id
 * @return bool
 */
function validUser($username, $id){
  global $conn;
  $stmt = $conn->prepare('SELECT *
                                        FROM "user"
                                        WHERE username = ? AND id = ?');
  $stmt->execute(array($username, $id));
  $result = $stmt->fetch();
  return $result !== false;
}

/**
 * Returns the active notifications (not read), with a limit of 5 elements.
 * @param $userId
 * @return array
 */
function getActiveNotifications($userId){
  global $conn;
  $stmt = $conn->prepare('SELECT notification.*
                                FROM notification
                                INNER JOIN "user" ON notification.user_id = "user".id
                                WHERE is_new = TRUE AND "user".id = ?
                                ORDER BY date DESC
                                LIMIT 5;');
  $stmt->execute(array($userId));
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Function useful to achieve pagination. Returns the notifications within the range necessary to each page
 * @param $userId
 * @param $items
 * @param $offset
 * @return array
 */
function getPageNotifications($userId, $items, $offset){
  global $conn;
  $stmt = $conn->prepare('SELECT *
                                FROM notification
                                WHERE user_id = ?
                                  ORDER BY is_new DESC , date DESC
                                LIMIT ?
                                OFFSET ?');
  $stmt->execute(array($userId, $items, $offset));
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Counts the number of notification that an user has
 * @param $userId
 * @return mixed
 */
function countNotifications($userId){
  global $conn;
  $stmt = $conn->prepare('SELECT COUNT(*)
                                FROM notification
                                WHERE user_id = ?');
  $stmt->execute(array($userId));
  $result = $stmt->fetch();
  return $result['count'];
}

/**
 * Returns the user profile pic
 * @param $userId
 *
 * @return mixed
 */
function getProfilePic($userId) {
  global $conn;
  $stmt = $conn->prepare('SELECT profile_pic
                          FROM "user"
                          WHERE id = :id');
  $stmt->bindParam('id', $userId);
  $stmt->execute();
  return $stmt->fetch()['profile_pic'];
}

/**
 * Returns the recovery request id
 * @param $email
 * @param $token
 *
 * @return mixed
 */
function getPasswordRecoveryRequestId($email, $token) {
  global $conn;
  $stmt = $conn->prepare('SELECT id
                          FROM password_request
                          WHERE email = :email
                            AND token = :token');
  $stmt->bindParam('email', $email);
  $stmt->bindParam('token', $token);
  $stmt->execute();
  return $stmt->fetch()['id'];
}

/**
 * Verifies if the given email exists in the database
 * @param $email
 */
function validEmail($email){
  global $conn;
  $stmt = $conn->prepare('SELECT EXISTS
                            (SELECT id
                            FROM "user"
                            WHERE email = :email)');
  $stmt->bindParam('email', $email);
  $stmt->execute();
  return $stmt->fetch()['exists'];
}

/* ========================== Inserts  ========================== */

/**
 * Insert a new user to the database
 * @param $name
 * @param $username
 * @param $password
 * @param $email
 * @param $description
 */
function createUser($name, $username, $password, $email, $description) {
  global $conn;
  $options = ['cost' => 12];
  $stmt = $conn->prepare('INSERT INTO "user" (name, username, hashed_pass, email, short_bio, register_date) VALUES (?, ?, ?, ?, ?, now())');
  $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
  $stmt->execute(array($name, $username, $encryptedPass, $email, $description));
}

/**
 * Insert a review.
 * @param $rating
 * @param $message
 * @param $bidId
 */
function insertReview($rating, $message, $bidId) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO review (rating, message, date, bid_id)
                                VALUES (:rating, :message, now(), :bid_id)');
  $stmt->bindParam('rating', $rating);
  $stmt->bindParam('message', $message);
  $stmt->bindParam('bid_id', $bidId);
  $stmt->execute();
}

/**
 * Add a new notification to the user given in the parameters
 * @param $userId
 * @param $message
 * @param $type
 */
function notifyUser($userId, $message, $type){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO notification
                                (message, type, is_new, user_id, date)
                                VALUES (?, ?, ?, ?, now())');
  $stmt->execute(array($message, $type, 'true', $userId));
}

/**
 * Add a new feedback record to the database
 * @param $userId
 * @param $message
 */
function createFeedback($userId, $message){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO feedback (user_id, message, date) VALUES(?, ?, now())');
  $stmt->execute(array($userId, $message));
}

/**
 * Creates an user report
 * @param $userId
 * @param $message
 */
function createUserReport($userId, $message) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO user_report(date, message, user_id)
                            VALUES(now(), :message, :user_id)');
  $stmt->bindParam('message', $message);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
}

/**
 * Creates a password request
 * @param $email
 */
function createRequestPasswordReset($email, $token) {
  global $conn;
  $stmt = $conn->prepare('INSERT INTO password_request(email, token)
                          VALUES(:email, :token)');
  $stmt->bindParam('email', $email);
  $stmt->bindParam('token', $token);
  $stmt->execute();
}

/* ========================== Deletes  ========================== */

/**
 * Makes the user unfollow another user.
 * Deletes from the database.
 * @param $followingUserId
 * @param $followedUserId
 */
function unfollowUser($followingUserId, $followedUserId) {
  global $conn;
  $stmt = $conn->prepare('DELETE FROM follow
                                WHERE user_following_id = :following_user_id
                                AND user_followed_id = :followed_user_id');
  $stmt->bindParam('following_user_id', $followingUserId);
  $stmt->bindParam('followed_user_id', $followedUserId);
  $stmt->execute();
}

/**
 * Delete an user
 * @param $userId
 */
function deleteUser($userId){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                          FROM "user"
                          WHERE id=?');
  $stmt->execute(array($userId));
}

/**
 * Deletes a notification
 * @param $notificationId
 */
function deleteNotification($notificationId){
  global $conn;
  $stmt = $conn->prepare('DELETE 
                                FROM notification
                                WHERE id=?');
  $stmt->execute(array($notificationId));
}

/* ========================== Updates  ========================== */

/**
 * Updates user details.
 * @param $userId
 * @param $realName
 * @param $smallBio
 * @param $email
 * @param $phone
 * @param $fullBio
 */
function updateUserDetails($userId, $realName, $smallBio, $email, $phone, $fullBio) {
  global $conn;
  $stmt = $conn->prepare('UPDATE "user"
                                SET name = :real_name,
                                short_bio = :small_bio,
                                email = :email,
                                phone = :phone,
                                full_bio = :full_bio
                                WHERE id = :user_id');
  $stmt->bindParam('real_name', $realName);
  $stmt->bindParam('small_bio', $smallBio);
  $stmt->bindParam('email', $email);
  $stmt->bindParam('phone', $phone);
  $stmt->bindParam('full_bio', $fullBio);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
}

/**
 * Updates user with facebook information
 * @param $userId
 * @param $facebook_oauth_id
 * @param $facebook_picture
 */
function updateUserFacebook($userId, $facebook_oauth_id, $facebook_picture) {
    global $conn;
    $stmt = $conn->prepare('UPDATE "user"
                                SET profile_pic = :picture_id,
                                    oauth_id = :facebook_oauth_id
                                WHERE id = :user_id');
    $stmt->bindParam('picture_id', $facebook_picture);
    $stmt->bindParam('facebook_oauth_id', $facebook_oauth_id);
    $stmt->bindParam('user_id', $userId);
    $stmt->execute();
}

/**
 * Updates user profile picture
 * @param $userId
 * @param $pictureId
 */
function updateUserPicture($userId, $pictureId) {
  global $conn;
  $stmt = $conn->prepare('UPDATE "user"
                          SET profile_pic = :picture_id
                          WHERE id = :user_id');
  $stmt->bindParam('picture_id', $pictureId);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
}

/**
 * Updates user location.
 * @param $userId
 * @param $cityId
 */
function updateUserLocation($userId, $cityId) {
  global $conn;
  $stmt = $conn->prepare('UPDATE "user"
                                SET city_id = :city_id
                                WHERE id = :user_id');
  $stmt->bindParam('city_id', $cityId);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
}

/**
 * Updates user password
 * @param $userId
 * @param $newPass
 */
function updatePassword($userId, $newPass) {
  global $conn;
  $options = ['cost' => 12];
  $encryptedNewPass = password_hash($newPass, PASSWORD_DEFAULT, $options);
  $stmt = $conn->prepare('UPDATE "user"
                                SET hashed_pass = :new_hashed_pass
                                WHERE id = :user_id');
  $stmt->bindParam('new_hashed_pass', $encryptedNewPass);
  $stmt->bindParam('user_id', $userId);
  $stmt->execute();
}

/**
 * Updates user password and removes password request.
 * @param $email
 * @param $newPass
 */
function updatePasswordWithEmail($email, $newPass) {
  global $conn;

  // Updates password.
  $options = ['cost' => 12];
  $encryptedNewPass = password_hash($newPass, PASSWORD_DEFAULT, $options);
  $stmt = $conn->prepare('UPDATE "user"
                          SET hashed_pass = :new_hashed_pass
                          WHERE email = :email');
  $stmt->bindParam('new_hashed_pass', $encryptedNewPass);
  $stmt->bindParam('email', $email);
  $stmt->execute();

  // Removes the password request.
  $stmt = $conn->prepare('DELETE FROM password_request
                          WHERE email = :email');
  $stmt->bindParam('email', $email);
  $stmt->execute();
}

/**
 * Sets the boolean is new in the respective notification
 * @param $notificationId
 */
function updateNotification($notificationId){
  global $conn;
  $stmt = $conn->prepare('UPDATE notification
                                SET is_new = ?
                                WHERE id = ?');
  $stmt->execute(array('FALSE', $notificationId));
}

/**
 * Update user credit of an user.
 * @param $newCredit
 * @param $userId
 */
function updateUserCredit($newCredit, $userId) {
  global $conn;
  $stmt = $conn->prepare('UPDATE "user"
                          SET amount = :newCredit
                          WHERE "user".id = :userId');
  $stmt->bindParam('newCredit', $newCredit);
  $stmt->bindParam('userId', $userId);
  $stmt->execute();
}

/**
 * Adds credit to the user ac
 * @param $userId
 * @param $amount
 */
function addCredit($userId, $amount){
  global $conn;
  $stmt = $conn->prepare('UPDATE "user"
                          SET amount = amount + ?
                          WHERE "user".id = ?');
  $stmt->execute(array($amount, $userId));
}