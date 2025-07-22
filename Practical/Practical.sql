Create database Practic

-- Creating the Dentists table
CREATE TABLE Dentists (
    DentistID INT PRIMARY KEY IDENTITY(1,1),
    Name VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Email VARCHAR(255) UNIQUE NOT NULL
);
select * from Dentists

-- Creating the Patients table
CREATE TABLE Patients (
    PatientID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Phone VARCHAR(20),
    Email VARCHAR(255) UNIQUE NOT NULL
);

-- Creating the Services table
CREATE TABLE Services (
    ServiceID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Fee DECIMAL(10, 2) NOT NULL
);

-- Creating the TreatmentPlans table
CREATE TABLE TreatmentPlans (
    TreatmentPlanID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    DurationInDays INT NOT NULL,
    Fee DECIMAL(10, 2) NOT NULL,
    ServiceID INT,
    FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID)
);

-- Creating the Appointments table
CREATE TABLE Appointments (
    AppointmentID INT PRIMARY KEY,
    AppointmentDate DATETIME NOT NULL,
    PatientID INT,
    DentistID INT,
    TreatmentPlanID INT,
    FOREIGN KEY (PatientID)
	REFERENCES Patients(PatientID),
	FOREIGN KEY (DentistID) REFERENCES Dentists(DentistID),
	FOREIGN KEY (TreatmentPlanID) REFERENCES TreatmentPlans(TreatmentPlanID)
	);

/*2*/
CREATE PROCEDURE AddNewPatient (
    IN p_Name VARCHAR(255),
    IN p_Phone VARCHAR(20),
    IN p_Email VARCHAR(255)
)
BEGIN
    -- Check if a patient with the same name already exists
    IF EXISTS (SELECT * FROM Patients WHERE Name = p_Name) THEN
        -- Display an error message
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A patient with this name already exists.';
    ELSE
        -- Insert the new patient into the Patients table
        INSERT INTO Patients (Name, Phone, Email) VALUES (p_Name, p_Phone, p_Email);
    END IF;
END //

/*3*/
CREATE VIEW FebruaryAppointments AS
SELECT p.Name, a.AppointmentDate
FROM Appointments a
JOIN Patients p ON a.PatientID = p.PatientID
WHERE MONTH(a.AppointmentDate) = 2 AND YEAR(a.AppointmentDate) = 2024;
select * from FebruaryAppointments

-- Sample data for Dentists
INSERT INTO Dentists (DentistID,Name, Phone, Email) VALUES
('1','Dr. Susan Hill', '123-456-7890', 'susan.hill@dentalclinic.com'),
('2','Dr. John Doe', '321-654-0987', 'john.doe@dentalclinic.com');

-- Sample data for Patients
INSERT INTO Patients (PatientID, Name, Phone, Email) VALUES

(1, 'Alice Smith', '555-0100', 'alice.smith@email.com'),
(2, 'Bob Jones', '555-0101', 'bob.jones@email.com');
select * from Patients
-- Sample data for Services
INSERT INTO Services (ServiceID, Name, Fee) VALUES
(1, 'Teeth Cleaning', 75.00),
(2, 'Cavity Filling', 150.00),
(3, 'Root Canal', 500.00);

-- Sample data for TreatmentPlans
INSERT INTO TreatmentPlans (TreatmentPlanID, Name, DurationInDays, Fee, ServiceID) VALUES
(1, 'Basic Cleaning', 1, 75.00, 1),
(2, 'Cavity Repair', 1, 150.00, 2),
(3, 'Root Canal Treatment', 3, 500.00, 3);

-- Sample data for Appointments
INSERT INTO Appointments (AppointmentID, AppointmentDate, PatientID, DentistID, TreatmentPlanID) VALUES
(1, '2024-02-15 09:00:00', 1, 1, 1),
(2, '2024-02-16 10:00:00', 2, 1, 2),
(3, '2024-03-01 11:00:00', 1, 2, 3);

-- Insert data into Patients table
INSERT INTO Patients (Name, Phone, Email) VALUES
('Alice Smith', '555-0100', 'alice.smith@email.com'),
('Bob Jones', '555-0101', 'bob.jones@email.com');

-- Insert data into Services table
INSERT INTO Services (Name, Fee) VALUES
('Teeth Cleaning', 75.00),
('Cavity Filling', 150.00),
('Root Canal', 500.00);

-- Insert data into TreatmentPlans table
INSERT INTO TreatmentPlans (Name, DurationInDays, Fee, ServiceID) VALUES
('Basic Cleaning', 1, 75.00, 1),
('Cavity Repair', 1, 150.00, 2),
('Root Canal Treatment', 3, 500.00, 3);

-- Insert data into Appointments table
INSERT INTO Appointments (AppointmentDate, PatientID, DentistID, TreatmentPlanID) VALUES
('2024-02-15 09:00:00', 1, 1, 1),
('2024-02-16 10:00:00', 2, 1, 2),
('2024-03-01 11:00:00', 1, 2, 3);

CREATE FUNCTION MostActiveDentist (startDate DATE, endDate DATE) RETURNS VARCHAR(255)
BEGIN
    DECLARE dentistName VARCHAR(255);

    SELECT d.Name INTO dentistName
    FROM Dentists d
    JOIN Appointments a ON d.DentistID = a.DentistID
    WHERE a.AppointmentDate BETWEEN startDate AND endDate
    GROUP BY d.DentistID
    ORDER BY COUNT(a.TreatmentPlanID) 

RETURN dentistName;
END;