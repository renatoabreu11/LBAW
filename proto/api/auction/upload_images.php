<?php

include_once("../../config/init.php");
include_once($BASE_DIR . "database/auction.php");

if (!empty($_POST['token'])) {
    if (hash_equals($_SESSION['token'], $_POST['token'])) {

        print_r($_FILES);
        print_r($_POST);
    }else {
        exit;
    }
}else {
    exit;
}