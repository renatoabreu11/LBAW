<?php

function createUser($name, $username, $password, $email, $description) {
    global $conn;
    $stmt = $conn->prepare("INSERT INTO users VALUES (?, ?, ?)");
    $stmt->execute(array($username, $realname, sha1($password)));
}