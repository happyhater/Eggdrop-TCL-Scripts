## @@@@@ @@   @@ @@@@ @   @
##    @  @ @ @ @ @    @   @
##   @   @  @  @ @@@  @   @
##  @    @     @ @    @   @
## @@@@@ @     @ @@@@ @@@@@
## [dns.tcl]

set zmeudns(cmdchar) "."
bind pub -|- $zmeudns(cmdchar)dns dns:rezolv

proc dns:rezolv {nickname hostname handle channel text} {
 if {$text == ""} {
            puthelp "NOTICE $nickname :Syntax: .dns <host/ip>"
        } else {
                set hostip [split $text]
                dnslookup $hostip rezolv_dns $nickname $hostip
        }
}

proc rezolv_dns {ip hostname status nickname hostip} {
        if {!$status} {
                puthelp "NOTICE $nickname :Unable to resolve address $hostip"
        } elseif {[regexp -nocase -- $ip $hostip]} {
                puthelp "NOTICE $nickname :Resolved $ip to $hostname"
        } else {
                puthelp "NOTICE $nickname :Resolved $hostname to $ip"
        }
}

putlog "{@}dns.tcl: version 0.1 by ZmEu"
