<?php

    include_once('../../config/init.php');
    include_once($BASE_DIR .'database/users.php');

    if(!$_POST['followingUser'] || !$_POST['followedUser']) {
        echo "error: atributes aren't set.";
        return;
    }

    $followingUserId = trim(strip_tags($_POST['followingUser']));
    $followedUserId = trim(strip_tags($_POST['followedUser']));

    if(!preg_match("[0-9]+", $followingUserId) || !preg_match("[0-9]+", $followedUserId)) {
        echo "invalid id characters.";
        return;
    }

    try {
        unfollowUser($followingUserId, $followedUserId);
    } catch(PDOException $e) {
        echo "Problem";
        return;
    }
    
    echo "success: user " . $followingUserId . " is no longer following user " + $followedUserId + ".";

?>