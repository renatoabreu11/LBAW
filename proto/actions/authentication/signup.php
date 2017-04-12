<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['username'] || !$_POST['name'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email'] || !$_POST['description']) {
    signupError('All fields are mandatory');
}

$name = trim(strip_tags($_POST["name"]));
if ( !preg_match ("/^[a-zA-Z\s]+$/", $name)) {
    signupError('Invalid name characters');
}

$username= trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z\s]+$/", $username)) {
    signupError('Invalid username characters');
}

$description = trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z\s]+$/", $description)) {
    signupError('Invalid description characters');
}

$password = $_POST['password'];
$email = $_POST['email'];

try {
    createUser($name, $username, $password, $email, $description);
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'users_pkey') !== false) {
        $_SESSION['error_messages'][] = 'Duplicate username';
        $_SESSION['field_errors']['username'] = 'Username already exists';
    }
    else $_SESSION['error_messages'][] = 'Error creating user';

    $_SESSION['form_values'] = $_POST;
    header("Location: /pages/authentication/signup.php");
    exit;
}

$_SESSION['success_messages'][] = 'User registered successfully';
header("Location: $BASE_URL");

function signupError($error){
    $_SESSION['error_messages'][] = $error;
    $_SESSION['form_values'] = $_POST;
    header("Location: /pages/authentication/signup.php");
    exit;
}
