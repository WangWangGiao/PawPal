<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['userid']) || !isset($_POST['name']) || !isset($_POST['phone']) || !isset($_POST['userpic'])) {
        sendJsonResponse(array('success' => false, 'message' => 'Bad Request'));
        exit();
    }

    $userid = $_POST['userid']; 
    $username = $_POST['name'];
    $userphone = $_POST['phone'];
    $useravatar = $_POST['userpic'];

    $sqlupdateuser = "UPDATE `tbl_users` SET `name`='$username', `phone`='$userphone' WHERE `user_id` = '$userid'";

    try {
        if ($conn->query($sqlupdateuser) === TRUE) {
            
                $decoded_image = base64_decode($useravatar);
                
                $dir = "../uploads/user_profile/";
                if (!file_exists($dir)) {
                    mkdir($dir, 0755, true);
                }

                $filename = $dir . "userAvatar_" . $userid . ".png";
                
                if (file_put_contents($filename, $decoded_image)) {
                    $avatarPath = "userAvatar_" . $userid . ".png";
                    $conn->query("UPDATE `tbl_users` SET `avatar` = '$avatarPath' WHERE `user_id` = '$userid'");
                }
            
            sendJsonResponse(array('success' => true, 'message' => 'Profile updated successfully'));
            
        } else {
            sendJsonResponse(array('success' => false, 'message' => 'Database update failed'));
        }
    } catch (Exception $e) {
        sendJsonResponse(array('success' => false, 'message' => $e->getMessage()));
    }

} else {
    http_response_code(405);
    sendJsonResponse(array('success' => false, 'message' => 'Method Not Allowed'));
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>