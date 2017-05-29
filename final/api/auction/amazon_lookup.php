<?php

include_once ('../../config/init.php');

use ApaiIO\Configuration\GenericConfiguration;
use ApaiIO\ApaiIO;
use ApaiIO\Operations\Lookup;

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

$ASIN = $_GET['ASIN'];
if(!$ASIN){
  $reply = array();
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Invalid ASIN.";
  echo json_encode($reply);
  return;
}

$apaiIO = new ApaiIO($conf);
$lookup = new Lookup();
$lookup->setItemId($ASIN);
$lookup->setResponseGroup(array('EditorialReview', 'ItemAttributes'));
$response = $apaiIO->runOperation($lookup);
$item = $response['Items']['Item'];

if($item == null){
  $reply = array();
  $reply['response'] = "Error 400 Bad Request";
  $reply['message'] = "Error retrieving amazon data.";
  echo json_encode($reply);
  return;
}

$description = $item['EditorialReviews']['EditorialReview']['Content'];

$itemAttributes = $item['ItemAttributes'];

$attributes = array();
$regex = '/(?<!^)((?<![[:upper:]])[[:upper:]]|[[:upper:]](?![[:upper:]]))/';
foreach($itemAttributes as $key => $value){
  if(!is_array($value) && strlen($key) > 5){
    $key = preg_replace( $regex, ' $1', $key );
    $characteristic = $key . ": " . $value;
    array_push($attributes, $characteristic);
  }
}

$dataToRetrieve = array(
  'description' => $description,
  'attributes' => $attributes,
  'response' => 'Success 200',
  'message' => "Successful amazon lookup!");
echo json_encode($dataToRetrieve);