<li><a href="#" data-toggle="modal" data-target="#loginModal">Sign in</a></li>
<div class="modal fade modalLogin" id="loginModal" tabindex="-1" role="dialog">
  <div class="modal-dialog1 modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <img src="{$BASE_URL}images/assets/favicon.jpg" class="img-rounded" alt="Cinque Terre" width="64" height="64">
        <h4>Sign in to Seek Bid</h4>
      </div>

      <div class="modal-body">
        <h4 class="field_error"></h4>
        <form role="form" action="{$BASE_URL}api/authentication/signin.php" method="post" id="signInForm">
          <div class="form-group">
            <label for="usrname">Username</label>
            <input type="text" name="username" class="form-control" id="usrname">
          </div>
          <div class="form-group">
            <label for="psw">Password</label>
            <input type="password" name="password" class="form-control" id="psw">
          </div>
          <button type="submit" class="btn btn-default btn-success btn-block">Sign in</button>
          <a class="btn btn-default btn-primary btn-block" href="{$FB_LOGIN_URL}">
            <span><i class="fa fa-facebook"> </i></span> Sign in with Facebook
          </a>
        </form>
      </div>

      <div class="modal-footer">
        <button type="submit" class="btn btn-info pull-left" data-dismiss="modal">Cancel</button>
        <p>Not a member? <a href="{$BASE_URL}pages/authentication/signup.php">Sign Up</a></p>
      </div>
    </div>
  </div>
</div>
<li><a href="{$BASE_URL}pages/authentication/signup.php">Sign up</a></li>
