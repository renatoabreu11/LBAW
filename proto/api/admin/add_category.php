<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply = array('message' => "Error 403 Forbidden: You don't have permissions to make this request.");
  echo json_encode($reply);
  return;
}

if (!$_POST['title']){
  $reply = array('message' => 'Error 400 Bad Request: All fields are mandatory!');
  echo json_encode($reply);
  return;
}

$title = trim(strip_tags($_POST["title"]));
if(strlen($title) > 64){
  $reply = array('message' => 'Error 400 Bad Request: Invalid category name length!');
  echo json_encode($reply);
  return;
}

$categoryId;
try {
  createCategory($title);
  $categoryId = getLastCategoryId();
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'category_name_key') !== false){
    $reply = array('message' => "Error 500 Internal Server: Category already exists.");
  } else $reply = array('message' => "Error 500 Internal Server: Error creating category.");
  echo json_encode($reply);
  return;
}

$reply = array('id' => $categoryId, 'category' => $title, 'message' => "Success: Category successfully added!");
echo json_encode($reply);