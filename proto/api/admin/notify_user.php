<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['id'] || !$_POST["message"]){
  echo 'All fields are mandatory!';
  return;
}

$user_id = $_POST["id"];
$message = trim(strip_tags($_POST["message"]));
if ( !preg_match ("/^[a-zA-Z0-9\s]+$/", $message)){
  echo 'Invalid message characters';
  return;
}

try {
  notifyUser($user_id, $message, "Warning");
} catch (PDOException $e) {
  echo 'Error notifying admin' . $e->getMessage();
  return;
}

echo "User notified!";
