<?php

include_once("../../config/init.php");
include_once($BASE_DIR . 'database/users.php');

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

$smarty->assign('email', $email);
$smarty->display('authentication/reset_password.tpl');