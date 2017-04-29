<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_GET['id']) {
  $_SESSION['error_messages'][] = "Undefined id";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$id = $_SESSION['user_id'];
$token = $_SESSION['token'];
$username = $_SESSION['username'];
$userId = $_GET['id'];

if(!is_numeric($userId) || !is_numeric($id)) {
  $_SESSION['error_messages'][] = "id has invalid characters";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

if($userId != $id || !$token || $username) {
  $_SESSION['error_messages'][] = "Invalid request. You don't have permissions!";
  header("Location: $BASE_URL");
  exit;
}

$notifications = getActiveNotifications($id);
$user = getUser($id);
$userCurrLocation = getCityAndCountry($userId);
$countries = getAllCountries();
$cities = getAllCities();

$smarty->assign('notifications', $notifications);
$smarty->assign("userId", $userId);
$smarty->assign("token", $token);
$smarty->assign('user', $user);
$smarty->assign('userCurrLocation', $userCurrLocation);
$smarty->assign('countries', $countries);
$smarty->assign('cities', $cities);

$smarty->display('user/user_edit.tpl');