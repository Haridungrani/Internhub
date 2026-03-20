-- Interns Table
CREATE TABLE IF NOT EXISTS interns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department VARCHAR(100)
);

-- Sample Data
INSERT INTO interns (name, email, phone, department) VALUES
('Bhargav Dungrani', 'bhargav@test.c', '9999999999', 'IT'),
('John Smith', 'john.smith@test.c', '8888888888', 'Backend'),
('Sarah Williams', 'sarah.w@test.c', '7777777777', 'Frontend'),
('Alex Chen', 'alex.chen@test.c', '6666666666', 'DevOps');

-- Create indexes for better query performance
CREATE INDEX idx_interns_email ON interns(email);
CREATE INDEX idx_interns_department ON interns(department);


