<div class="adminOption">
  <h4><i class="fa fa-users" aria-hidden="true"></i> {$reportType} reports</h4>

  <div class="table-responsive">
    <table id="reportsTable" class="table row-border" cellspacing="0" width="100%">
      <thead>
      <tr>
        <th>Report ID</th>
        <th class="reportType">{$reportType}</th>
        <th>Message</th>
        <th>Date</th>
      </tr>
      </thead>
      <tbody>
      {foreach $reports as $report}
        <tr>
          <td>{$report.id}</td>
          {if $reportType === "User"}
            <td><a href="{$BASE_URL}pages/user/user.php?id={$report.user_id}">{$report.username}</a></td>
          {elseif $reportType === "Auction"}
            <td><a href="{$BASE_URL}pages/auction/auction.php?id={$report.auction_id}">{$report.auction_id}</a></td>
          {elseif $reportType === "Review" || $reportType === "Question" || $reportType == "Answer"}
            <td>Written by <a href="{$BASE_URL}pages/auction/auction.php?id={$report.user_id}">{$report.username}</a></td>
          {/if}
          <td>{$report.message}</td>
          <td>{$report.date}</td>
        </tr>
      {/foreach}
      </tbody>
    </table>
  </div>

  <div>
    <a class="btn btn-info removeReportPopup" href="#removeReportConfirmation">Remove selected report</a>
    <div id="removeReportConfirmation" class="white-popup mfp-hide">
      <h4>Are you sure that you want to delete this report?</h4>
      <p>You will not be able to undo this action!</p>
      <div class="text-center">
        <button class="btn btn-info removeReport">Yes, I'm sure</button>
        <button class="btn btn-info closePopup">No, go back</button>
      </div>
    </div>
  </div>

  <div class="form-group reportSelection">
    <label for="service">Select the type of report that you want to analyse</label>
    <br>
    <div class="col-sm-3">
      <select class="form-control" id="report_type" name="report_type">
        <option value="User">User Reports</option>
        <option value="Auction">Auction Reports</option>
        <option value="Review">Review Reports</option>
        <option value="Answer">Answer Reports</option>
        <option value="Question">Question Reports</option>
      </select>
    </div>
    <a class="btn btn-info showReports">Show reports</a>
  </div>
</div>