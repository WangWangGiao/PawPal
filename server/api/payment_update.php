<?php
//error_reporting(0);
include_once("dbconnect.php");

$email = $_GET['email'];
$phone = $_GET['phone'];
$name = $_GET['name']; 
$credit = $_GET['credit']; 
$userid = $_GET['userid'];
$xkey = '0a27016049bb90f8a58f3925bc7bc353b507bd0bc15223356e38c5491ec3a212ea4a184f59cf99cafd3ea1c41d02cae4ec50332d07ba73a2207a06637808479a';

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

//Process status
$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];

//X-Signature Security Authentication
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$signed= hash_hmac('sha256', $signing, $xkey);

$mainBlue = "#1F3C88";
$errorRed = "#e74c3c";
$lightRed = "#fdedec";

if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
    
        //update credit
        $sqlupdatecredit = "UPDATE `tbl_users` SET `credit` = `credit` + '$credit' WHERE `user_id` = '$userid'";
        if ($conn->query($sqlupdatecredit) === TRUE){
             //print receipt for success transaction
            echo "
            <html>
            <head>
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
                <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
                <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css\">
                <style>
                    body { background-color: #f4f7f6; font-family: sans-serif; }
                    .receipt-card { max-width: 400px; margin: 30px auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
                    .header { background-color: $mainBlue; color: white; padding: 30px; text-align: center; }
                    .status-icon { font-size: 50px; margin-bottom: 10px; }
                    .content { padding: 20px; }
                    .item-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #eee; }
                    .label { color: #888; font-size: 14px; }
                    .value { font-weight: bold; color: #333; }
                    .total-box { background: #f9f9f9; padding: 15px; border-radius: 10px; margin-top: 20px; text-align: center; }
                    .total-amount { font-size: 24px; color: $mainBlue; font-weight: bold; }
                </style>
            </head>
            <body>
                <div class=\"receipt-card\">
                    <div class=\"header\">
                        <div class=\"status-icon\"><i class=\"fa fa-check-circle\"></i></div>
                        <h2 style=\"margin:0\">Payment Success</h2>
                        <p style=\"opacity:0.8; margin:5px 0 0 0\">Transaction ID: $receiptid</p>
                    </div>
                    
                    <div class=\"content\">
                        <div class=\"item-row\">
                            <span class=\"label\">Customer</span>
                            <span class=\"value\">$name</span>
                        </div>
                        <div class=\"item-row\">
                            <span class=\"label\">Email</span>
                            <span class=\"value\">$email</span>
                        </div>
                        <div class=\"item-row\">
                            <span class=\"label\">Phone</span>
                            <span class=\"value\">$phone</span>
                        </div>
                        <div class=\"item-row\">
                            <span class=\"label\">Status</span>
                            <span class=\"value\" style=\"color:green\">$paidstatus</span>
                        </div>

                        <div class=\"total-box\">
                            <div class=\"label\">Total Credits Added</div>
                            <div class=\"total-amount\">RM " . number_format($credit, 2) . "</div>
                        </div>
                        
                        <p style=\"text-align:center; color:#999; font-size:12px; margin-top:20px;\">
                            Please take a screenshot for your records.
                        </p>
                    </div>
                </div>
            </body>
            </html>";
        }else{ 
            //Fail to update credit
            echo "
            <html>
            <head>
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
                <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
                <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css\">
                <style>
                    body { background-color: #f4f7f6; font-family: sans-serif; }
                    .receipt-card { max-width: 400px; margin: 30px auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
                    .header { background-color: $warningOrange; color: white; padding: 30px; text-align: center; }
                    .status-icon { font-size: 50px; margin-bottom: 10px; }
                    .content { padding: 20px; }
                    .item-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #eee; }
                    .label { color: #888; font-size: 14px; }
                    .value { font-weight: bold; color: #333; }
                    .warning-box { background: #FFF3E0; padding: 15px; border-radius: 10px; margin-top: 20px; border: 1px solid #FFE0B2; }
                    .warning-text { font-size: 14px; color: #E65100; font-weight: bold; text-align: center; }
                </style>
            </head>
            <body>
                <div class=\"receipt-card\">
                    <div class=\"header\">
                        <div class=\"status-icon\"><i class=\"fa fa-exclamation-triangle\"></i></div>
                        <h2 style=\"margin:0\">Payment Received</h2>
                        <p style=\"opacity:0.9; margin:5px 0 0 0\">Transaction Pending Update</p>
                    </div>
                    
                    <div class=\"content\">
                        <p style='color:#666; font-size:14px; text-align:center;'>We received your payment, but our system encountered a technical error while updating your credits.</p>
                        
                        <div class=\"item-row\">
                            <span class=\"label\">Bill ID</span>
                            <span class=\"value\">$receiptid</span>
                        </div>
                        <div class=\"item-row\">
                            <span class=\"label\">Status</span>
                            <span class=\"value\" style=\"color:#E65100\">Success (Update Pending)</span>
                        </div>
                        <div class=\"item-row\">
                            <span class=\"label\">Amount Paid</span>
                            <span class=\"value\">RM " . number_format($credit, 2) . "</span>
                        </div>

                        <div class=\"warning-box\">
                            <div class=\"warning-text\">
                                ⚠️ ACTION REQUIRED:<br>
                                Please screenshot this receipt and contact our support to manually update your credits.
                            </div>
                        </div>
                    </div>
                </div>
            </body>
            </html>";
        }
    }else{
        //print receipt for failed transaction
         echo "
        <html>
        <head>
            <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
            <link rel=\"stylesheet\" href=\"https://www.w3schools.com/w3css/4/w3.css\">
            <link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css\">
            <style>
                body { background-color: #f4f7f6; font-family: sans-serif; }
                .receipt-card { max-width: 400px; margin: 30px auto; background: white; border-radius: 20px; overflow: hidden; box-shadow: 0 10px 20px rgba(0,0,0,0.1); }
                .header { background-color: $errorRed; color: white; padding: 30px; text-align: center; }
                .status-icon { font-size: 50px; margin-bottom: 10px; }
                .content { padding: 20px; }
                .item-row { display: flex; justify-content: space-between; padding: 10px 0; border-bottom: 1px dashed #eee; }
                .label { color: #888; font-size: 14px; }
                .value { font-weight: bold; color: #333; }
                .fail-box { background: $lightRed; padding: 15px; border-radius: 10px; margin-top: 20px; border: 1px solid #fadbd8; }
                .fail-text { font-size: 14px; color: #a94442; text-align: center; }
                .btn-retry { display: block; width: 100%; background: $errorRed; color: white; text-align: center; padding: 12px; border-radius: 10px; text-decoration: none; margin-top: 20px; font-weight: bold; }
            </style>
        </head>
        <body>
            <div class=\"receipt-card\">
                <div class=\"header\">
                    <div class=\"status-icon\"><i class=\"fa fa-times-circle\"></i></div>
                    <h2 style=\"margin:0\">Payment Failed</h2>
                    <p style=\"opacity:0.8; margin:5px 0 0 0\">Transaction was not completed</p>
                </div>
                
                <div class=\"content\">
                    <div class=\"item-row\">
                        <span class=\"label\">Reference ID</span>
                        <span class=\"value\">$receiptid</span>
                    </div>
                    <div class=\"item-row\">
                        <span class=\"label\">Amount</span>
                        <span class=\"value\">RM " . number_format($credit, 2) . "</span>
                    </div>
                    <div class=\"item-row\">
                        <span class=\"label\">Status</span>
                        <span class=\"value\" style=\"color:$errorRed\">$paidstatus</span>
                    </div>

                    <div class=\"fail-box\">
                        <div class=\"fail-text\">
                            <strong>Reason:</strong> Your transaction could not be processed. This can happen due to insufficient funds or cancellation.
                        </div>
                    </div>

                    <p style=\"text-align:center; color:#999; font-size:12px; margin-top:20px;\">
                        No money has been deducted from your account.
                    </p>
                    
                    <a href=\"javascript:history.back()\" class=\"btn-retry\">Try Again</a>
                </div>
            </div>
        </body>
        </html>";
    }
}

?>