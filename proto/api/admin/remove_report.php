<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['id'] || !$_POST['type']){
  echo 'All fields are mandatory!';
  return;
}

$report_id = $_POST['id'];
$type = $_POST['type'];

$types = array("User", "Auction", "Review", "Question", "Answer");

if (!in_array($type, $types)) {
  echo "Invalid report type!";
  return;
}

try {
  switch($type){
    case "User":
      deleteUserReport($report_id);
      break;
    case "Auction":
      deleteAuctionReport($report_id);
      break;
    case "Question":
      deleteQuestionReport($report_id);
      break;
    case "Answer":
      deleteAnswerReport($report_id);
      break;
    case "Review":
      deleteReviewReport($report_id);
      break;
  }
} catch (PDOException $e) {
  echo $e->getMessage();
  return;
}

echo "Report deleted!";