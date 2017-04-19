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
    echo 'Login Successful!';
    return;
} else {
    echo 'Invalid username or password!';
    return;
}