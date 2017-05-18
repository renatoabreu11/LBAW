<htm>
    <head>
        <title>Password Recovery</title>
        <style>
            .message {
                font-weight: bold
            }

            .goodbye {
                margin-top: 20px
            }
        </style>
    </head>
    <body>
        <div class="message">
            <p>Someone requested a password recovery email. Click the link below to reset your password to be able to login again.</p>
            <p>If it wasn't you who requested a password recovery, please ignore this message.</p>
            <a href='%base-url%pages/authentication/reset_password.php?email=%email%&token=%token%'>Recover password</a>
            <div class="goodbye">
                <p>Good luck in your bids,</p>
                <p>Seek Bid Team</p>
            </div>
        </div>
    </body>
</htm>