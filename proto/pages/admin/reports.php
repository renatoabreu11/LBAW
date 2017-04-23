<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$username = $_SESSION['admin_username'];
$id = $_SESSION['admin_id'];

if(!$username || !$id){
    $smarty->display('common/404.tpl');
    return;
}

if(!validAdmin($username, $id)){
    $smarty->display('common/404.tpl');
    return;
}

$report_type = $_GET['type'];
$reports;

switch ($report_type){
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
        $report_type = "User";
        $reports = getUserReports();
}

$smarty->assign("report_type", $report_type);
$smarty->assign("reports", $reports);
$smarty->assign("admin_section", "reports");
$smarty->display('admin/admin_page.tpl');