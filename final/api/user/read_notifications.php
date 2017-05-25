<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/users.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['notifications']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid notifications id's!";
  echo json_encode($reply);
  return;
}

$notifications = $_POST['notifications'];

foreach ($notifications as $notification){
  if(!is_numeric($notification)){
    $reply['response'] = "Error 400 Bad Request";
    $reply['message'] = "Invalid notifications id's!";
    echo json_encode($reply);
    return;
  }
}

foreach ($notifications as $notification){
  try {
    updateNotification($notification);
  } catch (PDOException $e) {
    $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Read notifications.'));
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Error marking notifications as read!";
    echo json_encode($reply);
    return;
  }
}

$notifications = getActiveNotifications($userId);
$nrNotifications = count($notifications);
$smarty->assign("notifications", $notifications);
$notificationsDiv = $smarty->fetch('common/notifications.tpl');
$dataToRetrieve = array(
  'notificationsDiv' => $notificationsDiv,
  'response' => "Success 200",
  'message' => "Notifications marked as read!",
  'nrNotifications' => $nrNotifications);
echo json_encode($dataToRetrieve);