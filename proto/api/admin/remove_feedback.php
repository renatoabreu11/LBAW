<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
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

$feedbackId = $_POST['id'];

if(!is_numeric($feedbackId)){
  echo 'Error 400 Bad Request: Invalid feedback id.';
  return;
}

try {
  deleteFeedback($feedbackId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove feedback.'));
  echo "Error 500 Internal Server: Error deleting feedback.";
  return;
}

echo "Success: Feedback successfully removed!";