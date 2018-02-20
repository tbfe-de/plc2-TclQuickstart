# =============================================================================
# demonstrate several variants of list processing
# =============================================================================
# The following code is used in the part of the presentation which demonstrates
# various forms of `for` and `foreach` to run over lists.

# -----------------------------------------------------------------------------
# `measurements` is list of two-element sub-lists

# outer list processed with `foreach`
#
proc avg1a {measurements} {
    set sum 0.0
    foreach tm $measurements {
        lassign $tm loc temp ;# same as: set loc [lindex $measurements 0]
                              #          set temp [lindex $measurements 1]
        puts "temperature $loc is $temp"
        set sum [expr {$sum + $temp}]
    }
    puts "average temperature: [expr {$sum / [llength $measurements]}]"
}

# outer list processed in counting loop
#
proc avg1b {measurements} {
    set count [llength $measurements]
    set sum 0.0
    for {set i 0} {$i < $count} {incr i} { 
        lassign [lindex $measurements $i] loc temp 
        # or even more verbose:
            # set loc [lindex $measurement $i 0]
            # set temp [lindex $measurement $i 1]
        puts "temperature $loc is $temp"
        set sum [expr {$sum + $temp}]
    }
    puts "average temperature: [expr {$sum / $count}]"
}

# required data structure
#
set mdata {
	{ front     12.5 }
	{ back      18.7 }
	{ ambient   10.9 }
	{ inside    32.1 }
}

# call would look like this:
#
# avg1a $mdata  ;# (comment out if not of interest)
# avg1b $mdata  ;# (comment out if not of interest)

# -----------------------------------------------------------------------------
# `measurements` is list with two adjacent elements processed in the loop

# list processed with `foreach`
#
proc avg2a {measurements} {
    set count 0
    set sum 0.0
    foreach {loc temp} $measurements {
        puts "temperature $loc is $temp"
        set sum [expr {$sum + $temp}]
	incr count
    }
    puts "average temperature: [expr {$sum / $count}]"
}

# list processed in counting loop
#
proc avg2b {measurements} {
    set count [llength $measurements]
    set sum 0.0
    for {set i 0} {$i < $count} {incr i 2} { 
        set loc [lindex $measurements $i]
        set temp [lindex $measurements $i+1]
        puts "temperature $loc is $temp"
        set sum [expr {$sum + $temp}]
    }
    puts "average temperature: [expr {$sum / ($count/2)}]"
}

# required data structure
#
set mdata {
	front     12.5
	back      18.7
	ambient   10.9
	inside    32.1
}

# avg2a $mdata  ;# (comment out if not of interest)
# avg2b $mdata  ;# (comment out if not of interest)

# -----------------------------------------------------------------------------
# `locations` and `temperatures` in two different lists

# summing up using `expr`
#
proc avg3a {locations temperatures} {
    set sum 0.0
    set count 0
    foreach loc $locations temp $temperatures {
        puts "temperature $loc is $temp"
        set sum [expr {$sum + $temp}]
        incr count
    }
    puts "average temperature: [expr {$sum / $count}]"
}

# summing up using `fincr`

proc fincr {vname {inc 1.0}} {
    upvar $vname val
    if {![info exists val]} {
        set val 0.0
    }
    set val [expr {$val + $inc}]
}

proc avg3b {locations temperatures} {
    foreach loc $locations temp $temperatures {
        puts "temperature $loc is $temp"
        fincr sum $temp
        incr count
    }
    if {[info exists sum]} {
       puts "average temperature: [expr {$sum / $count}]"
    }
}

# required data structures
#
set mlocs  { front   back    ambient inside }
set mtemps { 12.5    18.7    10.9    32.1   }

# avg3a $mlocs $mtemps  ;# (comment out if not of interest)
# avg3b $mlocs $mtemps  ;# (comment out if not of interest)
avg3b {} {}           ;# (comment out if not of interest)

# -----------------------------------------------------------------------------
# `measurements` are array of temperatures indexed by locations

proc avg4a {vmeasurements} {
    upvar $vmeasurements measurements
    set sum 0.0
    foreach loc [array names measurements] {
        set temp $measurements($loc)
        puts "temperature $loc is $temp"
	set sum [expr {$sum + $temp}]
    }
    puts "average temperature: [expr {$sum / [array size measurements]}]"
}

proc avg4b {vmeasurements} {
    upvar $vmeasurements measurements
    set sum 0.0
    foreach {loc temp} [array get measurements] {
        puts "temperature $loc is $temp"
	set sum [expr {$sum + $temp}]
    }
    puts "average temperature: [expr {$sum / [array size measurements]}]"
}

# required data structure
#
array set m_array {
    front     12.5
    back      18.7
    ambient   10.9
    inside    32.1
}

# or with separate commands
#  set m_array(front)   12.5
#  set m_array(back)    18.7
#  set m_array(ambient) 10.9
#  set m_array(inside)  32.1

# avg4a m_array  ;# (comment out if not of interest)
# avg4b m_array  ;# (comment out if not of interest)
