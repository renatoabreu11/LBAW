<?php

include_once("../../config/init.php");

if(!$_POST['contactEmail']) {
    echo "Error 400 Bad Request: Please write your email.";
    return;
}
$contactEmail = trim(strip_tags($_POST['contactEmail']));

if(!$_POST['message']) {
    echo "Error 400 Bad Request: Please describe your problem";
    return;
}
$message = $_POST['message'];

$gnomo = 'gnomo.fe.up.pt';
$mail = new PHPMailer;
$mail->isSMTP();
$mail->SMTPDebug = 2;
$mail->Debugoutput = 'html';
$mail->Host = 'smtp.gmail.com';
$mail->Mailer = "gmail";
$mail->Port = 465;
$mail->SMTPSecure = 'tls';
$mail->SMTPAuth = true;

$mail->Username = "seekbid1617@gmail.com";
$mail->Password = "oc86ve46";

$mail->setFrom($contactEmail, '');
$mail->addAddress('seekbid1617@gmail.com', 'Seek Bid');

$mail->IsHTML(false);
$mail->CharSet='utf-8';
$mail->Subject = 'User contact';
$mail->AltBody = 'User contact';
$mail->Body = $message;

if (!$mail->send()) {
  $log->error($mail->ErrorInfo, array('request' => "Mailer password request."));
  echo "Error sending mail to " . $email;
} else echo "Success: Your message was successfully sent. We'll answer you as fast as we can.";