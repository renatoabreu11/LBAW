<div class="modal fade modalDefault" id="loginModal" tabindex="-1" role="dialog">
  <div class="modal-dialog1 modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <img src="{$BASE_URL}images/assets/favicon.jpg" class="img-rounded" Alt="Seek Bid logo" width="64" height="64">
        <h4>Sign in to Seek Bid</h4>
      </div>
      <div class="modal-body">
        <div class="field_error"></div>
        <form action="{$BASE_URL}api/authentication/signin.php" method="post" id="signInForm">
          <div class="form-group">
            <label for="usrname">Username</label>
            <input type="text" name="username" class="form-control" id="usrname" required maxlength="64">
          </div>
          <div class="form-group">
            <label for="psw">Password</label>
            <input type="password" name="password" class="form-control" id="psw" required maxlength="64">
          </div>
          <button class="btn btn-default btn-success btn-block">Sign in</button>
          <a class="btn btn-primary btn-block" href="{$FB_LOGIN_URL}">
            <span><i class="fa fa-facebook"> </i></span> Sign in with Facebook
          </a>
        </form>
      </div>
      <div class="modal-footer">
        <div class="col-xs-3 pull-left" style="padding-top: 0.5em;">
          <button class="btn btn-info pull-left" data-dismiss="modal">Cancel</button>
        </div>
        <div class="col-xs-9 pull-right">
          <p>Not a member? <a href="{$BASE_URL}pages/authentication/signup.php">Sign Up</a></p>
          <p><a href="{$BASE_URL}pages/authentication/recovery.php">Forgot your password?</a></p>
        </div>
      </div>
    </div>
  </div>
</div>
