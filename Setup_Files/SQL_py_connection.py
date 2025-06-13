import mysql.connector


config = {
    'user': 'me',
    'password': 'myUserPassword',
    'host': 'localhost',
    'database': 'FIFA_World_Cup_20748199'
}

# Create a connection to the database
connection = mysql.connector.connect(**config)

cursor = connection.cursor()


# Query One: How many games were played in Sydney In total?

q1_Query = "SELECT COUNT(*) AS Games_Played_In_Sydney FROM Game WHERE Venue LIKE '%Sydney';"

cursor.execute(q1_Query)
q1_Query_result = cursor.fetchall()
for row in q1_Query_result:
    print(row)



#Question 2 - What was the total Attendance accross the Whole Tournament?

q2_Query = "SELECT SUM(Attendance) AS Total_Attendance FROM Game;"
cursor.execute(q2_Query)
q2_Query_result = cursor.fetchall()
for row in q2_Query_result:
    print(row)


# List of values for insertion into the Game table
game_values = [
    (65, 1, 2, 1, 2, 'Accor Stadium, Sydney', 'Group Stage', '2023-06-20', 1, 71123),
    (66, 3, 4, 3, 4, 'Suncorp Stadium, Brisbane', 'Group Stage', '2023-06-19', 2, 53461),
    (67, 4, 2, 4, 2, 'Accor Stadium, Sydney', 'Group Stage', '2023-06-16', 1, 75284)
]

# List of values for insertion into the Goal table
goal_values = [
    (193, 64, 'Steph Catley', 'NONE', 52, 4, 'Own Goal'),
    (194, 63, 'Hannah Wilkinson', 'Jaqui Hand', 48, 31, 'Penalty'),
    (195, 62, 'Valeria de Campo', 'NONE', 21, 27, 'Normal')
]

try:

    # SQL INSERT statement for the Game table
    game_insert_statement = "INSERT INTO Game (Match_ID, Home_Team_ID, Away_Team_ID, Home_Manager_ID, " \
                            "Away_Manager_ID, Venue, Game_Round, `Date`, Referee_ID, Attendance) " \
                            "VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"

    # SQL INSERT statement for the Goal table
    goal_insert_statement = "INSERT INTO Goal (Goal_ID, Match_ID, Scorer, Assist, `Minute`, Country_ID, Goal_Type) " \
                            "VALUES (%s, %s, %s, %s, %s, %s, %s)"

    # Insert rows into the Game table
    cursor.executemany(game_insert_statement, game_values)

    # Insert rows into the Goal table
    cursor.executemany(goal_insert_statement, goal_values)

    # Commit the changes to the database
    connection.commit()
    print("Insertion successful")

    # View the last 5 rows of the Game table
    cursor.execute("SELECT * FROM Game ORDER BY Match_ID DESC LIMIT 5")
    last_game_rows = cursor.fetchall()
    print("Last 5 rows of Game table:")
    for row in last_game_rows:
        print(row)

    # View the last 5 rows of the Goal table
    cursor.execute("SELECT * FROM Goal ORDER BY Goal_ID DESC LIMIT 5")
    last_goal_rows = cursor.fetchall()
    print("\nLast 5 rows of Goal table:")
    for row in last_goal_rows:
        print(row)

    # Modify one row in the Game table
    cursor.execute("UPDATE Game SET Venue = 'New Venue' WHERE Match_ID = 68")
    connection.commit()

    # Delete one row in the Goal table
    cursor.execute("DELETE FROM Goal WHERE Goal_ID = 195")
    connection.commit()

    # View the last 5 rows of the Goal table after the deletion
    cursor.execute("SELECT * FROM Goal ORDER BY Goal_ID DESC LIMIT 5")
    last_goal_rows = cursor.fetchall()
    print("\nLast 5 rows of Goal table after deletion:")
    for row in last_goal_rows:
        print(row)

except mysql.connector.Error as err:
    print(f"Error: {err}")
finally:
    if connection.is_connected():
        cursor.close()
        connection.close()

