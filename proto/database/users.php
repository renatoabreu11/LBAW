<?php

function createUser($name, $username, $password, $email, $description) {
    global $conn;
    $options = ['cost' => 12];
    $stmt = $conn->prepare('INSERT INTO proto."user" (name, username, hashed_pass, email, short_bio) VALUES (?, ?, ?, ?, ?)');
    $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
    $stmt->execute(array($name, $username, $encryptedPass, $email, $description));
}