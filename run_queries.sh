#!/bin/bash

cd /
hive -f hive_project/queries/top_movies.q > top_movies.log
