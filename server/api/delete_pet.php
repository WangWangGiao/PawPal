<?php
header("Access-Control-Allow-Origin: *");
include 'dbconnect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if (!isset($_POST['pet_id'])) {
        $response = array('success' => false, 'message' => 'Bad Request');
        sendJsonResponse($response);
        exit();
    }

    $petid = $_POST['pet_id'];

    $sqldeleteadoption = "DELETE FROM `tbl_adoptions` WHERE `pet_id` = '$petid'";
    
    $sqldeletepet = "DELETE FROM `tbl_pets` WHERE `pet_id` = '$petid'";

    try {
        $conn->query($sqldeleteadoption);

        if ($conn->query($sqldeletepet) === TRUE) {
            for ($i = 1; $i <= 3; $i++) {
                    $oldFile = "../uploads/pet/pets_" . $petid . "_" . $i . ".png";
                    if (file_exists($oldFile)) {
                        unlink($oldFile);
                    }
                }
            $response = array('success' => true, 'message' => 'Pet and adoption records deleted successfully');
            sendJsonResponse($response);
        } else {
            $response = array('success' => false, 'message' => 'Failed to delete pet record');
            sendJsonResponse($response);
        }
    } catch (Exception $e) {
        $response = array('success' => false, 'message' => $e->getMessage());
        sendJsonResponse($response);
    }
} else {
    http_response_code(405);
    echo json_encode(array('error' => 'Method Not Allowed'));
    exit();
}

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>