# .s scriptname 
# not .s scriptname.tcl

### set
# director where the scripts are (ie: scripts/):
set shit(load_dir) "scripts/"

bind dcc n|- s script:load 
proc script:load { handle idx text } {
	global shit
	if {$text == ""} {
		putlog "SYNTAX: .s <scriptname>"
		return
	}
	if { [catch { uplevel #0 [list source $shit(load_dir)$text.tcl] } error] } { 
		putlog "Error while loading $text -- Errormsg: $error" 
		putlog "script: $text"
		putlog "::errorInfo: $::errorInfo"
		return 
	} 
	putlog "script: $text.tcl -- loaded without error." 
	return 
} 

putlog "{@}load.tcl: version 0.1 by ZmEu"
