<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/auctions.php');

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

$closedAuctions = getClosedAuctions();