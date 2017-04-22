<li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
        <i class="glyphicon glyphicon-bell"></i>
    </a>
    <ul class="dropdown-menu notifications" role="menu">
        <div class="notification-heading text-center">
            <h4 class="menu-title">Notifications</h4>
        </div>
        <li class="divider"></li>
        <div class="notifications-wrapper">
            <div class="media notification-media">
                <div class="media-left">
                    <a href="#"><img src="https://www.thurrott.com/wp-content/uploads/2015/10/surface-book-hero.jpg" width="64"></a>
                </div>
                <div class="media-body">
                    <a href="#" class="notifications-item-title">
                        <i class="fa fa-bug" aria-hidden="true"></i>
                        A bug was submitted by Juan de Las Nieves
                    </a>
                    <p class="notification-item-date"><small>02/02/2016 14:45</small></p>
                </div>
                <div class="media-right">
                    <button type="button" class="notification-item-remove btn btn-default btn-xs"><i class="glyphicon glyphicon-remove"></i></button>
                </div>
            </div>
        </div>

        <li class="divider"></li>

        <div class="notifications-wrapper">
            <div class="media notification-media">
                <div class="media-left">
                    <a href="#"><img src="https://www.thurrott.com/wp-content/uploads/2015/10/surface-book-hero.jpg" width="64"></a>
                </div>
                <div class="media-body">
                    <a href="#" class="notifications-item-title">
                        <i class="fa fa-flag" aria-hidden="true"></i>
                        User anthony67 has been reported
                    </a>
                    <p class="notification-item-date"><small>02/02/2016 14:45</small></p>
                </div>
                <div class="media-right">
                    <button type="button" class="notification-item-remove btn btn-default btn-xs"><i class="glyphicon glyphicon-remove"></i></button>
                </div>
            </div>
        </div>

        <li class="divider"></li>
        <div class="notification-footer">
            <h4 class="menu-title"><a>View all notifications</a></h4>
            <h4 class="menu-title pull-right"><a>Mark all as read</a></h4>
        </div>
    </ul>
</li>

<li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"><span class="glyphicon glyphicon-user"></span> {$USERNAME} {$ADMIN_USERNAME}</a>
    <ul class="dropdown-menu">
        <li><a href="{$BASE_URL}pages/user/user.php?id={$USER_ID}">Profile</a></li>
        <li><a href="">My Auctions</a></li>
        <li><a href="">Watch List</a></li>
        <li><a href="{$BASE_URL}actions/authentication/signout.php">Sign Out</a></li>
    </ul>
</li>