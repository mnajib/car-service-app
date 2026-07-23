-- schema.sql
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    car_plate VARCHAR(20) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    appointment_date DATE NOT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data for demo purposes
INSERT INTO appointments (customer_name, car_plate, service_type, appointment_date, status)
VALUES
('Ali Ahmad', 'VBC 1234', 'Oil Change', '2026-08-01', 'Confirmed'),
('Siti Sarah', 'WYY 8888', 'Brake Inspection', '2026-08-02', 'Pending');
