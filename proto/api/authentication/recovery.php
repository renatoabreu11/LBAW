<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_GET['email']) {
  echo "Error 400 Bad Request: You didn't specify the email.";
  return;
}

$email = trim(strip_tags($_GET['email']));

try {
  $link = createRequestPasswordReset($email);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error creating password recovery request.";
  return;
}

echo "Success: A password recovery request was successfully created." . $link;