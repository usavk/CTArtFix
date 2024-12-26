<?php
// Allow from any origin (consider restricting in production)
if (isset($_SERVER['HTTP_ORIGIN'])) {
    header("Access-Control-Allow-Origin: {$_SERVER['HTTP_ORIGIN']}");
    header('Access-Control-Allow-Credentials: true');
    header('Access-Control-Max-Age: 86400'); // Cache for 1 day
}

// Access-Control headers for preflight requests (OPTIONS)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_METHOD'])) {
        header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
    }

    if (isset($_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS'])) {
        header("Access-Control-Allow-Headers: {$_SERVER['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']}");
    }

    exit(0);
}

// Set content type to JSON
header('Content-Type: application/json');

// Database connection parameters
require_once 'dbh.php'; // This should include $conn (your DB connection)

// Check if all required fields are set via POST request
if (!isset($_POST['username']) || !isset($_POST['password'])) {
    die(json_encode(array("status" => "error", "message" => "Invalid request: username and password are required")));
}

// Extract data from POST
$username = $_POST['username'];
$password = $_POST['password'];

// Check if the username already exists
$sql_check = "SELECT * FROM login1 WHERE username = ?";
if ($stmt_check = $conn->prepare($sql_check)) {
    // Bind the parameter
    $stmt_check->bind_param("s", $username);
    $stmt_check->execute();
    $stmt_check->store_result();

    // If username already exists, return an error
    if ($stmt_check->num_rows > 0) {
        die(json_encode(array("status" => "error", "message" => "Username already exists")));
    }

    // Close the check statement
    $stmt_check->close();
}

// Prepare SQL query to insert new user using prepared statements
$sql_insert = "INSERT INTO login1 (username, password) VALUES (?, ?)";
if ($stmt = $conn->prepare($sql_insert)) {
    // Bind the parameters (s = string)
    $stmt->bind_param("ss", $username, $password);

    // Execute the statement
    if ($stmt->execute()) {
        // Signup successful
        echo json_encode(array("status" => "success", "message" => "User registered successfully"));
    } else {
        // Signup failed
        error_log("Signup failed: " . $stmt->error); // Log error
        die(json_encode(array("status" => "error", "message" => "Signup failed, please try again")));
    }

    // Close the statement
    $stmt->close();
} else {
    // Query preparation failed
    error_log("Query preparation failed: " . $conn->error); // Log the error
    die(json_encode(array("status" => "error", "message" => "Server error")));
}

// Close the database connection
$conn->close();
?>
