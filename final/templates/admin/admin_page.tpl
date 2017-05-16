{include file='common/header.tpl'}

<div id="wrapper" class="toggled">
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
  <div id="page-content-wrapper">
    <div class="container-fluid">
      <h2>Website Administration</h2>
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
        <a class="pull-right about-site" data-toggle="modal" data-target="#about-modal">About</a>
        <div id="about-modal" class="modal fade" role="dialog">
          <div class="modal-dialog">
            <div class="modal-content">
              <div class="modal-header">
                <h4 class="modal-title">About</h4>
              </div>
              <div class="modal-body">
                <p>Website developed under the mentorship of <strong>J. Correia Lopes</strong> during the <a href="https://sigarra.up.pt/feup/pt/ucurr_geral.ficha_uc_view?pv_ocorrencia_id=384950" style="padding: 0;"><strong>LBAW</strong></a> course at <a href="https://sigarra.up.pt/feup/pt/web_page.Inicial" style="padding: 0;"><strong>FEUP</strong></a>.</p>
                <p>Project members: </p>
                <ul>
                  <li><strong>Diogo Cepa</strong></li>
                  <li><strong>Hélder Antunes</strong></li>
                  <li><strong>José Vieira</strong></li>
                  <li><strong>Renato Abreu</strong></li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script src="{$BASE_URL}lib/datatables/jquery.dataTables.min.js"></script>
<script src="{$BASE_URL}lib/datatables/dataTables.bootstrap.min.js"></script>
<script src="{$BASE_URL}javascript/admin.js"></script>

</body>
</html>
