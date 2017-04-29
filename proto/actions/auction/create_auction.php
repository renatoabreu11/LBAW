<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

print_r($_POST);
if (!empty($_POST['token'])) {
  if (hash_equals($_SESSION['token'], $_POST['token'])) {
    if (!$_POST['product_name'] || !$_POST['category']
      | !$_POST['quantity'] || !$_POST['description']
      || !$_POST['condition'] || !$_POST['user_id']
      || !$_POST['auction_type'] || !$_POST['base_price']
      || !$_POST['start_date'] || !$_POST['end_date']
      || !$_POST['notifications_enabled'] || !$_POST['qa_section']){
      $_SESSION['error_messages'][] = "All fields are mandatory!";
      $_SESSION['form_values'] = $_POST;
      header("Location:"  . $_SERVER['HTTP_REFERER']);
      exit;
    }

    $loggedUserId = $_SESSION['user_id'];
    $userId = $_POST['user_id'];
    $username = $_SESSION['username'];

    if($loggedUserId != $userId){
      $_SESSION['error_messages'][] = "Invalid user. You don't have the necessary permissions to create an auction.";
      header("Location:" . $BASE_URL);
      exit;
    }

    if(!validUser($username, $userId)) {
      $_SESSION['error_messages'][] = "Invalid user. You don't have the necessary permissions to create an auction.";
      header("Location:" . $BASE_URL);
      exit;
    }

    $productName = trim(strip_tags($_POST["product_name"]));
    $invalidInfo = false;
    if ( strlen($productName) > 64) {
      $_SESSION['field_errors']['product_name'] = 'Invalid product name length.';
      $invalidInfo = true;
    }

    $category = $_POST["category"];
    $categoryArr;
    if(count($category) == 2){
      if ( !validCategory($category[0]) || !validCategory($category[1])) {
        $invalidInfo = true;
        $_SESSION['field_errors']['category'] = 'Invalid category.';
      }else{
        $categoryArr = '{' . $category[0] . ',' . $category[1] . '}';
      }
    }else if (count($category) == 1){
      if ( !validCategory($category[0])) {
        $invalidInfo = true;
        $_SESSION['field_errors']['category'] = 'Invalid category.';
      }else{
        $categoryArr = '{' . $category[0] . '}';
      }
    }else{
      $invalidInfo = true;
      $_SESSION['field_errors']['category'] = 'Invalid category.';
    }

    $quantity = $_POST['quantity'];
    if(!is_numeric($quantity)){
      $_SESSION['field_errors']['quantity'] = 'Invalid quantity.';
      $invalidInfo = true;
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

    $auctionType = $_POST["auction_type"];
    if ( !validAuctionType($auctionType)) {
      $invalidInfo = true;
      $_SESSION['field_errors']['auction_type'] = 'Invalid auction type.';
    }

    $basePrice = $_POST['base_price'];
    if(!is_numeric($basePrice)){
      $_SESSION['field_errors']['base_price'] = 'Invalid base price.';
      $invalidInfo = true;
    }

    $startDate = date("Y-m-d H:i:s", strtotime($_POST['start_date']));
    $endDate = date("Y-m-d H:i:s", strtotime($_POST['end_date']));

    if(!$startDate){
      $_SESSION['field_errors']['start_date'] = 'Invalid starting date.';
      $invalidInfo = true;
    }

    if(!$endDate){
      $_SESSION['field_errors']['end_date'] = 'Invalid ending date.';
      $invalidInfo = true;
    }

    $notificationsEnabled = $_POST['notifications_enabled'];
    if($notificationsEnabled != "No" && $notificationsEnabled != "Yes"){
      $_SESSION['field_errors']['notifications_enabled'] = 'Invalid notifications option';
      $invalidInfo = true;
    }

    $qaSection = $_POST['qa_section'];
    if($qaSection != "No" && $qaSection != "Yes"){
      $_SESSION['field_errors']['qa_section'] = 'Invalid Q&A option';
      $invalidInfo = true;
    }

    if($invalidInfo){
      $_SESSION['form_values'] = $_POST;
      header("Location:"  . $_SERVER['HTTP_REFERER']);
      exit;
    }else{
      try {
        createProduct($categoryArr, $productName, $description, $condition);
      } catch (PDOException $e) {
        $_SESSION['error_messages'][] = "Error creating the auction product.";
        $_SESSION['form_values'] = $_POST;
        echo $e->getMessage();
        exit;
      }

      $productId = getLastProductID();
      try {
        createAuction($productId, $userId, $basePrice, $startDate, $endDate, $auctionType, $quantity, $qaSection);
      } catch (PDOException $e) {
        $_SESSION['error_messages'][] = "Error creating auction.";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
      }

      $auctionId = getLastAuctionID();
      try {
        addAuctionToWatchlist($auctionId, $userId, $notificationsEnabled);
      } catch (PDOException $e) {
        $_SESSION['error_messages'][] = "Error adding auction to your watchlist.";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
      }

      $_SESSION['success_messages'][] = 'Auction created with success!';
      header("Location: $BASE_URL" . 'pages/auction/auction_gallery.php?id=' . $auctionId);
    }

  } else {
    $_SESSION['error_messages'][] = "Invalid request!";
    $_SESSION['form_values'] = $_POST;
    header("Location:"  . $_SERVER['HTTP_REFERER']);
    exit;
  }
}else header("Location:"  . $BASE_URL);