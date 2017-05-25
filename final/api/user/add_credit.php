<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!is_numeric($_POST['creditToAdd']) || !is_numeric($userId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid parameters.";
  echo json_encode($reply);
  return;
}

$creditToAdd = round($_POST['creditToAdd'], 2);

if($creditToAdd > 1000){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "You cannot add this amount of money. The maximum is 1000€.";
  echo json_encode($reply);
  return;
}

$currCredit = getCreditOfUser($userId);
$newCredit = $creditToAdd + $currCredit;

try {
  updateUserCredit($newCredit, $userId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Add credit.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error updating user credit.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Credit added to account.";
echo json_encode($reply);