<?php

    /************************************* SELECTS *************************************/

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

    function getUser($userId) {
        global $conn;
        $stmt = $conn->prepare('SELECT *
                                FROM "user"
                                WHERE id=:user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetch();
    }

    function getUserWithUsername($username) {
        global $conn;
        $stmt = $conn->prepare('SELECT id
                                FROM "user" 
                                WHERE username = :username_received');
        $stmt->bindParam('username_received', $username);
        $stmt->execute();
        return $stmt->fetch();
    }

    function getAllUsers(){
        global $conn;
        $stmt = $conn->prepare('SELECT *
                                FROM "user" 
                                ORDER BY id ASC');
        $stmt->execute();
        return $stmt->fetchAll();
    }

    function getCityAndCountry($userId) {
        global $conn;
        $stmt = $conn->prepare('SELECT city.name as city, country.name as country
                                FROM "user"
                                JOIN location ON "user".location_id = location.id
                                JOIN city ON location.city_id = city.id
                                JOIN country ON city.country_id = country.id
                                WHERE "user".id = :user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetch();
    }

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

    function getActiveAuctions($userId) {
        global $conn;
        $stmt = $conn->prepare('SELECT product.name, (
                                SELECT image.filename
                                FROM image
                                WHERE image.product_id = product.id
                                LIMIT 1
                                ) AS image, product.description, auction.curr_bid, auction.end_date - now() AS remaining_time
                                FROM auction
                                JOIN product ON auction.product_id = product.id
                                JOIN "user" ON auction.user_id = "user".id
                                WHERE now() < auction.end_date
                                AND "user".id = :user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
    * Returns all the reviews made to a user.
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
    * Returns all the auction the user has won.
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
    */
    function getLastBids($userId) {
        global $conn;
        $stmt = $conn->prepare('SELECT bid.amount, auction.id AS auction_id, bid.date, seller.id as seller_id, seller.username as seller_username
                                FROM bid
                                INNER JOIN "user" own ON bid.user_id = own.id
                                JOIN auction ON bid.auction_id = auction.id
                                JOIN "user" seller ON auction.user_id = seller.id
                                WHERE own.id = :user_id
                                ORDER BY bid.date
                                LIMIT 2');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetchAll();
    }

    /**
    * Returns the last 2 followed users.
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

    function getPassword($userId) {
        global $conn;
        $stmt = $conn->prepare('SELECT hashed_pass
                                FROM "user"
                                WHERE id = :user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetch();
    }

    /************************************* INSERTS *************************************/

    function createUser($name, $username, $password, $email, $description) {
        global $conn;
        global $PASSWORD_HASH_COST;
        global $BASIC_PROFILE_PIC;
        $options = ['cost' => $PASSWORD_HASH_COST];
        $register_date = $date = date('Y-m-d H:i:s');
        $stmt = $conn->prepare('INSERT INTO "user" (name, username, hashed_pass, email, short_bio, register_date, profile_pic) VALUES (?, ?, ?, ?, ?, ?, ?)');
        $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
        $stmt->execute(array($name, $username, $encryptedPass, $email, $description, $register_date, $BASIC_PROFILE_PIC));
    }

    /**
    * Insert a review.
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

    function notifyUser($user_id, $message, $type){
        global $conn;
        $stmt = $conn->prepare('INSERT INTO notification
                                (message, type, is_new, user_id, date)
                                VALUES (?, ?, ?, ?, now())');
        $stmt->execute(array($message, $type, 'true', $user_id));
    }

    /************************************* DELETES *************************************/
    
    /**
    * Makes the user unfollow another user.
    * Deletes from the database.
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

    function deleteUser($user_id){
        global $conn;
        $stmt = $conn->prepare('DELETE 
                                FROM "user"
                                WHERE id=?');
        $stmt->execute(array($user_id));
    }

    /************************************* UPDATES *************************************/

    /**
    * Updates user details.
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
    */
    function updateUserLocation($userId, $city, $country) {
        global $conn;

        // Get location id.
        $stmt = $conn->prepare('SELECT location_id
                                FROM "user"
                                WHERE id = :user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        $locationId = $stmt->fetch();

        // Get city id.
        $stmt = $conn->prepare('SELECT city_id
                                FROM location
                                WHERE id = :location_id');
        $stmt->bindParam('location_id', $locationId['location_id']);
        $stmt->execute();
        $cityId = $stmt->fetch();

        // Update city name.
        $stmt = $conn->prepare('UPDATE city
                                SET name = :city
                                WHERE id = :city_id');
        $stmt->bindParam('city', $city);
        $stmt->bindParam('city_id', $cityId['city_id']);
        $stmt->execute();

        // Get country id.
        $stmt = $conn->prepare('SELECT country_id
                                FROM city
                                WHERE id = :city_id');
        $stmt->bindParam('city_id', $cityId['city_id']);
        $stmt->execute();
        $countryId = $stmt->fetch();

        // Update country name.
        $stmt = $conn->prepare('UPDATE country
                                SET name = :country
                                WHERE id = :country_id');
        $stmt->bindParam('country', $country);
        $stmt->bindParam('country_id', $countryId['country_id']);
        $stmt->execute();
    }

    function updatePassword($userId, $newPass) {
        global $conn;
        global $PASSWORD_HASH_COST;
        $options = ['cost' => $PASSWORD_HASH_COST];
        $encryptedNewPass = password_hash($newPass, PASSWORD_DEFAULT, $options);
        $stmt = $conn->prepare('UPDATE "user"
                                SET hashed_pass = :new_hashed_pass
                                WHERE id = :user_id');
        $stmt->bindParam('new_hashed_pass', $encryptedNewPass);
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
    }

    function userExists($username, $password){
        global $conn;
        $stmt = $conn->prepare('SELECT * FROM "user" WHERE "user".username = ?');
        $stmt->execute(array($username));
        $result = $stmt->fetch();
        return ($result !== false && password_verify($password, $result["hashed_pass"]));
    }

?>