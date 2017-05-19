<?php

class Amazon {
  public $common_params;
  private $client;

  public function __construct() {
    $this->common_params = [
      'Service' => 'AWSECommerceService',
      'Operation' => 'ItemSearch',
      'ResponseGroup' => 'Medium',
      'AssociateTag' => 'seekbid0e-20',
      'AWSAccessKeyId' => 'AKIAIIU2FF6IJUP33MRQ',
    ];
    $this->client = new GuzzleHttp\Client();
  }

  private function generateSignature($query) {
    ksort($query);

    $sign = http_build_query($query);

    $request_method = 'GET';
    $base_url = 'webservices.amazon.com';
    $endpoint = '/onca/xml';

    $string_to_sign = "{$request_method}\n{$base_url}\n{$endpoint}\n{$sign}";
    $signature = base64_encode(
      hash_hmac("sha256", $string_to_sign, '/co8H40l+Du25rSh/Bn1oTNbxQL3WACs8uFPEwww', true)
    );
    return $signature;
  }

  private function doRequest($query) {
    $timestamp = date('c');
    $query['Timestamp'] = $timestamp;
    $query = array_merge($this->common_params, $query);
    $query['Signature'] = $this->generateSignature($query);

    try {
      $response = $this->client->request(
        'GET', 'http://webservices.amazon.com/onca/xml',
        ['query' => $query]
      );
      $contents = new \SimpleXMLElement($response->getBody()->getContents());
      return $contents;
    } catch (GuzzleHttp\Exception\ClientException $e) {
      $response = $e->getResponse();
      $responseBodyAsString = $response->getBody()->getContents();
      return [
        'error' => $responseBodyAsString
      ];
    }
  }

  public function getSearchIndices() {
    return [
      'All',
      'Appliances',
      'ArtsAndCrafts',
      'Automotive',
      'Baby',
      'Beauty',
      'Books',
      'Collectibles',
      'Electronics',
      'Fashion',
      'Grocery',
      'HealthPersonalCare',
      'HomeGarden',
      'Industrial',
      'KindleStore',
      'LawnAndGarden',
      'Luggage',
      'Magazines',
      'MobileApps',
      'Music',
      'MusicalInstruments',
      'OfficeProducts',
      'PCHardware',
      'PetSupplies',
      'Software',
      'SportingGoods',
      'Tools',
      'Toys',
      'Vehicles',
      'VideoGames'
    ];
  }

  public function itemSearch($keywords, $search_index) {
    $query = [
      'Keywords' => $keywords,
      'SearchIndex' => $search_index
    ];

    $response = $this->doRequest($query);
    return $response;
  }
}