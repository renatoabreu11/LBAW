<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$adminId = $_POST['adminId'];
$userId = $_POST['userId'];
if(!$adminId) {
  $loggedAdminId = $_SESSION['admin_id'];
  if($loggedAdminId != $adminId) {
    $reply['response'] = "Error 403 Forbidden";
    $reply['message'] = "You don't have permissions to make this request.";
    echo json_encode($reply);
    return;
  }
}else if(!$userId) {
  $loggedUserId = $_SESSION['user_id'];
  if($loggedUserId != $userId) {
    $reply['response'] = "Error 403 Forbidden";
    $reply['message'] = "You don't have permissions to make this request.";
    echo json_encode($reply);
    return;
  }
}else {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['questionId']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid question.";
  echo json_encode($reply);
  return;
}

$questionId = $_POST['questionId'];
if(!is_numeric($questionId)) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid question.";
  echo json_encode($reply);
  return;
}

if($userId && !isQuestionCreator($questionId, $userId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

try {
  deleteQuestion($questionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'adminId' => $adminId, 'request' => 'Delete question.'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error deleting question.";
  echo json_encode($reply);
  return;
}

$reply['response'] = "Success 200";
$reply['message'] = "Question deleted successfully.";
echo json_encode($reply);