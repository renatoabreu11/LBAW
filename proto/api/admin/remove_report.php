<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/admin.php');

if (!$_POST['id'] || !$_POST['type']){
    echo 'All fields are mandatory!';
    return;
}

$report_id = $_POST['id'];
$type = $_POST['type'];