<div class="adminOption">
  <h4><i class="fa fa-users" aria-hidden="true"></i> Users list</h4>
  <div class="table-responsive">
    <table id="usersTable" class="table row-border">
      <thead>
      <tr>
        <th>#</th>
        <th>Username</th>
        <th>Email</th>
        <th>Biography</th>
        <th>Register date</th>
        <th>Number of auctions</th>
      </tr>
      </thead>
      <tbody>
      {$i = 0}
      {foreach $users as $user}
        <tr>
          <td>{$user.id}</td>
          <td><a href="{$BASE_URL}pages/user/user.php?id={$user.id}">{$user.username}</a></td>
          <td>{$user.email}</td>
          <td>{$user.short_bio}</td>
          <td>{$user.register_date}</td>
          <td>{$auctionsUser[$i++]}</td>
        </tr>
      {/foreach}
      </tbody>
    </table>
  </div>

  <div class="text-center userOptions">
    <a class="btn btn-info removeUserPopup" href="#removeUserConfirmation">Remove selected user</a>
    <a class="btn btn-info notifyUserPopup" href="#notifyUserConfirmation">Notify selected user</a>
  </div>

  <div id="removeUserConfirmation" class="white-popup mfp-hide">
    <h4>Are you sure that you want to delete this user?</h4>
    <p>You will not be able to undo this action!</p>
    <div class="text-center">
      <button class="btn btn-info removeUser">Yes, I'm sure</button>
      <button class="btn btn-info closePopup">No, go back</button>
    </div>
  </div>

  <div id="notifyUserConfirmation" class="white-popup mfp-hide">
    <form action="{$BASE_URL}api/admin/notify_user.php" method="post" id="notificationForm">
      <div class="form-group">
        <label for="notification">Notification:</label>
        <textarea class="form-control" rows="5" id="notification" name="notification"></textarea>
      </div>
      <div class="text-center">
        <input type="submit" id="notifyUser" class="btn btn-info" value="Notify User">
      </div>
    </form>
  </div>
</div>
