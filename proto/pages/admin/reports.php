<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/admins.php');

$report_type = $_GET['type'];
$type;
$reports;

switch ($report_type){
    case "answer_reports":
        $type = "Answer";
        $reports = getAnswerReports();
        break;
    case "auction_reports":
        $type = "Auction";
        $reports = getAuctionReports();
        break;
    case "question_reports":
        $type = "Question";
        $reports = getQuestionReports();
        break;
    case "review_reports":
        $type = "Review";
        $reports = getReviewReports();
        break;
    default:
        $type = "User";
        $reports = getUserReports();
}

$smarty->assign("report_type", $type);
$smarty->assign("reports", $reports);
$smarty->assign("admin_section", "reports");
$smarty->display('admin/admin_page.tpl');