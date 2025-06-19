<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// Connect to DB
$conn = new mysqli("localhost", "root", "", "wtms");

// Check connection
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// Get POST data
$work_id = isset($_POST['work_id']) ? intval($_POST['work_id']) : 0;
$worker_id = isset($_POST['worker_id']) ? intval($_POST['worker_id']) : 0;
$submission_text = isset($_POST['submission_text']) ? trim($_POST['submission_text']) : "";

if ($work_id > 0 && $worker_id > 0 && $submission_text !== "") {
    $stmt = $conn->prepare("INSERT INTO tbl_submissions (work_id, worker_id, submission_text) VALUES (?, ?, ?)");
    $stmt->bind_param("iis", $work_id, $worker_id, $submission_text);

    if ($stmt->execute()) {
        // Update the status of the work to 'Completed'
        $update = $conn->prepare("UPDATE tbl_works SET status = 'Completed' WHERE id = ?");
        $update->bind_param("i", $work_id);
        $update->execute();
        $update->close();

        echo json_encode(["success" => true, "message" => "Submission successful and status updated"]);
    } else {
        echo json_encode(["success" => false, "message" => "Failed to insert submission"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid input"]);
}

$conn->close();
?>
