<?php

function createUser($name, $username, $password, $email, $description) {
    global $conn;
    $options = ['cost' => 12];
    $register_date = $date = date('Y-m-d H:i:s');
    $stmt = $conn->prepare('INSERT INTO "user" (name, username, hashed_pass, email, short_bio, register_date) VALUES (?, ?, ?, ?, ?, ?)');
    $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
    $stmt->execute(array($name, $username, $encryptedPass, $email, $description, $register_date));
}