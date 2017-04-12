<?php
  include_once ('../../config/init.php');
  include_once ($BASE_DIR . 'database/auctions.php');
  
  $auctions = getMostPopularAuctions();
  $numActiveAuctions = getNumActiveAuctions();
  $totalValOfActiveAuctions = getTotalValueOfActiveAuctions();

  $smarty->assign('auctions', $auctions);
  $smarty->assign('numActiveAuctions', $numActiveAuctions);
  $smarty->assign('totalValOfActiveAuctions', $totalValOfActiveAuctions);
  $smarty->display('auctions/list_best_auctions.tpl');
?>