<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['id']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$feedbackId = $_POST['id'];

if(!is_numeric($feedbackId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid feedback id.";
  echo json_encode($reply);
  return;
}

try {
  deleteFeedback($feedbackId);
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove feedback.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting feedback.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Feedback successfully removed!";
echo json_encode($reply);