<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/users.php');

if(!$_POST['user-id'] || !$_POST['currPass'] || !$_POST['newPass'] || !$_POST['newPassRepeat']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = trim(strip_tags($_POST['user-id']));

if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "id doesn't match.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$currPass = $_POST['currPass'];
$newPass = $_POST['newPass'];
$newPassRepeat = $_POST['newPassRepeat'];

// Checks if the password repeat is the same as the password.
if($newPass != $newPassRepeat) {
  $_SESSION['error_messages'][] = "new password must be the same in the 2 columns.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$storedHashPass = getPassword($userId);
// Checks if the stored password is the same.
if(!password_verify($currPass, $storedHashPass)) {
  $_SESSION['error_messages'][] = "your current password is incorrect.";
  $_SESSION['form_values'] = $_POST;
  header("Location:" . $_SERVER['HTTP_REFERER']);
  exit;
}

// Checks if the new introduced password is equal to the current one.
if(password_verify($newPass, $storedHashPass)) {
  $_SESSION['error_messages'] = 'your current password and new password can\'t be the same!';
  $_SESSION['form_values'] = $_POST;
  header("Location: $BASE_URL" . "pages/user/user_edit.php?id=" . $userId);
  exit;
}

try {
  updatePassword($userId, $newPass);
} catch(PDOException $e) {
  echo $e->getMessage();
  $_SESSION['error_messages'][] = "error: can't update user password.";
  $_SESSION['form_values'] = $_POST;
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$_SESSION['success_messages'][] = 'Update successful';
header("Location: $BASE_URL" . 'pages/user/user.php?id=' . $userId);