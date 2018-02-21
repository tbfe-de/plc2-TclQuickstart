# ============================================================================
# Various Ways to Create a Multiplication table
# ============================================================================

# not using arguments, direct output via puts:
#
proc mtab_globals_puts {} {
    global rows cols
    # calculate required with
    set w [string length [expr {$rows * $cols}]]
    for {set r 1} {$r <= $rows} {incr r} {
        for {set c 1} {$c <= $cols} {incr c} {
            puts -nonewline [format "%*d " $w [expr {$r*$c}]]
	}
	puts "" ;# just a newline
    }
}

# to be called like this:
set rows 5
set cols 10
# mtab_globals_puts
# or alternatively like this:
# lassign "12 12" rows cols; mtab_globals_puts

# using arguments with defaults, output as return value
#
proc mtab_args_return {{rows 10} {cols 10}} {
    set w [string length [expr {$rows * $cols}]]
    for {set r 1} {$r <= $rows} {incr r} {
        for {set c 1} {$c <= $cols} {incr c} {
	    append result [format "%*d " $w [expr {$r*$c}]]
	}
	append result \n
    }
    return $result
}

# to be called like this:
# puts [mtab_args_return 7 3]
# puts [mtab_args_return 7]
# puts [mtab_args_return]

# using arguments with defaults, store output in variable
#
proc mtab_args_to_var {vname {rows 10} {cols 10}} {
    upvar $vname result
    set w [string length [expr {$rows * $cols}]]
    for {set r 1} {$r <= $rows} {incr r} {
        for {set c 1} {$c <= $cols} {incr c} {
	    append result [format "%*d " $w [expr {$r*$c}]]
	}
	append result \n
    }
}

# to be called like this:
# mtab_args_to_var my_var ; puts $my_var
# mtab_args_to_var out 3 3; puts $out

# using arguments with defaults, store output in array
#
proc mtab_args_to_array {arrname {rows 10} {cols 10}} {
    upvar $arrname result
    for {set r 1} {$r <= $rows} {incr r} {
        for {set c 1} {$c <= $cols} {incr c} {
            set result($r·$c) [expr {$r*$c}]
	}
    }
}

# to be called like this:
# mtab_args_to_array a 4 4; foreach {k v} [array get a] { puts "$k ==> $v" }
# mtab_args_to_array a 2 3; foreach k [lsort [array names a]] { puts "$k ==> $a($k)" }

# using "named" arguments with (some)
#
proc mtab {args} {
    # set the default values
    array set argval {-rows 10 -cols 10}
    # overwrite with what is specified
    array set argval $args

    # setup output to variable, if requested
    if {[info exists argval(-to_var)]} {
        upvar $argval(-to_var) result
    }

    # create the table in result
    set w [string length [expr {$argval(-rows) * $argval(-cols)}]]
    for {set r 1} {$r <= $argval(-rows)} {incr r} {
        for {set c 1} {$c <= $argval(-cols)} {incr c} {
	    append result [format "%*d " $w [expr {$r*$c}]]
	}
	append result \n
    }
    if {[info exists argval(-to_var)]} {
        return "" ;# caller catches result in variable or ...
    } else {
        return $result ;# ... receives result via return value

    }
}

# to be called like this:
puts [mtab -rows 5 -cols 10]
mtab -rows 3 -to_var x; puts $x
