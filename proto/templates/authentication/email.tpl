<htm>
    <head>
        <title>Password Recovery</title>
        <style>
            .message {
                font-weight: bold
            }
        </style>
    </head>
    <body>
        <img src=\"cid:seekBidLogo\">
        <div class="message">
            <p>Someone requested a password recovery email. Click the link below to reset your password to be able to login again.</p>
            <p>If it wasn't you who requested a password recovery, please ignore this message.</p>
            <a href='%base-url%pages/authentication/reset_password.php?email=%email%&token=%token%'>Recover password</a>
            <p>Good luck in your bids,</p>
            <p>Seek Bid Team</p>
        </div>
    </body>
</htm>