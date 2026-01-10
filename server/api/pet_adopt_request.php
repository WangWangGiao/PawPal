<?php
	header("Access-Control-Allow-Origin: *");

	if ($_SERVER['REQUEST_METHOD'] == 'POST') {
		if (!isset($_POST['pet_id']) || !isset($_POST['user_id']) || !isset($_POST['motivation']) || !isset($_POST['previous_exp']) || !isset($_POST['status']) || !isset($_POST['owned_id'])) {
			http_response_code(400);
			$response = array('success' => false, 'message' => 'Bad Request');
			exit();
		}

		include 'dbconnect.php';
		$petId = $_POST['pet_id'];
		$userId = $_POST['user_id'];
		$motivation = $_POST['motivation'];
		$previous_experience = $_POST['previous_exp'];
		$status = $_POST['status'];
		$ownedId = $_POST['owned_id'];

		$sqlcheck = "SELECT * FROM `tbl_adoptions` WHERE `pet_id` = '$petId' AND `user_id` = '$userId'";
        $resultcheck = $conn->query($sqlcheck);
		if ($resultcheck->num_rows > 0) {
            $response = array('success' => false, 'message' => 'You have already submitted a request for this pet.');
            sendJsonResponse($response);
            exit();
        }
		// Insert new request
		$sqladoptrequest = "INSERT INTO `tbl_adoptions`(`pet_id`, `user_id`, `motivation`, `previous_exp`, `status`, `owned_id`) 
        VALUES ('$petId','$userId','$motivation', '$previous_experience', '$status', '$ownedId')";
		try{
			if ($conn->query($sqladoptrequest) === TRUE){
				$response = array('success' => true, 'message' => 'Submit Adoption Request Successful');
				sendJsonResponse($response);
			}else{
				$response = array('success' => false, 'message' => 'Submit Adoption Request Failed');
				sendJsonResponse($response);
			}
		}catch(Exception $e){
			$response = array('success' => false, 'message' => $e->getMessage());
			sendJsonResponse($response);
		}
	}else{
		http_response_code(405);
		$response = array('success' => false, 'message' => 'Method Not Allowed');
		exit();
	}


//	function to send json response	
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>