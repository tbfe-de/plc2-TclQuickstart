#!/usr/bin/env wish

pack [label .r -font {Courier 20} -textvariable out]\
     -side bottom -fill x
pack [label .x -font {Courier 20} -text expr]\
     -side left
pack [entry .e -font {Courier 20} -width 30 -textvariable in]\
     -side left -expand 1
pack [button .b -font {Courier 20} -text \u21B5 -command calc]\
     -side left
proc calc {} {
    if {[catch {expr $::in} ::out]} {
        .r configure -bg red
    } else {
        .r configure -bg lightgreen
    }
}
set in 2*acos(0.0); calc
