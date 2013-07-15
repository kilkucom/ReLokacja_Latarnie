#!/bin/bash
arecord -q -f cd -t wav -d 3 -D plughw -r 16000 sox_test.wav
sox sox_test.wav -n stat -v
vol=$(sox sox_test.wav -n stat -v)
if [[ $vol -gt 10 ]]; then
	echo "dupa do skasow"
fi
