## @@@@@ @@   @@ @@@@ @   @
##    @  @ @ @ @ @    @   @
##   @   @  @  @ @@@  @   @
##  @    @     @ @    @   @
## @@@@@ @     @ @@@@ @@@@@
## [ssh.tcl]

set zmeussh(cmdchar) "."
bind pub -|- $zmeussh(cmdchar)ssh zmeussh_syntax

proc zmeussh_syntax {nickname uhost hand chan text} {
        set host [lindex $text 0]
        set port [lindex $text 1]
        if {$port == ""} {
                putquick "NOTICE $nickname :Syntax: .ssh <hostname:port/ip:port>"
        } else {
        if {[catch {set sock [socket -async $host $port]} error]} {
                putquick "NOTICE $nickname :$host:$port, was refused."
        } else {
        set timerid [utimer 15 [list zmeussh_disconnect $nickname $sock $host $port]]
        fileevent $sock writable [list zmeussh_connect $nickname $sock $host $port $timerid]
                }
        }
}

proc zmeussh_connect {nickname sock host port timerid} {
        killutimer $timerid
        if {[set error [fconfigure $sock -error]] != ""} {
        close $sock
                putquick "NOTICE $nickname :$host:$port, unable to connect to remote host. [string totitle $error]"
        } else {
        fileevent $sock writable {}
        fileevent $sock readable [list zmeussh_read $nickname $sock $host $port]
                putquick "NOTICE $nickname :$host:$port, accepted."
        }
}

proc zmeussh_disconnect {nickname sock host port} {
        close $sock
                putquick "NOTICE $nickname :$host:$port, timed out."
}

proc zmeussh_read {sock} {
        if {[gets $sock 1] == -1} {
                putquick "NOTICE $nickname :$host:$port, address family not supported by protocol."
        close $sock
        }
}

putlog "{@}ssh.tcl: version 0.1 by ZmEu"
