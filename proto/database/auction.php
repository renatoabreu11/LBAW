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


function bid($amount_bid, $bidder_id, $auction_id) {
    global $conn;

    $conn->beginTransaction();
    $conn->exec('SET TRANSACTION ISOLATION LEVEL REPEATABLE READ');
    
    $stmt = $conn->prepare('SELECT amount as balance FROM "user" WHERE "user".id = ?;');
    $stmt->execute(array($bidder_id));
    $result = $stmt->fetch();
    $balance = $result['balance'];

    if ($balance >= $amount_bid) {
  
        $stmt = $conn->prepare('INSERT INTO bid (amount, date, user_id, auction_id) 
                                VALUES (:amount, now(), :user_id, :auction_id)');
        $stmt->bindParam('amount', $amount_bid);
        $stmt->bindParam('user_id', $bidder_id);
        $stmt->bindParam('auction_id', $auction_id);
        $stmt->execute();

        $stmt = $conn->prepare('UPDATE "user"
                                SET amount = amount - :amount_bid
                                WHERE "user".id = :user_id;');
        $stmt->bindParam('amount_bid', $amount_bid);
        $stmt->bindParam('user_id', $bidder_id);
        $stmt->execute();

        $conn->commit();
        return "Bet was correctly recorded.";
    }
    else {
        $conn->commit();
        return "Error: insufficient funds.";
    }

}