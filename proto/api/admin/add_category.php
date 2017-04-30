<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  echo "Error 403 Forbidden: You don't have permissions to make this request.";
  return;
}

if (!$_POST['title']){
  echo 'Error 400 Bad Request: All fields are mandatory!';
  return;
}

$title= trim(strip_tags($_POST["title"]));

try {
  createCategory($title);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'category_name_key') !== false){
    echo "Error 500 Internal Server: Category already exists";
  } else echo $e->getMessage() . "Error 500 Internal Server: Error creating category.";
  return;
}

echo "Success 201 Created: Category successfully added!";