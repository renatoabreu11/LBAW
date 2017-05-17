<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_GET['email']) {
  echo "Error 400 Bad Request: You didn't specify the email.";
  return;
}

$email = trim(strip_tags($_GET['email']));
if(!validEmail($email)){
  echo "Error 400 Bad Request: Invalid email.";
  return;
}

try {
  $username = getUserUsername($email);
} catch(PDOException $e) {
  echo "Error 500 Internal Server: Error getting the username.";
  return;
}

if(!$username) {
  echo "Success: An email with the necessary steps to recover the password was sent to " . $email . ".";
  return;
}

$token = bin2hex(openssl_random_pseudo_bytes(32));
try {
  createRequestPasswordReset($email, $token);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => "Recover password."));
  echo "Error 500 Internal Server: Error creating password recovery request.";
  return;
}

$message = file_get_contents($BASE_URL . 'templates/authentication/email.html');// "<p><strong>" . $username . "</strong> hi there!</p>";
$message = str_replace('%email%', $email, $message);
$message = str_replace('%token%', $token, $message);

$mail = new PHPMailer;
$mail->isSMTP();
$mail->SMTPDebug = 2;
$mail->Debugoutput = 'html';
$mail->Host = 'smtp.gmail.com';
$mail->Mailer   = "gmail";
$mail->Port = 465;
$mail->SMTPSecure = 'tls';
$mail->SMTPAuth = true;

$mail->Username = "seekbid1617@gmail.com";
$mail->Password = "oc86ve46";

$mail->setFrom('seekbid1617@gmail.com', 'Seek Bid');
$mail->addReplyTo($email, 'Seek Bid');
$mail->addAddress($email, 'Jose Carlos');

$mail->IsHTML(true);
$mail->CharSet='utf-8';
$mail->Subject = 'Seek Bid password recovery';
$mail->AltBody = 'This is a plain-text message body';
$mail->MsgHTML($message);
$mail->AddEmbeddedImage($BASE_URL . 'images/assets/favicon.jpg', 'seek-bid-logo');

if (!$mail->send()) {
  $log->error($mail->ErrorInfo, array('request' => "Mailer password request."));
  echo "Error sending mail to " . $email;
} else {
  echo "Success: An email with the necessary steps to recover the password was sent to " . $email . ".";
}