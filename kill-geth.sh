#!/usr/bin/env bash
ps aux | grep geth | grep -v grep | awk '{ print $2 }' | xargs kill
