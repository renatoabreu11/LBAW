<?php
	
function getMostPopularAuctions() {

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