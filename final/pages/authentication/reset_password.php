<?php

include_once("../../config/init.php");
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$userId = $_SESSION['user_id'];
$token = $_SESSION['token'];

if($username && $userId && $token){
  header("Location: $BASE_URL");
  exit;
}

if(!$_GET['email'] || !$_GET['token']) {
  header("Location: " . $BASE_URL);
  exit;
}

$email = trim($_GET['email']);
$token = trim(strip_tags($_GET['token']));

$requestId = getPasswordRecoveryRequestId($email, $token);
if(!($requestId)) {
  header("Location: " . $BASE_URL);
  exit;
}

$smarty->assign("module", "Auth");
$smarty->assign('email', $email);
$smarty->display('authentication/reset_password.tpl');