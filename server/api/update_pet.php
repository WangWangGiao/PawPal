<?php
    header("Access-Control-Allow-Origin: *");
    include 'dbconnect.php';

    if ($_SERVER['REQUEST_METHOD'] != 'POST') {
        http_response_code(405);
        sendJsonResponse(array('success' => false, 'message' => 'Method Not Allowed'));
        exit();
    }

    $petid = $_POST['pet_id']; 
    $userid = $_POST['user_id'];
    $petName = $_POST['pet_name'];
    $petType = $_POST['pet_type'];
    $petAge = $_POST['pet_age'];
    $petGender = $_POST['pet_gender'];
    $petHealth = $_POST['pet_health'];
    $category = $_POST['category'];
    $description = addslashes($_POST['description']);
    $lat = $_POST['lat'];
    $lng = $_POST['lng'];
    $imageList = json_decode($_POST['image'], true);

    // Update Query
    $sqlupdatepet = "UPDATE `tbl_pets` SET 
        `pet_name`='$petName', `pet_type`='$petType', `pet_age`='$petAge', 
        `pet_gender`='$petGender', `pet_health`='$petHealth', `category`='$category', 
        `description`='$description', `lat`='$lat', `lng`='$lng' 
        WHERE `pet_id` = '$petid'";

    try {
        if ($conn->query($sqlupdatepet) === TRUE) {
            
            // Check if user have upload new picture or not
            if ($imageList[0] !== "no_change") { //If upload new pic
                
                // Delete the old picture from the local folder
                for ($i = 1; $i <= 3; $i++) {
                    $oldFile = "../uploads/pet/pets_" . $petid . "_" . $i . ".png";
                    if (file_exists($oldFile)) {
                        unlink($oldFile);
                    }
                }

                // Store
                $newImagePaths = [];
                for ($x = 0; $x < count($imageList); $x++) {
                    $imageData = $imageList[$x];
                    if ($imageData !== "no_change" && $imageData !== "remove" && !empty($imageData)) {
                        $filename = "../uploads/pet/pets_" . $petid . "_" . ($x + 1) . ".png";
                        $base64Image = base64_decode($imageData);
                        file_put_contents($filename, $base64Image);
                        $newImagePaths[] = $filename;
                    }
                }

                $imageJsonPath = json_encode($newImagePaths);
                $conn->query("UPDATE `tbl_pets` SET `image_paths` = '$imageJsonPath' WHERE `pet_id` = '$petid'");
            }
            sendJsonResponse(array('success' => true, 'message' => 'Pet record updated successfully'));
        } else {
            sendJsonResponse(array('success' => false, 'message' => 'Pet record updated failed'));
        }
    } catch (Exception $e) {
        sendJsonResponse(array('success' => false, 'message' => $e->getMessage()));
    }

function sendJsonResponse($sentArray) {
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>