<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$reply = array();
if (!$_POST['token'] || !$_SESSION['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

$loggedAdminId = $_SESSION['admin_id'];
$adminId = $_POST['adminId'];
if($loggedAdminId != $adminId) {
  $reply['response'] = "Error 403 Forbidden";
  $reply['message'] = "You don't have permissions to make this request.";
  echo json_encode($reply);
  return;
}

if (!$_POST['title']){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "All input fields are mandatory!";
  echo json_encode($reply);
  return;
}

$title = trim(strip_tags($_POST["title"]));
if(strlen($title) > 64){
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid category name length!";
  echo json_encode($reply);
  return;
}

$categoryId;
try {
  $categoryId = createCategory($title);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'category_name_key') !== false){
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Category already exists.";
  } else{
    $log->error($e->getMessage(), array('adminId' => $adminId, 'request' => 'Add new category'));
    $reply['response'] = "Error 500 Internal Server";
    $reply['message'] = "Error creating category.";
  }
  echo json_encode($reply);
  return;
}

$reply = array('id' => $categoryId,
  'category' => $title,
  'response' => 'Success 200',
  'message' => "Category successfully added!");
echo json_encode($reply);