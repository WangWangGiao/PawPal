<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    http_response_code(405);
    sendJsonResponse(['success' => false, 'message' => 'Method Not Allowed']);
    exit();
}

if (!isset($_POST['pet_id'], $_POST['user_id'], $_POST['donation_type'], $_POST['amount'], $_POST['description'])) {
    http_response_code(400);
    sendJsonResponse(['success' => false, 'message' => 'Bad Request: Missing parameters']);
    exit();
}

$petId = $_POST['pet_id'];
$userId = $_POST['user_id'];
$donationType = $_POST['donation_type'];
$amount = floatval($_POST['amount']);  //Convert to num
$description = $conn->real_escape_string($_POST['description']); //Prevent SQL Injection

try {
    //Insert donate record
    $sqlinsertdonate = "INSERT INTO `tbl_donations`(`pet_id`, `user_id`, `donation_type`, `amount`, `description`) 
                        VALUES ('$petId', '$userId', '$donationType', '$amount', '$description')";

    if ($conn->query($sqlinsertdonate) === TRUE) {
        //If donate money and amount more than 0
        if ($donationType === "Money" && $amount > 0) {
            $updateUserCredit = "UPDATE `tbl_users` SET `credit` = `credit` - $amount WHERE `user_id` = '$userId'";
            
            if ($conn->query($updateUserCredit) === TRUE) {
                sendJsonResponse(['success' => true, 'message' => 'Donate successfully']);
            } else {
                sendJsonResponse(['success' => false, 'message' => 'Failed to update user credit']);
            }
        } else {
			//Donate Food/Medical no need update user credit
            sendJsonResponse(['success' => true, 'message' => 'Item donation recorded']);
        }
    } else {
        throw new Exception("Insert failed: " . $conn->error);
    }
} catch (Exception $e) {
    $response = array('success' => false, 'message' => $e->getMessage());
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>