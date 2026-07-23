<?php
// db.php
$host = "127.0.0.1";
$user = "app_user";
$password = "app_password";
//$password = "";
$database = "car_service_db";

$conn = new mysqli($host, $user, $password, $database);

if ($conn->connect_error) {
    die("Database Connection Failed: " . $conn->connect_error);
}
