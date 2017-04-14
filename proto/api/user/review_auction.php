<?php

    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/users.php');

    if(!$_POST['rating'] || !$_POST['message'] || !$_POST['bid_id']) {
        echo "error: parameters aren't set.";
        return;
    }

    $rating = trim(strip_tags($_POST['rating']));
    $message = trim(strip_tags($_POST['message']));
    $bidId = trim(strip_tags($_POST['bid_id']));

    if(!preg_match("/^([0-9]|10)$/", $rating) || !preg_match("/[0-9]+/", $bidId)) {
        echo "error: invalid characters.";
        return;
    }

    try {
        insertReview($rating, $message, $bidId);
    } catch(PDOException $e) {
        echo "error: ";
        return;
    }

    echo "success: review posted."

?>