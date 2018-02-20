# create a recursive directory listing in alphabetic order
#
proc xdirlist_r {resultvar} {
	upvar $resultvar result
	set csize [expr {[llength $result] - 1}]
	set dir [lindex $result "$csize 0"]
	set maxmt [file mtime $dir]
	set subdirs [glob -nocomplain -type d -directory $dir *]
	set files [glob -nocomplain -type f -directory $dir *]
	set all [concat $subdirs $files]
	foreach fn [concat [lsort $subdirs] [lsort $files]] {
		set cs [llength $result]
		lappend result [list $fn [file mtime $fn]]
		if {[file isdirectory $fn]} {
			xdirlist_r result
		}
		set mt [lindex $result "$cs 1"]
		if {$maxmt < $mt} {
			set maxmt $mt
		}
	}
	lset result "$csize 1" $maxmt
}

proc xdirlist {dir} {
	lappend result [list $dir [file mtime $dir]]
	xdirlist_r result
	return $result
}

proc fsdelta {xlistvar nlist resultarr} {
	upvar $xlistvar xlist
	upvar $resultarr result
	foreach f {- + ! =} {
		if {[info exists result($f)]} {
			set result($f) [list]
		}
	}
	set x [list]
	foreach el $xlist {
		set fn [lindex $el 0]
		set p [lsearch -index 0 $nlist $fn]
		if {$p != -1} {
			set mtx [lindex $el 1]
			set mtn [lindex $nlist "$p 1"]
			if {$mtx == $mtn} {
				lappend x $el
				if {[info exists result(=)]} {
					lappend result(=) $el
				}
			} else {
				lappend x [lindex $nlist $p]
				if {[info exists result(!)]} {
					lappend result(!) $el
				}
			}
		} elseif {[info exists result(-)]} {
			lappend result(-) $el
		}
	}
	set xlist $x
	foreach el $nlist {
		if {[lsearch $xlist $el] == -1} {
			lappend xlist $el
			if {[info exists result(+)]} {
				lappend result(+) $el
			}
		}
	}
}

proc test_xdirlist {} {
	foreach fn_mt [xdirlist .] {
		lassign $fn_mt fn mt
		puts "[clock format $mt -format {%Y-%m-%d %H:%M:%S}] $fn"
	}
}

proc tsfmt {ts} {
	clock format $ts -format {%Y-%m-%d %H:%M:%S}
}

proc test_fsdelta {d} {
	set sq {- + ! =}
	foreach s $sq {
		set st($s) ""
	}
	set fs [list]
	while {[
		fsdelta fs [xdirlist $d] st
		foreach s $sq {
			foreach fn_mt $st($s) {
				lassign $fn_mt fn mt
				puts "$s $mt $fn"
			}
		}
		puts -nonewline ">>> "
	 	flush stdout
		gets stdin cmd
	] >= 0} {
		if {[string length $cmd]} {
			catch {eval exec $cmd}
		}
	}
}

proc test_listing {d} {
	set fs [list]
	for {array set st {
		! {}
		= {}
		- {}
		+ {}
	}} {[
		fsdelta fs [xdirlist $d] st
		set r [list]
		foreach {k el} [array get st] {
			foreach fn_mt $el {
				lassign $fn_mt fn mt
				switch -exact -- $k {
					+ - = - - {
						lappend r [list $fn [tsfmt $mt] $k ""]
					}
					! {
						set p [lsearch -index 0 $fs $fn]
						if {$p == -1} {
							set nt "????-??-?? ??:??:??"
						} else {
							set nt [lindex $fs "$p 1"]
						}
						lappend r [list $fn [tsfmt $mt] $k [tsfmt $nt]]
					}
				}
			}
		}
		set r [lsort -index 0 $r]
		set ml 0
		foreach z $r {
			set zr [file split [lindex $z 0]]
			set n [expr {2*([llength $zr] - 1)} + [string length [lindex $zr end]] + 3]
			if {$ml < $n} {
				set ml $n
			}
		}
		foreach z $r {
			set fns [file split [lindex $z 0]]
			set fnr [llength $fns]
			set fnp [lindex {"" "+-"} [expr {$fnr > 1}]]
			set fnx [string repeat "  " [expr {$fnr - 2}]]
			set fnb [lindex $fns end]
			set fnd "$fnx$fnp$fnb:"
			if {[string length $fnd] % 2 == 0} {
				append fnd " "
			}
			while {[string length $fnd] < $ml} {
				append fnd " ·"
			}
			puts [format "%-*s %s (%s) %s" $ml $fnd\
							[lindex $z 1]\
							[lindex $z 2]\
							[lindex $z 3]\
			]
		}
		gets stdin cmd] >= 0
	} {
		if {[catch {eval exec $cmd} m]} {
			puts "!! >>> $m (recovering)"
		} else {
			puts "(OK) = $m"
		}
	} {}
}

# test_xdirlist
  test_fsdelta .
# test_listing ..
