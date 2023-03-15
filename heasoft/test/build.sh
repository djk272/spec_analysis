#!/bin/bash
FILE=.docker_build.out
if [ -f "$FILE" ]; then
	rm $FILE 
	echo "Starting docker build, run tail -f $FILE to follow the build."
	docker build . > $FILE 2>&1
else
	echo "Starting docker build, run tail -f $FILE to follow the build."
	docker build . > $FILE 2>&1
fi
