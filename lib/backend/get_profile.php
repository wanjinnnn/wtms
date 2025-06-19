<?php
include "db_connection.php";

// Check if worker_id is set
if (!isset($_POST['worker_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing worker_id"]);
    exit;
}

$worker_id = $_POST['worker_id'];

$sql = "SELECT id, full_name, email, phone, address FROM workers WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

if ($row = $result->fetch_assoc()) {
    echo json_encode($row);
} else {
    echo json_encode(["status" => "error", "message" => "Worker not found"]);
}
?>
