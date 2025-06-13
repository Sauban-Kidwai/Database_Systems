-- Name: Sauban Kidwai
-- StudentID: 20748199

-- An example of a Stored Procedure

-- Calculate Match Stats for a Team: 

-- Create a stored procedure that takes a Team_ID and calculates various statistics for that team, such as the number of matches played, goals scored, and yellow/red cards received.

DELIMITER //
CREATE PROCEDURE CalculateTeamStats(IN teamID INT)
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE matchID INT;
    DECLARE goalsScored INT;
    DECLARE yellowCards INT;
    DECLARE redCards INT;

    -- Declare a cursor for iterating over matches
    DECLARE cur CURSOR FOR 
        SELECT Match_ID FROM Game WHERE Home_Team_ID = teamID OR Away_Team_ID = teamID;
    
    -- Declare a continue handler to exit the loop when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    -- Start the loop
    read_loop: LOOP
        FETCH cur INTO matchID;

        -- Exit the loop if no more rows are found
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Calculate goals scored by the team
        SELECT COUNT(Goal_ID) INTO goalsScored FROM Goal WHERE Match_ID = matchID AND Country_ID = teamID;

        -- Calculate yellow cards received by the team
        SELECT COUNT(Card_ID) INTO yellowCards FROM Card WHERE Match_ID = matchID AND Country_ID = teamID AND Card_Type = 'Yellow';

        -- Calculate red cards received by the team
        SELECT COUNT(Card_ID) INTO redCards FROM Card WHERE Match_ID = matchID AND Country_ID = teamID AND Card_Type = 'Red';

        -- Perform any other actions with the calculated data here

    END LOOP;

    CLOSE cur;

    -- Output or store the aggregated statistics for the team
    SELECT goalsScored AS GoalsScored, yellowCards AS YellowCards, redCards AS RedCards;

END //
DELIMITER ;


-- Can call the above procedure by passing the Team ID
CALL CalculateTeamStats(2);


-- Another Stored Procedure Implemented
-- This stored Procedure will retrieve the total goals scored by a specific team in the tournament.
-- It can be called by passing a team name as a parameter to get the total goals scored by that team


DELIMITER //

CREATE PROCEDURE GetTotalGoalsByTeam(IN teamName VARCHAR(255), OUT outTotalGoals INT)
BEGIN
    SELECT COUNT(Goal.Goal_ID) INTO outTotalGoals
    FROM Goal
    LEFT JOIN Team ON Goal.Country_ID = Team.Team_ID
    WHERE Team.Team_Name = teamName;
END //

DELIMITER ;

-- Call it:
SET @totalGoals = 0;
CALL GetTotalGoalsByTeam('England', @totalGoals);
SELECT @totalGoals;


-- The Third Stored Procedure chosen to Implement
-- This stored procedure retrieves the number of yellow cards received by a specific player.


DELIMITER //
CREATE PROCEDURE GetYellowCardsByPlayer(IN playerName VARCHAR(255))
BEGIN
    SELECT Goal.Scorer AS Player_Name, COUNT(Card.Card_ID) AS YellowCards
    FROM Goal
    LEFT JOIN Card ON Goal.Scorer = Card.Player
    WHERE Goal.Scorer = playerName AND Card.Card_Type = 'Yellow'
    GROUP BY Goal.Scorer;
END //
DELIMITER ;

-- call this stored procedure by passing the player's name as a parameter to get the number of yellow cards received by that player.
CALL GetYellowCardsByPlayer('Olga Carmona');






-- Trigger 1 -> 

-- Auto-Incrementing Match IDs
-- Essentialy this trigger can be used to automatically generate and assign unique Match IDs when new matches are inserted into the Game table. It ensures that each match has a unique identifier without the need for manual assignment.

DELIMITER //
CREATE TRIGGER AutoIncrementMatchID
BEFORE INSERT ON Game
FOR EACH ROW
BEGIN
    DECLARE newMatchID INT;
    SET newMatchID = (SELECT MAX(Match_ID) + 1 FROM Game);
    IF newMatchID IS NULL THEN
        SET newMatchID = 1;
    END IF;
    SET NEW.Match_ID = newMatchID;
END;
//
DELIMITER ;



-- Now to test this works, insert a new row into game without specifying match id so that the trigger auto assigns it. Before testing this there are 64 games

-- Example INSERT statement that will trigger the AutoIncrementMatchID trigger
INSERT INTO Game (Home_Team_ID, Away_Team_ID, Home_Manager_ID, Away_MAnager_ID, Venue, Game_Round, `Date`, Referee_ID, Attendance)
VALUES (1, 2, 1, 2, 'Optus Stadium', 'Group Stage', '2023-10-12', 1, 50000);


-- VIEW

-- This view is there to show a summary of the game.


CREATE VIEW MatchGoalsSummary AS
SELECT
    G.Match_ID,
    G.`Date`,
    Home.Team_Name AS Home_Team,
    Away.Team_Name AS Away_Team,
    COUNT(Goal.Scorer) AS Home_Team_Goals,
    (
        SELECT COUNT(Goal.Scorer)
        FROM Goal
        WHERE G.Match_ID = Goal.Match_ID
        AND Goal.Country_ID = Away.Team_ID
    ) AS Away_Team_Goals
FROM Game G
JOIN Team Home ON G.Home_Team_ID = Home.Team_ID
JOIN Team Away ON G.Away_Team_ID = Away.Team_ID
LEFT JOIN Goal ON G.Match_ID = Goal.Match_ID
GROUP BY G.Match_ID;


-- The following command will show the View:
SELECT * FROM MatchGoalsSummary;

