#!/bin/bash
PULL_RESULT=$(git pull)
[ "$PULL_RESULT" = "Already up-to-date." ] && ./setup.sh 
