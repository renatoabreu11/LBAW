<div class="adminOption">
    <h4><i class="fa fa-users" aria-hidden="true"></i> Users list</h4>
    <div class="table-responsive">
        <table class="table">
            <thead>
            <tr>
                <th>#</th>
                <th>Username</th>
                <th>Email</th>
                <th>Notify</th>
                <th>Remove</th>
            </tr>
            </thead>
            {for $i = 1; $i < $nrPages + 1; $i++}
                <tbody id="page{$i}" data-toggle='collapse'>
                {for $j = 0; $j < $usersPerPage; $j++}
                    {$index = $usersPerPage * ($i - 1) + $j}
                    {if $index < $nrUsers}
                        <tr>
                            <td>{$users[$index].id}</td>
                            <td><a href="#">{$users[$index].username}</a></td>
                            <td><a href="mailto:jan@gmail.com">{$users[$index].email}</a></td>
                            <td><i class="fa fa-flag" aria-hidden="true"></i></td>
                            <td><i class="fa fa-times" aria-hidden="true"></i></td>
                        </tr>
                    {/if}
                {/for}
                </tbody>
            {/for}
        </table>
    </div>

    {if $nrPages > 1}
        <div class="row text-center">
            <ul class="pagination">
                <li class="disabled"><a href="#">«</a></li>
                {for $i = 1; $i < $nrPages + 1; $i++}
                    {if $i === 1 }
                        <li class="active"><a href="#page1">1 <span class="sr-only">(current)</span></a></li>
                    {else}
                        <li><a href="#page{$i}">{$i}</a></li>
                    {/if}
                {/for}
                <li><a href="#">»</a></li>
            </ul>
        </div>
    {/if}
</div>
