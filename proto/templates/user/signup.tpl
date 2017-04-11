{include file='common/header.tpl'}

<div class="container">
    <div class="row main">
        <div class="panel-heading">
            <div class="panel-title text-center">
                <img src="/images/assets/favicon.jpg" class="img-rounded" width="32" height="32" style="position: relative; bottom: 5px;">
                <h2 class="title" id="title-signup" style="display: inline;">Join Seek Bid for free!</h2>
            </div>
        </div>

        <div class="main-login main-center">
            <form class="form-horizontal" method="post" action="#">
                <div class="form-group">
                    <label for="name" class="cols-sm-2 control-label">Name</label>
                    <div class="cols-sm-10">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-user fa" aria-hidden="true"></i></span>
                            <input type="text" class="form-control" name="name" id="name"  placeholder="Enter your Name"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email" class="cols-sm-2 control-label">Email</label>
                    <div class="cols-sm-10">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-envelope fa" aria-hidden="true"></i></span>
                            <input type="text" class="form-control" name="email" id="email"  placeholder="Enter your Email"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="username" class="cols-sm-2 control-label">Username</label>
                    <div class="cols-sm-10">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-users fa" aria-hidden="true"></i></span>
                            <input type="text" class="form-control" name="username" id="username"  placeholder="Enter your Username"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="password" class="cols-sm-2 control-label">Password</label>
                    <div class="cols-sm-10">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
                            <input type="password" class="form-control" name="password" id="password"  placeholder="Enter your Password"/>
                        </div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="confirm" class="cols-sm-2 control-label">Confirm Password</label>
                    <div class="cols-sm-10">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="fa fa-lock fa-lg" aria-hidden="true"></i></span>
                            <input type="password" class="form-control" name="confirm" id="confirm"  placeholder="Confirm your Password"/>
                        </div>
                    </div>
                </div>

                <div class="form-group" id="textarea-signup">
                    <div class="form-group" style="padding:12px">
                        <label for="confirm" class="cols-sm-2 control-label">Short bio</label>
                        <textarea class="form-control" rows="5" placeholder="Talk a little about you..."></textarea>
                    </div>
                </div>

                <div class="form-group text-center" id="signup-btn">
                    <button type="submit" class="btn btn-info">Sign up</button>
                </div>
            </form>
        </div>
    </div>
</div>

{include file='common/footer.tpl'}