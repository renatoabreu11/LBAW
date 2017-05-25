<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');
include_once($BASE_DIR .'database/users.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/auctions.php');

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

$closedAuctions = getClosedAuctions();

$xml = new DOMDocument();
$xml->formatOutput = true;
$xml_root = $xml->createElement("SeekBid");
foreach ($closedAuctions as $auction){
  $xml_auction = $xml->createElement("Auction");
  $xml_auction->setAttribute("Id", $auction['id']);
  $xml_auction->setAttribute("Type", $auction['type']);

  $user = getUser( $auction['user_id']);
  $xml_seller = $xml->createElement("Seller");
  $xml_seller->setAttribute("Id", $auction['user_id']);
  $xml_seller->setAttribute("rating", $user['rating']);
  $xml_seller->appendChild($xml->createElement("Username", $user['username']));
  $xml_seller->appendChild($xml->createElement("Name", $user['name']));
  $xml_seller->appendChild($xml->createElement("Biography", $user['short_bio']));
  $xml_seller->appendChild($xml->createElement("Email", $user['email']));
  $xml_seller->appendChild($xml->createElement("Phone", $user['phone']));
  $xml_auction->appendChild($xml_seller);

  $xml_date = $xml->createElement("Date");
  $xml_date->appendChild($xml->createElement("Creation", $auction['date']));
  $xml_date->appendChild($xml->createElement("Start", $auction['start_date']));
  $xml_date->appendChild($xml->createElement("End", $auction['end_date']));
  $xml_auction->appendChild($xml_date);

  $product = getAuctionProduct($auction['product_id']);
  $characteristics = getProductCharacteristics($auction['product_id']);
  $categories = getProductCategories($auction['product_id']);
  $xml_product = $xml->createElement("Product");
  $xml_product->setAttribute("Id", $auction['product_id']);
  $xml_product->setAttribute("Quantity", $auction['quantity']);
  $xml_product->appendChild($xml->createElement("Name", $product['name']));
  $xml_product->appendChild($xml->createElement("Description", $product['description']));
  $xml_product->appendChild($xml->createElement("Condition", $product['condition']));

  $xml_categories = $xml->createElement("Categories");
  foreach ($categories as $category){
    $xml_category = $xml->createElement("Category", $category['name']);
    $xml_category->setAttribute('Id', $category['id']);
    $xml_categories->appendChild($xml_category);
  }

  $xml_product->appendChild($xml_categories);
  $xml_auction->appendChild($xml_product);

  $xml_bids = $xml->createElement("Bids");
  $xml_bids->appendChild($xml->createElement("Initial_price", $auction['start_bid']));
  $xml_bids->appendChild($xml->createElement("Last_bid", $auction['curr_bid']));
  $xml_bids->appendChild($xml->createElement("Number_bids", $auction['num_bids']));
  $xml_auction->appendChild($xml_bids);

  $winningUser = getWinningUser($auction['id']);
  if($winningUser != NULL){
    $winner = getUser($winningUser['user_id']);
    $xml_winner = $xml->createElement("Auction_winner");
    $xml_winner->setAttribute("Id", $winner['id']);
    $xml_winner->setAttribute("rating", $winner['rating']);
    $xml_winner->appendChild($xml->createElement("Username", $winner['username']));
    $xml_winner->appendChild($xml->createElement("Name", $winner['name']));
    $xml_winner->appendChild($xml->createElement("Biography", $winner['short_bio']));
    $xml_winner->appendChild($xml->createElement("Email", $winner['email']));
    $xml_winner->appendChild($xml->createElement("Phone", $winner['phone']));
    $xml_auction->appendChild($xml_winner);
  }

  $xml_root->appendChild( $xml_auction );
}

$xml->appendChild($xml_root);
$xml->save($BASE_DIR . "config/auctions.xml");

$reply['response'] = "Success 200";
$reply['message'] = "Auctions exported with success! The xml file is stored in the config folder.";
echo json_encode($reply);