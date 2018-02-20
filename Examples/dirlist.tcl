# create a recursive directory listing in alphabetic order
#
proc dirlist_r {resultvar mode} {
	upvar $resultvar result
	set dir [lindex $result end]
	set subdirs [glob -nocomplain -type d -directory $dir *]
	set files [glob -nocomplain -type f -directory $dir *]
	switch -exact -- $mode {
		-unsorted {
			set all [concat $subdirs $files]
		}
		-dirs_first {
			set all [concat [lsort $subdirs] [lsort $files]]
		}
		-dirs_merged {
			set all [lsort [concat $subdirs $files]]
		}
		default {
			error "mode must be from {-unsorted|-dirs_first|-dirs_merged}"
		}
	}
	foreach fn $all {
		lappend result $fn
		if {[file isdirectory $fn]} {
			dirlist_r result $mode
		}
	}
}

proc dirlist {dir {mode -dirs_first}} {
	lappend result $dir
	dirlist_r result $mode
	return $result
}

proc test_dirlist {} {
	puts [join [dirlist . -dirs_merged] \n]
}

test_dirlist
