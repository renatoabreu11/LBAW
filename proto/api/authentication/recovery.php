<?php

    include_once("../../config/init.php");
    include_once($BASE_DIR . "database/users.php");

    if(!$_GET['email']) {
        echo "Error 403 Forbidden: You don't have permissions to make this request. You didn't specify the email.";
        return;
    }

    $email = trim(strip_tags($_GET['email']));

    try {
        $link = createRequestPasswordReset($email);
    } catch(PDOException $e) {
        echo "Error 500 Internal Server: Error creating password recovery request." . $e->getMessage();
        return;
    }

    echo "Success 201 Created: A password recovery request was successfully created." . $link;