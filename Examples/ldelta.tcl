# determine difference between two list
# - `xlistvar` names an existing list variable (not a LIST!)
# - `nlist` is a new list (not a list VARIABLE)
# - `resultarr` names a Tcl array which will be filled as follows
#    - at the index '+' a list of all elements NEW in `nlist`,
#      i.e. such NOT already in held in`xlistvar`
#    - at the index '-' a list of elements held in `xlistvar`
#      which do NOT again appear in `nlist`
# - finally `xlistvar` is updated to be identical to `nlist`
# - return value is
#   - `1` if there are differences between `xlistvar` and `nlist`
#   - `0` if nothing has changed
#   
proc ldelta {xlistvar nlist resultarr} {
	upvar $xlistvar xlist
	upvar $resultarr result
	if {[info exists result(+)]} {
		set result(+) [list]
	}
	if {[info exists result(-)]} {
		set result(-) [list]
	}
	set x [list]
	foreach el $xlist {
		if {[lsearch $nlist $el] != -1} {
			lappend x $el
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
