{include file = 'common/header.tpl'}

  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <ul class="breadcrumb">
          <li>
            <a href="#">Home</a> <span class="divider"></span>
          </li>
          <li>
            <a href="#">Profile</a> <span class="divider"></span>
          </li>
          <li class="active">
            Settings
          </li>
        </ul>
      </div>
    </div>

    <!-- ****************** General information ****************** -->
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h4 class="panel-title">
          <i class="glyphicon glyphicon-user"></i>
          <a href="#profile-edit" data-toggle="collapse">Profile</a>
        </h4>
      </div>
      <div id="profile-edit" class="panel-collapse collapse in">
        <div class="panel-body">
          <form class="form-horizontal" method="post" action="{$BASE_URL}actions/user/user_edit.php" enctype="multipart/form-data">
            <input type="hidden" name="user-id" value="{$user.id}">
            <div class="panel panel-info">
              <div class="panel-heading">General Info</div>
              <div class="panel-body">
                <div class="form-group">
                  <label class="col-md-3 control-label">Avatar: </label>
                  <div class="col-md-6">
                    <img src="../../images/avatars/{$user.profile_pic}" alt="Profile image" width="156">
                    <input type="file">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-md-3 control-label">Real name: </label>
                  <div class="col-md-6">
                    <input type="text" class="form-control" id="real-name" name="real-name" value="{$user.name}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-md-3 control-label">Small biography: </label>
                  <div class="col-md-6">
                    <textarea class="form-control" name="small-bio" rows="2" id="small-bio">{$user.short_bio}</textarea>
                  </div>
                </div>
              </div>
            </div>

            <div class="panel panel-info">
              <div class="panel-heading">Contact Info</div>
              <div class="panel-body">
                <div class="form-group">
                  <label class="col-md-3 control-label">City: </label>
                  <div class="col-md-6">
                    <input type="text" class="form-control" name="city" id="city" value="{$location.city}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-md-3 control-label">Country: </label>
                  <div class="col-md-6">
                    <input type="text" class="form-control" name="country" id="country" value="{$location.country}" >
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-md-3 control-label">e-mail: </label>
                  <div class="col-md-6">
                    <input type="text" class="form-control" name="email" id="e-mail" value="{$user.email}">
                  </div>
                </div>
                <div class="form-group">
                  <label class="col-md-3 control-label">Cellphone number: </label>
                  <div class="col-md-6">
                    <input type="text" class="form-control" name="phone" id="cellphone-number" value="{$user.phone}">
                  </div>
                </div>
              </div>
            </div>

            <div class="panel panel-info">
              <div class="panel-heading">Details Info</div>
              <div class="panel-body">
                <div class="form-group">
                  <label class="col-md-3 control-label">Who am I: </label>
                  <div class="col-md-6">
                    <textarea class="form-control" rows="4" name="full-bio" id="who-am-I">{$user.full_bio}</textarea>
                  </div>
                </div>
              </div>
            </div>

            <div class="row">
              <div class="col-xs-6 text-left">
                <div class="previous">
                  <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
              </div>
              <div class="col-xs-6 text-right">
                <div class="next">
                  <button type="button" class="btn btn-primary btn-discard">Discard</button>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- ****************** Password ****************** -->
    <div class="panel-group">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h4 class="panel-title">
            <i class="glyphicon glyphicon-alert"></i>
            <a href="#password-edit" data-toggle="collapse">Password</a>
          </h4>
        </div>
        <div id="password-edit" class="panel-collapse collapse">
          <div class="panel-body">

            <form class="form-horizontal" method="post" action="{$BASE_URL}actions/user/user_edit_password.php">
              <input type="hidden" name="user-id" value="{$user.id}">
              <div class="form-group">
                <label class="col-md-3 control-label">Current password: </label>
                <div class="col-md-6">
                  <input type="password" class="form-control" name="curr-pass" id="curr-pass">
                </div>
              </div>
              <div class="form-group">
                <label class="col-md-3 control-label">New password: </label>
                <div class="col-md-6">
                  <input type="password" class="form-control" name="new-pass" id="new-pass-1">
                </div>
              </div>
              <div class="form-group">
                <label class="col-md-3 control-label">Repeat password: </label>
                <div class="col-md-6">
                  <input type="password" class="form-control" name="new-pass-repeat" id="new-pass-2">
                </div>
              </div>

              <div class="row">
                <div class="col-xs-6 text-left">
                  <div class="previous">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                  </div>
                </div>
                <div class="col-xs-6 text-right">
                  <div class="next">
                    <button type="button" class="btn btn-primary btn-discard">Discard</button>
                  </div>
                </div>
              </div>
            </form>

          </div>
        </div>
      </div>
    </div>

    <!-- ****************** Notifications ****************** -->
    <div class="panel-group">
      <div class="panel panel-primary">
        <div class="panel-heading">
          <h4 class="panel-title">
            <i class="glyphicon glyphicon-bell"></i>
            <a href="#notifications-edit" data-toggle="collapse">Notifications</a>
          </h4>
        </div>
        <div id="notifications-edit" class="panel-collapse collapse">
          <div class="panel-body">
            <form method="post" action="">
              <div class="panel panel-info">
                <div class="panel-heading">Active Notifications</div>
                <div class="panel-body">
                  <div class="form-group">
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Auction won.</label>
                      </div>
                    </div>
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Bid surpassed.</label>
                      </div>
                    </div>
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Question.</label>
                      </div>
                    </div>
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Question reply.</label>
                      </div>
                    </div>
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Review.</label>
                      </div>
                    </div>
                    <div class="row checkbox-row">
                      <div class="col-md-2 col-md-offset-5">
                        <label class="checkbox-inline"><input type="checkbox" value="" checked> Auction removed.</label>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <div class="row" style="padding-top: 20px;">
                <div class="col-xs-6 text-left">
                  <div class="previous">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                  </div>
                </div>
                <div class="col-xs-6 text-right">
                  <div class="next">
                    <button type="button" class="btn btn-primary btn-discard">Discard</button>
                  </div>
                </div>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script type="text/javascript" src="{$BASE_URL}javascript/user_edit.js"></script>

{include file = 'common/footer.tpl'}