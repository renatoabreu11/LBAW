<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];
$token = $_SESSION['token'];

$userId = null;
if (!$_GET['userId']) {
  $_SESSION['error_messages'][] = "User id field not specified!";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  return;
} else {
  $userId = $_GET['userId'];
}

if ($userId != $_SESSION['user_id']) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  return;
}

$currCredit = getCreditOfUser($userId);
$numBetsOnGame = getBetsOnGame($userId);
$valBetsOnGame = getValBetsOnGame($userId);
if ($valBetsOnGame === null) $valBetsOnGame = 0;

$smarty->assign('userId', $userId);
$smarty->assign('currCredit', $currCredit);
$smarty->assign('numBetsOnGame', $numBetsOnGame);
$smarty->assign('valBetsOnGame', $valBetsOnGame);
$smarty->display('user/credit.tpl');
