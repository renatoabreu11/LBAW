<div class="row answerArticle">
  <input type="hidden" name="answer-id" value="{$question.answer_id}">
  <div class="col-md-1 col-sm-1 col-md-offset-1 col-sm-offset-0 hidden-xs">
    <figure class="thumbnail">
      <img class="img-responsive" src="{$BASE_URL}images/users/{$seller.profile_pic}" Alt="Profile picture"/>
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
            <div class="answer-edit-display" hidden>
              <label class="sr-only" for="updated-answer-{$question.answer_id}">Updated answer</label>
              <textarea id="updated-answer-{$question.answer_id}" name="updated-answer" class="form-control answer-area" rows="3">{$question.answer_message}</textarea>
              <button style="margin-top: 1em;" class="btn btn-default btn-edit-answer">Send</button>
            </div>
            <div class="comment-meta">
              {if $ADMIN_ID}
                <span><a class="underline-text-hover removeAnswerPopup id-{$question.answer_id}" href="#removeAnswer">delete</a></span>
              {/if}
              {if ($USER_ID)}
                {if ($seller.id == $USER_ID)}
                  {if ($question.answer_can_edit)}
                    <span><a class="edit-answer underline-text-hover">edit</a></span>
                  {/if}
                  <span><a class="underline-text-hover removeAnswerPopup id-{$question.answer_id}" href="#removeAnswer">delete</a></span>
                {/if}
                {if ($seller.id != $USER_ID)}
                  <span><a class="reportAnswerPopup underline-text-hover" href="#reportAnswerConfirmation">report</a></span>
                {/if}
              {/if}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>