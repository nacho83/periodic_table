#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --tuples-only -c"

if [[ -z $1 ]]; then
  echo -e "Please provide an element as an argument."
  exit
fi

#if ARGUMENT is atomic number
if [[ $1 =~ ^[1-9]+$ ]]; then
  ELEMENT=$($PSQL "select elements.atomic_number, elements.name, elements.symbol, properties.type_changed, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius from elements inner join properties on elements.atomic_number=properties.atomic_number where elements.atomic_number = '$1'")
else
  #if ARGUMENT is string
  ELEMENT=$($PSQL "select elements.atomic_number, elements.name, elements.symbol, properties.type_changed, properties.atomic_mass, properties.melting_point_celsius, properties.boiling_point_celsius from elements inner join properties on elements.atomic_number=properties.atomic_number where elements.name = '$1' or elements.symbol='$1'")
fi

#not in database
if [[ -z $ELEMENT ]]; then
  echo -e "I could not find that element in the database."
  exit
fi

# Iterate over the result rows and print information
echo $ELEMENT | while IFS=" |" read atomic_num name symbol type atomic_mass melting_point boiling_point 
  do
    echo -e "The element with atomic number $atomic_num is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
  done
