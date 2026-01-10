<?php
    $servername = "localhost";
    $username = "youcapfu_admin";
    $password = "^6jny+7zY%Fi";
    $dbname = "youcapfu_pawpal_db";
    // Create connection
    $conn = new mysqli($servername, $username, $password, $dbname);
    // Check connection
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>