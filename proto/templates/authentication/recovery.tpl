{include file='common/header.tpl'}

    <div class="container">
        <form class="form-horizontal" action="javascript:void(0);">
            <div class="form-group">
                <label class="control-label col-md-3" for="email">Email address:</label>
                <div class="col-md-9">
                    <input type="email" class="form-control" id="email">
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Send me a recovery email</button>
        </form>
    </div>

<script src="{$BASE_URL}javascript/recovery.js"></script>
{include file='common/footer.tpl'}