#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  # Display a message if one is passed as an argument (for error handling)
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  # Get available services from the database
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

  # Display the list of services
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
    echo "$SERVICE_ID) $NAME"
  done

  # Get user's service selection
  read SERVICE_ID_SELECTED

  # If input is not a numer, restart the menu with an error message
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
  then
    MAIN_MENU "I could not find that service. What would you like today?"
  else
    # Check if the service exists in the database
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    
    # If service doesn't exist, restart the menu
    if [[ -z $SERVICE_NAME ]]
    then
      MAIN_MENU "I could not find that service. What would you like today?"
    else
      # Service exists! Move to the next step
      GET_CUSTOMER_INFO "$SERVICE_ID_SELECTED" "$SERVICE_NAME"
    fi
  fi

}

GET_CUSTOMER_INFO(){
  # Get Customer number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # If Phone number doesn't exist
  if [[ -z $CUSTOMER_ID ]]
  then
    # Get Customer Name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # Insert new customer info
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # Get customer_id for the appointment
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # Proceed to reservation with all necessary data
  TIME_RESERVATION "$SERVICE_ID_SELECTED" "$SERVICE_NAME" "$CUSTOMER_ID" "$CUSTOMER_NAME"

}

TIME_RESERVATION(){
  SERVICE_ID=$1
  SERVICE_NAME=$(echo $2 | sed -E 's/^ *| *$//g') # Trim spaces
  CUSTOMER_ID=$3
  CUSTOMER_NAME=$(echo $4 | sed -E 's/^ *| *$//g') # Trim spaces

  echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME

  # Insert new appointment
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

  # Final message and exit
  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

}

MAIN_MENU
