{include file = 'common/header.tpl'}

<div class="container notificationsPageContainer">
  <div class="row heading">
    <div class="col-md-12 index">
      <ul class="breadcrumb">
        <li>
          <a href="{$BASE_URL}index.php">Home</a> <span class="divider"></span>
        </li>
        <li class="active">
          Notifications
        </li>
      </ul>
    </div>
    <h3>Notifications</h3>
    <p>You’ll see here notifications of your auctions, bids, questions, answers and warnings.</p>
  </div>
  <div class="col-xs-12 notificationsPage">
    {if count($pageNotifications) == 0}
      <div class="container-fluid" style="padding-bottom: 2em;">
        <div class="row-fluid">
          <div class="empty-content text-center">
            <i class="fa fa-bell fa-3x" aria-hidden="true"></i>
            <h3>No new notifications.</h3>
          </div>
        </div>
      </div>
    {/if}
    {foreach $pageNotifications as $notif}
      <div class="notifications-wrapper">
        <div class="media notification-media">
          <div class="media-left" style="padding: 1em;">
            <img src="{$BASE_URL}images/assets/{$notif.type}.png" Alt="{$notif.type}" width="64">
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
            <small style="padding-left: 1em; padding-right: 1em;">Feb 20th, 2017 at 9:37:41</small>
            {if !$notif.is_new}
              <a href="javascript:void(0)" data-toggle="tooltip" title="Notification read!"><span class="sr-only">Notification read!</span><i class="fa fa-eye" aria-hidden="true"></i></a>
            {/if}
            <p style="padding-top: 1em;">{$notif.message}</p>
            <div class="notification-options">
              <span><a class="removeNotificationPopup id-{$notif.id}" href="#removeNotification">delete</a></span>
              {if $notif.is_new}
                <span><a class="readNotification id-{$notif.id}">read</a></span>
              {/if}
            </div>
          </div>
        </div>
        <hr class="divider">
      </div>
    {/foreach}
    <div id="removeNotification" class="white-popup mfp-hide">
      <h4>Are you sure that you want to delete this notification?</h4>
      <p>You will not be able to undo this action!</p>
      <div class="text-center">
        <button class="btn btn-info removeNotification">Yes, I'm sure</button>
        <button class="btn btn-info closePopup">No, go back</button>
      </div>
    </div>
    {if $nrPages > 1}
      <div class="row text-center">
        <ul class="pagination">
          {if $currPage == 1}
            <li class="disabled"><a>«</a></li>
          {else}
            <li ><a href="{$BASE_URL}pages/user/notifications.php?page={$currPage - 1}">«</a></li>
          {/if}
          {for $i=1; $i <= $nrPages; $i++}
            {if $currPage == $i}
              <li class="active"><a>{$i} <span class="sr-only">(current)</span></a></li>
            {else}
              <li ><a href="{$BASE_URL}pages/user/notifications.php?page={$i}">{$i} </a></li>
            {/if}
          {/for}
          {if $currPage == $nrPages}
            <li class="disabled"><a>»</a></li>
          {else}
            <li ><a href="{$BASE_URL}pages/user/notifications.php?page={$currPage + 1}">»</a></li>
          {/if}
        </ul>
      </div>
    {/if}
  </div>
</div>

<script type="text/javascript" src="{$BASE_URL}javascript/user.min.js"></script>

{include file = 'common/footer.tpl'}