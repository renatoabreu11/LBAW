<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auction.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_POST['auction-id'] || !$_POST['token'] || !$_POST['user-id'] || !$_POST['comment']) {
        $reply = array('error' => 'error: Some fields are not set.');
        echo json_encode($reply);
        return;
    }

    if (!hash_equals($_SESSION['token'], $_POST['token'])) {
        $reply = array('error' => 'error: Tokens are not the same.');
        echo json_encode($reply);
        return;
    }

    $loggedUserId = $_SESSION['user_id'];
    $userId = trim(strip_tags($_POST['user-id']));
    if($loggedUserId != $userId) {
        $reply = array('error' => 'error: User id is not the same.');
        echo json_encode($reply);
        return;
    }

    $auctionId = trim(strip_tags($_POST['auction-id']));
    if(!is_numeric($auctionId)) {
        $reply = array('error' => 'error: Auction id is not numeric.');
        echo json_encode($reply);
        return;
    }

    $comment = strip_tags($_POST['comment']);

  /*  try {
        createQuestion($comment, $loggedUserId, $auctionId);
    } catch(PDOException $e) {
        $reply = array('error' => 'error: Couldn\'t insert question.');
        echo json_encode($reply);
        return;
    }*/

    $user = getUser($userId);
    $reply = array('comment' => $comment, 'user-id' => $loggedUserId, 'username' => $user['username'], 'picture' => $user['profile_pic'], 'date' => date('Y-m-d H:i:s'));
    echo json_encode($reply);

?>