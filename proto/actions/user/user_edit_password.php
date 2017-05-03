<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user-id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['curr-pass'] || !$_POST['new-pass'] || !$_POST['new-pass-repeat']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$currPass = $_POST['curr-pass'];
$newPass = $_POST['new-pass'];
$newPassRepeat = $_POST['new-pass-repeat'];

// Checks if the password repeat is the same as the password.
if($newPass != $newPassRepeat) {
  $_SESSION['error_messages'][] = "The new password must be equal to the confirmation.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

if(strlen($newPass) > 64){
  $_SESSION['error_messages'][] = "The new password length exceeds the maximum.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$storedHashPass = getPassword($userId);

// Checks if the stored password is the same.
if(!password_verify($currPass, $storedHashPass)) {
  $_SESSION['error_messages'][] = "Invalid current password.";
  $_SESSION['form_values'] = $_POST;
  header("Location:" . $_SERVER['HTTP_REFERER']);
  exit;
}

/*if(!preg_match("/(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!#$%+*?@€&])([a-zA-Z\d!#$%+*?@€& ]){8,25}/", $newPass)) {
    $_SESSION['field_errors']['new_password'] = 'Invalid new password! Minimum 8 and maximum 25 characters, must contain at least 1 uppercase letter, 1 lowercase letter, 1 number and 1 special character.';
    $_SESSION['form_values'] = $_POST;
    header("Location: $BASE_URL" . "pages/user/user_edit.php?id=" . $userId);
    exit;
}*/

// Checks if the new introduced password is equal to the current one.
if(password_verify($newPass, $storedHashPass)) {
  $_SESSION['error_messages'] = 'Your current password and new password can\'t be the same!';
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . "pages/user/user_edit.php?id=" . $userId);
  exit;
}

try {
  updatePassword($userId, $newPass);
} catch(PDOException $e) {
  echo $e->getMessage();
  $_SESSION['error_messages'][] = "Error updating your password password.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$_SESSION['success_messages'][] = 'Password updated with success!';
header("Location: $BASE_URL" . 'pages/user/user.php?id=' . $userId);