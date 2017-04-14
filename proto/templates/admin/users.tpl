<div class="adminOption">
    <h4><i class="fa fa-users" aria-hidden="true"></i> Users list</h4>
    <div class="table-responsive">
        <table id="usersTable" class="table table-striped table-bordered" cellspacing="0" width="100%">
            <thead>
            <tr>
                <th>#</th>
                <th>Username</th>
                <th>Email</th>
                <th>Notify</th>
                <th>Remove</th>
            </tr>
            </thead>
                <tbody>
            {foreach $users as $user}
                <tr>
                    <td>{$user.id}</td>
                    <td><a href="#">{$user.username}</a></td>
                    <td><a href="mailto:jan@gmail.com">{$user.email}</a></td>
                    <td><i class="fa fa-flag" aria-hidden="true"></i></td>
                    <td><i class="fa fa-times" aria-hidden="true"></i></td>
                </tr>
            {/foreach}
                </tbody>
        </table>
    </div>
</div>
