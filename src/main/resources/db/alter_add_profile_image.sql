-- Run only if the profile_image column does not already exist on users.
ALTER TABLE users ADD COLUMN profile_image VARCHAR(255) NULL AFTER email;
