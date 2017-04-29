<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

if (!$_POST['id']){
  echo 'Invalid user id!';
  return;
}

$user_id = $_POST['id'];

try {
  deleteUser($user_id);
} catch (PDOException $e) {
  echo $e->getMessage();
  return;
}

echo "User deleted!";