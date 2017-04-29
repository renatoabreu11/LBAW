<?php

include_once('../../config/init.php');

if($_SESSION['username'] != null)
  unset($_SESSION['username']);
if($_SESSION['admin_username'] != null)
  unset($_SESSION['admin_username']);
if($_SESSION['user_id'] != null)
  unset($_SESSION['user_id']);
if (!empty($_SESSION['token'])) {
  unset($_SESSION['token']);
}
if (!empty($_SESSION['facebook_user_data'])) {
    unset($_SESSION['facebook_user_data']);
}
if (!empty($_SESSION['facebook_access_token'])) {
    unset($_SESSION['facebook_access_token']);
}

header("Location: $BASE_URL" . 'index.php');