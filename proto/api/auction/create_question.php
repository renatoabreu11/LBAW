<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");
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
$qaSection = getQAstate($auctionId);

if($qaSection == false){
  $reply['message'] = "Error 403 Forbidden: The auction owner doesn't allow questions!";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['message'] = "Error 400 Bad Request: The field length exceeds the maximum!";
  echo json_encode($reply);
  return;
}

$nrQuestions = getNumberQuestions($auctionId, $userId);
if($nrQuestions >= 3){
  $reply['message'] = "Error 403 Forbidden: The number of questions allowed per user is three!";
  echo json_encode($reply);
  return;
}

try {
  createQuestion($comment, $userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create question'));
  $reply['message'] = "Error 500 Internal Server: Error creating the question!";
  echo json_encode($reply);
  return;
}

$questions = getQuestionsAnswers($auctionId);
$smarty->assign("questions", $questions);
$questionsDiv = $smarty->fetch('auction/question.tpl');
$dataToRetrieve = array(
  'questionsDiv' => $questionsDiv,
  'message' => "Success: Question successfully added!");
echo json_encode($dataToRetrieve);