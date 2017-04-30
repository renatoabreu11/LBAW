<article class="row">
  <input type="hidden" name="question-id" value="{$question.id}">
  <div class="col-md-1 col-sm-1 hidden-xs">
    <figure class="thumbnail">
      <img class="img-responsive" src="{$BASE_URL}images/users/{$question.profile_pic}" />
    </figure>
  </div>
  <div class="col-md-10 col-sm-10 col-xs-12">
    <div class="panel panel-default arrow left">
      <div class="panel-body">
        <div class="media-heading">
          <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseComment{$question.id}">
            <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
          </button>
          <a href="{$BASE_URL}pages/user/user.php?id={$question.user_id}"><strong>{$question.user_username}</strong></a> {$question.date}
        </div>
        <div class="panel-collapse collapse in" id="collapseComment{$question.id}">
          <div class="media-body">
            <div class="question-display">
              <p>{$question.message}</p>
            </div>
            <div class="comment-meta">
              {if ($USER_ID)}
                {if ($question.user_id == $USER_ID)}
                  {if ($question.can_edit)}
                    <span class="edit-question underline-text-hover">edit</span>
                  {/if}
                  <span class="delete-question underline-text-hover">delete</span>
                {/if}
                {if ($question.user_id != $USER_ID)}
                  <span class="report-question underline-text-hover" data-toggle="modal" data-target="#report-modal-question-{$question.id}">report</span>
                {/if}
                {if ($seller.id == $USER_ID && !$question.answer_message)}
                  <span class="reply-question underline-text-hover">reply</span>
                {/if}
              {/if}
            </div>
            {if ($seller.id == $USER_ID && !$question.answer_message)}
              <form class="new-answer" action="javascript:void(0);">
                <div class="form-group">
                  <textarea name="comment" placeholder="Your answer..." class="form-control answer-area" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-default btn-answer-question">Send</button>
              </form>
            {/if}
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="report-modal-question-{$question.id}" class="modal fade" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
            Question report
          </h4>
        </div>
        <div class="modal-body">
          <form class="form horizontal" role="form" action="javascript:void(0);">
            <div class="form-group">
              <label>Message</label>
              <textarea rows="5" class="report-question-{$question.id}-comment" placeholder="Your message..."></textarea>
            </div>
            <button type="submit" class="btn btn-default btn-send-question-{$question.id}-report">Send</button>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</article>



