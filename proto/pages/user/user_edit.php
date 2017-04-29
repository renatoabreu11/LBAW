<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_GET['id']) {
  $_SESSION['error_messages'][] = "Undefined id";
  header("Location: $BASE_URL");
  exit;
}

$userId = trim(strip_tags($_GET['id']));
$loggedUserId = $_SESSION['user_id'];

if(!is_numeric($userId) || !is_numeric($loggedUserId)) {
  $_SESSION['error_messages'][] = "id has invalid characters";
  header("Location: $BASE_URL");
  exit;
}

if($userId != $loggedUserId) {
  $_SESSION['error_messages'][] = "id doesn't match.";
  header("Location: $BASE_URL");
  exit;
}

if($_SESSION['username'] && $_SESSION['user_id']){
  $notifications = getActiveNotifications($_SESSION['user_id']);
  $smarty->assign('notifications', $notifications);
}

$user = getUser($loggedUserId);
$userCurrLocation = getCityAndCountry($userId);
$countries = getAllCountries();
$cities = getAllCities();
$token = $_SESSION['token'];

$smarty->assign("userId", $userId);
$smarty->assign("token", $token);
$smarty->assign('user', $user);
$smarty->assign('userCurrLocation', $userCurrLocation);
$smarty->assign('countries', $countries);
$smarty->assign('cities', $cities);

$smarty->display('user/user_edit.tpl');