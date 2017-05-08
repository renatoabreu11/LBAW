<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");
include_once($BASE_DIR . "database/auctions.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
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

if(!$_POST['comment'] || !$_POST['auctionId']) {
  $reply['message'] = "Error 400 Bad Request: All fields are mandatory!";
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auctionId'];
$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['message'] = "Error 400 Bad Request: The field length exceeds the maximum!";
  echo json_encode($reply);
  return;
}

$questionId = $_POST['questionId'];
if(!$questionId || !is_numeric($questionId)){
  $reply['message'] = "Error 400 Bad Request: Invalid question id!";
  echo json_encode($reply);
  return;
}

if(!isOwner($userId, $auctionId)){
  $reply['message'] = "Error 403 Forbidden: You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

try {
  if(!createAnswer($comment, $userId, $questionId)) {
    $reply['message'] = "Error 500 Internal Server: Question already has an answer!";
    echo json_encode($reply);
    return;
  }
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create answer'));
  $reply['message'] = "Error 500 Internal Server: Couldn't create answer!";
  echo json_encode($reply);
  return;
}

$question = getQuestion($questionId);
if(getNotificationOption($question['user_id'], $auctionId)) {
  try {
    $message = "The auction seller answered your question.";
    notifyUser($question['user_id'], $message, "Answer");
  } catch (PDOException $e) {
    $log->error($e->getMessage(), ['request' => 'New answer notification']);
  }
}

$seller = getUser($userId);
$questions = getQuestionsAnswers($auctionId);
$smarty->assign("questions", $questions);
$smarty->assign("seller", $seller);
$questionsDiv = $smarty->fetch('auction/question.tpl');
$dataToRetrieve = array(
  'questionsDiv' => $questionsDiv,
  'message' => "Success: Question successfully added!");
echo json_encode($dataToRetrieve);