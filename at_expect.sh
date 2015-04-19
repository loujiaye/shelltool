#!/usr/bin/expect  -f
set time [lindex $argv 0]
set task [lindex $argv 1]
spawn at ${time}
expect "*at*"
send "${task}\n"
send "\004\n"
interact
