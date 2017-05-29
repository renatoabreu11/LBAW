{include file='common/header.tpl'}

<div class="container">
  <div class="row main">
    <div class="panel-heading">
      <div class="panel-title text-center">
        <img src="{$BASE_URL}images/assets/favicon.jpg" class="img-rounded" width="32" height="32" Alt="Seek Bid logo" style="position: relative; bottom: 5px;">
        <h2 class="title" id="title-signup" style="display: inline;">Join Seek Bid for free!</h2>
      </div>
    </div>
    <div class="main-login main-center">
      <form class="form-horizontal" id="signUpForm" action="{$BASE_URL}actions/authentication/signup.php" method="post" enctype="multipart/form-data">
        <div class="form-group">
          <label for="name" class="cols-sm-2 control-label">Name</label>
          <div class="cols-sm-10">
            <div class="input-group">
              <span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
              <input type="text" class="form-control" required maxlength="64" name="name" id="name"  placeholder="Enter your Name" value="{$FORM_VALUES.name}"/>
            </div>
            <strong class="field_error">{$FIELD_ERRORS.name}</strong>
          </div>
        </div>
        <div class="form-group">
          <label for="username" class="cols-sm-2 control-label">Username</label>
          <div class="cols-sm-10">
            <div class="input-group">
              <span class="input-group-addon"><i class="fa fa-users fa" aria-hidden="true"></i></span>
              <input type="text" class="form-control" required maxlength="64" name="username" id="username"  placeholder="Enter your Username" value="{$FORM_VALUES.username}"/>
            </div>
            <strong class="field_error">{$FIELD_ERRORS.username}</strong>
          </div>
        </div>
        <div class="form-group">
          <label for="email" class="cols-sm-2 control-label">Email</label>
          <div class="cols-sm-10">
            <div class="input-group">
              <span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
              <input type="text" class="form-control" required maxlength="64" name="email" id="email"  placeholder="Enter your Email" value="{$FORM_VALUES.email}"/>
            </div>
            <strong class="field_error">{$FIELD_ERRORS.email}</strong>
          </div>
        </div>
        <div class="form-group">
          <label for="password" class="cols-sm-2 control-label">Password</label>
          <div class="cols-sm-10">
            <div class="input-group">
              <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
              <input type="password" class="form-control" required maxlength="64" name="password" id="password"  placeholder="Enter your Password"/>
            </div>
          </div>
        </div>
        <div class="form-group">
          <label for="confirm" class="cols-sm-2 control-label">Confirm Password</label>
          <div class="cols-sm-10">
            <div class="input-group">
              <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
              <input type="password" class="form-control" required maxlength="64" name="confirm" id="confirm"  placeholder="Confirm your Password"/>
            </div>
          </div>
        </div>
        <div class="form-group" id="textarea-signup">
          <div class="form-group" style="padding:12px">
            <label for="description" class="cols-sm-2 control-label">Short bio</label>
            <textarea class="form-control" id="description" required maxlength="256" name="description" rows="5" placeholder="Talk a little about you..." >{$FORM_VALUES.description}</textarea>
          </div>
        </div>
        <div class="form-group text-center" id="signup-btn">
          <button class="btn btn-info" style="width: 180px">Sign up</button>
        </div>
        <div class="form-group text-center">
          <a class="btn btn-primary" href="{$FB_LOGIN_URL}" style="width: 180px">
            <span><i class="fa fa-facebook"> </i></span> Sign in with Facebook
          </a>
        </div>
      </form>
    </div>
  </div>
</div>

<script src="{$BASE_URL}javascript/auth.min.js"></script>

{include file='common/footer.tpl'}