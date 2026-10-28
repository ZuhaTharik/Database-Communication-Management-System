CREATE DATABASE IF NOT EXISTS UniversityMeetingDB;

USE UniversityMeetingDB;


CREATE TABLE IF NOT EXISTS `user` (
    UserId VARCHAR(10) PRIMARY KEY,
    Role VARCHAR(50) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(15) NOT NULL,
    Email VARCHAR(100) NOT NULL
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS student_representative (
    UserId VARCHAR(10) PRIMARY KEY,
    AcademicYear INT NOT NULL,
    RegNo VARCHAR(30) NOT NULL UNIQUE,

    CONSTRAINT chk_AcademicYear
        CHECK (AcademicYear > 0),

    CONSTRAINT fk_Student_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS temporary_lecturer (
    UserId VARCHAR(10) PRIMARY KEY,
    TemporaryEmployeId VARCHAR(20) NOT NULL UNIQUE,
    ContractStartDate DATE NOT NULL,
    ContractEndDate DATE NOT NULL,

    CONSTRAINT chk_Temporary_ContractDates
        CHECK (ContractEndDate >= ContractStartDate),

    CONSTRAINT fk_Temporary_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS permanent_lecturer (
    UserId VARCHAR(10) PRIMARY KEY,
    PermanentEmployeeId VARCHAR(20) NOT NULL UNIQUE,
    Designation VARCHAR(100) NOT NULL,

    CONSTRAINT fk_Permanent_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS hod (
    UserId VARCHAR(10) PRIMARY KEY,
    AppoinmentStartDate DATE NOT NULL,
    AppoinmentEndDate DATE NOT NULL,

    CONSTRAINT chk_HOD_AppointmentDates
        CHECK (AppoinmentEndDate >= AppoinmentStartDate),

    CONSTRAINT fk_HOD_PermanentLecturer
        FOREIGN KEY (UserId)
        REFERENCES permanent_lecturer (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS meeting (
    MeetingId VARCHAR(10) PRIMARY KEY,
    MeetingName VARCHAR(150) NOT NULL,
    MeetingDate DATE NOT NULL,
    MeetingTime TIME NOT NULL,
    MeetingVenue VARCHAR(100) NOT NULL,
    Recording VARCHAR(255),
    HOD_user_id VARCHAR(10) NOT NULL,

    CONSTRAINT fk_Meeting_HOD
        FOREIGN KEY (HOD_user_id)
        REFERENCES hod (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS meeting_decision (
    MeetingId VARCHAR(10) NOT NULL,
    decision VARCHAR(255) NOT NULL,

    PRIMARY KEY (MeetingId, decision),

    CONSTRAINT fk_Decision_Meeting
        FOREIGN KEY (MeetingId)
        REFERENCES meeting (MeetingId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS agenda (
    AgendaId VARCHAR(10) PRIMARY KEY,
    AgendaTitle VARCHAR(150) NOT NULL,
    Document VARCHAR(255) NOT NULL,
    HOD_user_id VARCHAR(10) NOT NULL,
    MeetingId VARCHAR(10) NOT NULL UNIQUE,

    CONSTRAINT fk_Agenda_HOD
        FOREIGN KEY (HOD_user_id)
        REFERENCES hod (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_Agenda_Meeting
        FOREIGN KEY (MeetingId)
        REFERENCES meeting (MeetingId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS confirm (
    UserId VARCHAR(10) NOT NULL,
    MeetingId VARCHAR(10) NOT NULL,
    Status VARCHAR(20) NOT NULL,

    PRIMARY KEY (UserId, MeetingId),

    CONSTRAINT chk_Confirm_Status
        CHECK (Status IN ('Confirmed', 'Pending')),

    CONSTRAINT fk_Confirm_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_Confirm_Meeting
        FOREIGN KEY (MeetingId)
        REFERENCES meeting (MeetingId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS participate (
    UserId VARCHAR(10) NOT NULL,
    MeetingId VARCHAR(10) NOT NULL,

    PRIMARY KEY (UserId, MeetingId),

    CONSTRAINT fk_Participate_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_Participate_Meeting
        FOREIGN KEY (MeetingId)
        REFERENCES meeting (MeetingId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


CREATE TABLE IF NOT EXISTS userlogin (
    UserId VARCHAR(10) PRIMARY KEY,
    PasswordHash VARCHAR(255) NOT NULL,
    MustChangePassword TINYINT(1) NOT NULL DEFAULT 0,

    CONSTRAINT fk_UserLogin_User
        FOREIGN KEY (UserId)
        REFERENCES `user` (UserId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;


INSERT INTO `user`
    (UserId, Role, Name, ContactNumber, Email)
VALUES
    ('U001', 'Student Representative', 'Amal Perera',
     '0712345678', 'amal.perera@gmail.com'),

    ('U002', 'Student Representative', 'Nimal Silva',
     '0723456789', 'nimal.silva@gmail.com'),

    ('U003', 'Temporary Lecturer', 'Sara Fernando',
     '0774567890', 'sara.fernando@gmail.com'),

    ('U004', 'Permanent Lecturer', 'Kamal Perera',
     '0765678901', 'kamal.perera@gmail.com'),

    ('U005', 'Permanent Lecturer', 'Nithya Sudhar',
     '0756789012', 'nithya.sudhar@gmail.com'),

    ('U006', 'Temporary Lecturer', 'Ravi Kumar',
     '0747890123', 'ravi.kumar@gmail.com'),

    ('U007', 'Student Representative', 'Ayesha Khan',
     '0788901234', 'ayesha.khan@gmail.com');


INSERT INTO student_representative
    (UserId, AcademicYear, RegNo)
VALUES
    ('U001', 3, 'ICT/2022/001'),
    ('U002', 1, 'ICT/2024/056'),
    ('U007', 2, 'ICT/2023/098');


INSERT INTO temporary_lecturer
    (UserId, TemporaryEmployeId, ContractStartDate, ContractEndDate)
VALUES
    ('U003', 'T101', '2026-01-01', '2026-12-31'),
    ('U006', 'T102', '2026-01-01', '2026-01-31');


INSERT INTO permanent_lecturer
    (UserId, PermanentEmployeeId, Designation)
VALUES
    ('U004', 'P201', 'Senior Lecturer'),
    ('U005', 'P202', 'Lecturer');


INSERT INTO hod
    (UserId, AppoinmentStartDate, AppoinmentEndDate)
VALUES
    ('U004', '2025-01-01', '2026-12-31');


INSERT INTO meeting
    (MeetingId, MeetingName, MeetingDate, MeetingTime,
     MeetingVenue, Recording, HOD_user_id)
VALUES
    ('M001', 'Curriculum Review', '2026-10-25',
     '09:00:00', 'Hall A', 'rec001.mp4', 'U004'),

    ('M002', 'Project Discussion', '2026-10-28',
     '10:00:00', 'Lab 01', 'rec002.mp4', 'U004'),

    ('M003', 'Department Planning', '2026-11-02',
     '14:00:00', 'Hall B', 'rec003.mp4', 'U004');


INSERT INTO meeting_decision
    (MeetingId, decision)
VALUES
    ('M001', 'Update the curriculum'),
    ('M001', 'Introduce a practical session'),
    ('M002', 'Approve project topics'),
    ('M002', 'Arrange demonstrations'),
    ('M003', 'Review the annual budget'),
    ('M003', 'Discuss staff requirements');


INSERT INTO agenda
    (AgendaId, AgendaTitle, Document, HOD_user_id, MeetingId)
VALUES
    ('A001', 'Curriculum Changes',
     'curriculum.pdf', 'U004', 'M001'),

    ('A002', 'Project Topics',
     'projects.pdf', 'U004', 'M002'),

    ('A003', 'Annual Budget',
     'budget.pdf', 'U004', 'M003');


INSERT INTO confirm
    (UserId, MeetingId, Status)
VALUES
    ('U001', 'M001', 'Confirmed'),
    ('U002', 'M001', 'Pending'),
    ('U003', 'M001', 'Confirmed'),
    ('U001', 'M002', 'Confirmed'),
    ('U005', 'M002', 'Confirmed'),
    ('U006', 'M003', 'Pending');


INSERT INTO participate
    (UserId, MeetingId)
VALUES
    ('U001', 'M001'),
    ('U003', 'M001'),
    ('U004', 'M001'),
    ('U002', 'M002'),
    ('U004', 'M002'),
    ('U005', 'M002'),
    ('U006', 'M003');


CREATE INDEX idx_meeting_date
ON meeting (MeetingDate);


CREATE INDEX idx_user_role
ON `user` (Role);


SHOW TABLES;


DESCRIBE `user`;


DESCRIBE userlogin;


SELECT *
FROM `user`;


SELECT *
FROM student_representative;


SELECT *
FROM temporary_lecturer;


SELECT *
FROM permanent_lecturer;


SELECT *
FROM hod;


SELECT *
FROM meeting;


SELECT *
FROM meeting_decision;


SELECT *
FROM agenda;


SELECT *
FROM confirm;


SELECT *
FROM participate;


SELECT
    'User' AS TableName,
    COUNT(*) AS TotalRows
FROM `user`

UNION ALL

SELECT 'Student_representative', COUNT(*)
FROM student_representative

UNION ALL

SELECT 'Temporary_lecturer', COUNT(*)
FROM temporary_lecturer

UNION ALL

SELECT 'Permanent_lecturer', COUNT(*)
FROM permanent_lecturer

UNION ALL

SELECT 'HOD', COUNT(*)
FROM hod

UNION ALL

SELECT 'Meeting', COUNT(*)
FROM meeting

UNION ALL

SELECT 'Meeting_Decision', COUNT(*)
FROM meeting_decision

UNION ALL

SELECT 'Agenda', COUNT(*)
FROM agenda

UNION ALL

SELECT 'Confirm', COUNT(*)
FROM confirm

UNION ALL

SELECT 'Participate', COUNT(*)
FROM participate

UNION ALL

SELECT 'UserLogin', COUNT(*)
FROM userlogin;


SELECT
    m.MeetingId,
    m.MeetingName,
    m.HOD_user_id,
    h.UserId AS HOD_UserId,
    u.Name AS HOD_Name
FROM meeting AS m
JOIN hod AS h
    ON m.HOD_user_id = h.UserId
JOIN `user` AS u
    ON h.UserId = u.UserId;


SELECT
    c.UserId,
    u.Name AS UserName,
    c.MeetingId,
    m.MeetingName,
    c.Status
FROM confirm AS c
JOIN `user` AS u
    ON c.UserId = u.UserId
JOIN meeting AS m
    ON c.MeetingId = m.MeetingId
ORDER BY c.MeetingId, c.UserId;


SELECT
    a.AgendaId,
    a.AgendaTitle,
    a.Document,
    a.MeetingId,
    m.MeetingName,
    a.HOD_user_id,
    u.Name AS HOD_Name
FROM agenda AS a
JOIN meeting AS m
    ON a.MeetingId = m.MeetingId
JOIN hod AS h
    ON a.HOD_user_id = h.UserId
JOIN `user` AS u
    ON h.UserId = u.UserId
ORDER BY a.AgendaId;


SELECT
    p.UserId,
    u.Name AS UserName,
    p.MeetingId,
    m.MeetingName
FROM participate AS p
JOIN `user` AS u
    ON p.UserId = u.UserId
JOIN meeting AS m
    ON p.MeetingId = m.MeetingId
ORDER BY p.MeetingId, p.UserId;


SELECT
    u.UserId,
    u.Name,
    u.Role
FROM `user` AS u
LEFT JOIN student_representative AS sr
    ON u.UserId = sr.UserId
LEFT JOIN temporary_lecturer AS tl
    ON u.UserId = tl.UserId
LEFT JOIN permanent_lecturer AS pl
    ON u.UserId = pl.UserId
WHERE sr.UserId IS NULL
  AND tl.UserId IS NULL
  AND pl.UserId IS NULL;


SELECT
    h.UserId
FROM hod AS h
LEFT JOIN permanent_lecturer AS pl
    ON h.UserId = pl.UserId
WHERE pl.UserId IS NULL;


SELECT
    m.MeetingId,
    m.MeetingName
FROM meeting AS m
LEFT JOIN agenda AS a
    ON m.MeetingId = a.MeetingId
WHERE a.AgendaId IS NULL;


SELECT
    h.UserId
FROM hod AS h
LEFT JOIN agenda AS a
    ON h.UserId = a.HOD_user_id
WHERE a.AgendaId IS NULL;


SELECT
    u.UserId,
    u.Name,
    u.Role,
    u.Email,
    u.ContactNumber
FROM `user` AS u
ORDER BY u.UserId;


SELECT
    m.MeetingId,
    m.MeetingName,
    m.MeetingDate,
    m.MeetingTime,
    m.MeetingVenue,
    m.Recording,
    u.Name AS HOD_Name
FROM meeting AS m
JOIN `user` AS u
    ON m.HOD_user_id = u.UserId
ORDER BY m.MeetingDate DESC, m.MeetingTime DESC;


SELECT
    u.UserId,
    u.Name,
    u.Role,
    u.Email,
    u.ContactNumber,
    CASE
        WHEN h.UserId IS NOT NULL THEN 1
        ELSE 0
    END AS IsHOD
FROM `user` AS u
LEFT JOIN hod AS h
    ON u.UserId = h.UserId
ORDER BY u.UserId;


SELECT
    UserId,
    PasswordHash,
    MustChangePassword
FROM userlogin;


SELECT
    UserId,
    Name,
    Email
FROM `user`;


SHOW INDEX FROM meeting;


SHOW INDEX FROM `user`;