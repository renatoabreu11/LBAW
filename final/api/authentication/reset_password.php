<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if(!$_POST['newPass'] || !$_POST['newPassRepeat'] || !$_POST['email']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All input fields are mandatory!";
  echo json_encode($reply);
  return;
}

$newPass = $_POST['newPass'];
if($newPass != $_POST['newPassRepeat']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The password confirmation doesn't match.";
  echo json_encode($reply);
  return;
}

$email = trim($_POST['email']);

try {
  updatePasswordWithEmail($email, $newPass);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => "Reset password."));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error updating password.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Password updated with success.";
echo json_encode($reply);