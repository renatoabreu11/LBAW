<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auction.php");

    if(!$_POST['answer-id'] || !$_POST['user-id'] || !$_POST['token']) {
        echo "Error: some fields are not set.";
        return;
    }

    if (!hash_equals($_SESSION['token'], $_POST['token'])) {
        echo "Error: tokens are not the same.";
        return;
    }

    $loggedUserId = $_SESSION['user_id'];
    $userId = trim(strip_tags($_POST['user-id']));
    if($loggedUserId != $userId) {
        echo "Error: user id is not the same.";
        return;
    }

    $answerId = trim(strip_tags($_POST['answer-id']));
    if(!is_numeric($answerId)) {
        echo "Error: invalid question id.";
        return;
    }

    try {
        deleteAnswer($answerId);
    } catch(PDOException $e) {
        echo "Error: couldn't delete answer.";
        return;
    }

    echo "success: answer deleted successfully.";

?>