#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo $($PSQL "SELECT SUM(opponent_goals + winner_goals) from games";)

echo -e "\nAverage number of goals in all games from the winning teams:"
echo  $($PSQL "SELECT AVG(WINNER_GOALS) FROM games;")

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo  $($PSQL "SELECT Round(AVG(winner_goals),2) FROM games;" )

echo -e "\nAverage number of goals in all games from both teams:"
echo  $($PSQL "SELECT AVG(opponent_goals+winner_goals) from games;")

echo -e "\nMost goals scored in a single game by one team:"
echo  $($PSQL "select max(winner_goals) from games;")

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo  $($PSQL "SELECT count(*) from games where winner_goals  > 2;" )

echo -e "\nWinner of the 2018 tournament team name:"
echo  $($PSQL "SELECT name from games left join teams on team_id=winner_id where year=2018 and round='Final'")

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
echo  $($PSQL "SELECT distinct(name) from teams left join games gw on team_id=winner_id left join games go on team_id=go.opponent_id where (go.year=2014 or gw.year =2014 )and (go.round='Eighth-Final' or gw.round='Eighth-Final') order by name")

echo -e "\nList of unique winning team names in the whole data set:"
echo  $($PSQL "SELECT distinct(name) from games left join teams on games.winner_id=team_id order by name;")

echo -e "\nYear and team name of all the champions:"
echo  $($PSQL "SELECT year,name from games left join teams on winner_id=team_id where round='Final' order by year;")

echo -e "\nList of teams that start with 'Co':"
echo  $($PSQL "SELECT * from teams where name LIKE 'Co%' ")