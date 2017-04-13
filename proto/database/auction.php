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