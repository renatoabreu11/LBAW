<?php

if (!empty($_POST['token'])) {
    if (hash_equals($_SESSION['token'], $_POST['token'])) {
        // Proceed to process the form data
    } else {
        // Log this as a warning and keep an eye on these attempts
    }
}