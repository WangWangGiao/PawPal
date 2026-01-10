<?php
header("Access-Control-Allow-Origin: *"); // running as chrome app
if ($_SERVER['REQUEST_METHOD'] == 'GET') {
    include 'dbconnect.php';
    
    $userid = isset($_GET['user_id']) ? $_GET['user_id'] : 'All';
    $viewerid = isset($_GET['viewer_id']) ? $_GET['viewer_id'] : '';
    $search = isset($_GET['search']) ? $conn->real_escape_string($_GET['search']) : '';
    $category = isset($_GET['category']) ? $_GET['category'] : 'All';
    $type = isset($_GET['type']) ? $_GET['type'] : 'All';

    // Base JOIN query
    $baseQuery = "SELECT s.*, u.name, u.email, u.phone
                   FROM tbl_pets s
                   JOIN tbl_users u ON s.user_id = u.user_id
                   WHERE 1=1";

    // Distinguish public pet list and personal pet list. (all = public)
    if ($userid === 'All' && !empty($viewerid)) {
        $baseQuery .= " AND s.user_id != '$viewerid'";
    } 
    else if ($userid !== 'All') {
        $baseQuery .= " AND s.user_id = '$userid'";
    }

    // Category - check it filter for specific or didn't filter any category
    if ($category !== 'All') {
        $category_val = $conn->real_escape_string($category);
        if ($category_val === 'Donation') {
            $category_val = 'Donate Request';
        }
        $baseQuery .= " AND s.category = '$category_val'";
    }

    // Type - check it filter for specific or didn't filter any pet type
    if ($type !== 'All') {
        $baseQuery .= " AND s.pet_type = '$type'";
    }

    // Search 
    if (!empty($search)) {
        $baseQuery .= " AND (s.pet_name LIKE '%$search%')";
    }

    $baseQuery .= " ORDER BY s.pet_id DESC";

    // Execute query
    $result = $conn->query($baseQuery);
    if ($result && $result->num_rows > 0) {
        $petdata = array();
        while ($row = $result->fetch_assoc()) {
            $petdata[] = $row;
        }
        $response = array('success' => true, 'data' => $petdata);
        sendJsonResponse($response);
    } else {
        $response = array('success' => false, 'data' => null, 'message' => 'No Data Founded');
        sendJsonResponse($response);
    }

} else {
    $response = array('success' => false,'message' => $e->getMessage());
    sendJsonResponse($response);
    exit();
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>