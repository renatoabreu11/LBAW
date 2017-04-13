<?php
	
function getMostPopularAuctions() {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name, "user".username, "user".rating, auction.curr_bid, auction.end_date
                            FROM bid
                            INNER JOIN auction ON bid.auction_id = auction.id
                            INNER JOIN product ON auction.product_id = product.id
                            INNER JOIN "user" ON auction.user_id = "user".id
                            WHERE now() < auction.end_date
                            GROUP BY auction.id, product.name, "user".username, "user".rating, auction.curr_bid, auction.end_date
                            ORDER BY COUNT(*) DESC
                            LIMIT 15;');
    $stmt->execute();
    return $stmt->fetchAll();
}

function getNumActiveAuctions() {
	global $conn;
    $stmt = $conn->prepare('SELECT COUNT(*) 
    						FROM auction 
    						WHERE now() < end_date;');
    $stmt->execute();
    $result = $stmt->fetch();    
  	return $result['count'];
}

function getTotalValueOfActiveAuctions() {
	global $conn;
    $stmt = $conn->prepare('SELECT SUM(curr_bid) 
    						FROM auction 
    						WHERE now() < end_date;');
    $stmt->execute();
    $result = $stmt->fetch();    
  	return $result['sum'];
}