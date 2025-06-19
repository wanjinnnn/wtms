<?php
// Enable error reporting (optional: helpful during development)
mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

include_once 'config.php';

$servername = DB_HOST;
$username = DB_USER;
$password = DB_PASS;
$dbname = DB_NAME;

// Create connection using MySQLi and set charset
$conn = new mysqli($servername, $username, $password, $dbname);
$conn->set_charset("utf8mb4"); 

// Check connection
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(["status" => "error", "message" => "Database connection failed"]);
    exit;
}
?>
