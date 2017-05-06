<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_POST['newPass'] || !$_POST['newPassRepeat'] || !$_POST['email']) {
        echo "Error 403 Forbidden: You don't have permissions to make this request. All fields are mandatory.";
        return;
    }

    $newPass = $_POST['newPass'];
    if($newPass != $_POST['newPassRepeat']) {
        echo "Error 403 Forbidden: You don't have permissions to make this request. Passwords must be the same.";
        return;
    }

    $email = trim($_POST['email']);

    try {
        updatePasswordWithEmail($email, $newPass);
    } catch(PDOException $e) {
        echo "Error 500 Internal Server: Error updating password.";
        return;
    }

    echo 'Success 200 OK: Password was updated successfully.';