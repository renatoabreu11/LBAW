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
$comment = strip_tags($_POST['comment']);
if(strlen($comment) > 512){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "The answer length exceeds the maximum number of characters (512).";
  echo json_encode($reply);
  return;
}

$questionId = $_POST['questionId'];
if(!$questionId || !is_numeric($questionId)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid question.";
  echo json_encode($reply);
  return;
}

if(!isOwner($userId, $auctionId)){
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

try {
  if(!createAnswer($comment, $userId, $questionId)) {
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Question already has an answer!";
    echo json_encode($reply);
    return;
  }
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create answer'));
  $reply['response'] = "Error 500 Internal Server";
  $reply['message'] = "Error creating the answer.";
  echo json_encode($reply);
  return;
}

$auction = getAuctionProduct($auctionId);
$question = getQuestion($questionId);
if(getNotificationOption($question['user_id'], $auctionId)) {
  try {
    $message = "The auction seller answered your question in the auction " . $auction['name'] . ".";
    notifyUser($question['user_id'], $message, "Answer");
  } catch (PDOException $e) {
    $log->error($e->getMessage(), ['request' => 'New answer notification']);
  }
}

$seller = getUser($userId);
$questions = getQuestionsAnswers($auctionId);
foreach ($questions as &$question){
  $question['date'] = date('d F Y, H:i', strtotime( $question['date']));
}
$smarty->assign("questions", $questions);
$smarty->assign("seller", $seller);
$questionsDiv = $smarty->fetch('auction/question.tpl');
$dataToRetrieve = array(
  'questionsDiv' => $questionsDiv,
  'response' => 'Success 200',
  'message' => "Answer successfully added!");
echo json_encode($dataToRetrieve);