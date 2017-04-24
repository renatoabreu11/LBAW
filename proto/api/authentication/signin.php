<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['username'] || !$_POST['password']) {
    echo "All fields are mandatory!";
    return;
}

$username = $_POST["username"];
$password = $_POST['password'];

if (userExists($username, $password)) {
    $_SESSION['username'] = $username;
    $_SESSION['user_id'] = getUserID($username);
    if (empty($_SESSION['token'])) {
        $_SESSION['token'] = bin2hex(random_bytes(32));
    }
    echo 'Login Successful!';
    return;
} else {
    echo 'Invalid username or password!';
    return;
}