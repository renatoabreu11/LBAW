<div id="footer">
    <div class="container">
        <p class="pull-left"> © Seek Bid 2017. All rights reserved. </p>
        <a class="pull-right">About</a>
        {if $USERNAME}
            <a class="pull-right leaveFeedbackPopup" href="#leaveFeedback">Leave a Feedback</a>
            <div id="leaveFeedback" class="white-popup mfp-hide">
                <form role="form" action="{$BASE_URL}api/user/feedback.php" method="post" id="feedbackForm">
                    <input type="hidden" name="username" value={$USERNAME}>
                    <div class="form-group">
                        <label for="feedback">Feedback:</label>
                        <textarea class="form-control" rows="5" id="feedback"></textarea>
                    </div>
                    <div class="text-center">
                        <input type="submit" id="submitFeedback" class="btn btn-info" value="Submit feedback">
                    </div>
                </form>
            </div>
        {/if}
    </div>
</div>

</body>
</html>
