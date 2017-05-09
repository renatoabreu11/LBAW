<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$userId = null;
$userId = $_GET['id'];

$loggedUserId = $_SESSION['user_id'];

if(!is_numeric($userId)) {
  $_SESSION['error_messages'][] = "Invalid user id.";
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

if($loggedUserId){
  $notifications = getActiveNotifications($loggedUserId);
  $smarty->assign('notifications', $notifications);
}

$smarty->assign('user', $user);

if($user['oauth_id']!=null)
    $smarty->assign('profile_pic', $user['profile_pic']);
else
    $smarty->assign('profile_pic', $BASE_URL . "images/users/" . $user['profile_pic']);

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
