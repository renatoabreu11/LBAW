<?php

include_once('../../config/init.php');
include_once($BASE_DIR .'database/auctions.php');
include_once($BASE_DIR .'database/auction.php');
include_once($BASE_DIR .'database/users.php');

if (!empty($_POST['token'])) {
    if (hash_equals($_SESSION['token'], $_POST['token'])) {
        if (!$_POST['product_name'] || !$_POST['category']
            | !$_POST['quantity'] || !$_POST['description']
            || !$_POST['condition'] || !$_FILES['input24']
            || !$_POST['auction_type'] || !$_POST['base_price']
            || !$_POST['start_date'] || !$_POST['end_date']
            || !$_POST['notifications_enabled'] || !$_POST['qa_section']){
                $_SESSION['error_messages'][] = "All fields are mandatory!";
                $_SESSION['form_values'] = $_POST;
                header("Location:"  . $_SERVER['HTTP_REFERER']);
                exit;
         }

        $user_id = $_SESSION['user_id'];
        $username = $_SESSION['username'];

        if(!validUser($username, $user_id)) {
            $_SESSION['error_messages'][] = "Invalid user";
            header("Location: $BASE_URL" . 'pages/auctions/best_auctions.php');
            exit;
        }

        $product_name = trim(strip_tags($_POST["product_name"]));
        $invalidInfo = false;
        if ( strlen($product_name) > 64) {
            $_SESSION['field_errors']['product_name'] = 'Invalid product name length.';
            $invalidInfo = true;
        }

        $category = $_POST["category"];
        $category_arr;
        if(count($category) == 2){
            if ( !validCategory($category[0]) || !validCategory($category[1])) {
                $invalidInfo = true;
                $_SESSION['field_errors']['category'] = 'Invalid category.';
            }else{
                $category_arr = '{' . $category[0] . ',' . $category[1] . '}';
            }
        }else if (count($category) == 1){
            if ( !validCategory($category[0])) {
                $invalidInfo = true;
                $_SESSION['field_errors']['category'] = 'Invalid category.';
            }else{
                $category_arr = '{' . $category[0] . '}';
            }
        }else{
            $invalidInfo = true;
            $_SESSION['field_errors']['category'] = 'Invalid category.';
        }

        $quantity = $_POST['quantity'];
        if(!is_numeric($quantity)){
            $_SESSION['field_errors']['quantity'] = 'Invalid quantity.';
            $invalidInfo = true;
        }

        $description = trim(strip_tags($_POST["description"]));
        if ( strlen($description) > 512) {
            $_SESSION['field_errors']['description'] = 'Invalid description length.';
            $invalidInfo = true;
        }

        $condition = trim(strip_tags($_POST["condition"]));
        if ( strlen($condition) > 512) {
            $_SESSION['field_errors']['condition'] = 'Invalid condition length.';
            $invalidInfo = true;
        }

        $auction_type = $_POST["auction_type"];
        if ( !validAuctionType($auction_type)) {
            $invalidInfo = true;
            $_SESSION['field_errors']['auction_type'] = 'Invalid auction type.';
        }

        $base_price = $_POST['base_price'];
        if(!is_numeric($base_price)){
            $_SESSION['field_errors']['base_price'] = 'Invalid base price.';
            $invalidInfo = true;
        }

        $start_date = date("Y-m-d H:i:s", strtotime($_POST['start_date']));
        $end_date = date("Y-m-d H:i:s", strtotime($_POST['end_date']));

        if(!$start_date){
            $_SESSION['field_errors']['start_date'] = 'Invalid starting date.';
            $invalidInfo = true;
        }

        if(!$end_date){
            $_SESSION['field_errors']['end_date'] = 'Invalid ending date.';
            $invalidInfo = true;
        }

        $notifications_enabled = $_POST['notifications_enabled'];
        if($notifications_enabled != "No" && $notifications_enabled != "Yes"){
            $_SESSION['field_errors']['notifications_enabled'] = 'Invalid notifications option';
            $invalidInfo = true;
        }

        $qa_section = $_POST['qa_section'];
        if($qa_section != "No" && $qa_section != "Yes"){
            $_SESSION['field_errors']['qa_section'] = 'Invalid Q&A option';
            $invalidInfo = true;
        }

        if($invalidInfo){
            $_SESSION['form_values'] = $_POST;
            header("Location:"  . $_SERVER['HTTP_REFERER']);
            exit;
        }else{
            try {
                createProduct($category_arr, $product_name, $description, $condition);
            } catch (PDOException $e) {
                $_SESSION['error_messages'][] = "Error creating the auction product.";
                $_SESSION['form_values'] = $_POST;
                echo $e->getMessage();
                exit;
            }

            $product_id = getLastProductID();

            try {
                createAuction($product_id, $user_id, $base_price, $start_date, $end_date, $type, $quantity, $qa_section);
            } catch (PDOException $e) {
                $_SESSION['error_messages'][] = "Error creating auction.";
                $_SESSION['form_values'] = $_POST;
                header("Location:"  . $_SERVER['HTTP_REFERER']);
                exit;
            }

            $auction_id = getLastAuctionID();
            try {
                createWatchlist($auction_id, $user_id, $notifications_enabled);
            } catch (PDOException $e) {
                $_SESSION['error_messages'][] = "Error adding auction to your watchlist.";
                $_SESSION['form_values'] = $_POST;
                header("Location:"  . $_SERVER['HTTP_REFERER']);
                exit;
            }

            $_SESSION['success_messages'][] = 'Auction created with success!';
            header("Location: $BASE_URL" . 'pages/auction/auction.php?id=' . $auction_id);
        }

    } else {
        $_SESSION['error_messages'][] = "Invalid request!";
        $_SESSION['form_values'] = $_POST;
        header("Location:"  . $_SERVER['HTTP_REFERER']);
        exit;
    }
}