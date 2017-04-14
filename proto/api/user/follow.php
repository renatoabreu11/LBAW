<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_POST['followedUserId']) {
        echo "error: id isn't set.";
        return;
    }

    $followingUserId = trim(strip_tags(1));//$_SESSION['user_id'']));   // We don't have the login functionality.'
    $followedUserId = trim(strip_tags($_POST['followedUserId']));

    if(!preg_match("/[0-9]+/", $followingUserId) || !preg_match("/[0-9]+/", $followedUserId)) {
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