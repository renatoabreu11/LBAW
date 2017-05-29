<div id="footer">
  <div class="container">
    <p class="pull-left"> © Seek Bid 2017. All rights reserved. </p>
    <a class="pull-right about-site" data-toggle="modal" data-target="#about-modal">About</a>
    <a class="pull-right about-site" data-toggle="modal" data-target="#contact-us-modal">Contact us</a>
    <div id="about-modal" class="modal fade modalDefault" role="dialog">
      <div class="modal-dialog1">
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
    <div id="contact-us-modal" class="modal fade modalDefault" role="dialog">
      <div class="modal-dialog1">
        <div class="modal-content"> 
          <div class="modal-header"> 
            <h4 class="modal-title">Contact us</h4>
          </div>
          <div class="modal-body">  
            <form action="{$BASE_URL}api/user/contact_us.php" method="POST" id="sendContactEmailForm">
              <div class="form-group">
                <label for="user_name">Name</label>
                <input required maxlength="32" class="form-control" name="user_name" id="user_name">
              </div>
              <div class="form-group">
                <label for="user_email">Email address</label>
                <input type="email" required class="form-control" id="user_email" name="user_email">
              </div>
              <div class="form-group">
                <label for="user_message">Tell us how can we help</label>
                <textarea required id="user_message" name="user_message" rows="5" cols="40" style="min-width: 100%"></textarea>
              </div>
              <div class="field_error text-center" style="padding-bottom: 1em"></div>
              <div class="text-center">
                <button type="submit" class="btn btn-primary">Send</button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
    {if $USERNAME}
      <a class="pull-right leaveFeedbackPopup" href="#leaveFeedback">Leave a Feedback</a>
      <div id="leaveFeedback" class="white-popup mfp-hide">
        <form action="{$BASE_URL}api/user/feedback.php" method="post" id="feedbackForm">
          <div class="form-group">
            <label for="feedback">Feedback:</label>
            <textarea class="form-control" rows="5" name="feedback" id="feedback"></textarea>
          </div>
          <div class="text-center">
            <input type="submit" id="submitFeedback" class="btn btn-primary" value="Submit feedback">
          </div>
        </form>
      </div>
    {/if}
  </div>
</div>

</body>
</html>
