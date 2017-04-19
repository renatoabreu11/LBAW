<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_GET['id']) {
        $_SESSION['error_messages'][] = "Undefined id";
        header("Location: $BASE_URL");
        exit;
    }

    $userId = trim(strip_tags($_GET['id']));
    $loggedUserId = $_SESSION['user_id'];

    if(!preg_match("/[0-9]/", $userId) || !preg_match("/[0-9]/", $loggedUserId)) {
        $_SESSION['error_messages'][] = "id has invalid characters";
        header("Location: $BASE_URL");
        exit;
    }

    if($userId != $loggedUserId) {
        $_SESSION['error_messages'][] = "id doesn't match.";
        header("Location: $BASE_URL");
        exit;
    }

    $user = getUser($loggedUserId);
    $location = getCityAndCountry($loggedUserId);

    $smarty->assign('user', $user);
    $smarty->assign('location', $location);

    $smarty->display('user/user_edit.tpl');

?>