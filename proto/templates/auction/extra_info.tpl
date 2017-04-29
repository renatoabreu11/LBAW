<div class="row setup-content" id="step-3">
  <div class="col-xs-12">
    <div class="col-md-12 well">
      <h3> Settings</h3>
      <div class="form-group">
        <label class="control-label col-md-4"> Q&A section<span>*</span> </label>
        <div class="input-group col-md-8 col-xs-12">
          <select class="selectpicker input-md form-control" name="qa_section" id="qa_section" title="Do you want to answer questions about the auction?">
            <option>Yes</option>
            <option>No</option>
          </select>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.qa_section}</strong>
      </div>
      <div class="form-group">
        <label class="control-label col-md-4"> Notifications<span>*</span> </label>
        <div class="input-group col-md-8 col-xs-12">
          <select class="selectpicker input-md form-control" name="notifications_enabled" id="notifications_enabled" title="Choose if you want to receive notifications relative to this auction">
            <option>Yes</option>
            <option>No</option>
          </select>
        </div>
        <strong class="field_error">{$FIELD_ERRORS.notifications_enabled}</strong>
      </div>
    </div>
  </div>
</div>