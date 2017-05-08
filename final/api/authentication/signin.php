<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['username'] || !$_POST['password']) {
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$username = $_POST["username"];
$password = $_POST['password'];

if($_SESSION['admin_username'] != null)
  unset($_SESSION['admin_username']);
if($_SESSION['admin_id'] != null)
  unset($_SESSION['admin_id']);
if (!empty($_SESSION['token'])) {
  unset($_SESSION['token']);
}

if (userExists($username, $password)) {
  $_SESSION['username'] = $username;
  $_SESSION['user_id'] = getUserID($username);
  if (empty($_SESSION['token'])) {
    $_SESSION['token'] = bin2hex(openssl_random_pseudo_bytes(32));
  }
  echo 'Success: Login Successful!';
  return;
} else {
  echo 'Error 400 Bad Request: Invalid username or password!';
  return;
}