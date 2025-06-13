-- Name: Sauban Kidwai
-- StudentID: 20748199


-- This file contains the SQL Queries for this Assignment:



-- Question 1 - How many Games were played in Sydney?

SELECT COUNT(*) AS Games_Played_In_Sydney
FROM Game
WHERE Venue LIKE '%Sydney';


-- Question 2 - What was the total Attendance accross the Whole Tournament?

SELECT SUM(Attendance) AS Total_Attendance
FROM Game;


-- Question 3 - How many goals were there in total and what was the contribution of Penaltiesand own goals in the total?

SELECT
    (SELECT COUNT(*) FROM Goal) AS Total_Goals,
    (SELECT COUNT(*) FROM Goal WHERE Goal_Type = 'Penalty') AS Penalties,
    (SELECT COUNT(*) FROM Goal WHERE Goal_Type = 'Own Goal') AS Own_Goals;



-- Question 4 - Who were the top 5 Goal Scorers and display their goal tally

SELECT Scorer AS Player_Name, COUNT(Goal_ID) AS Goals_Scored
FROM Goal
GROUP BY Scorer
ORDER BY Goals_Scored DESC
LIMIT 5;

-- Question 5 - Calculate the Average Attendance for the Tournament

SELECT AVG(Attendance) AS AvgAttendance
FROM Game;

-- Question 6 - Retrieve the matches and their referees where the same referee officiated more than one match

SELECT R.Referee_ID, R.Referee_Name, GROUP_CONCAT(DISTINCT G.Match_ID ORDER BY G.Match_ID ASC) AS Matches
FROM Game AS G
JOIN Referee AS R ON G.Referee_ID = R.Referee_ID
GROUP BY R.Referee_ID
HAVING COUNT(G.Match_ID) > 1;



-- Question 7 - Display the amount of Yellow Cards and Red Cards given to each team in the tournament

SELECT
    T.Team_Name,
    SUM(CASE WHEN C.Card_Type = 'Yellow' THEN 1 ELSE 0 END) AS Yellow_Cards,
    SUM(CASE WHEN C.Card_Type = 'Red' THEN 1 ELSE 0 END) AS Red_Cards
FROM Team T
LEFT JOIN Goal G ON T.Team_ID = G.Country_ID
LEFT JOIN Card C ON G.Match_ID = C.Match_ID
GROUP BY T.Team_Name;


-- Question 8 - Display the Percentage of games played in each city accross the competition

SELECT
    Venue,
    COUNT(Game.Match_ID) AS Games_Played,
    COUNT(Game.Match_ID) / (SELECT COUNT(Match_ID) FROM Game) * 100 AS Percentage
FROM Game
GROUP BY Venue;


-- Question 9 - Find the matches in which the total number of goals (home team goals + away team goals) exceeded 5.

SELECT G.Match_ID, Home.Team_Name AS Home_Team, Away.Team_Name AS Away_Team, TotalGoals.TotalGoals AS Total_Goals
FROM Game AS G
JOIN Team AS Home ON G.Home_Team_ID = Home.Team_ID
JOIN Team AS Away ON G.Away_Team_ID = Away.Team_ID
JOIN (
    SELECT Goal.Match_ID, COUNT(*) AS TotalGoals
    FROM Goal
    GROUP BY Goal.Match_ID
    HAVING TotalGoals > 5
) AS TotalGoals ON G.Match_ID = TotalGoals.Match_ID;

-- Question 10 - List the teams that received the most yellow cards in the group stage matches.


SELECT T.Team_Name, 
       SUM(CASE WHEN C.Card_Type = 'Yellow' THEN 1 ELSE 0 END) AS Yellow_Cards
FROM Team AS T
JOIN Game AS G ON T.Team_ID = G.Home_Team_ID OR T.Team_ID = G.Away_Team_ID
JOIN Card AS C ON G.Match_ID = C.Match_ID
WHERE G.Game_Round = 'Group Stage'
GROUP BY T.Team_Name
ORDER BY Yellow_Cards DESC;



-- Question 11 - Who were the top 5 Assisters in this competition?

SELECT
    Goal.Assist AS Assister,
    COUNT(Goal.Goal_ID) AS Assists
FROM Goal
WHERE Goal.Assist IS NOT NULL AND Goal.Assist != 'NONE'
GROUP BY Goal.Assist
ORDER BY Assists DESC
LIMIT 5;






