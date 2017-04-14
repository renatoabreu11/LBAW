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
        $stmt = $conn->prepare('SELECT COUNT(*) as number
                                FROM auction
                                JOIN "user" ON auction.user_id = "user".id
                                WHERE "user".id = :user_id');
        $stmt->bindParam('user_id', $userId);
        $stmt->execute();
        return $stmt->fetch();
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
        $stmt = $conn->prepare('SELECT bid.amount, auction.id AS auction_id, bid.date, seller.id as seller_id
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
        $stmt = $conn->prepare('SELECT auction.end_date, seller.username, auction.id as auction_id
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

    /************************************* INSERTS *************************************/

    function createUser($name, $username, $password, $email, $description) {
        global $conn;
        $options = ['cost' => 12];
        $register_date = $date = date('Y-m-d H:i:s');
        $stmt = $conn->prepare('INSERT INTO "user" (name, username, hashed_pass, email, short_bio, register_date) VALUES (?, ?, ?, ?, ?, ?)');
        $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
        $stmt->execute(array($name, $username, $encryptedPass, $email, $description, $register_date));
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

?>