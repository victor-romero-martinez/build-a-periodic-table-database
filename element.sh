#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

USER_INPUT=$1

# if empty the user input
if [[ -z $USER_INPUT ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# check if a positive number
if [[ ! $USER_INPUT =~ ^[0-9]+$ ]];then
  RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE (name = '$1') OR (symbol = '$1')")
else
  RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) where atomic_number = $1")
fi

# if not result
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
  exit 0
fi

# display result
echo "$RESULT" |while IFS='|' read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE;do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
done
