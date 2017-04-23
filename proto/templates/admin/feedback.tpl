<div class="adminOption">
    <h4><i class="fa fa-comments" aria-hidden="true"></i> User Feedback</h4>

    {foreach $feedback as $feed}
        <div class="notifications-wrapper">
            <div class="media notification-media">
                <div class="media-left" style="padding: 1em;">
                    <img src="{$BASE_URL}images/users/{$feed.profile_pic}" class="img-rounded center-block" alt="User Avatar" width="64">
                </div>
                <div class="media-body">
                    <h5 class="notifications-item-title">
                        Feedback #<span class="feed_id">{$feed.id}</span> written by <a href="{$BASE_URL}pages/user/user.php?id={$feed.user_id}">{$feed.username}</a>
                    </h5>
                    <p>{$feed.message}</p>
                    <small>{$feed.date}</small>
                    <a class="removeFeedbackPopup" style="padding-left: 1em; padding-right: 1em;" href="#removeFeedbackConfirmation">Remove</a>
                </div>
            </div>
            <hr class="divider">
        </div>
    {/foreach}

    <div id="removeFeedbackConfirmation" class="white-popup mfp-hide">
        <h4>Are you sure that you want to delete this feedback?</h4>
        <p>You will not be able to undo this action!</p>
        <div class="text-center">
            <button class="btn btn-info removeFeedback">Yes, I'm sure</button>
            <button class="btn btn-info closePopup">No, go back</button>
        </div>
    </div>
</div>