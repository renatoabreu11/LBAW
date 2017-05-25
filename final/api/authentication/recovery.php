<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

$reply = array();
if(!$_GET['email']) {
  $reply['response'] = 'Error 400 Bad Request';
  $reply['message'] = "You didn't specify the email!";
  echo json_encode($reply);
  return;
}

$email = trim(strip_tags($_GET['email']));
try {
  $username = getUserUsername($email);
} catch(PDOException $e) {
  $reply['response'] = 'Error 500 Internal Server';
  $reply['message'] = "Error sending email.";
  echo json_encode($reply);
  return;
}

if(!$username) {
  $reply['response'] = 'Success 200';
  $reply['message'] = "An email with the necessary steps to recover the password was sent to " . $email . ".";
  echo json_encode($reply);
  return;
}

$token = bin2hex(openssl_random_pseudo_bytes(32));
try {
  createRequestPasswordReset($email, $token);
} catch(PDOException $e) {
  $log->error($e->getMessage(), array('request' => "Recover password."));
  $reply['response'] = 'Error 500 Internal Server';
  $reply['message'] = "Error creating password recovery request.";
  echo json_encode($reply);
  return;
}

$gnomo = 'gnomo.fe.up.pt';
$message = file_get_contents($BASE_DIR . 'templates/authentication/email.tpl');
$message = str_replace('%base-url%', $gnomo . $BASE_URL, $message);
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
$mail->addAddress($email, 'Jose Carlos');

$mail->IsHTML(true);
$mail->CharSet='utf-8';
$mail->Subject = 'Seek Bid password recovery';
$mail->AltBody = 'Recovery email request for Seek Bid';
$mail->MsgHTML($message);

if (!$mail->send()) {
  $log->error($mail->ErrorInfo, array('request' => "Mailer password request."));
  $reply['response'] = 'Success 202 Accepted';
  $reply['message'] = "Error sending email to " . $email . ".";
  echo json_encode($reply);
  return;
} else {
  $reply['response'] = 'Success 200';
  $reply['message'] = "An email with the necessary steps to recover the password was sent to " . $email . ".";
  echo json_encode($reply);
  return;
}