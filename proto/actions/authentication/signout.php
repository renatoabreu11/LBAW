<?php

include_once('../../config/init.php');

if($username != null)
    $username = null;
if($password != null)
    $password = null;
if($_SESSION['username'] != null)
    unset($_SESSION['username']);
if($_SESSION['admin_username'] != null)
    unset($_SESSION['admin_username']);

header("Location: $BASE_URL" . 'index.php');