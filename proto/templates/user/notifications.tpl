{include file = 'common/header.tpl'}

<div class="container notification-page-container">
    <div class="row">
        <div class="col-md-12">
            <ul class="breadcrumb">
                <li>
                    <a href="{$BASE_URL}index.php">Home</a> <span class="divider"></span>
                </li>
                <li class="active">
                    Notifications
                </li>
            </ul>
        </div>
    </div>

    <div class="col-lg-8 col-md-8">
        <div class="row heading">
            <h3 class="notification-page-title">Notifications</h3>
            <p>You’ll see here updates of your auctions, bids, questions, answers and warnings.</p>
        </div>

        {foreach $page_notifications as $notif}
            <div class="notifications-wrapper">
                <div class="media notification-media">
                    <div class="media-left" style="padding: 1em;">
                        <img src="{$BASE_URL}images/assets/{$notif.type}.png" width="64">
                    </div>
                    <div class="media-body">
                        <a class="notifications-item-title">
                            {if $notif.type === "Warning"}
                                You have received a warning!
                            {elseif $notif.type === "Auction"}
                                You have received a notification relative to an auction.
                            {elseif $notif.type === "Question"}
                                You have received a notification relative to an question.
                            {elseif $notif.type === "Answer"}
                                You have received a notification relative to an answer.
                            {elseif $notif.type === "Win"}
                                You are the winner of an auction. Congratulations!
                            {/if}
                        </a>
                        <small style="padding-left: 1em;">Feb 20th, 2017 at 9:37:41</small>
                        <p style="padding-top: 1em;">{$notif.message}</p>
                        <div class="notification-options">
                            <span><a>delete</a></span>
                            <span><a>read</a></span>
                            <span><a>hide</a></span>
                        </div>
                    </div>
                </div>
            </div>

            <hr class="divider">
        {/foreach}
    </div>
</div>

{include file = 'common/footer.tpl'}