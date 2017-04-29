<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['title']){
  echo 'All fields are mandatory!';
  return;
}

$title= trim(strip_tags($_POST["title"]));
if ( !preg_match ("/^[a-zA-Z0-9\s]+$/", $title)){
  echo 'Invalid category characters';
  return;
}

try {
  createCategory($title);
} catch (PDOException $e) {
  if (strpos($e->getMessage(), 'Duplicate object') !== false){
    echo "Category already exists";
  } else echo $e->getMessage();
  return;
}

echo "Category successfully added!";