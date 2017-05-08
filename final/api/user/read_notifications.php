<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['message'] = "Error 403 Forbidden: You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['userId'];
if($loggedUserId != $userId) {
  $reply['message'] = "Error 403 Forbidden: You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['notifications']){
  $reply['message'] = 'Error 400 Bad Request: Invalid notifications id\'s!';
  echo json_encode($reply);
  return;
}

$notifications = $_POST['notifications'];

foreach ($notifications as $notification){
  if(!is_numeric($notification)){
    $reply['message'] = 'Error 400 Bad Request: Invalid notifications id\'s!';
    echo json_encode($reply);
    return;
  }
}

foreach ($notifications as $notification){
  try {
    updateNotification($notification);
  } catch (PDOException $e) {
    $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Read notifications.'));
    $reply['message'] = "Error 500 Internal Server: Error marking notification as read.<br/>";
  }
}

$notifications = getActiveNotifications($userId);
$nrNotifications = count($notifications);
$smarty->assign("notifications", $notifications);
$notificationsDiv = $smarty->fetch('common/notifications.tpl');
$dataToRetrieve = array(
  'notificationsDiv' => $notificationsDiv,
  'message' => "Success: Notifications marked as read!",
  'nrNotifications' => $nrNotifications);
echo json_encode($dataToRetrieve);