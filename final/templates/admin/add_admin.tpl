<div class="adminOption">
  <h4><i class="fa fa-user-secret" aria-hidden="true"></i> New admin</h4>
  <form id="newAdmin" class="form-horizontal" style="padding-top: 2em;" action="{$BASE_URL}api/admin/add_admin.php" method="post" enctype="multipart/form-data">
    <div class="form-group">
      <label for="username" class="col-md-4 control-label">Username</label>
      <div class="col-md-4">
        <div class="input-group">
          <span class="input-group-addon"><i class="fa fa-users fa" aria-hidden="true"></i></span>
          <input type="text" class="form-control" name="username" id="username" required maxlength="64" placeholder="Enter the new admin username" value="{$FORM_VALUES.username}"/>
        </div>
        <strong class="field_error username">{$FIELD_ERRORS.username}</strong>
      </div>
    </div>
    <div class="form-group">
      <label for="email" class="col-md-4 control-label">Email</label>
      <div class="col-md-4">
        <div class="input-group">
          <span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
          <input type="text" class="form-control" name="email" id="email" required maxlength="64" placeholder="Enter the new admin email" value="{$FORM_VALUES.email}"/>
        </div>
        <strong class="field_error email">{$FIELD_ERRORS.email}</strong>
      </div>
    </div>
    <div class="form-group">
      <label for="password" class="col-md-4 control-label">Password</label>
      <div class="col-md-4">
        <div class="input-group">
          <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
          <input type="password" class="form-control" name="password" required id="password"  placeholder="Enter password"/>
        </div>
      </div>
    </div>
    <div class="form-group">
      <label for="confirm" class="col-md-4 control-label">Confirm Password</label>
      <div class="col-md-4">
        <div class="input-group">
          <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
          <input type="password" class="form-control" name="confirm" required id="confirm"  placeholder="Confirm password"/>
        </div>
      </div>
    </div>
    <div class="col-sm-10 text-center" style="padding-top: 1em;">
      <button name="saveBtn" class="btn btn-info">Add new admin</button>
    </div>
  </form>
</div>