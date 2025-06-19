<?php
include "db_connection.php";

// Check if all required POST parameters are set
if (
    !isset($_POST['worker_id']) ||
    !isset($_POST['full_name']) ||
    !isset($_POST['email']) ||
    !isset($_POST['phone']) ||
    !isset($_POST['address'])
) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit;
}

$id = $_POST['worker_id'];
$name = $_POST['full_name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$address = $_POST['address'];

$sql = "UPDATE workers SET full_name=?, email=?, phone=?, address=? WHERE id=?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssssi", $name, $email, $phone, $address, $id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Profile updated"]);
} else {
    echo json_encode(["status" => "error", "message" => "Update failed"]);
}
?>
