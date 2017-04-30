<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!is_numeric($_POST['creditToAdd']) || !is_numeric($_POST['userId'])) {
  echo 'Error 400 Bad Request: Invalid parameters.';
  return;
}

if ($_SESSION['user_id'] != $_POST['userId']) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$creditToAdd = $_POST['creditToAdd'];
$userId =  $_POST['userId'];
$currCredit = getCreditOfUser($userId);
$newCredit = $creditToAdd + $currCredit;

try {
  updateUserCredit($newCredit, $userId);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error updating user credit.";
  echo $e->getMessage();
  return;
}

echo "Credit added successfully.";