<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'config.php';

// Connect to DB
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// Get POST data
$worker_id = isset($_POST['worker_id']) ? intval($_POST['worker_id']) : 0;

if ($worker_id > 0) {
    $sql = "SELECT * FROM tbl_works WHERE assigned_to = ?";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $worker_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $tasks = [];
    while ($row = $result->fetch_assoc()) {
        $tasks[] = $row;
    }

    echo json_encode(["success" => true, "tasks" => $tasks]);
} else {
    echo json_encode(["success" => false, "message" => "Invalid worker_id"]);
}

$conn->close();
?>
