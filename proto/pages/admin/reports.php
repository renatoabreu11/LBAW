<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['admin_username'];
$id = $_SESSION['admin_id'];
$token = $_SESSION['token'];

if(!$username || !$id || !$token){
  $smarty->display('common/404.tpl');
  return;
}

if(!validAdmin($username, $id)){
  $smarty->display('common/404.tpl');
  return;
}
$reportTypes = ['Answer', 'Auction', 'Question', 'Review', 'User'];
$reportType = $_GET['type'];
$reports;

switch ($reportType){
  case "Answer":
    $reports = getAnswerReports();
    break;
  case "Auction":
    $reports = getAuctionReports();
    break;
  case "Question":
    $reports = getQuestionReports();
    break;
  case "Review":
    $reports = getReviewReports();
    break;
  default:
    $reportType = "User";
    $reports = getUserReports();
}

$smarty->assign("reportTypes", $reportTypes);
$smarty->assign("reportType", $reportType);
$smarty->assign("reports", $reports);
$smarty->assign("adminSection", "reports");
$smarty->display('admin/admin_page.tpl');