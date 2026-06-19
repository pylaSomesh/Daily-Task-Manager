-- Run only if the category column does not already exist on tasks.
ALTER TABLE tasks ADD COLUMN category VARCHAR(50) NOT NULL DEFAULT 'Personal' AFTER priority;
