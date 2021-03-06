<?php

include_once ('../../config/init.php');

use ApaiIO\Configuration\GenericConfiguration;
use ApaiIO\Operations\Search;
use ApaiIO\ApaiIO;

$conf = new GenericConfiguration();
$client = new \GuzzleHttp\Client();
$request = new \ApaiIO\Request\GuzzleRequest($client);

$conf
  ->setCountry('com')
  ->setAccessKey('AKIAILCGVBOLCCWSTAZA')
  ->setSecretKey('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')
  ->setAssociateTag('seekbid0e-20')
  ->setRequest($request)
  ->setResponseTransformer(new \ApaiIO\ResponseTransformer\XmlToArray());
$apaiIO = new ApaiIO($conf);

$category = $_GET['category'];
$keyword = $_GET['keyword'];
if(!$category)
  $category = "Books";
if(!$keyword)
  $keyword = "Game of Thrones";

$search = new Search();
$search->setCategory($category);
$search->setKeywords($keyword);
$search->setPage(1);
$search->setResponseGroup(array('Small', 'Images'));
$response = $apaiIO->runOperation($search);
$totalResults = $response['Items']['TotalResults'];

$items = array();
if($totalResults == 1){
  $aux = $response['Items']['Item'];
  array_push($items, $aux);
}
else
  $items = $response['Items']['Item'];

$amazonSearchIndices = array(
  'Apparel',
  'Appliances',
  'Automotive',
  'Baby',
  'Beauty',
  'Books',
  'Classical',
  'DVD',
  'Electronics',
  'Grocery',
  'HealthPersonalCare',
  'HomeGarden',
  'HomeImprovement',
  'Jewelry',
  'KindleStore',
  'Kitchen',
  'Lighting',
  'Music',
  'MusicalInstruments',
  'OfficeProducts',
  'OutdoorLiving',
  'Outlet',
  'PetSupplies',
  'PCHardware',
  'Shoes',
  'Software',
  'SportingGoods',
  'Tools',
  'Toys',
  'Video',
  'VideoGames',
  'Watches'
);

$smarty->assign("searchIndex", $category);
$smarty->assign("keyword", $keyword);
$smarty->assign("searchIndices", $amazonSearchIndices);
$smarty->assign("items", $items);
$amazonDiv = $smarty->fetch('auction/amazon.tpl');
$dataToRetrieve = array(
  'amazonDiv' => $amazonDiv,
  'message' => "Search completed with success!",
  'response' => "Success 200");
echo json_encode($dataToRetrieve);