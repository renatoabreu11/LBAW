<?php
include_once('../../config/init.php');
include_once($BASE_DIR .'database/users.php');

use Intervention\Image\ImageManager;

if(isset($accessToken)) {
  if (isset($_SESSION['facebook_access_token'])) {
    $fb->setDefaultAccessToken($_SESSION['facebook_access_token']);
  } else {
    // Put short-lived access token in session
    $_SESSION['facebook_access_token'] = (string)$accessToken;

    // OAuth 2.0 client handler helps to manage access tokens
    $oAuth2Client = $fb->getOAuth2Client();

    // Exchanges a short-lived access token for a long-lived one
    $longLivedAccessToken = $oAuth2Client->getLongLivedAccessToken($_SESSION['facebook_access_token']);
    $_SESSION['facebook_access_token'] = (string)$longLivedAccessToken;

    // Set default access token to be used in script
    $fb->setDefaultAccessToken($_SESSION['facebook_access_token']);
  }

  // Getting user facebook profile info
  try {
    $profileRequest = $fb->get('/me?fields=name,first_name,last_name,email,link,picture.width(400).height(400)');
    $fbUserProfile = $profileRequest->getGraphNode()->asArray();
  } catch(FacebookResponseException $e) {
    echo 'Graph returned an error: ' . $e->getMessage();
    session_destroy();
    // Redirect user back to app login page
    header("Location: $BASE_URL");
    exit;
  } catch(FacebookSDKException $e) {
    echo 'Facebook SDK returned an error: ' . $e->getMessage();
    exit;
  }

  // Insert or update user data to the database
  $fbUserData = array(
    'oauth_provider'=> 'facebook',
    'oauth_uid' 	=> $fbUserProfile['id'],
    'first_name' 	=> $fbUserProfile['first_name'],
    'last_name' 	=> $fbUserProfile['last_name'],
    'email' 		=> $fbUserProfile['email'],
    'picture' 		=> $fbUserProfile['picture']['url'],
    'link' 			=> $fbUserProfile['link']
  );

  // Unser Admin Session
  if($_SESSION['admin_username'] != null)
    unset($_SESSION['admin_username']);
  if($_SESSION['admin_id'] != null)
    unset($_SESSION['admin_id']);
  if (!empty($_SESSION['token'])) {
    unset($_SESSION['token']);
  }
  // Put user data into session
  $_SESSION['facebook_user_data'] = $fbUserData;
  if(!getUserByEmail($_SESSION['facebook_user_data']['email'])){
    // Create User
    //$smarty->assign("FACEBOOK_USER_DATA", $_SESSION['facebook_user_data']);
    $_SESSION['form_values']['name'] = $_SESSION['facebook_user_data']['first_name'] . " " . $_SESSION['facebook_user_data']['last_name'];
    $_SESSION['form_values']['email'] = $_SESSION['facebook_user_data']['email'];
    header("Location: $BASE_URL" . "pages/authentication/signup.php");
  }else{
    // Add link to facebook to user if not already linked
    $_SESSION['username'] = getUserUsername($_SESSION['facebook_user_data']['email']);
    $_SESSION['user_id'] = getUserID($_SESSION['username']);
    if(!getUserByEmail($_SESSION['facebook_user_data']['email'])['oauth_id']) {
      $manager = new ImageManager();
      $image = $manager->make($_SESSION['facebook_user_data']['picture']);
      $name = $_SESSION['username'] . '.jpg';
      $dir = $BASE_DIR . "images/users/" . $name;
      $image->save($dir);
      updateUserFacebook($_SESSION['user_id'], $_SESSION['facebook_user_data']['oauth_uid'], $name);
    }
    if (empty($_SESSION['token'])) {
      $_SESSION['token'] = bin2hex(openssl_random_pseudo_bytes(32));
    }
    echo 'Login Successful!';

    header("Location: $BASE_URL" . "pages/auctions/best_auctions.php");
  }
}else{
  // Alert of signin with facebook failed
  header("Location: $BASE_URL" . "pages/authentication/signup.php");
}