<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['username'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$username= trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z0-9]+([_ -]?[a-zA-Z0-9])*$/", $username)){
  echo 'Error 400 Bad Request: Invalid username characters.';
  return;
}

if(strlen($username) > 64){
  echo 'Error 400 Bad Request: Invalid username length.';
  return;
}

$password = $_POST['password'];
if(strlen($password) > 64){
  echo 'Error 400 Bad Request: Invalid password length.';
  return;
}

$email = $_POST['email'];

try {
  createAdmin($username, $password, $email);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'admin_username_uindex') !== false){
    echo "Error 500 Internal Server: Username already exists.";
    return;
  }
  else if (strpos($e->getMessage(), 'admin_email_uindex') !== false){
    echo "Error 500 Internal Server: Email already exists.";
    return;
  }
  else {
    echo "Error 500 Internal Server: Error creating admin.";
    return;
  }
}

echo "Success: Admin successfully added!";