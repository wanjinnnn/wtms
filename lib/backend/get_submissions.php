<?php
include "db_connection.php";

// Check if worker_id is set
if (!isset($_POST['worker_id'])) {
    echo json_encode(["status" => "error", "message" => "Missing worker_id"]);
    exit;
}

$worker_id = $_POST['worker_id'];

$sql = "SELECT s.id, s.submission_text, s.submitted_at, w.title 
        FROM tbl_submissions s 
        JOIN tbl_works w ON s.work_id = w.id 
        WHERE s.worker_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $worker_id);
$stmt->execute();
$result = $stmt->get_result();

$submissions = [];
while ($row = $result->fetch_assoc()) {
    $submissions[] = $row;
}
echo json_encode($submissions);
?>
