<?php

include_once('../../config/init.php');

if($_SESSION['username'] != null)
    unset($_SESSION['username']);
if($_SESSION['admin_username'] != null)
    unset($_SESSION['admin_username']);
if($_SESSION['user_id'] != null)
    unset($_SESSION['user_id']);

header("Location: $BASE_URL" . 'index.php');