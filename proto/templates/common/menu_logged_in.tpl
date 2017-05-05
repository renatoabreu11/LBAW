{if $USERNAME}
  <li>
    <a href="{$BASE_URL}pages/auction/create_auction.php"><span class="glyphicon glyphicon-plus"></span> Auction</a>
  </li>
  <li class="dropdown">
    <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button">
      <i class="glyphicon glyphicon-bell"></i> <span class="badge">{count($notifications)}</span>
    </a>
    <div class="dropdown-menu notifications" role="menu">
      {include file='common/notifications.tpl'}
    </div>
  </li>
{/if}

<li class="dropdown">
  <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button"><span class="glyphicon glyphicon-user"></span> {$USERNAME} {$ADMIN_USERNAME}</a>
  <ul class="dropdown-menu">
    {if $USERNAME}
      <li><a href="{$BASE_URL}pages/user/user.php?id={$USER_ID}">Profile</a></li>
      <li><a href="{$BASE_URL}pages/user/credit.php">Credit info</a></li>
      <li><a href="{$BASE_URL}pages/auctions/watchlist.php">Watch List</a></li>
    {elseif $ADMIN_USERNAME}
      <li><a href="{$BASE_URL}pages/admin/users.php">Admin Page</a></li>
      <li><a href="{$BASE_URL}pages/auctions/best_auctions.php">Home Page</a></li>
    {/if}
    <li><a href="{$BASE_URL}actions/authentication/signout.php">Sign Out</a></li>
  </ul>
</li>