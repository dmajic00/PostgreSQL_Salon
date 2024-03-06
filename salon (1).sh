#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"
MAIN_MENU(){
  #get available services
  AVAILABLE_SERVICES=$($PSQL "select service_id, name from services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
  do
   echo "$SERVICE_ID) $NAME"
  done
read SERVICE_ID_SELECTED
#if input is not a  number
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
#send to main menu
echo -e "\nI could not find that service, how can I help you?"
MAIN_MENU 
#if input is not valid number in services
else
SERVICE_AVAILABLE=$($PSQL "select service_id from services where service_id='$SERVICE_ID_SELECTED'")
if [[ -z $SERVICE_AVAILABLE ]]
then
echo -e "\nI could not find that service, how can I help you?"
MAIN_MENU 
else
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE' ")
#if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
  #get new customer name
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  #insert new customer
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME"
  read SERVICE_TIME
  #CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'" )
  #=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME') ")
  echo -e "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  else
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME"
  read SERVICE_TIME
  #CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" )
  #INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME') ")
  echo -e "I have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'" )
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) values ('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME') ")
fi
fi
}
MAIN_MENU

