#!/bin/bash
P=0
# run infinite loop
while true ; do
  # read some variables from file variable_command exp. 'start|5|192.168.1.15'
  # with: echo "stop|5|192.168.1.15" > variable_command
  # you can stop the script
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