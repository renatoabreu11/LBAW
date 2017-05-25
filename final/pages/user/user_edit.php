<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

$userId = $_SESSION['user_id'];
$token = $_SESSION['token'];
$username = $_SESSION['username'];

if(!$username || !$userId || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!is_numeric($userId)) {
  $_SESSION['error_messages'][] = "Invalid user id.";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$notifications = getActiveNotifications($userId);
foreach ($notifications as &$n){
  $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
}
$user = getUser($userId);
$userCurrLocation = getCityAndCountry($userId);
$countries = getAllCountries();
$cities = getAllCities();

$smarty->assign("module", "User");
$smarty->assign('notifications', $notifications);
$smarty->assign('user', $user);
$smarty->assign('userCurrLocation', $userCurrLocation);
$smarty->assign('countries', $countries);
$smarty->assign('cities', $cities);
$smarty->display('user/user_edit.tpl');