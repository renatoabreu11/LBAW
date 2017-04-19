<div class="adminOption">
    <h4><i class="fa fa-users" aria-hidden="true"></i> {$report_type} reports</h4>
    <div class="table-responsive">
        <table id="reportsTable" class="table row-border" cellspacing="0" width="100%">
            <thead>
            <tr>
                <th>#</th>
                <th class="reportType">{$report_type}</th>
                <th>Message</th>
                <th>Date</th>
            </tr>
            </thead>
            <tbody>
            {foreach $reports as $report}
                {print_r($report)}
                <tr>
                    <td>{$report.id}</td>
                    <td><a href="{$BASE_URL}pages/user/user.php?id={$report.user_id}">{$report.username}</a></td>
                    <td>{$report.message}</td>
                    <td>{$report.date}</td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    </div>

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