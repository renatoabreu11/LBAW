{include file='common/header.tpl'}

<div id="wrapper" class="toggled">
  <!-- Sidebar -->
  <div id="sidebar-wrapper">
    <ul class="sidebar-nav">
      <li class="sidebar-brand">
        <h4>Admin Panel</h4>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/users.php" id="usersList"> Users List</a>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/auctions.php" id="auctionsList"> Auctions List</a>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/categories.php" id="categoriesList"> Categories</a>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/add_admin.php" id="addAdmin"> Add Admin</a>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/reports.php" id="reports"> Reports</a>
      </li>
      <li>
        <a href="{$BASE_URL}pages/admin/feedback.php" id="feedback"> Feedback</a>
      </li>
    </ul>
  </div>
  <!-- /#sidebar-wrapper -->

  <!-- Page Content -->
  <div id="page-content-wrapper">
    <div class="container-fluid">

      <h2>Website Administration</h2>
      <input type="hidden" name="admin_id" value="{$adminId}">
      <input type="hidden" name="token" value="{$token}">

      {if $adminSection === "users"}
        {include file='admin/users.tpl'}
      {elseif $adminSection === "auctions"}
        {include file='admin/auctions.tpl'}
      {elseif $adminSection === "categories"}
        {include file='admin/categories.tpl'}
      {elseif $adminSection === "addAdmin"}
        {include file='admin/add_admin.tpl'}
      {elseif $adminSection === "reports"}
        {include file='admin/reports.tpl'}
      {elseif $adminSection === "feedback"}
        {include file='admin/feedback.tpl'}
      {/if}

    </div>
    <div id="footer" style="margin-top: 65px">
      <div class="container">
        <p class="pull-left"> © Seek Bid 2017. All rights reserved. </p>
        <a href="#" class="pull-right">About</a>
      </div>
    </div>
  </div>
</div>

<script src="https://cdn.datatables.net/1.10.13/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.10.13/js/dataTables.bootstrap.min.js"></script>
<script src="{$BASE_URL}javascript/admin.js"></script>
</body>
</html>
