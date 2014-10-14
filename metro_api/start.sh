#!/bin/sh
./manage.py runserver >> logs/server.log 2>& 1 &

