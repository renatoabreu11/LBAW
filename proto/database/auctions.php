<?php

/**
 * Popular = more bids
 */
function getMostPopularAuctions() {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id
                            FROM bid
                            INNER JOIN auction ON bid.auction_id = auction.id
                            INNER JOIN product ON auction.product_id = product.id
                            INNER JOIN "user" ON auction.user_id = "user".id
                            WHERE now() < auction.end_date
                            GROUP BY auction.id, product.name, "user".username, "user".rating, auction.curr_bid, auction.end_date, "user".id
                            ORDER BY COUNT(*) DESC
                            LIMIT 10;');
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

function getAllAuctions(){
    global $conn;
    $stmt = $conn->prepare('SELECT * 
    						FROM auction
    						ORDER BY id ASC;');
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctions($textSearch) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank
                            FROM auction, product, "user",
                                  plainto_tsquery(\'english\', :textSearch) AS query,
                                  to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch
                            WHERE auction.product_id = product.id 
                            AND query @@ textsearch 
                            AND now() < auction.end_date
                            AND auction.user_id = "user".id
                            ORDER BY rank DESC');
    $stmt->bindParam('textSearch', $textSearch);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByCategory($category) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating,
                            auction.curr_bid, auction.end_date, "user".id as user_id
                            FROM auction, product, "user"
                            WHERE auction.product_id = product.id
                            AND auction.user_id = "user".id
                            AND now() < auction.end_date
                            AND :category = ANY(product.type)');
    $stmt->bindParam('category', $category);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByCategoryAndName($textSearch, $category) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank
                            FROM auction, product, "user",
                                  plainto_tsquery(\'english\', :textSearch) AS query,
                                  to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch
                            WHERE auction.product_id = product.id 
                            AND query @@ textsearch 
                            AND now() < auction.end_date
                            AND auction.user_id = "user".id
                            AND :category = ANY(product.type)
                            ORDER BY rank DESC;');
    $stmt->bindParam('textSearch', $textSearch);
    $stmt->bindParam('category', $category);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByDatePrice($fromDate, $toDate, $fromPrice, $toPrice) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating,
                            auction.curr_bid, auction.end_date, "user".id as user_id
                            FROM auction, product, "user"
                            WHERE auction.product_id = product.id
                            AND auction.user_id = "user".id
                            AND :fromDate < auction.end_date
                            AND auction.end_date < :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice;');
    $stmt->bindParam('fromDate', $fromDate);
    $stmt->bindParam('toDate', $toDate);
    $stmt->bindParam('fromPrice', $fromPrice);
    $stmt->bindParam('toPrice', $toPrice);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByDatePriceText($fromDate, $toDate, $fromPrice, $toPrice, $textsearch) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating,
                            auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank
                            FROM auction, product, "user",
                              plainto_tsquery(\'english\', :textsearch) AS query,
                              to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch
                            WHERE auction.product_id = product.id
                            AND query @@ textsearch
                            AND auction.user_id = "user".id
                            AND :fromDate <= auction.end_date
                            AND auction.end_date <= :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice
                            ORDER BY rank DESC');
    $stmt->bindParam('fromDate', $fromDate);
    $stmt->bindParam('toDate', $toDate);
    $stmt->bindParam('fromPrice', $fromPrice);
    $stmt->bindParam('toPrice', $toPrice);
    $stmt->bindParam('textsearch', $textsearch);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByDatePriceCategory($fromDate, $toDate, $fromPrice, $toPrice, $category) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating,
                            auction.curr_bid, auction.end_date, "user".id as user_id
                            FROM auction, product, "user"
                            WHERE auction.product_id = product.id
                            AND auction.user_id = "user".id
                            AND :fromDate < auction.end_date
                            AND auction.end_date < :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice
                            AND :category = ANY(product.type)');
    $stmt->bindParam('fromDate', $fromDate);
    $stmt->bindParam('toDate', $toDate);
    $stmt->bindParam('fromPrice', $fromPrice);
    $stmt->bindParam('toPrice', $toPrice);
    $stmt->bindParam('category', $category);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function searchAuctionsByDatePriceTextCategory($fromDate, $toDate, $fromPrice, $toPrice, $textsearch, $category) {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating,
                            auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank
                            FROM auction, product, "user",
                              plainto_tsquery(\'english\', :textsearch) AS query,
                              to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch
                            WHERE auction.product_id = product.id
                            AND query @@ textsearch
                            AND auction.user_id = "user".id
                            AND :fromDate <= auction.end_date
                            AND auction.end_date <= :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice
                            AND :category = ANY(product.type)
                            ORDER BY rank DESC');
    $stmt->bindParam('fromDate', $fromDate);
    $stmt->bindParam('toDate', $toDate);
    $stmt->bindParam('fromPrice', $fromPrice);
    $stmt->bindParam('toPrice', $toPrice);
    $stmt->bindParam('textsearch', $textsearch);
    $stmt->bindParam('category', $category);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function deleteAuction($auction_id){
    global $conn;
    $stmt = $conn->prepare('DELETE 
                            FROM auction
                            WHERE id = ?');
    $stmt->execute(array($auction_id));
}

function getPageWatchlistAuctions($user_id, $items, $offset){
    global $conn;
    $stmt = $conn->prepare('SELECT watchlist.notifications, auction.* as auction
                                FROM watchlist
                                INNER JOIN auction ON auction.id = watchlist.auction_id
                                WHERE watchlist.user_id = ?             
                                LIMIT ?
                                OFFSET ?');
    $stmt->execute(array($user_id, $items, $offset));
    $result = $stmt->fetchAll();
    return $result;
}

function countWatchlistAuctions($user_id){
    global $conn;
    $stmt = $conn->prepare('SELECT COUNT(*)
                                FROM watchlist
                                WHERE user_id = ?');
    $stmt->execute(array($user_id));
    $result = $stmt->fetch();
    return $result['count'];
}

function getMostRecentAuction() {
    global $conn;
    $stmt = $conn->prepare('SELECT auction.id as auction_id, product.name as product_name, (SELECT image.filename 
                                                                                            FROM image
                                                                                            JOIN product ON image.product_id = product.id
                                                                                            LIMIT 1) as image_filename
                            FROM auction
                            JOIN product ON auction.product_id = product.id
                            ORDER BY auction.id DESC
                            LIMIT 1');
    $stmt->execute();
    return $stmt->fetch();
}