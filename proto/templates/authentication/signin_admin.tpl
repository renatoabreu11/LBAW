{include file='common/header.tpl'}

<section id="adminLogin">
    <div class="container">
        <div class="row">
            <div class="form-wrap">
                <h1>Admin Sign In</h1>
                <strong class="field_error">{$FIELD_ERRORS.login}</strong>
                <form role="form" action="{$BASE_URL}actions/authentication/signin_admin.php" method="post" id="adminSigninForm">
                    <div class="form-group">
                        <label for="username" class="sr-only">Username</label>
                        <input type="text" name="username" id="username" class="form-control" placeholder="Your username" value="{$FORM_VALUES.username}">
                        <strong class="field_error">{$FIELD_ERRORS.username}</strong>
                    </div>
                    <div class="form-group">
                        <label for="key" class="sr-only">Password</label>
                        <input type="password" name="password" id="password" class="form-control" placeholder="Your password">
                    </div>
                    <div class="text-center">
                        <input type="submit" id="btn-login" class="btn btn-lg btn-info" value="Sign in">
                    </div>
                </form>
                <a class="forget" data-toggle="modal" data-target=".forget-modal">Forgot your password?</a>
                <hr>
            </div>
        </div>
    </div>
</section>

<script src="{$BASE_URL}javascript/auth.js"></script>

{include file='common/footer.tpl'}