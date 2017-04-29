<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

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

if (!$_POST['id'] || !$_POST['type']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$reportId = $_POST['id'];
$type = $_POST['type'];

$types = array("User", "Auction", "Review", "Question", "Answer");

if (!in_array($type, $types)) {
  echo 'Error 400 Bad Request: Invalid report type!';
  return;
}

if(!is_numeric($reportId)){
  echo 'Error 400 Bad Request: Invalid report id.';
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
    case "Review":
      deleteReviewReport($reportId);
      break;
  }
} catch (PDOException $e) {
  echo "Error 500 Internal Server: Error deleting report.";
  return;
}

echo "Success 201: Report successfully removed!";