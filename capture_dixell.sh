#!/bin/bash
# Connect to database de run sql command
PSQL="psql -X --username=monitoruser --dbname=monitor --no-align --tuples-only -c"

# nest variable is used for debug only
#P=0

# run infinite loop may be I need later, the script can be stopped in next loop
while true ; do
  # read some variables from file variable_command, example 'start|5|192.168.1.15'
  # was written with command: echo "start|5|192.168.1.15" > variable_command
  # where with 'stop' word you can stop the script
  # where with 'start' word you can run the script
  # next after first delimiter '|' it's a number for how many seconds to wait,
  # a very small number can flood the device, so for me 10 seconds is ok,
  # next after second delimiter '|' it's ip address for Dixell XWEB300D device
    while IFS="|" read -r RUN TIME IP < /usr/local/etc/variable_command; do
      # check if IP exist in network, if not exist exit from loops and inform
      if ! fping -c1 -t300 "$IP" 2>/dev/null 1>/dev/null; then
          echo "Check where is the problems for route at Dixell XWEB300D - IP $IP"
          break 2
      fi
      # check if PostgreSQL is running, if not run exit from loops and inform
      if ! pgrep -fa -- -D | grep postgres 2>/dev/null 1>/dev/null; then
          echo "Check if PostgreSQL is running"
          break 2
      fi
      # check if word 'stop' is written on file variable_command and exit from the loops
      if [ "$RUN" = 'stop' ]; then
            echo "Word 'stop' was written in the file /usr/local/etc/variable_command"
            break 2
      # but if exist 'start' word in the first line then run command
      elif [ "$RUN" = 'start' ]; then
          # next three lines is used for debug only
          #HOUR=$(date +%H:%M:%S)
          #P=$(("$P"+1))
          #echo "$HOUR" "Loop no. $P"

          # Put current date as dd-mm-YYYY HH:MM:SS in $DATETIME, in sql insert can be used also now() for datetime
          DATETIME=$(date '+%d-%m-%Y %H:%M:%S')
          curl -s -X POST http://"$IP"/cgi-bin/runtime.cgi -H "Content-Type: application/x-www-form-urlencoded" \
          -b "user=Florin" \
          -d "NDVC=8&DEV_0=1|2|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|
          &DEV_1=1|3|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|
          &DEV_2=1|4|2857|3857|4857|8857|9857|18857|19857|20857|21857|24857|25857|17857|1|29857|30857|
          &DEV_3=1|5|2857|3857|4857|5857|6857|20857|29857|32857|23857|1|35857|36857|38857|
          &DEV_4=1|6|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|
          &DEV_5=1|7|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|
          &DEV_6=1|8|2858|3858|4858|5858|6858|20858|29858|32858|23858|1|35858|36858|38858|
          &DEV_7=1|9|2858|3858|4858|8858|9858|18858|19858|20858|21858|24858|25858|17858|1|29858|30858|" | while IFS="|" read -r VAL_1 VAL_2 VAL_3 VAL_4 VAL_5 VAL_6 VAL_7 VAL_8 VAL_9 VAL_10 VAL_11 VAL_12 VAL_13 VAL_14 VAL_15 VAL_16 VAL_17 VAL_18 VAL_19; do
            # First values is address for controller connected at XWeb300D RS485 serial line
                ADDRESS=$VAL_1
                # At address 5, 6, 7 and 8 I have XR60CX controller connected at XWeb300D using RS485 line and I prepare variable for this tables (cc - frost and refrigerator chambers)
                if [ "$ADDRESS" = 5 ] || [ "$ADDRESS" = 6 ] || [ "$ADDRESS" = 7 ] || [ "$ADDRESS" = 8 ]; then
                  # Replace value 0 with FALSE and value 1 with TRUE for better debug and to be sure not using value where is not necessary
                  case $VAL_2 in [1]) CODE_1=TRUE ;; [0]) CODE_1=FALSE ;; esac
                  case $VAL_3 in [1]) CODE_2=TRUE ;; [0]) CODE_2=FALSE ;; esac
                  # Define variables with numbers
                  PROBE_1=$VAL_4
                  PROBE_2=$VAL_5
                  PROBE_3=$VAL_6
                  PROBE_R=$VAL_7
                  SETPOINT_R=$VAL_8
                  SETPOINT=$VAL_9
                  # Replace value 0 with FALSE and value 1 with TRUE for better debug and to be sure not using value where is not necessary
                  case $VAL_10 in [1]) FAN_OUT=TRUE ;; [0]) FAN_OUT=FALSE ;; esac
                  case $VAL_11 in [1]) COMPRESSOR_OUT=TRUE ;; [0]) COMPRESSOR_OUT=FALSE ;; esac
                  case $VAL_12 in [1]) GDI=TRUE ;; [0]) GDI=FALSE ;; esac
                  case $VAL_13 in [1]) ON_STATUS=TRUE ;; [0]) ON_STATUS=FALSE ;; esac
                  case $VAL_14 in [1]) DEFROST_STATUS=TRUE ;; [0]) DEFROST_STATUS=FALSE ;; esac
                  case $VAL_15 in [1]) CODE_8=TRUE ;; [0]) CODE_8=FALSE ;; esac
                  case $VAL_16 in [1]) CODE_9=TRUE ;; [0]) CODE_9=FALSE ;; esac
                  # Define variables with string (this string it's for error codes)
                  CODE_10=$VAL_17
                  # Run sql insert command
                  INSERT_CC_RESULT=$($PSQL "INSERT INTO cc$ADDRESS(datetime,address,code_1,code_2,probe_1,probe_2,probe_3,probe_r,setpoint_r,setpoint,fan_out,compressor_out,gdi,on_status,defrost_status,code_8,code_9,code_10) VALUES('$DATETIME','$ADDRESS','$CODE_1','$CODE_2','$PROBE_1','$PROBE_2','$PROBE_3','$PROBE_R','$SETPOINT_R','$SETPOINT','$FAN_OUT','$COMPRESSOR_OUT','$GDI','$ON_STATUS','$DEFROST_STATUS','$CODE_8','$CODE_9','$CODE_10')")
                  # Print messages for success insert.
                  if [[ $INSERT_CC_RESULT == 'INSERT 0 1' ]]; then
                    echo "Inserted into cc$ADDRESS"
                  fi
                fi
                # At address 2, 3, 4 and 9 I have XH260L controller connected at XWeb300D using RS485 line and I prepare variable for this tables (cr - refrigerators chambers)
                if [ "$ADDRESS" = 2 ] || [ "$ADDRESS" = 3 ] || [ "$ADDRESS" = 4 ] || [ "$ADDRESS" = 9 ]; then
                  # Replace value 0 with FALSE and value 1 with TRUE for better debug and to be sure not using value where is not necessary
                  case $VAL_2 in [1]) CODE_1=TRUE ;; [0]) CODE_1=FALSE ;; esac
                  case $VAL_3 in [1]) CODE_2=TRUE ;; [0]) CODE_2=FALSE ;; esac
                  # Define variables with numbers
                  PROBE_1=$VAL_4
                  PROBE_2=$VAL_5
                  PROBE_3=$VAL_6
                  TEMP_SET=$VAL_7
                  HUMID_SET=$VAL_8
                  # Replace value 0 with FALSE and value 1 with TRUE for better debug and to be sure not using value where is not necessary
                  case $VAL_9 in [1]) COMPRESSOR_OUT=TRUE ;; [0]) COMPRESSOR_OUT=FALSE ;; esac
                  case $VAL_10 in [1]) HEATER_OUT=TRUE ;; [0]) HEATER_OUT=FALSE ;; esac
                  case $VAL_11 in [1]) FAN_OUT=TRUE ;; [0]) FAN_OUT=FALSE ;; esac
                  case $VAL_12 in [1]) HUMIDIFIER_OUT=TRUE ;; [0]) HUMIDIFIER_OUT=FALSE ;; esac
                  case $VAL_13 in [1]) DEFROST_OUT=TRUE ;; [0]) DEFROST_OUT=FALSE ;; esac
                  case $VAL_14 in [1]) LIGHT_OUT=TRUE ;; [0]) LIGHT_OUT=FALSE ;; esac
                  case $VAL_15 in [1]) GDI=TRUE ;; [0]) GDI=FALSE ;; esac
                  case $VAL_16 in [1]) ON_STATUS=TRUE ;; [0]) ON_STATUS=FALSE ;; esac
                  case $VAL_17 in [1]) DEFROST_STATUS=TRUE ;; [0]) DEFROST_STATUS=FALSE ;; esac
                  case $VAL_18 in [1]) KEYBOARD_STATUS=TRUE ;; [0]) KEYBOARD_STATUS=FALSE ;; esac
                  # Define variables with string (this string it's for error codes)
                  CODE_13=$VAL_19
                  # Run sql insert command
                  INSERT_CR_RESULT=$($PSQL "INSERT INTO cr$ADDRESS(datetime,address,code_1,code_2,probe_1,probe_2,probe_3,temp_set,humid_set,compressor_out,heater_out,fan_out,humidifier_out,defrost_out,light_out,gdi,on_status,defrost_status,keyboard_status,code_13) VALUES('$DATETIME','$ADDRESS','$CODE_1','$CODE_2','$PROBE_1','$PROBE_2','$PROBE_3','$TEMP_SET','$HUMID_SET','$COMPRESSOR_OUT','$HEATER_OUT','$FAN_OUT','$HUMIDIFIER_OUT','$DEFROST_OUT','$LIGHT_OUT','$GDI','$ON_STATUS','$DEFROST_STATUS','$KEYBOARD_STATUS','$CODE_13')")
                  # Print messages for success insert.
                  if [[ $INSERT_CR_RESULT == 'INSERT 0 1' ]]; then
                  echo "Inserted into cr$ADDRESS"
                  fi
                fi
            done
          # wait some (TIME variable) seconds
          sleep "$TIME"
          # exit from the loop if the first word is not 'start' or 'stop'
          else
            echo "The file /usr/local/etc/variable_command is necessary to have one line, by example 'start|10|192.168.0.15'"
            break 2
        fi
    done
done