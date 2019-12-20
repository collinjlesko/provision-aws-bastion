#!/usr/bin/expect -f

set timeout -1

spawn git push origin master
match_max 100000
 
expect "Username for 'http://localhost:3000':"
 
send -- "ubuntu\r"
 
expect "Password for 'http://ubuntu@localhost:3000':"

send -- "dynatrace\r"
 
expect eof
