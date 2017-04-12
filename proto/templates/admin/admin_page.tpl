{include file='common/header.tpl'}

<div id="wrapper" class="toggled">
    <!-- Sidebar -->
    <div id="sidebar-wrapper">
        <ul class="sidebar-nav">
            <li class="sidebar-brand">
                <h4>Admin Panel</h4>
            </li>
            <li>
                <a href="#" id="usersAdmin" data-target="#rightSideUsers">Users</a>
            </li>
            <li>
                <a href="#" id="auctionsAdmin" data-target="#rightSideAuctions"> Auctions</a>
            </li>
            <li>
                <a href="#" id="commentsAdmin" data-target="#rightSideComments"> Comments</a>
            </li>
            <li>
                <a href="#" id="reviewsAdmin" data-target="#rightSideReviews"> Reviews</a>
            </li>
            <li>
                <a href="#" id="addCategory" data-target="#rightSideAddCategory"> Add category</a>
            </li>
            <li>
                <a href="#" id="addAdmin" data-target="#rightSideAddAdmin"> Add admin</a>
            </li>
            <li>
                <a href="#" id="usersList" data-target="#rightSideUsersList"> Users List</a>
            </li>
        </ul>
    </div>
    <!-- /#sidebar-wrapper -->

    <!-- Page Content -->
    <div id="page-content-wrapper">
        <div class="container-fluid">

            <h2>Website Administration</h2>

            {if $admin_section === "users"}
                {include file='admin/users.tpl'}
            {elseif $admin_section === "auctions"}
                {include file='admin/auctions.tpl'}
            {/if}

            <div class="box-body">
                <div class="mailbox-controls">
                    <div class="btn-group">
                        <button class="btn btn-default btn-sm checkbox-toggle"><i class="glyphicon glyphicon-unchecked"></i></button>
                        <button class="btn btn-default btn-sm"><i class="glyphicon glyphicon-trash"></i></button>
                        <button class="btn btn-default btn-sm"><i class="glyphicon glyphicon-refresh"></i></button>
                    </div>

                    <div class="pull-right">
                        1-8/20
                        <div class="btn-group">
                            <button class="btn btn-default btn-sm"><i class="glyphicon glyphicon-arrow-left"></i></button>
                            <button class="btn btn-default btn-sm"><i class="glyphicon glyphicon-arrow-right"></i></button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>

