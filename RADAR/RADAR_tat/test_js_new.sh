#!/bin/bash
PATH1="/home/vmeduri/Desktop/radar/RADAR_tat/"
#PATH2="/home/vmeduri/Desktop/FastDownward/src/"
filename="fdCompile.py"
#arg1="blocks.pddl"
#arg2="problem-1"
sql_file="load-data.sql"
py_file="$PATH1$filename"
#domain="$PATH2$arg1"
#problem="$PATH2$arg2"
sql_script="$PATH1$sql_file"
python $py_file 
cp sas_plan /tmp/
mysql -h "localhost" -u "root" "-ppassword" "radar" < $sql_script
# ./fast-downward.py ../../blocks.pddl ../../problem-1 --search "astar(lmcut())"
echo "Hello" > hello.out
