<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auction.php");

    if(!$_POST['user-id'] || !$_POST['question_id'] || !$_POST['comment']) {
        echo "error: some fields are not set.";
        return;
    }

    $userId = trim(strip_tags($_POST['id']));
    $loggedUserId = $_SESSION['user-id'];

    if($userId != $loggedUserId) {
        echo "error: logged in user and sender user are not the same.";
        return;
    }

    $questionId = trim(strip_tags($_POST['question-id']));
    $comment = strip_tags($_POST['comment']);

    if(!is_numeric($auctionId)) {
        echo "error: question id is not numeric.";
        return;
    }

    try {
        createAnswer($comment, $userId, $questionId);
    } catch(PDOException $e) {
        echo "error: couldn\'t insert new question.";
        return;
    }

    echo "success: question successfully posted.";

?>