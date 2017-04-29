<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

if (!$_POST['id']){
  echo 'Invalid feedback id!';
  return;
}

$feedback_id = $_POST['id'];

try {
  deleteFeedback($feedback_id);
} catch (PDOException $e) {
  echo $e->getMessage();
  return;
}

echo "Feedback deleted!";