#!/bin/bash
P=0
# run infinite loop
while true ; do
  # read some variables from file variable_command, example 'start|5|192.168.1.15'
  # was written with command: echo "stop|5|192.168.1.15" > variable_command
  # where with 'stop' word you can stop the script
  # where with 'start' word you can run the script
  # next after first delimiter | it's a number for how many seconds to wait, a very small number can flood the device
  # next after second delimiter | it's ip address for Dixell Xweb300D device
    while IFS="|" read -r RUN TIME IP < variable_command; do
      # check if stop and exit from the loop
        if [ "$RUN" = 'stop' ]; then
            exit 1;
        # but if exist 'start' word in the first line then run command
        elif [ "$RUN" = 'start' ]; then
          HOUR=$(date +%H:%M:%S)
          P=$(("$P"+1))
          echo "$HOUR" "Loop no. $P"
          # wait some (TIME variable) seconds
          sleep "$TIME"
          # exit from the loop if the first word is not 'start' or 'stop'
          else
            echo "The file named variable_command is necessary to have one line with 'start|3|192.168.0.15'"
            exit 1
            fi
    done
done