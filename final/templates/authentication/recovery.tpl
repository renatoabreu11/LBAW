{include file='common/header.tpl'}

<section id="adminLogin">
  <div class="container">
    <div class="row">
      <div class="form-wrap">
        <h1>Password recovery</h1>
        <form action="{$BASE_URL}api/authentication/recovery.php" id="recoveryForm">
          <div class="form-group">
            <label class="sr-only" for="email">Email address</label>
            <input type="email" class="form-control" name="email" id="email" placeholder="Email address" required>
          </div>
          <div class="text-center">
            <button class="btn btn-primary">Send me a recovery email</button>
          </div>
        </form>
        <hr>
      </div>
    </div>
  </div>
</section>

<script src="{$BASE_URL}javascript/recovery.js"></script>
{include file='common/footer.tpl'}