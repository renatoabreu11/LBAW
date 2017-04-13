<li><a href="#" data-toggle="modal" data-target="#loginModal">Sign in</a></li>
<div class="modal fade" id="loginModal" tabindex="-1" role="dialog">
  <div class="modal-dialog modal-sm">
    <div class="modal-content">
      <div class="modal-header">
        <img src="{$BASE_URL}images/assets/favicon.jpg" class="img-rounded" alt="Cinque Terre" width="64" height="64">
        <h4>Sign in to Seek Bid</h4>
      </div>

      <div class="modal-body">
        <form role="form">
          <div class="form-group">
            <label for="usrname">Username or email address</label>
            <input type="text" class="form-control" id="usrname">
          </div>
          <div class="form-group">
            <label for="psw">Password</label>
            <input type="text" class="form-control" id="psw">
          </div>
          <div class="checkbox">
            <label><input type="checkbox" value="" checked>Remember me</label>
          </div>
          <button type="submit" class="btn btn-default btn-success btn-block">Sign in</button>
        </form>
      </div>

      <div class="modal-footer">
        <button type="submit" class="btn btn-default btn-default pull-left" data-dismiss="modal">Cancel</button>
        <p>Not a member? <a href="{$BASE_URL}pages/authentication/signup.php">Sign Up</a></p>
      </div>
    </div>
  </div>
</div>
<li><a href="{$BASE_URL}pages/authentication/signup.php">Sign up</a></li>
