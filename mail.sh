#!/bin/bash

TO_TEAM=$1
ALERT_TYPE=$2
BODY=$3
ESCAPE_BODY=$(printf '%s\n' "$BODY" | sed -e 's/[]\/$*.^[]/\\&/g');
TO_ADDRESS=$4
SUBJECT=$5

FINAL_BODY=$(sed -e "s/TO_TEAM/$TO_TEAM/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" -e "s/BODY/$ESCAPE_BODY/g" template.html)

{
  echo "To: $TO_ADDRESS"
  echo "Subject: $SUBJECT"
  echo "MIME-Version: 1.0"
  echo "Content-Type: text/html; charset=UTF-8"
  echo "Content-Transfer-Encoding: 8bit"
  echo
  echo "$FINAL_BODY"
} | msmtp "$TO_ADDRESS"