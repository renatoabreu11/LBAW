<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/users.php");

if(!$_POST['username'] || !$_POST['feedback']) {
    echo "All fields are mandatory!";
    return;
}

$username = $_POST["username"];
$feedback = trim(strip_tags($_POST["feedback"]));
$user_id = getUserID($username);

if($user_id === null ){
    echo "Invalid User!";
    return;
}

if ( !preg_match ("/^[a-zA-Z0-9\s]+$/", $feedback)){
    echo 'Invalid feedback characters';
    return;
}

try {
    createFeedback($user_id, $feedback);
} catch (PDOException $e) {
    echo $e->getMessage();
    return;
}

echo "Thank you for your collaboration! With your help we can improve even more our website.";

