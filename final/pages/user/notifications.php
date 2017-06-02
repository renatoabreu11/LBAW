<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];
$token = $_SESSION['token'];

if(!$username || !$id || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!validUser($username, $id)){
  $smarty->display('common/404.tpl');
  return;
}

$page = $_GET['page'];

if (empty($page) || is_numeric($page) == FALSE) {
    $page = 1;
}else {
    $page = $_GET['page'];
}

$items = 10;
$offset = ($page * $items) - $items;
$page_notifications = getPageNotifications($id, $items, $offset);
$notifications = getActiveNotifications($id);
foreach ($page_notifications as &$notif){
  $notif['date'] = date('d F Y, H:i:s', strtotime($notif['date']));
}
foreach ($notifications as &$n){
  $n['date'] = date('d F Y, H:i:s', strtotime($n['date']));
}
$nr_pages = ceil(countNotifications($id) / $items);

$smarty->assign("module", "User");
$smarty->assign('currPage', $page);
$smarty->assign('nrPages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('pageNotifications', $page_notifications);
$smarty->assign("title", "Seek Bid - " . $username . " notifications");
$smarty->display('user/notifications.tpl');