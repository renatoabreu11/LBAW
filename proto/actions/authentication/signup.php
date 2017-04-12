<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['username'] || !$_POST['name'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email'] || !$_POST['description']) {
    $_SESSION['error_messages'][] = "All fields are mandatory!";
    $_SESSION['form_values'] = $_POST;
    header("Location: $BASE_URL" . 'pages/authentication/signup.php');
    exit;
}

$name = trim(strip_tags($_POST["name"]));
$invalidCharacters = false;
if ( !preg_match ("/^[a-zA-Z\s]+$/", $name)) {
    $_SESSION['field_errors']['name'] = 'Invalid name characters';
    $invalidCharacters = true;
}

$username= trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z\s]+$/", $username)) {
    $invalidCharacters = true;
    $_SESSION['field_errors']['username'] = 'Invalid username characters';
}

$description = trim(strip_tags($_POST["description"]));
if ( !preg_match ("/^[a-zA-Z\s]+$/", $description)) {
    $invalidCharacters = true;
    $_SESSION['field_errors']['description'] = 'Invalid description characters';
}

if($invalidCharacters){
    $_SESSION['form_values'] = $_POST;
    header("Location: $BASE_URL" . 'pages/authentication/signup.php');
    exit;
}

$password = $_POST['password'];
$email = $_POST['email'];

try {
    createUser($name, $username, $password, $email, $description);
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'user_pkey') !== false) {
        $_SESSION['error_messages'][] = 'Duplicate username';
        $_SESSION['field_errors']['username'] = 'Username already exists';
    }
    else $_SESSION['error_messages'][] = 'Error creating user';

    $_SESSION['form_values'] = $_POST;
    header("Location: $BASE_URL" . 'pages/authentication/signup.php');
    exit;
}

$_SESSION['success_messages'][] = 'User registered successfully';
header("Location: $BASE_URL" . 'pages/auctions/best_auctions.php');