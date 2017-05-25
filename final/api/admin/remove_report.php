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

if (!$_POST['id'] || !$_POST['type']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$reportId = $_POST['id'];
$type = $_POST['type'];

$types = array("User", "Auction", "Question", "Answer");

if (!in_array($type, $types)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid report type!";
  echo json_encode($reply);
  return;
}

if(!is_numeric($reportId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid report.";
  echo json_encode($reply);
  return;
}

try {
  switch($type){
    case "User":
      deleteUserReport($reportId);
      break;
    case "Auction":
      deleteAuctionReport($reportId);
      break;
    case "Question":
      deleteQuestionReport($reportId);
      break;
    case "Answer":
      deleteAnswerReport($reportId);
      break;
  }
} catch (PDOException $e) {
  $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Remove report.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting report.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Report successfully removed!";
echo json_encode($reply);