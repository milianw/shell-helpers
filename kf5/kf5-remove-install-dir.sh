#!/bin/bash

if [ -z "$KF5" ]; then
  echo "KF5 env var not set"
  exit 1
fi

rm -Rf "$KF5"