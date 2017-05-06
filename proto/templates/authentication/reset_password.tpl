{include file='common/header.tpl'}

    <div class="container">
        <form class="form-horizontal" id="form-password-reset" action="javascript:void(0);">
            <input type="hidden" id="email" value="{$email}">
            <div class="form-group">
                <label class="control-label col-md-3" for="email">New password:</label>
                <div class="col-md-9">
                    <input type="password" class="form-control" id="newPassword">
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-md-3" for="email">Repeat password:</label>
                <div class="col-md-9">
                    <input type="password" class="form-control" id="repeatPassword">
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Update password</button>
        </form>
    </div>

<script src="{$BASE_URL}javascript/reset_password.js"></script>
{include file='common/footer.tpl'}