<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

$username = $_SESSION['username'];
$id = $_SESSION['user_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validUser($username, $id)) {
    $smarty->display('common/404.tpl');
    return;
}

$allNotifications = getAllNotifications($id);
$notifications = getActiveNotifications($id);

$smarty->assign('notifications', $notifications);
$smarty->assign('all_notifications', $allNotifications);
$smarty->display('user/notifications.tpl');