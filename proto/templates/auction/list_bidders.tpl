{if (count($recentBidders) > 0)}
<div class="col-md-6">
    <h4 style="padding-top: 1em;">Recent Bidders</h4>
    <table class="table table-fixed">
    <thead>
    <tr>
        <th class="col-xs-5">User</th><th class="col-xs-1">Bid</th><th class="col-xs-6">Date</th>
    </tr>
    </thead>
    <tbody class="bidders-table-body">
    {foreach $recentBidders as $recentBidder}
        <tr>
        <td class="col-xs-5">
            <a href="{$BASE_URL}pages/user/user.php?id={$recentBidder.id}">{$recentBidder.username}</a>
        </td>
        <td class="col-xs-1">{$recentBidder.amount}</td>
        <td class="col-xs-6">{$recentBidder.date}</td>
        </tr>
    {/foreach}
    </tbody>
    </table>
</div>
{/if}