<?php
// Enable error reporting for debugging
error_reporting(E_ALL);
ini_set('display_errors', 1);

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
} else {
    echo json_encode(array("status" => "success", "message" => "Database connected successfully."));
}

// Check if form is submitted
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Check if required fields are set
    if (!isset($_POST['part']) || !isset($_FILES['image'])) {
        die(json_encode(array("status" => "error", "message" => "Invalid request: Both part and image are required.")));
    }

    // Extract data from POST
    $part = $_POST['part'];

    // Handle image upload
    $target_dir = "uploads/"; // Directory where the images will be stored

    // Check if the uploads directory exists
    if (!is_dir($target_dir)) {
        mkdir($target_dir, 0777, true); // Create the directory if it doesn't exist
    }

    $target_file = $target_dir . basename($_FILES["image"]["name"]);
    $uploadOk = 1;
    $imageFileType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));

    // Check if image file is a actual image or fake image
    $check = getimagesize($_FILES["image"]["tmp_name"]);
    if ($check === false) {
        echo json_encode(array("status" => "error", "message" => "File is not an image."));
        $uploadOk = 0;
    }

    // Check file size (limit to 2MB for example)
    if ($_FILES["image"]["size"] > 2000000) {
        echo json_encode(array("status" => "error", "message" => "Sorry, your file is too large."));
        $uploadOk = 0;
    }

    // Allow certain file formats
    if (!in_array($imageFileType, ['jpg', 'jpeg', 'png', 'gif'])) {
        echo json_encode(array("status" => "error", "message" => "Sorry, only JPG, JPEG, PNG & GIF files are allowed."));
        $uploadOk = 0;
    }

    // Check if $uploadOk is set to 0 by an error
    if ($uploadOk == 0) {
        echo json_encode(array("status" => "error", "message" => "Your file was not uploaded."));
    } else {
        // Attempt to move the uploaded file to the server
        if (move_uploaded_file($_FILES["image"]["tmp_name"], $target_file)) {
            // Prepare SQL query to insert part and image into the database
            $sql_insert = "INSERT INTO input (part, image) VALUES (?, ?)";
            if ($stmt = $conn->prepare($sql_insert)) {
                // Bind the parameters (s = string)
                $stmt->bind_param("ss", $part, $target_file);

                // Execute the statement
                if ($stmt->execute()) {
                    // Insertion successful
                    echo json_encode(array("status" => "success", "message" => "Part and image uploaded successfully."));
                } else {
                    // Insertion failed
                    error_log("Insertion failed: " . $stmt->error); // Log error
                    echo json_encode(array("status" => "error", "message" => "Upload failed, please try again."));
                }

                // Close the statement
                $stmt->close();
            } else {
                // Query preparation failed
                error_log("Query preparation failed: " . $conn->error); // Log the error
                echo json_encode(array("status" => "error", "message" => "Server error: " . $conn->error));
            }
        } else {
            echo json_encode(array("status" => "error", "message" => "Sorry, there was an error uploading your file."));
        }
    }
}

// Close the database connection
$conn->close();
?>