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

$page = $_GET['page'];

if (empty($page) || is_numeric($page) == FALSE) {
    $page = 1;
}else {
    $page = $_GET['page'];
}

$items = 5;
$offset = ($page * $items) - $items;

$page_notifications = getPageNotifications($id, $items, $offset);
$notifications = getActiveNotifications($id);

$nr_pages = ceil(countNotifications($id) / $items);

$smarty->assign('curr_page', $page);
$smarty->assign('nr_pages', $nr_pages);
$smarty->assign('notifications', $notifications);
$smarty->assign('page_notifications', $page_notifications);
$smarty->display('user/notifications.tpl');