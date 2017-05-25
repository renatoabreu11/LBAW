<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");
include_once($BASE_DIR . "database/auctions.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$userId = $_POST['userId'];
$loggedUserId = $_SESSION['user_id'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if(!$_POST['comment'] || !$_POST['auctionId']) {
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All fields are mandatory.";
  echo json_encode($reply);
  return;
}

$auctionId = $_POST['auctionId'];
if(!is_numeric($auctionId) || !validAuction($auctionId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid auction.";
  echo json_encode($reply);
  return;
}

$auction = getAuction($auctionId);
$seller = $auction['user_id'];
$qaSection = $auction['questions_section'];

if($qaSection == false){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "The auction owner doesn't allow questions!";
  echo json_encode($reply);
  return;
}

$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The question length exceeds the maximum number of characters (512).";
  echo json_encode($reply);
  return;
}

$nrQuestions = getNumberQuestions($auctionId, $userId);
if($nrQuestions >= 3){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "The number of questions allowed per user is three!";
  echo json_encode($reply);
  return;
}

try {
  createQuestion($comment, $userId, $auctionId);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create question'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the question.";
  echo json_encode($reply);
  return;
}

if(getNotificationOption($seller, $auctionId)) {
  try {
    $message = "Someone posted a question in your auction.";
    notifyUser($seller, $message, "Question");
  } catch (PDOException $e) {
    $log->error($e->getMessage(), ['request' => 'New question notification']);
  }
}

$questions = getQuestionsAnswers($auctionId);
foreach ($questions as &$question){
  $question['date'] = date('d F Y, H:i', strtotime($question['date']));
}
$smarty->assign("questions", $questions);
$questionsDiv = $smarty->fetch('auction/question.tpl');
$dataToRetrieve = array(
  'questionsDiv' => $questionsDiv,
  'response' => 'Success 200',
  'message' => "Question successfully added!");
echo json_encode($dataToRetrieve);