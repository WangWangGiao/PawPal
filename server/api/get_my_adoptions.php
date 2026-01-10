<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    $userid = isset($_GET['user_id']) ? $conn->real_escape_string($_GET['user_id']) : '';

    if (empty($userid)) {
        echo json_encode(array("success" => false, "message" => "User ID required"));
        exit();
    }

    $sql = "SELECT a.*, p.pet_name, u.name AS owner_name, u.phone AS owner_phone 
            FROM tbl_adoptions a
            JOIN tbl_pets p ON a.pet_id = p.pet_id
            JOIN tbl_users u ON p.user_id = u.user_id
            WHERE a.user_id = '$userid'";

    $result = $conn->query($sql);
    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode(array("success" => true, "data" => $data));
    } else {
        echo json_encode(array("success" => false, "message" => "No Data"));
    }
}
?>