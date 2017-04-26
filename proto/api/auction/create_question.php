<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auction.php");

    if(!$_POST['auction-id'] || !$_POST['comment']) {
        echo "error: some fields are not set.";
        return;
    }

    $loggedUserId = $_SESSION['user_id'];
    $auctionId = trim(strip_tags($_POST['auction-id']));
    $comment = strip_tags($_POST['comment']);

    if(!is_numeric($auctionId)) {
        echo "error: auction id is not numeric.";
        return;
    }

    /*try {
        createQuestion($comment, $loggedUserId, $auctionId);
    } catch(PDOException $e) {
        echo "error: couldn't insert new question.";
        return;
    }*/

    $reply = array('comment' => $comment, 'user-id' => $loggedUserId);
    echo json_encode($reply);

?>