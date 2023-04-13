#!/usr/bin/env bash

export PATH=/home/ubuntu/FVP/models/Linux64_GCC-6.4/:$PATH
export LD_LIBRARY_PATH=/home/ubuntu/FVP/models/Linux64_GCC-6.4/:$LD_LIBRARY_PATH

if [[ -z ${ETHOS_U65} ]]; then
  echo "(default) Launching Ethos-U55 version."
  ETHOS="U55"
else
  echo "Launching Ethos-U65 version."
  ETHOS="U65"
fi

if [[ -z ${NON_INTERACTIVE} ]]; then
  FVP_Corstone_SSE-300_Ethos-${ETHOS} \
    -C mps3_board.telnetterminal0.start_telnet=0 \
    -C mps3_board.telnetterminal1.start_telnet=0 \
    -C mps3_board.telnetterminal2.start_telnet=0 \
    -C mps3_board.telnetterminal5.start_telnet=0 \
    -C mps3_board.visualisation.disable-visualisation=1 \
    $* &

  PID=$?

  sleep 2

  tmux new-session -d bash
  tmux split-window -d bash
  tmux split-window -h bash
  tmux select-pane -t 2
  tmux split-window -h bash
  tmux send -t 0 "telnet localhost 5000" C-m
  tmux send -t 1 "telnet localhost 5001" C-m
  tmux send -t 2 "telnet localhost 5002" C-m
  tmux send -t 3 "telnet localhost 5003" C-m
  tmux -2 attach-session -d

  kill ${PID}
else
  echo "Running in non-interactive mode"

  FVP_Corstone_SSE-300_Ethos-${ETHOS} \
    -C mps3_board.telnetterminal0.start_telnet=0 \
    -C mps3_board.telnetterminal1.start_telnet=0 \
    -C mps3_board.telnetterminal2.start_telnet=0 \
    -C mps3_board.telnetterminal5.start_telnet=0 \
    -C mps3_board.visualisation.disable-visualisation=1 \
    -C mps3_board.uart0.out_file=- \
    -C mps3_board.uart1.out_file=- \
    -C mps3_board.uart2.out_file=- \
    -C mps3_board.uart5.out_file=- \
    -C mps3_board.uart0.shutdown_on_eot=1 \
    -C mps3_board.uart1.shutdown_on_eot=1 \
    -C mps3_board.uart2.shutdown_on_eot=1 \
    -C mps3_board.uart5.shutdown_on_eot=1 \
    $*
fi
