<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auctions.php");

    if(!$_POST['token'] || !$_POST['userId'] || !$_POST['auctionId'] || !$_POST['notifications']) {
        echo "Error 403 Forbidden: You don't have permissions to make this request. Fields missing.";
        return;
    }

    if (!hash_equals($_SESSION['token'], $_POST['token'])) {
        echo "Error 403 Forbidden: You don't have permissions to make this request.";
        return;
    }

    $loggedUserId = $_SESSION['user_id'];
    $userId = trim(strip_tags($_POST['userId']));
    if($loggedUserId != $userId) {
        echo "Error 403 Forbidden: You don't have permissions to make this request.";
        return;
    }

    $auctionId = trim(strip_tags($_POST['auctionId']));
    if(!is_numeric($auctionId)) {
        echo "Error 403 Forbidden: You don't have permissions to make this request.";
        return;
    }

    $notifications = trim(strip_tags($_POST['notifications']));
    if($notifications == "Yes")
        $notifications = true;
    else if($notifications == "No")
        $notifications = false;
    else {
        echo "Error 403 Forbidden: You don't have permissions to make this request. Notifications value is not the espected.";
        return;
    }

    try {
        addAuctionToWatchlist($userId, $auctionId, $notifications);
    } catch(PDOException $e) {
        echo "Error 500 Internal Server: Error adding auction.";
        return;
    }

    echo "Success: Auction added successfully to watchlist.";