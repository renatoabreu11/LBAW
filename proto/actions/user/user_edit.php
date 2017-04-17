<?php

    include_once('../../config/init.php');
    include_once($BASE_DIR . 'database/users.php');

    if(!$_POST['user-id'] || !$_POST['real-name'] || !$_POST['small-bio'] || !$_POST['city'] || !$_POST['country'] || !$_POST['email'] || !$_POST['phone'] || !$_POST['full-bio']) {
        $_SESSION['error_messages'][] = "All fields are required!";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
    }

    $loggedUserId = 1;//$_SESSION['user_id'];
    $userId = trim(strip_tags($_POST['user-id']));

    if($loggedUserId != $userId) {
        $_SESSION['error_messages'][] = "id doesn't match.";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
    }

    $realName = trim(strip_tags($_POST['real-name']));
    $smallBio = trim(strip_tags($_POST['small-bio']));
    $city = trim(strip_tags($_POST['city']));
    $country = trim(strip_tags($_POST['country']));
    $email = trim(strip_tags($_POST['email']));
    $phone = trim(strip_tags($_POST['phone']));
    $fullBio = trim(strip_tags($_POST['full-bio']));

    $invalidChars = false;

    if(!preg_match("/^[a-zA-Z\s]+$/", $realName)) {
        $_SESSION['field_errors']['real_name'] = 'Invalid name characters';
        $invalidChars = true;
    }

    if(!preg_match("/^[a-zA-Z\s]+$/", $city)) {
        $_SESSION['field_errors']['city'] = 'Invalid city characters';
        $invalidChars = true;
    }

    if(!preg_match("/^[a-zA-Z\s]+$/", $country)) {
        $_SESSION['field_errors']['country'] = 'Invalid country characters';
        $invalidChars = true;
    }

    if(!preg_match('/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/', $email)) {
        $_SESSION['field_errors']['email'] = 'Invalid email format';
        $invalidChars = true;
    }

    if($invalidChars) {
        $_SESSION['form_values'] = $_POST;
        header("Location: $BASE_URL" . 'pages/user/user_edit.php?id=' . $userId);
        exit;
    }

    // MAKE FIELD ERROR MESSAGES APPEAR!!!

    try {
        updateUserDetails($userId, $realName, $smallBio, $email, $phone, $fullBio);
    } catch(PDOException $e) {
        $_SESSION['error_messages'][] = "error: can't update user details.";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
    }

    try {
        updateUserLocation($userId, $city, $country);
    } catch(PDOException $e) {
        $_SESSION['error_messages'][] = "error: can't update user location.";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
    }

    $picture = $_FILES['picture'];
    if($picture['size'] > 0) {
        $extension = end(explode(".", $picture['name']));
        try {
            updateUserPicture($userId, $userId . "." . $extension);
        } catch(PDOException $e) {
            echo $e;
            $_SESSION['error_messages'][] = "error: can't update user profile avatar.";
            $_SESSION['form_values'] = $_POST;
            header("Location:"  . $_SERVER['HTTP_REFERER']);
            exit;
        }

        $picturePath = $BASE_DIR . "images/users/" . $userId . "." . $extension;
        if(!move_uploaded_file($picture['tmp_name'], $picturePath)) {
            $_SESSION['error_messages'][] = "error: can't move user profile avatar.";
            $_SESSION['form_values'] = $_POST;
            header("Location:"  . $_SERVER['HTTP_REFERER']);
            exit;
        }
    }

    $_SESSION['success_messages'][] = 'Update successful';
    header("Location: $BASE_URL" . 'pages/user/user.php?id=' . $userId);

?>