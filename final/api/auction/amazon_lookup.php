<?php

include_once ('../../config/init.php');

use ApaiIO\Configuration\GenericConfiguration;
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

use ApaiIO\Operations\Lookup;

$lookup = new Lookup();
$lookup->setItemId('0553593714');
$lookup->setResponseGroup(array('Images'));

$response = $apaiIO->runOperation($lookup);
$item = $images = $response['Items']['Item'];
$imageSet = $item['ImageSets']['ImageSet'];
$mainImage = $item['LargeImage']['URL'];

$images = array();
array_push($images, $mainImage);

foreach ($imageSet as $image){
  $imageURL = $image['LargeImage']['URL'];
  array_push($images, $imageURL);
}

print_r($images);