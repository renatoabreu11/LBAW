<?php

function getAuction($auction_id){
    global $conn;
    $stmt = $conn->prepare('SELECT * 
    						FROM auction 
    						WHERE auction.id = ?');
    $stmt->execute(array($auction_id));
    return $stmt->fetch();
}

function getAuctionProduct($auction_id){
    global $conn;
    $stmt = $conn->prepare('
                          SELECT *
                            FROM product
                            JOIN auction ON auction.product_id = product.id
                            WHERE auction.id = ?;');
    $stmt->execute(array($auction_id));
    return $stmt->fetch();
}

function getProductName($product_id){
    global $conn;
    $stmt = $conn->prepare('
                          SELECT product.name
                            FROM product
                            WHERE product.id = ?;');
    $stmt->execute(array($product_id));
    return $stmt->fetch();
}


function bid($amount, $bidder_id, $auction_id) {
    global $conn;

    $conn->beginTransaction();
    $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');
    
    $stmt = $conn->prepare('SELECT curr_bid FROM auction WHERE auction.id = ?;');
    $stmt->execute(array($auction_id));
    $result = $stmt->fetch();
    $curr_bid = $result['curr_bid'];

    if ($amount > $curr_bid) {
  
        $stmt = $conn->prepare('INSERT INTO bid (amount, date, user_id, auction_id) 
                                VALUES (:amount, now(), :user_id, :auction_id)');
        $stmt->bindParam('amount', $amount);
        $stmt->bindParam('user_id', $bidder_id);
        $stmt->bindParam('auction_id', $auction_id);
        $stmt->execute();

        $stmt = $conn->prepare('UPDATE auction SET curr_bid = :curr_bid WHERE auction.id = :auction_id');
        $stmt->bindParam('curr_bid', $amount);
        $stmt->bindParam('auction_id', $auction_id);
        $stmt->execute();

        $conn->commit();
        return "Bet was correctly recorded.";
    }
    else {
        $conn->commit();
        return "Error: bet is less than the amount of the auction.";
    }

}