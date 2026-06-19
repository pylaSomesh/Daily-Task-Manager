-- Run only if the priority column does not already exist on tasks.
ALTER TABLE tasks ADD COLUMN priority VARCHAR(20) NOT NULL DEFAULT 'Medium' AFTER due_date;
