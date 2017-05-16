<form id="updateSettingsForm" action="{$BASE_URL}actions/auction/update_settings.php" method="post" enctype="multipart/form-data">
  <input type="hidden" name="token" value="{$TOKEN}">
  <input type="hidden" name="user_id" value="{$USER_ID}">
  <input type="hidden" name="auction_id" value="{$auction.id}">
  <div class="row setup-content" id="step-3">
    <div class="col-xs-12">
      <div class="col-md-12 well">
        <h3> Settings</h3>
        <div class="form-group">
          <label class="control-label col-md-4"> Q&A section<span> *</span> </label>
          <div class="input-group col-md-8 col-xs-12">
            <select class="selectpicker input-md form-control" name="qa_section" id="qa_section" title="Do you want to answer questions about this auction?">
              {if $auction.questions_section == 1}
                <option selected>Yes</option>
              {else}
                <option>Yes</option>
              {/if}
              {if $auction.questions_section == 0}
                <option selected>No</option>
              {else}
                <option>No</option>
              {/if}
            </select>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.qa_section}</strong>
        </div>
        <div class="form-group">
          <label class="control-label col-md-4"> Notifications<span> *</span> </label>
          <div class="input-group col-md-8 col-xs-12">
            <select class="selectpicker input-md form-control" name="notifications_enabled" id="notifications_enabled" title="Do you want to receive notifications about this auction?">
              {if $watchlist.notifications == 1}
                <option selected>Yes</option>
              {else}
                <option>Yes</option>
              {/if}
              {if $watchlist.notifications == 0}
                <option selected>No</option>
              {else}
                <option>No</option>
              {/if}
            </select>
          </div>
          <strong class="field_error">{$FIELD_ERRORS.notifications_enabled}</strong>
        </div>
        <button type="submit" class="btn btn-primary pull-right">Update settings</button>
      </div>
    </div>
  </div>
</form>