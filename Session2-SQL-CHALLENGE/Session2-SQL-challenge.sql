use master
create database session2
go
use session2
go
-- Create the runner table
CREATE TABLE runner (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    main_distance INT NOT NULL,
    age INT NOT NULL,
    is_female BIT NOT NULL
);

-- Create the event table
CREATE TABLE event (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    city VARCHAR(100) NOT NULL
);

-- Create the runner_event table
CREATE TABLE runner_event (
    runner_id INT NOT NULL,
    event_id INT NOT NULL,
    PRIMARY KEY (runner_id, event_id),
    FOREIGN KEY (runner_id) REFERENCES runner(id),
    FOREIGN KEY (event_id) REFERENCES event(id)
);

-- Insert data into the runner table
INSERT INTO runner (name, main_distance, age, is_female) VALUES 
('John Doe', 10000, 30, 0),
('Jane Smith', 5000, 25, 1),
('Emily Johnson', 1500, 22, 1),
('Michael Brown', 5000, 35, 0),
('Sarah Davis', 10000, 28, 1);

-- Insert data into the event table
INSERT INTO event (name, start_date, city) VALUES 
('London Marathon', '2024-04-21', 'London'),
('Warsaw Runs', '2024-05-15', 'Warsaw'),
('New Year Run', '2024-01-01', 'New York'),
('Spring Challenge', '2024-03-20', 'Paris'),
('Summer Sprint', '2024-07-10', 'Tokyo');

-- Insert data into the runner_event table
INSERT INTO runner_event (runner_id, event_id) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(1, 2),
(2, 3),
(3, 4),
(4, 5),
(5, 1);




--2. Organize Runners Into Groups
--Select the main distance and the number of runners that run the given distance (runners_number). Display only those rows where the number of runners is greater than 3.

select* from runner

SELECT COUNT(*) AS count_than3
FROM runner
WHERE main_distance > 3000;


--3.How Many Runners Participate in Each Event
--Display the event name and the number of club members that take part in this event (call this column runner_count). Note that there may be events in which no club 
--members participate. For these events, the runner_count should equal 0.

SELECT 
    e.name AS event_name, 
    COUNT(re.runner_id) AS runner_count
FROM 
    event e
LEFT JOIN 
    runner_event re ON e.id = re.event_id
GROUP BY 
    e.name;


	--4.Group Runners by Main Distance and Age
--Display the distance and the number of runners there are for the following age categories: under 20, 20–29, 30–39, 40–49, and over 50. 
--Use the following column aliases: under_20, age_20_29, age_30_39, age_40_49, and over_50.

SELECT 
    main_distance,
    SUM(CASE WHEN age < 20 THEN 1 ELSE 0 END) AS under_20,
    SUM(CASE WHEN age BETWEEN 20 AND 29 THEN 1 ELSE 0 END) AS age_20_29,
    SUM(CASE WHEN age BETWEEN 30 AND 39 THEN 1 ELSE 0 END) AS age_30_39,
    SUM(CASE WHEN age BETWEEN 40 AND 49 THEN 1 ELSE 0 END) AS age_40_49,
    SUM(CASE WHEN age >= 50 THEN 1 ELSE 0 END) AS over_50
FROM 
    runner
GROUP BY 
    main_distance;

