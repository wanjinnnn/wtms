<?php
include "db_connection.php";

// Check if required POST parameters are set
if (!isset($_POST['submission_id']) || !isset($_POST['updated_text'])) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit;
}

$submission_id = $_POST['submission_id'];
$updated_text = $_POST['updated_text'];

$sql = "UPDATE tbl_submissions SET submission_text = ? WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("si", $updated_text, $submission_id);

if ($stmt->execute()) {
    echo "success";
} else {
    echo "error";
}
?>
