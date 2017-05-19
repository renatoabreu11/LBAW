<?php

include_once ('../../config/init.php');
include_once ($BASE_DIR . 'lib/amazon.php');

$amazon = new Amazon();
$search_indices = $amazon->getSearchIndices();

$items = [];
$keyword = 'Books';
$search_index = 'Books';
$has_searched = false;

if (!empty($_GET['keyword'])) {
  $keyword = $_GET['keyword'];
  $search_index = $_GET['search_index'];
  $has_searched = true;

  if (in_array($search_index, $search_indices)) {
    $response = $amazon->itemSearch($keyword, $search_index);
    $items = $response->Items->Item;
  }
}

$smarty->assign("search_indices", $search_indices);
$smarty->assign("keyword", $keyword);
$smarty->assign("search_index", $search_index);
$smarty->assign("items", $items);
$smarty->assign("has_searched", $has_searched);
$smarty->display('auction/amazon.tpl');