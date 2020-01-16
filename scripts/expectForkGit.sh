#!/usr/bin/expect -f
set x [lindex $argv 0];
set timeout -1

spawn git push origin master
match_max 100000

expect "Username for 'http://localhost:3000':"

send -- "$x\r"

expect "Password for 'http://$x@localhost:3000':"

send -- "dynatrace\r"

expect eof
