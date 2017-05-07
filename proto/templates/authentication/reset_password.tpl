{include file='common/header.tpl'}

<section id="adminLogin">
  <div class="container">
    <div class="row">
      <div class="form-wrap">
        <h1>Password reset</h1>
        <form action="{$BASE_URL}'api/authentication/reset_password.php" method="post" id="resetPasswordForm">
          <input type="hidden" id="email" value="{$email}">
          <div class="form-group">
            <label class="sr-only" for="newPassword">New password:</label>
            <input type="password" class="form-control" id="newPassword" name="newPassword" placeholder="New password">
          </div>
          <div class="form-group">
            <label class="sr-only" for="repeatPassword">Repeat password:</label>
            <input type="password" class="form-control" id="repeatPassword" name="repeatPassword" placeholder="Repeat your new password">
          </div>
          <div class="text-center">
            <button type="submit" class="btn btn-primary">Update password</button>
          </div>
        </form>
        <hr>
      </div>
    </div>
  </div>
</section>

<script src="{$BASE_URL}javascript/reset_password.js"></script>

{include file='common/footer.tpl'}