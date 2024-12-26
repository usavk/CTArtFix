<?php
// Database connection parameters
$server_name = "localhost"; // You can replace this with an IP address or domain if needed
$db_username = "root"; // Database username
$db_password = ""; // Database password
$db_name = "vasu"; // Database name


// Establishing the connection with MySQLi
$conn = new mysqli($server_name, $db_username, $db_password, $db_name);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>