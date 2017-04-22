<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['username'] || !$_POST['password']) {
    $_SESSION['error_messages'][] = "Invalid login!";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
}

$username = $_POST["username"];
$password = $_POST['password'];

if (adminExists($username, $password)) {
    $admin_id = getAdminID($username);
    $_SESSION['admin_username'] = $username;
    $_SESSION['admin_id'] = $admin_id;
    $_SESSION['success_messages'][] = 'Login successful';
    header("Location: $BASE_URL" . 'pages/admin/users.php');
} else {
    $_SESSION['error_messages'][] = 'Login failed';
    $_SESSION['field_errors']['login'] = 'Invalid username or password!';
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
}