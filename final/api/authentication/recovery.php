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
  createRequestPasswordReset($email);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => "Recover password."));
  echo "Error 500 Internal Server: Error creating password recovery request.";
  return;
}

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
$mail->addReplyTo('renatoabreu1196@gmail.com', 'Seek Bid');
$mail->addAddress($email, 'Renato Abreu');

$mail->IsHTML(true);
$mail->Subject = 'PHPMailer GMail SMTP test';
$mail->AltBody = 'This is a plain-text message body';
$mail->Body = 'cenas mano!';

if (!$mail->send()) {
  $log->error($mail->ErrorInfo, array('request' => "Mailer password request."));
  echo "Error sending mail to " . $email;
} else {
  echo "Success: An email with the necessary steps to recover the password was sent to " . $email . ".";
}