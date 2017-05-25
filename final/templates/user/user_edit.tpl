{include file = 'common/header.tpl'}

<div class="container">
  <div class="row">
    <div class="col-md-12">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}pages/auctions/best_auctions.php">Home</a> <span class="divider"></span>
        </li>
        <li>
          <a href="{$BASE_URL}pages/user/user.php?id={$user.id}">Profile</a> <span class="divider"></span>
        </li>
        <li class="active">
          Settings
        </li>
      </ul>
    </div>
  </div>
  <div class="panel panel-primary">
    <div class="panel-heading">
      <h4 class="panel-title">
        <i class="glyphicon glyphicon-user"></i>
        <a href="#profile-edit" data-toggle="collapse">Profile</a>
      </h4>
    </div>
    <div id="profile-edit" class="panel-collapse collapse in">
      <div class="panel-body">
        <form class="form-horizontal" id="form-general" method="post" action="{$BASE_URL}actions/user/user_edit.php" enctype="multipart/form-data">
          <input type="hidden" name="userId" value="{$user.id}">
          <input type="hidden" name="token" value="{$TOKEN}">
          <input type="hidden" name="picture" value="{$BASE_URL}images/users/{$user.profile_pic}">
          <div class="panel panel-info">
            <div class="panel-heading">General Info</div>
            <div class="panel-body">
              <div class="form-group">
                <label for="picture" class="col-md-3 control-label">Avatar: </label>
                <div class="kv-avatar center-block text-center" style="width:200px">
                  <input id="picture" name="picture" type="file" class="file-loading">
                </div>
                <div id="kv-avatar-errors-1" class="center-block" style="width: 75%; display:none"></div>
              </div>
              <div class="form-group">
                <label for="real-name" class="col-md-3 control-label">Real name: </label>
                <div class="col-md-6">
                  <input type="text" class="form-control" id="real-name" name="realName" value="{$user.name}" required maxlength="64">
                </div>
                <strong class="field_error">{$FIELD_ERRORS.realName}</strong>
              </div>
              <div class="form-group">
                <label for="small-bio" class="col-md-3 control-label">Small biography: </label>
                <div class="col-md-6">
                  <textarea class="form-control" name="smallBio" rows="2" required maxlength="255" id="small-bio">{$user.short_bio}</textarea>
                </div>
                <strong class="field_error">{$FIELD_ERRORS.smallBio}</strong>
              </div>
            </div>
          </div>
          <div class="panel panel-info">
            <div class="panel-heading">Contact Info</div>
            <div class="panel-body">
              <div class="form-group">
                <label class="col-md-3 control-label">Country and city: </label>
                <div class="col-md-6 col-xs-12">
                  <select class="input-md form-control selectpicker show-tick" id="country-city" name="cityId" data-max-options="1" data-live-search="true" title="Define your location">
                    {foreach $countries as $country}
                      <optgroup label="{$country.name}">
                        {foreach $cities as $city}
                          {if ($city.country_id == $country.id)}
                            {if $city.id == $userCurrLocation.city_id}
                              <option selected value="{$city.id}">{$city.name}</option>
                            {else} <option value="{$city.id}">{$city.name}</option>
                            {/if}
                          {/if}
                        {/foreach}
                      </optgroup>
                    {/foreach}
                  </select>
                </div>
                <strong class="field_error">{$FIELD_ERRORS.cityId}</strong>
              </div>
              <div class="form-group">
                <label for="e-mail" class="col-md-3 control-label">E-mail: </label>
                <div class="col-md-6">
                  <input type="text" class="form-control" required maxlength="64" name="email" id="e-mail" value="{$user.email}">
                </div>
                <strong class="field_error">{$FIELD_ERRORS.email}</strong>
              </div>
              <div class="form-group">
                <label for="cellphone-number" class="col-md-3 control-label">Phone number: </label>
                <div class="col-md-6">
                  <input type="number" class="form-control" name="phone" id="cellphone-number" value="{$user.phone}">
                </div>
                <strong class="field_error">{$FIELD_ERRORS.phone}</strong>
              </div>
            </div>
          </div>
          <div class="panel panel-info">
            <div class="panel-heading">Details Info</div>
            <div class="panel-body">
              <div class="form-group">
                <label for="who-am-I" class="col-md-3 control-label">Who am I: </label>
                <div class="col-md-6">
                  <textarea class="form-control" rows="4" name="fullBio" id="who-am-I">{$user.full_bio}</textarea>
                </div>
                <strong class="field_error">{$FIELD_ERRORS.fullBio}</strong>
              </div>
            </div>
          </div>
          <div class="row">
            <div class="col-xs-6 text-left">
              <div class="previous">
                <button class="btn btn-primary">Save Changes</button>
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
          <form class="form-horizontal" id="form-password" method="post" action="{$BASE_URL}actions/user/user_edit_password.php">
            <input type="hidden" name="user-id" value="{$user.id}">
            <div class="form-group">
              <label for="curr-pass" class="col-md-3 control-label">Current password: </label>
              <div class="col-md-6">
                <input type="password" required maxlength="64" class="form-control" name="currPass" id="curr-pass">
              </div>
              <strong class="field_error">{$FIELD_ERRORS.currPass}</strong>
            </div>
            <div class="form-group">
              <label for="new-pass-1" class="col-md-3 control-label">New password: </label>
              <div class="col-md-6">
                <input type="password" required maxlength="64" class="form-control" name="newPass" id="new-pass-1">
              </div>
              <strong class="field_error">{$FIELD_ERRORS.newPass}</strong>
            </div>
            <div class="form-group">
              <label for="new-pass-2" class="col-md-3 control-label">Repeat password: </label>
              <div class="col-md-6">
                <input type="password" required maxlength="64" class="form-control" name="newPassRepeat" id="new-pass-2">
              </div>
              <strong class="field_error">{$FIELD_ERRORS.newPassRepeat}</strong>
            </div>
            <div class="row">
              <div class="col-xs-6 text-left">
                <div class="previous">
                  <button class="btn btn-primary">Save Changes</button>
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

<script type="text/javascript" src="{$BASE_URL}lib/fileinput/fileinput.js"></script>
<script type="text/javascript" src="{$BASE_URL}lib/select/bootstrap-select.js"></script>
<script type="text/javascript" src="{$BASE_URL}javascript/user_edit.min.js"></script>

{include file = 'common/footer.tpl'}