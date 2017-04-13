<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');
if (!$_POST['username'] || !$_POST['password'] || !$_POST['confirm'] || !$_POST['email']){
    echo 'All fields are mandatory!';
    return;
}

$username= trim(strip_tags($_POST["username"]));
if ( !preg_match ("/^[a-zA-Z0-9\s]+$/", $username)){
    echo 'Invalid username characters';
    return;
}

$password = $_POST['password'];
$email = $_POST['email'];

try {
    createAdmin($username, $password, $email);
} catch (PDOException $e) {
    if (strpos($e->getMessage(), 'admin_username_uindex') !== false){
        echo "Username already exists";
    }
    else if (strpos($e->getMessage(), 'admin_email_uindex') !== false){
        echo "Email already exists";
        return;
    }
    else {
        echo 'Error creating admin' . $e->getMessage();
        return;
    }
}

echo "Admin successfully added!";