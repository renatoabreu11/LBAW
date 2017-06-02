<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$userId = $_GET['id'];
$loggedUserId = $_SESSION['user_id'];

if(!is_numeric($userId) || !validUserId($userId)) {
  $_SESSION['error_messages'][] = "Invalid user.";
  header("Location: $BASE_URL");
  exit;
}

$user = getUser($userId);
$user['register_date'] = date('d F Y, H:i:s', strtotime($user['register_date']));
$userCurrLocation = getCityAndCountry($userId);
$isFollowing = getIsFollowing($loggedUserId, $userId);        // handle if user not logged in.
$totalAuctions = getNumTotalAuctions($userId);
$activeAuctions = getActiveAuctions($userId);
$reviews = getReviews($userId);

foreach ($reviews as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

$wins = getWins($userId);

foreach ($wins as &$aux) {
  $aux['end_date'] = date('d F Y, H:i', strtotime($aux['end_date']));
}

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
  foreach ($notifications as &$n){
    $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
  }
  $smarty->assign('notifications', $notifications);
}

foreach ($lastReviews as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

foreach ($lastBids as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

foreach ($lastFollowing as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

foreach ($lastWins as &$aux) {
  $aux['end_date'] = date('d F Y, H:i', strtotime($aux['end_date']));
}

foreach ($lastQuestion as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

foreach ($lastWatchlistAuctions as &$aux) {
  $aux['date'] = date('d F Y, H:i', strtotime($aux['date']));
}

foreach ($activeAuctions as &$auction){
  $auction['end_date_readable'] = date('d F Y, H:i:s', strtotime($auction['end_date']));
  $auction['start_date_readable'] = date('d F Y, H:i:s', strtotime($auction['start_date']));
}

$smarty->assign('user', $user);
$smarty->assign('profile_pic', $BASE_URL . "images/users/" . $user['profile_pic']);
$smarty->assign("module", "User");
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

$smarty->assign("title", "Seek Bid - " . $user['name']);
$smarty->display('user/user.tpl');
