<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_POST['followedUserId']) {
  echo "error: id isn't set.";
  return;
}

$followingUserId = $_SESSION['user_id'];
$followedUserId = trim(strip_tags($_POST['followedUserId']));

if(!preg_match("/[0-9]+/", $followingUserId) || !preg_match("/[0-9]+/", $followedUserId)) {
  echo "error: invalid id characters.";
  return;
}

try {
  unfollowUser($followingUserId, $followedUserId);
} catch(PDOException $e) {
  echo $e->getMessage(); //"error: Problem.";
  return;
}

echo "success: user is no longer following user.";