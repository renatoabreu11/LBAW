<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['username'] || !$_POST['name'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email'] || !$_POST['description']) {
  $_SESSION['error_messages'][] = "All fields are mandatory!";
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . 'pages/authentication/signup.php');
  exit;
}

$name = trim(strip_tags($_POST["name"]));
$invalidCharacters = false;
if ( !preg_match ("/^[a-zA-Z\s]+$/", $name)) {
  $_SESSION['field_errors']['name'] = 'Invalid name characters.';
  $invalidCharacters = true;
}

if(strlen($name) > 64){
  $_SESSION['field_errors']['name'] = 'Invalid name length.';
  $invalidCharacters = true;
}

$username = trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z0-9]+([_ -]?[a-zA-Z0-9])*$/", $username)) {
  $invalidCharacters = true;
  $_SESSION['field_errors']['username'] = 'Invalid username characters. ';
}

if(strlen($username) > 64){
  $_SESSION['field_errors']['username'] = 'Invalid username length.';
  $invalidCharacters = true;
}

$description = trim(strip_tags($_POST["description"]));
if(strlen($description) > 255){
  $_SESSION['field_errors']['description'] = 'Invalid description length.';
  $invalidCharacters = true;
}

if($invalidCharacters){
  $_SESSION['form_values'] = $_POST;
  $_SESSION['error_messages'][] = "Sign Up failed!";
  header("Location: $BASE_URL" . 'pages/authentication/signup.php');
  exit;
}

$password = $_POST['password'];
$email = $_POST['email'];

try {
  createUser($name, $username, $password, $email, $description);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'user_username_uindex') !== false) {
    $_SESSION['field_errors']['username'] = 'Username already exists';
  }
  else if (strpos($e->getMessage(), 'user_email_uindex') !== false){
    $_SESSION['field_errors']['email'] = 'Email already exists';
  } else{
    $log->error($e->getMessage(), array('request' => 'Create user'));
    $_SESSION['error_messages'][] = 'Error creating user';
  }

  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . 'pages/authentication/signup.php');
  exit;
}
// facebook info
if(isset($_SESSION['facebook_user_data']))
    updateUserFacebook(getUserID($username), $_SESSION['facebook_user_data']['oauth_uid'], $_SESSION['facebook_user_data']['picture']);

// Session

// Unset Admin Session
if($_SESSION['admin_username'] != null)
    unset($_SESSION['admin_username']);
if($_SESSION['admin_id'] != null)
    unset($_SESSION['admin_id']);
if (!empty($_SESSION['token'])) {
    unset($_SESSION['token']);
}

$_SESSION['username'] = $username;
$_SESSION['user_id'] = getUserID($username);
if (empty($_SESSION['token'])) {
    $_SESSION['token'] = bin2hex(openssl_random_pseudo_bytes(32));
}

$_SESSION['success_messages'][] = 'User successfully registered';
header("Location: $BASE_URL" . 'pages/auctions/best_auctions.php');