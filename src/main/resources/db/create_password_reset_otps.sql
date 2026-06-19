-- New table for OTP-based password reset (does not modify existing tables).
CREATE TABLE IF NOT EXISTS password_reset_otps (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    otp_code VARCHAR(10) NOT NULL,
    expires_at TIMESTAMP NOT NULL,
    is_used TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_otp_email (email)
);
