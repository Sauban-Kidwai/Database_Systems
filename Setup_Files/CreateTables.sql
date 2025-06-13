-- Name: Sauban Kidwai
-- StudentID: 20748199


-- Initial Setup

-- The Following Commands will create the Database in MySQL

SHOW DATABASES;

CREATE DATABASE FIFA_World_Cup_20748199;

USE FIFA_World_Cup_20748199;

-- Now that the Database is created, the following Tables will be created

-- Create Team Table

-- Create Team Table
CREATE TABLE Team (
    Team_ID INT PRIMARY KEY,
    Team_Name VARCHAR(255) NOT NULL
);

-- Create Manager Table
CREATE TABLE Manager (
    Manager_ID INT PRIMARY KEY,
    Manager_Name VARCHAR(255) NOT NULL
);


-- Create Referee Table
CREATE TABLE Referee (
	Referee_ID INT PRIMARY KEY,
	Referee_Name VARCHAR(255) NOT NULL
);



-- Create Game Table
CREATE TABLE Game (
    Match_ID INT PRIMARY KEY,
    Home_Team_ID INT NOT NULL,
    Away_Team_ID INT NOT NULL,
    Home_Manager_ID INT NOT NULL,
    Away_Manager_ID INT NOT NULL,
    Venue VARCHAR(255) NOT NULL,
    Game_Round VARCHAR(255) NOT NULL,
    `Date` DATE NOT NULL,
    Referee_ID INT NOT NULL,
    Attendance INT NOT NULL,
    FOREIGN KEY (Home_Team_ID) REFERENCES Team (Team_ID),
    FOREIGN KEY (Away_Team_ID) REFERENCES Team (Team_ID),
    FOREIGN KEY (Home_Manager_ID) REFERENCES Manager (Manager_ID),
    FOREIGN KEY (Away_Manager_ID) REFERENCES Manager (Manager_ID),
    FOREIGN KEY (Referee_ID) REFERENCES Referee (Referee_ID)
);

-- Create Goal Table
CREATE TABLE Goal (
    Goal_ID INT PRIMARY KEY,
    Match_ID INT NOT NULL,
    Scorer VARCHAR(255) NOT NULL,
    Assist VARCHAR(255),
    `Minute` INT NOT NULL,
    Country_ID INT NOT NULL,
    Goal_Type VARCHAR(255),
    FOREIGN KEY (Match_ID) REFERENCES Game (Match_ID),
    FOREIGN KEY (Country_ID) REFERENCES Team (Team_ID)
);

-- Create Card Table
CREATE TABLE Card (
    Card_ID INT PRIMARY KEY,
    Match_ID INT NOT NULL,
    Player VARCHAR(255) NOT NULL,
    Card_Type VARCHAR(255) NOT NULL,
    Country_ID INT NOT NULL,
    FOREIGN KEY (Country_ID) REFERENCES Team (Team_ID),
    FOREIGN KEY (Match_ID) REFERENCES Game (Match_ID)
);


-- Now the tables are created, the following commands will show the Description of each table


SHOW TABLES;

DESC Team;
DESC Manager;
DESC Referee;
DESC Game;
DESC Goal;
DESC Card;

















