<article class="row">
  <input type="hidden" name="answer-id" value="{$question.answer_id}">
  <div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs">
    <figure class="thumbnail">
      <img class="img-responsive" src="{$BASE_URL}images/users/{$seller.profile_pic}"/>
    </figure>
  </div>
  <div class="col-md-9 col-sm-9 col-sm-offset-0 col-md-offset-0 col-xs-offset-1 col-xs-11">
    <div class="panel panel-default arrow left">
      <div class="panel-body">
        <div class="media-heading">
          <button class="btn btn-default btn-xs" type="button" data-toggle="collapse" data-target="#collapseReply{$question.answer_id}">
            <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
          </button>
          <a href="{$BASE_URL}pages/user/user.php?id={$seller.id}"><strong>{$seller.username}</strong></a>{$question.answer_date}
        </div>
        <div class="panel-collapse collapse in" id="collapseReply{$question.answer_id}">
          <div class="media-body">
            <div class="answer-display">
              <p>{$question.answer_message}</p>
            </div>
            <div class="comment-meta">
              {if ($USER_ID)}
                {if ($seller.id == $USER_ID)}
                  {if ($question.answer_can_edit)}
                    <span class="edit-answer underline-text-hover">edit</span>
                  {/if}
                  <span class="delete-answer underline-text-hover">delete</span>
                {/if}
                {if ($seller.id != $USER_ID)}
                  <span class="report-answer underline-text-hover" data-toggle="modal" data-target="#report-modal-answer-{$question.answer_id}">report</span>
                {/if}
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div id="report-modal-answer-{$question.answer_id}" class="modal fade" role="dialog">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h4 class="modal-title">
            Answer report
          </h4>
        </div>
        <div class="modal-body">
          <form class="form horizontal" role="form" action="javascript:void(0);">
            <div class="form-group">
              <label>Message</label>
              <textarea rows="5" class="report-answer-{$question.answer_id}-comment" placeholder="Your message..."></textarea>
            </div>
            <button type="submit" class="btn btn-default btn-send-answer-{$question.answer_id}-report">Send</button>
          </form>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        </div>
      </div>
    </div>
  </div>
</article>