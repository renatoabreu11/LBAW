<?php

include_once('../../config/init.php');
include_once($BASE_DIR . 'database/auction.php');
include_once($BASE_DIR . 'database/users.php');

function to_pg_array($set) {
  settype($set, 'array'); // can be called with a scalar or array
  $result = array();
  foreach ($set as $t) {
    if (is_array($t)) {
      $result[] = to_pg_array($t);
    } else {
      $t = str_replace('"', '\\"', $t); // escape double quote
      if (! is_numeric($t)) // quote only non-numeric values
        $t = '"' . $t . '"';
      $result[] = $t;
    }
  }
  return '{' . implode(",", $result) . '}'; // format
}

if (!$_POST['token'] || !hash_equals($_SESSION['token'], $_POST['token'])) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

$loggedUserId = $_SESSION['user_id'];
$userId = $_POST['user_id'];
if($loggedUserId != $userId) {
  $_SESSION['error_messages'][] = "You don't have permissions to make this request.";
  header("Location:"  . $BASE_URL);
  exit;
}

if(!$_POST['product_name'] || !$_POST['category'] || !$_POST['description'] || !$_POST['condition'] || !$_POST['auction_id']) {
  $_SESSION['error_messages'][] = "All fields are required!";
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}

$auctionId = $_POST['auction_id'];

if(!isOwner($userId, $auctionId)){
  header("Location: $BASE_URL");
  exit;
}

$auction = getAuction($auctionId);

if($auction['start_date'] < date("Y-m-d H:i:s")){
  $_SESSION['error_messages'][] = "The auction has already started. You can't update it anymore.";
  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
  exit;
}

$productName = trim(strip_tags($_POST["product_name"]));
$invalidInfo = false;
if ( strlen($productName) > 64) {
  $_SESSION['field_errors']['product_name'] = 'Invalid product name length.';
  $invalidInfo = true;
}

$category = $_POST["category"];
$categoryId1 = NULL;
$categoryId2 = NULL;
if(count($category) == 2){
  if ( !validCategory($category[0]) || !validCategory($category[1])) {
    $invalidInfo = true;
    $_SESSION['field_errors']['category'] = 'Invalid category.';
  }else {
    $categoryId1 = getCategoryId($category[0]);
    $categoryId2 = getCategoryId($category[1]);
    if($categoryId1 == $categoryId2){
      $invalidInfo = true;
      $_SESSION['field_errors']['category'] = 'Invalid categories.';
    }
  }
}else if (count($category) == 1){
  if ( !validCategory($category[0])) {
    $invalidInfo = true;
    $_SESSION['field_errors']['category'] = 'Invalid category.';
  }else{
    $categoryId1 = getCategoryId($category[0]);
  }
}else{
  $invalidInfo = true;
  $_SESSION['field_errors']['category'] = 'Invalid category.';
}

$description = trim(strip_tags($_POST["description"]));
if ( strlen($description) > 512) {
  $_SESSION['field_errors']['description'] = 'Invalid description length.';
  $invalidInfo = true;
}

$condition = trim(strip_tags($_POST["condition"]));
if ( strlen($condition) > 512) {
  $_SESSION['field_errors']['condition'] = 'Invalid condition length.';
  $invalidInfo = true;
}

$tmpCharacteristics = $_POST['characteristics'];
$characteristics;
if(count($tmpCharacteristics) > 10){
  $_SESSION['field_errors']['characteristics'] = 'Invalid number of characteristics.';
  $invalidInfo = true;
}else if(count($tmpCharacteristics) > 0){
  $aux = array_map(function($v){
    return trim(strip_tags($v));
  }, $tmpCharacteristics);

  foreach ($aux as $c){
    if(strlen($c) > 128){
      $_SESSION['field_errors']['characteristics'] = 'Invalid characteristics length. The maximum length is 128 characters.';
      $invalidInfo = true;
    }
  }

  if(!$invalidInfo){
    $characteristics = to_pg_array($aux);
  }
}

if($invalidInfo){
  header("Location:"  . $_SERVER['HTTP_REFERER']);
  exit;
}else {
  $productId = $auction['product_id'];

  try {
    deleteProductCategories($productId);

    if($categoryId1 != NULL){
      createProductCategory($productId, $categoryId1);
    }

    if($categoryId2 != NULL){
      createProductCategory($productId, $categoryId2);
    }

  } catch (PDOException $e) {
    $_SESSION['error_messages'][] = 'Error updating the product\'s categories.';
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }

  try {
    updateProduct($productId, $productName, $description, $condition, $characteristics);
  } catch (PDOException $e) {
    $_SESSION['error_messages'][] = 'Error updating the product.';
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }

  header("Location:"  . $BASE_URL . "pages/auction/auction.php?id=" . $auction['id']);
}