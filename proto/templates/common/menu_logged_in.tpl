{if $USERNAME}

  <li>
    <a href="{$BASE_URL}pages/auction/create_auction.php"><span class="glyphicon glyphicon-plus"></span> Auction</a>
  </li>
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
      <i class="glyphicon glyphicon-bell"></i> <span class="badge">{count($notifications)}</span>
    </a>
    <div class="dropdown-menu notifications" role="menu">
      <div class="notification-heading text-center">
        <h4 class="menu-title">Notifications</h4>
      </div>
      <hr class="divider">
      {if count($notifications) == 0}
        <p class="notifications-empty">You have no new notifications</p>
      {/if}
      {foreach $notifications as $notification}
        <div class="notifications-wrapper">
          <div class="media notification-media id-{$notification.id}">
            <div class="media-left" style="padding-top: 0.25em; padding-left: 0.5em;">
              <img src="{$BASE_URL}images/assets/{$notification.type}.png" Alt="{$notification.type}" width="64">
            </div>
            <div class="media-body">
              <a class="notifications-item-title hideNotification">
                {$notification.message}
              </a>
              <p class="notification-item-date"><small>{$notification.date}</small></p>
            </div>
            <div class="media-right">
              <button type="button" class="notification-item-remove btn btn-default btn-xs hideNotification"><i class="glyphicon glyphicon-remove"></i></button>
            </div>
          </div>
        </div>
      {/foreach}

      <hr class="divider">
      <div class="notification-footer">
        <h4 class="menu-title"><a href="{$BASE_URL}pages/user/notifications.php?page=1">View all notifications</a></h4>
        <h4 class="menu-title pull-right markRecentNotificationsAsRead"><a>Mark all as read</a></h4>
      </div>
    </div>
  </li>
{/if}

<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"><span class="glyphicon glyphicon-user"></span> {$USERNAME} {$ADMIN_USERNAME}</a>
  <ul class="dropdown-menu">
    {if $USERNAME}
      <li><a href="{$BASE_URL}pages/user/user.php?id={$USER_ID}">Profile</a></li>
      <li><a href="{$BASE_URL}pages/user/credit.php">Credit info</a></li>
      <li><a href="{$BASE_URL}pages/auctions/watchlist.php?page=1">Watch List</a></li>
    {elseif $ADMIN_USERNAME}
      <li><a href="{$BASE_URL}pages/admin/users.php">Admin Page</a></li>
      <li><a href="{$BASE_URL}pages/auctions/best_auctions.php">Home Page</a></li>
    {/if}
    <li><a href="{$BASE_URL}actions/authentication/signout.php">Sign Out</a></li>
  </ul>
</li>