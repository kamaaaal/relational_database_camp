#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"
echo -e "\nWelcome to My Salon, how can I help you?"

SERVICE_MENU() {

  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi 

  SERVICES=$($PSQL "SELECT service_id,name from services;");

  echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME
  do 
    echo "$SERVICE_ID) $SERVICE_NAME"
  done 

  read SERVICE_ID_SELECTED


  
  if [[  ( $SERVICE_ID_SELECTED =~ ^[0-9]$ ) ]]
  then 
    SELECTED_SERVICE_NAME=$($PSQL "SELECT name from services where service_id=$SERVICE_ID_SELECTED")
    if [[ ( -z $SELECTED_SERVICE_NAME ) ]]
    then
      SERVICE_MENU  "I could not find that service. What would you like today?"
    else 

    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name from CUSTOMERS WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then 
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME   
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id from CUSTOMERS WHERE phone='$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your $(echo $SELECTED_SERVICE_NAME | sed 's/^ *| *$//g'), $CUSTOMER_NAME"
    read SERVICE_TIME

    # echo "values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')"
    INSERT_APPOINTMENT_RESULTS=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME');")

    echo -e "\nI have put you down for a$SELECTED_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

    fi
    else 
      SERVICE_MENU "I could not find that service. What would you like today?" 
  fi
  

}


SERVICE_MENU