<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['message'] = "Error 403 Forbidden: You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  $reply['message'] = "Error 403 Forbidden: You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['comment']) {
  $reply['message'] = "Error 400 Bad Request: All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['message'] = "Error 400 Bad Request: The field length exceeds the maximum!";
  echo json_encode($reply);
  return;
}

try {
  if(!createAnswer($comment, $userId, $questionId)) {
    $reply = array('error' => 'Error: question already has an answer.');
    echo json_encode($reply);
    return;
  }
} catch(PDOException $e) {
  $reply = array('error' => 'Error: couldn\'t insert answer.');
  echo json_encode($reply);
  return;
}

try {
  $user = getUser($userId);
} catch(PDOException $e) {
  $reply = array('error' => 'Error: couldn\'t get user.');
  echo json_encode($reply);
  return;
}

$reply = array('username' => $user['username'], 'profile_pic' => $user['profile_pic'], 'date' => date('Y-m-d H:i:s'));
echo json_encode($reply);