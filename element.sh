#!/bin/bash

# Define our database querying variable
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# 1. Check if the user provided an argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # 2. Figure out if the input is a number (atomic_number) or text (symbol/name)
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # It's a number
    CONDITION="atomic_number = $1"
  else
    # It's text (symbol or name)
    CONDITION="symbol = '$1' OR name = '$1'"
  fi

  # 3. Query the database, joining all three tables to get all the data at once
  ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE $CONDITION")

  # 4. Check if we found a match
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
    # 5. Split the data by the pipe '|' character and print the final sentence
    echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE MASS MELTING BOILING
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
    done
  fi
fi
# Trigger commit check
# Final submission check
