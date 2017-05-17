<htm>
    <head>
        <title>Password Recovery</title>
        <style>
            .message {
                color: red;
            }
        </style>
    </head>
    <body>
        <img src="%seek-bid-logo%">
        <div class="message">
            <p>Someone requested a password recovery email. Click the link below to reset your password to be able to login again.</p>
            <p>If it wasn't you who requested the email, please ignore this message.</p>
        </div>
        <div class="link">
            <p>%base-url%pages/authentication/reset_password?email=%email%&token=%token%</p>
            <a href='%base-url%pages/authentication/reset_password.php?email=%email%&token=%token%'>Recover password</a>
        </div>
    </body>
</htm>