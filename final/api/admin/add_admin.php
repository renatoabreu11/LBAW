<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['username'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email']){
  $reply['response'] = 'Error 400 Bad Request';
  $reply['message'] = 'All input fields are mandatory!';
  echo json_encode($reply);
  return;
}

$username= trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z0-9]+([_ -]?[a-zA-Z0-9])*$/", $username)){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid username characters.";
  echo json_encode($reply);
  return;
}

if(strlen($username) > 64){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid username length.";
  echo json_encode($reply);
  return;
}

$password = $_POST['password'];
if(strlen($password) > 64){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid password length.";
  echo json_encode($reply);
  return;
}

$email = $_POST['email'];

try {
  createAdmin($username, $password, $email);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'admin_username_uindex') !== false){
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Username already exists.";
    echo json_encode($reply);
    return;
  }
  else if (strpos($e->getMessage(), 'admin_email_uindex') !== false){
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Email already exists.";
    echo json_encode($reply);
    return;
  }else {
    $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Add new admin.'));
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Error creating admin.";
    echo json_encode($reply);
    return;
  }
}

$reply['response'] = "Success 200";
$reply['message'] = "Admin successfully added to the database!";
echo json_encode($reply);