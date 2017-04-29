<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$userId = null;
if(!$_GET['id']) {
  $userId = 1;
}else{
  $userId = $_GET['id'];
}

$loggedUserId = $_SESSION['user_id'];

if(!is_numeric($userId)) {
  $_SESSION['error_messages'][] = "id has invalid characters";
  header("Location: $BASE_URL");
  exit;
}

$user = getUser($userId);
$userCurrLocation = getCityAndCountry($userId);
$isFollowing = getIsFollowing($loggedUserId, $userId);        // handle if user not logged in.
$totalAuctions = getNumTotalAuctions($userId);
$activeAuctions = getActiveAuctions($userId);
$reviews = getReviews($userId);
$wins = getWins($userId);
$followingUsers = getFollowingUsers($userId);

// Recent Activity.
$lastReviews = getLastReviews($userId);
$lastBids = getLastBids($userId);
$lastFollowing = getLastFollows($userId);
$lastWins = getLastWins($userId);
$lastQuestion = getLastQuestions($userId);
$lastWatchlistAuctions = getLastWatchlistAuctions($userId);

if($userId == $loggedUserId)
  $reviewsPosted = getWonReviews($userId);

if(!$loggedUserId){
  $token = $_SESSION['token'];
  $notifications = getActiveNotifications($loggedUserId);
  $smarty->assign("userId", $loggedUserId);
  $smarty->assign("token", $token);
  $smarty->assign('notifications', $notifications);
}else if(!$_SESSION['admin_id']){
  $id = $_SESSION['admin_id'];
  $token = $_SESSION['token'];
  $smarty->assign("adminId", $id);
  $smarty->assign("token", $token);
}

$smarty->assign('user', $user);
$smarty->assign('userCurrLocation', $userCurrLocation);
$smarty->assign('isFollowing', $isFollowing);
$smarty->assign('totalAuctions', $totalAuctions);
$smarty->assign('activeAuctions', $activeAuctions);
$smarty->assign('reviews', $reviews);
$smarty->assign('wins', $wins);
$smarty->assign('followingUsers', $followingUsers);

$smarty->assign('lastReviews', $lastReviews);
$smarty->assign('lastBids', $lastBids);
$smarty->assign('lastFollowing', $lastFollowing);
$smarty->assign('lastWins', $lastWins);
$smarty->assign('lastQuestion', $lastQuestion);
$smarty->assign('lastWatchlistAuctions', $lastWatchlistAuctions);

if($userId == $loggedUserId)
  $smarty->assign('reviewsPosted', $reviewsPosted);

$smarty->display('user/user.tpl');
