<?php

function adminExists($username, $password){
    global $conn;
    $stmt = $conn->prepare('SELECT * FROM admin where username = ?');
    $stmt->execute(array($username));
    $result = $stmt->fetch();
    return ($result !== false && password_verify($password, $result["hashed_pass"]));
}

function createAdmin($username, $password, $email){
    global $conn;
    $options = ['cost' => 12];
    $stmt = $conn->prepare('INSERT INTO admin (username, hashed_pass, email) VALUES (?, ?, ?)');
    $encryptedPass = password_hash($password, PASSWORD_DEFAULT, $options);
    $stmt->execute(array($username, $encryptedPass, $email));
}