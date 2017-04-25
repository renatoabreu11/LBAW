{if $USERNAME}
    <li class="dropdown">
        <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
            <i class="glyphicon glyphicon-bell"></i>
        </a>
        <ul class="dropdown-menu notifications" role="menu">
            <div class="notification-heading text-center">
                <h4 class="menu-title">Notifications</h4>
            </div>
            <hr class="divider">
            {foreach $notifications as $notification}
                <div class="notifications-wrapper">
                    <div class="media notification-media">
                        <div class="media-left" style="padding-top: 0.25em; padding-left: 0.5em;">
                            <img src="{$BASE_URL}images/assets/{$notification.type}.png" width="64">
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
        </ul>
    </li>
{/if}

<li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"><span class="glyphicon glyphicon-user"></span> {$USERNAME} {$ADMIN_USERNAME}</a>
    <ul class="dropdown-menu">
        {if $USERNAME}
            <li><a href="{$BASE_URL}pages/user/user.php?id={$USER_ID}">Profile</a></li>
            <li><a href="">My Auctions</a></li>
            <li><a href="">Watch List</a></li>
        {elseif $ADMIN_USERNAME}
            <li><a href="{$BASE_URL}pages/admin/users.php">Admin Page</a></li>
        {/if}
        <li><a href="{$BASE_URL}actions/authentication/signout.php">Sign Out</a></li>
    </ul>
</li>