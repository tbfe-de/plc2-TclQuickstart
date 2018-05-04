#!/usr/bin/env wish

set font "Sans 20"

pack [label .o -font $font -textvariable out]\
     -side bottom -fill both -expand 1
pack [label .t -font $font -text regexp]\
     -side left
pack [entry .r -width 25 -font $font -textvariable re]\
     [entry .e -width 20 -font $font -textvariable in]\
     -side left -fill x -expand 1
pack [button .b -font $font -text \u21B5 -command show]\
     -side left
bind . <Return> show
proc show {} {
    if {[catch {regexp -indices -- $::re $::in m} ::out]} {
        .o configure -bg red
    } elseif {$::out} {
        .o configure -bg lightgreen
        lassign $m f t
        set n [expr {$t+1-$f}]
        if {!$n} {
            set ::out "empty string at $f"
        } else {
	    set ::out "from $f to $t ($n chars) → "
	    append ::out \" [string range $::in $f $t] \"
        }
    } else {
        .o configure -bg lightblue
        set ::out "sorry, no match"
    }
}
set re {[[:alpha:]_][[:alnum:]_]*=\d+(\.\d*)?}
set in "PI=[expr 2*acos(0.0)]"; show
