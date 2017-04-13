<?php
  include_once ('../../config/init.php');
  include_once ($BASE_DIR . 'database/auctions.php');
  include_once ($BASE_DIR . 'database/users.php');
  
  $auctions = getMostPopularAuctions();
  $numActiveAuctions = getNumActiveAuctions();
  $totalValOfActiveAuctions = getTotalValueOfActiveAuctions();
  $topTenRankingUsers = getTopTenRankingUsers();

  $smarty->assign('auctions', $auctions);
  $smarty->assign('numActiveAuctions', $numActiveAuctions);
  $smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
  $smarty->assign('topTenRankingUsers', $topTenRankingUsers);
  $smarty->display('auctions/list_best_auctions.tpl');
?>