<?php

/* ========================== SELECTS  ========================== */

/**
 * Select the most popular auctions (popular = more bids).
 */
function getMostPopularAuctions() {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id, auction.num_bids as numBids, auction.start_date 
                            FROM bid
                            INNER JOIN auction ON bid.auction_id = auction.id
                            INNER JOIN product ON auction.product_id = product.id
                            INNER JOIN "user" ON auction.user_id = "user".id
                            WHERE now() < auction.end_date
                            GROUP BY auction.id, product.name, "user".username, "user".rating, auction.curr_bid, auction.end_date, "user".id, auction.num_bids
                            ORDER BY auction.num_bids DESC
                            LIMIT 10;');
  $stmt->execute();
  return $stmt->fetchAll();
}

/**
 * Get number of active auctions.
 */
function getNumActiveAuctions() {
  global $conn;
  $stmt = $conn->prepare('SELECT COUNT(*) 
    						FROM auction 
    						WHERE now() < end_date;');
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['count'];
}

/**
 * Get total value of active auctions.
 */
function getTotalValueOfActiveAuctions() {
  global $conn;
  $stmt = $conn->prepare('SELECT SUM(curr_bid) 
    						FROM auction 
    						WHERE now() < end_date;');
  $stmt->execute();
  $result = $stmt->fetch();
  return $result['sum'];
}

/**
 * Get all auctions.
 */
function getAllAuctions(){
  global $conn;
  $stmt = $conn->prepare('SELECT * 
    						FROM auction
    						ORDER BY id ASC;');
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by name.
 * @param $textSearch
 * @return array
 */
function searchAuctions($textSearch) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank, auction.num_bids as numBids, auction.start_date 
                            FROM auction, product, "user",
                                  plainto_tsquery(\'english\', :textSearch) AS query,
                                  to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch
                            WHERE auction.product_id = product.id 
                            AND bids.auction_id = auction.id
                            AND query @@ textsearch 
                            AND now() < auction.end_date
                            AND auction.user_id = "user".id
                            ORDER BY rank DESC');
  $stmt->bindParam('textSearch', $textSearch);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by category
 * @param $category
 * @return array
 */
function searchAuctionsByCategory($category) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.num_bids as numBids, auction.curr_bid, auction.end_date, "user".id as user_id, auction.start_date
                            FROM auction, product, "user", category, product_category
                            WHERE auction.product_id = product.id
                            AND product.id = product_category.product_id
                            AND product_category.category_id = category.id
                            AND auction.user_id = "user".id
                            AND now() < auction.end_date
                            AND :category = category.name');
  $stmt->bindParam('category', $category);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by category and name
 * @param $textSearch
 * @param $category
 * @return array
 */
function searchAuctionsByCategoryAndName($textSearch, $category) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank, auction.num_bids as numBids, auction.start_date
                            FROM auction, product, "user",
                                  plainto_tsquery(\'english\', :textSearch) AS query,
                                  to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch,
                                  category, product_category
                            WHERE auction.product_id = product.id 
                            AND product.id = product_category.product_id
                            AND product_category.category_id = category.id
                            AND query @@ textsearch 
                            AND now() < auction.end_date
                            AND auction.user_id = "user".id
                            AND :category = category.name
                            ORDER BY rank DESC;');
  $stmt->bindParam('textSearch', $textSearch);
  $stmt->bindParam('category', $category);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by date and price
 * @param $fromDate
 * @param $toDate
 * @param $fromPrice
 * @param $toPrice
 * @return array
 */
function searchAuctionsByDatePrice($fromDate, $toDate, $fromPrice, $toPrice) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.num_bids as numBids, auction.curr_bid, auction.end_date, "user".id as user_id, auction.start_date
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

/**
 * Search auctions by date, name and price
 * @param $fromDate
 * @param $toDate
 * @param $fromPrice
 * @param $toPrice
 * @param $textSearch
 * @return array
 */
function searchAuctionsByDatePriceText($fromDate, $toDate, $fromPrice, $toPrice, $textSearch) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.num_bids as numBids, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank, auction.start_date
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
  $stmt->bindParam('textsearch', $textSearch);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by date, price and a category
 * @param $fromDate
 * @param $toDate
 * @param $fromPrice
 * @param $toPrice
 * @param $category
 * @return array
 */
function searchAuctionsByDatePriceCategory($fromDate, $toDate, $fromPrice, $toPrice, $category) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.num_bids as numBids, auction.curr_bid, auction.end_date, "user".id as user_id, auction.start_date
                            FROM auction, product, "user", category, product_category
                            WHERE auction.product_id = product.id
                            AND product.id = product_category.product_id
                            AND product_category.category_id = category.id
                            AND auction.user_id = "user".id
                            AND :fromDate < auction.end_date
                            AND auction.end_date < :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice
                            AND :category = category.name');
  $stmt->bindParam('fromDate', $fromDate);
  $stmt->bindParam('toDate', $toDate);
  $stmt->bindParam('fromPrice', $fromPrice);
  $stmt->bindParam('toPrice', $toPrice);
  $stmt->bindParam('category', $category);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Search auctions by date, price, text and category
 * @param $fromDate
 * @param $toDate
 * @param $fromPrice
 * @param $toPrice
 * @param $textSearch
 * @param $category
 * @return array
 */
function searchAuctionsByDatePriceTextCategory($fromDate, $toDate, $fromPrice, $toPrice, $textSearch, $category) {
  global $conn;
  $stmt = $conn->prepare('SELECT auction.id, product.name as product_name, product.description, "user".username, "user".rating as user_rating, auction.num_bids as numBids, auction.curr_bid, auction.end_date, "user".id as user_id, ts_rank_cd(textsearch, query) AS rank, auction.start_date
                            FROM auction, product, "user",
                              plainto_tsquery(\'english\', :textsearch) AS query,
                              to_tsvector(\'english\', product.name || \' \' || product.description) AS textsearch,
                              category, product_category
                            WHERE auction.product_id = product.id
                            AND product.id = product_category.product_id
                            AND product_category.category_id = category.id
                            AND query @@ textsearch
                            AND auction.user_id = "user".id
                            AND :fromDate <= auction.end_date
                            AND auction.end_date <= :toDate
                            AND auction.curr_bid >= :fromPrice
                            AND auction.curr_bid <= :toPrice
                            AND :category = category.name
                            ORDER BY rank DESC');
  $stmt->bindParam('fromDate', $fromDate);
  $stmt->bindParam('toDate', $toDate);
  $stmt->bindParam('fromPrice', $fromPrice);
  $stmt->bindParam('toPrice', $toPrice);
  $stmt->bindParam('textsearch', $textSearch);
  $stmt->bindParam('category', $category);
  $stmt->execute();
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Get auctions of a page from the user's watchlist.
 * @param $userId
 * @param $items
 * @param $offset
 * @return array
 * @internal param $user_id
 */
function getPageWatchlistAuctions($userId, $items, $offset){
  global $conn;
  $stmt = $conn->prepare('SELECT watchlist.notifications, auction.* as auction
                                FROM watchlist
                                INNER JOIN auction ON auction.id = watchlist.auction_id
                                WHERE watchlist.user_id = ?             
                                LIMIT ?
                                OFFSET ?');
  $stmt->execute(array($userId, $items, $offset));
  $result = $stmt->fetchAll();
  return $result;
}

/**
 * Count the number of auctions in the watchlist of an user.
 * @param $userId
 * @return
 */
function countWatchlistAuctions($userId){
  global $conn;
  $stmt = $conn->prepare('SELECT COUNT(*)
                                FROM watchlist
                                WHERE user_id = ?');
  $stmt->execute(array($userId));
  $result = $stmt->fetch();
  return $result['count'];
}

/**
 * Get most recent auction.
 */
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

/* ========================== INSERTS  ========================== */

/**
 * Adds an auction the user's watchlist
 * @param $auctionId
 * @param $userId
 * @param $notifications
 */
function addAuctionToWatchlist($auctionId, $userId, $notifications){
  global $conn;
  $stmt = $conn->prepare('INSERT INTO watchlist(auction_id, user_id, date, notifications)
                            VALUES(?, ?, now(), ?)');
  $stmt->execute(array($auctionId, $userId, $notifications));
}

/* ========================== UPDATES  ========================== */

/* ========================== DELETES  ========================== */