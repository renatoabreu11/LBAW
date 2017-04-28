<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/auction.php");

    if(!$_POST['question-id'] || !$_POST['token'] || !$_POST['user-id'] || !$_POST['comment']) {
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

    $questionId = trim(strip_tags($_POST['question-id']));
    if(!is_numeric($questionId)) {
        echo "Error: question id is not numeric.";
        return;
    }

    $comment = strip_tags($_POST['comment']);

    try {
        createQuestionReport($questionId, $comment);
    } catch(PDOException $e) {
        echo $e->getMessage();
        echo "Error: couldn't create a new question report.";
        return;
    }

    echo "success: question report successfully created.";

?>