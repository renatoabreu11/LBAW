{foreach $questions as $question}
  <div class="question-answer">
    <div class="row questionArticle">
      <input type="hidden" name="question-id" value="{$question.id}">
      <div class="col-md-1 col-sm-1 hidden-xs">
        <figure class="thumbnail">
          <img class="img-responsive" src="{$BASE_URL}images/users/{$question.profile_pic}" Alt="Profile picture" />
        </figure>
      </div>
      <div class="col-md-10 col-sm-10 col-xs-12">
        <div class="panel panel-default arrow left">
          <div class="panel-body">
            <div class="media-heading">
              <button class="btn btn-default btn-xs" data-toggle="collapse" data-target="#collapseComment{$question.id}">
                <span class="glyphicon glyphicon-minus" aria-hidden="true"></span>
              </button>
              <a href="{$BASE_URL}pages/user/user.php?id={$question.user_id}"><strong>{$question.user_username}</strong></a> {$question.date}
            </div>
            <div class="panel-collapse collapse in" id="collapseComment{$question.id}">
              <div class="media-body">
                <div class="question-display">
                  <p>{$question.message}</p>
                </div>
                <div class="question-edit-display" hidden>
                  <label class="sr-only" for="updated-question-{$question.id}">Updated question</label>
                  <textarea id="updated-question-{$question.id}" name="updated-question" class="form-control question-area" rows="3">{$question.message}</textarea>
                  <button style="margin-top: 1em;" class="btn btn-default btn-edit-question">Send</button>
                </div>
                <div class="comment-meta">
                  {if $ADMIN_ID}
                    <span><a class="underline-text-hover removeQuestionPopup id-{$question.id}" href="#removeQuestion">delete</a></span>
                  {/if}
                  {if ($USER_ID)}
                    {if ($question.user_id == $USER_ID)}
                      {if ($question.can_edit)}
                        <span><a class="edit-question underline-text-hover" href="javascript:void(0)">edit</a></span>
                      {/if}
                      <span><a class="underline-text-hover removeQuestionPopup id-{$question.id}" href="#removeQuestion">delete</a></span>
                    {/if}
                    {if ($question.user_id != $USER_ID)}
                      <span><a class="reportQuestionPopup underline-text-hover" href="#reportQuestionConfirmation">report</a></span>
                    {/if}
                    {if ($seller.id == $USER_ID && !$question.answer_message)}
                      <span><a class="reply-question underline-text-hover" href="javascript:void(0)">reply</a></span>
                    {/if}
                  {/if}
                </div>
                {if ($seller.id == $USER_ID && !$question.answer_message)}
                  <form class="newAnswerForm" action="{$BASE_URL}api/auction/create_answer.php" method="post" hidden>
                    <label class="sr-only" for="comment">New answer</label>
                    <div class="form-group">
                      <textarea name="comment" id="comment" required maxlength="512" placeholder="Your answer..." class="form-control answer-area" rows="3"></textarea>
                    </div>
                    <button class="btn btn-default">Send</button>
                  </form>
                {/if}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    {if ($question.answer_message)}
      {include file='auction/answer.tpl'}
    {/if}
  </div>
{/foreach}