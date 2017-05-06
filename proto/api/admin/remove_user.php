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

if (!$_POST['id']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$userId = $_POST['id'];
if(!is_numeric($userId)){
  echo 'Error 400 Bad Request: Invalid user id.';
  return;
}

try {
  deleteUser($userId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove user.'));
  echo "Error 500 Internal Server: Error deleting user.";
  return;
}

echo "Success: User successfully removed!";