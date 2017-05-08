<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$userId = $_SESSION['user_id'];
$token = $_SESSION['token'];

if(!$username || !$userId || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!validUser($username, $userId)){
  $smarty->display('common/404.tpl');
  return;
}

$currCredit = getCreditOfUser($userId);
$numBetsOnGame = getBetsOnGame($userId);
$valBetsOnGame = getValBetsOnGame($userId);
if ($valBetsOnGame === null) $valBetsOnGame = 0;

$notifications = getActiveNotifications($userId);
$smarty->assign('notifications', $notifications);
$smarty->assign('userId', $userId);
$smarty->assign('currCredit', $currCredit);
$smarty->assign('numBetsOnGame', $numBetsOnGame);
$smarty->assign('valBetsOnGame', $valBetsOnGame);
$smarty->display('user/credit.tpl');
