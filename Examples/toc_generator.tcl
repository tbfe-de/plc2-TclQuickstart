#!/usr/bin/env tclsh

# check command line argument

set filename [lindex $argv 0]
if {$argc == 0 || [string equal $filename -help]} {
    puts stderr "Usage: $argv0 {<filename>|-help}"
    exit 1
}

# get a file handle `fh` for file named as agument
#
if {[catch {open $filename r} fh]} {
    puts stderr $fh; exit 2
}

# read complete file into `htmltext`, close handle `fh`
#
set htmltext [read $fh]; close $fh

# RE to strip prefix and postfix for actual content
#       ++----------------------------------- anything
#       || +++++++++++++--------------------- start-tag
#       || |||||||||||||  ++----------------- any content (\1)
#       || |||||||||||||  ||  +++++++++------ end-tag
#       || |||||||||||||  ||  ||||||||| ++--- anything
set re {.*<textarea>(.*)</textarea>.*}

set content [regsub $re $htmltext {\1}]
set page 0 ;# not necessary in recent Tcl version
foreach line [split $content \n] {
    if {[regexp {^header:\s+(#+)\s+(.*)} $line - hashes chapter]} {
	set chleng [string length $chapter]
	set hlevel [string length $hashes]
	set nlead [expr {63 - 2*$hlevel - $chleng}]
	puts [format "%*s%s %s %3d"\
		[expr {2*($hlevel-2)}] "" $chapter\
		[string repeat . $nlead]\
		[incr $page]]
    }
}
