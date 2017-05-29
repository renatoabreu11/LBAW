<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'crontab/crontab.php');

use ApaiIO\Configuration\GenericConfiguration;
use ApaiIO\ApaiIO;
use ApaiIO\Operations\Lookup;
use Intervention\Image\ImageManager;

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

if (!empty($_POST['token']) || !$_SESSION['token']) {
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

    $quantity = $_POST['quantity'];
    if(!is_numeric($quantity) || $quantity > 25){
      $_SESSION['field_errors']['quantity'] = 'Invalid quantity.';
      $invalidInfo = true;
    }

    $description = trim(strip_tags($_POST["description"], '<br>, </br>, <i></i>, <b></b>'));

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
        return trim(strip_tags($v, '<i></i>, <b></b>'));
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

    $postStartDate = strtr($_POST['start_date'], '/', '-');
    $postEndDate = strtr($_POST['end_date'], '/', '-');
    $startDate = date("Y-m-d H:i", strtotime($postStartDate));
    $endDate = date("Y-m-d H:i", strtotime($postEndDate));
    if($startDate > $endDate){
      $_SESSION['field_errors']['start_date'] = "The auction's starting date has to be smaller than the ending date.";
      $_SESSION['field_errors']['end_date'] = "The auction's ending date has to be after the starting date.";
      $invalidInfo = true;
    }

    if($startDate < date("Y-m-d H:i")){
      $_POST['start_date'] = date("d/m/Y H:i", strtotime('+1 hour'));
      $_SESSION['field_errors']['start_date'] = "The auction's starting date has to be after the current date.";
      $invalidInfo = true;
    }

    if($endDate < date("Y-m-d H:i")){
      $_POST['end_date'] = date("d/m/Y H:i", strtotime('+2 hour'));
      $_SESSION['field_errors']['end_date'] = "The auction's ending date has to be after the current date.";
      $invalidInfo = true;
    }

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
    }else{
      if($notificationsEnabled == "No")
        $notificationsEnabled = 'FALSE';
      else $notificationsEnabled = 'TRUE';
    }

    $qaSection = $_POST['qa_section'];
    if($qaSection != "No" && $qaSection != "Yes"){
      $_SESSION['field_errors']['qa_section'] = 'Invalid Q&A option';
      $invalidInfo = true;
    }else{
      if($qaSection == "No")
        $qaSection = 'FALSE';
      else $qaSection = 'TRUE';
    }

    if($invalidInfo){
      $_SESSION['form_values'] = $_POST;
      header("Location:"  . $_SERVER['HTTP_REFERER']);
      exit;
    }else{
      $auctionId = NULL;
      try {
        $auctionId = createAuction($productName, $description, $condition, $categoryId1, $categoryId2, $userId, $basePrice, $startDate, $endDate, $auctionType, $quantity, $qaSection, $notificationsEnabled, $characteristics);
      } catch (PDOException $e) {
        if (strpos($e->getMessage(), 'product_category_pkey') !== false) {
          $_SESSION['field_errors']['category'] = "Product-category association already exists.";
        } else if (strpos($e->getMessage(), 'auction_date_ck') !== false) {
          $_POST['start_date'] = date("d/m/Y H:i", strtotime('+1 hour'));
          $_POST['end_date'] = date("d/m/Y H:i", strtotime('+2 hour'));
          $_SESSION['field_errors']['start_date'] = "The auction's starting date has to be after the current date.";
          $_SESSION['field_errors']['end_date'] = "The auction's ending date has to be after the starting date.";
        } else {
          $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Create auction.'));
          $_SESSION['error_messages'][] = "Error creating the auction.";
        }

        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
      }

      createCrontabCommand($startDate, $OPEN_AUCTION_SCRIPT, $auctionId);
      createCrontabCommand($endDate, $CLOSE_AUCTION_SCRIPT, $auctionId);

      $ASIN = $_POST['ASIN'];
      if($ASIN != ""){
        $conf = new GenericConfiguration();
        $client = new \GuzzleHttp\Client();
        $request = new \ApaiIO\Request\GuzzleRequest($client);

        $conf
          ->setCountry('com')
          ->setAccessKey('AKIAILCGVBOLCCWSTAZA')
          ->setSecretKey('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')
          ->setAssociateTag('seekbid0e-20')
          ->setRequest($request)
          ->setResponseTransformer(new \ApaiIO\ResponseTransformer\XmlToArray());
        $apaiIO = new ApaiIO($conf);

        $lookup = new Lookup();
        $lookup->setItemId($ASIN);
        $lookup->setResponseGroup(array('Images'));

        $response = $apaiIO->runOperation($lookup);
        $item = $response['Items']['Item'];
        $imageSet = $item['ImageSets']['ImageSet'];
        $mainImage = $item['LargeImage']['URL'];
        $images = array();

        foreach ($imageSet as $image){
          $imageURL = $image['LargeImage']['URL'];
          if($imageURL != NULL && strlen($imageURL) > 0)
            array_push($images, $imageURL);
        }

        if(count($images) == 0){
          array_push($images, $mainImage);
        }

        if(count($images) != 0){
          $manager = new ImageManager();
          $product = getAuctionProduct($auctionId);
          $i = 1;
          foreach ($images as $image){
            if($i > 10)
              break;
            try {
              $filename = basename($image);
              $extension = pathinfo($filename, PATHINFO_EXTENSION);
              $caption = "Amazon pic";
              $imageId = addProductPicture($product['id'], $extension, $caption, $filename);
              $picturePath = $BASE_DIR . "images/auctions/" . $imageId . "." . $extension;
              $thumbnailPath = $BASE_DIR . "images/auctions/thumbnails/" . $imageId . "." . $extension;
              $img = $manager->make($image);
              $img->save($picturePath);
              $img->resize(460, 360);
              $img->save($thumbnailPath);
              $i++;
            } catch(PDOException $e) {
              $log->error($e->getMessage(), array('userId' => $userId, 'request' => 'Upload amazon image.'));
              $_SESSION['error_messages'][] = "Internal server error while association amazon image to product.";
            }
          }
        }
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