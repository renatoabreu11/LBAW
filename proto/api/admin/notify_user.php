<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['id'] || !$_POST["message"]){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$user_id = $_POST["id"];
$message = trim(strip_tags($_POST["message"]));

try {
  notifyUser($user_id, $message, "Warning");
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error notifying user.";
  return;
}

echo "Success 201 Created: User notified.";
