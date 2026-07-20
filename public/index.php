<?php
// public/index.php
require_once __DIR__ . '/../db.php';

// Fetch all appointments
$sql = "SELECT * FROM appointments ORDER BY appointment_date ASC";
$result = $conn->query($sql);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Service Appointment System</title>
    <!-- Local Bootstrap 5 CSS -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

    <!-- Header Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary mb-4">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.php">Car Service Center</a>
        </div>
    </nav>

    <div class="container">
        <!-- Page Title & Action Button -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Appointments List</h2>
            <a href="book.php" class="btn btn-success fw-semibold">+ Book New Appointment</a>
        </div>

        <!-- Appointments Table Card -->
        <div class="card shadow-sm border-0">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover table-striped mb-0 align-middle">
                        <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Customer Name</th>
                                <th>Car Plate</th>
                                <th>Service Type</th>
                                <th>Date</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if ($result && $result->num_rows > 0): ?>
                                <?php while ($row = $result->fetch_assoc()): ?>
                                    <tr>
                                        <td><?php echo $row['id']; ?></td>
                                        <td class="fw-medium"><?php echo htmlspecialchars($row['customer_name']); ?></td>
                                        <td>
                                            <span class="badge bg-secondary font-monospacefs-6"><?php echo htmlspecialchars($row['car_plate']); ?></span>
                                        </td>
                                        <td><?php echo htmlspecialchars($row['service_type']); ?></td>
                                        <td><?php echo $row['appointment_date']; ?></td>
                                        <td>
                                            <?php
                                                $statusClass = ($row['status'] === 'Confirmed') ? 'bg-success' : 'bg-warning text-dark';
                                            ?>
                                            <span class="badge <?php echo $statusClass; ?>"><?php echo htmlspecialchars($row['status']); ?></span>
                                        </td>
                                    </tr>
                                <?php endwhile; ?>
                            <?php else: ?>
                                <tr>
                                    <td colspan="6" class="text-center text-muted p-4">No appointments found.</td>
                                </tr>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Local Bootstrap 5 JS Bundle -->
    <script src="assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
