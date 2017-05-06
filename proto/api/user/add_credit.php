<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!is_numeric($_POST['creditToAdd']) || !is_numeric($userId)) {
  echo 'Error 400 Bad Request: Invalid parameters.';
  return;
}

$creditToAdd = round($_POST['creditToAdd'], 2);
$currCredit = getCreditOfUser($userId);
$newCredit = $creditToAdd + $currCredit;

try {
  updateUserCredit($newCredit, $userId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Add credit.'));
  echo "Error 500 Internal Server: Error updating user credit.";
  return;
}

echo "Success: Credit added successfully.";