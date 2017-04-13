<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$report_type = $_GET['type'];
$reports;

switch ($report_type){
    case "answer_reports":
        $reports = getAnswerReports();
        break;
    case "auction_reports":
        $reports = getAuctionReports();
        break;
    case "question_reports":
        $reports = getQuestionReports();
        break;
    case "review_reports":
        $reports = getReviewReports();
        break;
    default:
        $reports = getUserReports();
}

$smarty->assign("reports", $reports);
$smarty->assign("admin_section", "reports");
$smarty->display('admin/admin_page.tpl');