<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_POST['followedUserId']) {
        echo "error: id isn't set.";
        return;
    }

    $followingUserId = $_SESSION['user_id'];
    $followedUserId = trim(strip_tags($_POST['followedUserId']));

    if(!preg_match("/[0-9]+/", $followedUserId)) {
        echo "error: invalid id characters.";
        return;
    }

    try {
        followUser($followingUserId, $followedUserId);
    } catch(PDOException $e) {
        echo "error.";       // Change.
        return;
    }

    echo "success: user started following."

?>