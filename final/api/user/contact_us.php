<?php

include_once("../../config/init.php");

$reply = array();
if(!$_POST['contactEmail']) {
    $reply['response'] = "Error 400 Bad Request.";
    $reply['message'] = "Please type your email.";
    echo json_encode($reply);
    return;
}
$contactEmail = trim(strip_tags($_POST['contactEmail']));

if(!$_POST['contactName']) {
  $reply['response'] = "Error 400 Bad Request.";
  $reply['message'] = "Please type your name.";
  echo json_encode($reply);
  return;
}
$contactName = $_POST['contactName'];

if(!$_POST['message']) {
    $reply['response'] = "Error 400 Bad Request.";
    $reply['message'] = "Please describe your problem.";
    echo json_encode($reply);
    return;
}
$message = $_POST['message'];

$gnomo = 'gnomo.fe.up.pt';
$mail = new PHPMailer;
$mail->isSMTP();
$mail->SMTPDebug = 0;
$mail->Debugoutput = 'html';
$mail->Host = 'smtp.gmail.com';
$mail->Mailer = "gmail";
$mail->Port = 465;
$mail->SMTPSecure = 'tls';
$mail->SMTPAuth = true;

$mail->Username = "seekbid1617@gmail.com";
$mail->Password = "oc86ve46";

$mail->setFrom($contactEmail, $contactName);
$mail->addAddress('seekbid1617@gmail.com', 'Seek Bid');

$mail->IsHTML(true);
$mail->CharSet='utf-8';
$mail->Subject = 'User contact';
$mail->AltBody = 'User contact';
$mail->Body = $message;

if (!$mail->send()) {
  $log->error($mail->ErrorInfo, array('request' => "Mailer password request."));
  $reply['response'] = 'Success 202 Accepted';
  $reply['message'] = "Error sending email.";
} else {
  $reply['response'] = 'Success 200';
  $reply['message'] = "Your message was successfully sent. We'll answer you as fast as we can.";
}

echo json_encode($reply);