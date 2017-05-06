<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_POST['newPass'] || !$_POST['newPassRepeat'] || !$_POST['email']) {
  echo "Error 400 Bad Request: All fields are mandatory.";
  return;
}

$newPass = $_POST['newPass'];
if($newPass != $_POST['newPassRepeat']) {
  echo "Error 400 Bad Request: The password confirmation doesn't match.";
  return;
}

$email = trim($_POST['email']);

try {
  updatePasswordWithEmail($email, $newPass);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error updating password.";
  return;
}

echo 'Success: Password was updated successfully.';