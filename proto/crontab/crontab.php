<?php

$CRONTAB_FILE = $BASE_DIR . 'crontab/crontab.txt';
$CURL_PATH = '/usr/bin/curl';
$OPEN_AUCTION_SCRIPT = $BASE_URL . 'crontab/open_auction.php';
$CLOSE_AUCTION_SCRIPT = $BASE_URL . 'crontab/close_auction.php';

/**
 * Create contrab command.
 *
 * @param $date {date} the script will run
 * @param $script {php script}
 * @param $auctionId
 */
function createCrontabCommand($date, $script, $auctionId) {
	global $CRONTAB_FILE;
	global $CURL_PATH;
	global $log;

	$timeCrontab = createCrontabTime($date);
	$command = $timeCrontab.' '.$CURL_PATH.' '.$script.'?auctionId='.$auctionId;

	$currJobs = shell_exec('crontab -l');
	$newJobs = $currJobs.$command.PHP_EOL;

  file_put_contents($CRONTAB_FILE, $newJobs);
  exec('crontab ' . $CRONTAB_FILE);
  $output = shell_exec('crontab -l');
  $log->info($output, array('request' => 'Crontab request.'));
}

/**
 * @param $date {date} in php format
 *
 * @return string {string} time in contrab format
 */
function createCrontabTime($date) {
	global $log;

	$date = date_create($date);
	$dayWeek = date_format($date, 'w');
  $month = date_format($date, 'n');
  $dayMonth = date_format($date, 'j');
  $hour = date_format($date, 'G');
  $minute = (int)date_format($date, 'i'); // int because leading zeros...
  $timeCrontab = $minute.' '.$hour.' '.$dayMonth.' '.$month.' '.$dayWeek;
  $log->info($timeCrontab, array('request' => 'Crontab time.'));
  return $timeCrontab; 
}