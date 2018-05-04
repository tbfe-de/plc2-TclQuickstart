#!/usr/bin/env wish

set font "Sans 20"

array set opt {
	-expanded	0
	-line		0
	-linestop	0
	-lineanchor	0
	-nocase		0
}

pack [frame .top] -side top -fill x
pack [label .top.re_ -font $font\
	-text regexp
     ] -side left
pack [entry .top.re -font [lreplace $font 0 0 Courier]\
	-width 70 -textvariable re
     ] -side left -fill x -expand true
pack [button .top.b -font $font\
	-text \u23CE -command show
     ] -side left

pack [frame .opt] -side top -fill x
pack [label .opt.start_ -font $font\
	-text -start
     ] -side left
pack [button .opt.back -font $font\
	-text \u21A4 -state normal\
	-command back
     ] -side left
pack [spinbox .opt.start -font $font\
	-width 3\
	-from 0 -to 10000000 -justify right\
	-textvariable match_beg
     ] -side left
pack [button .opt.skip -font $font\
	-text \u21B7 -state disabled\
	-command skip
     ] -side left
pack [checkbutton .opt.expanded -font $font\
	-text -expanded\
	-variable opt(-expanded)\
	-command show
     ] -side left
pack [checkbutton .opt.line -font $font\
	-text -line\
	-variable opt(line)\
	-command show
     ] -side left
pack [checkbutton .opt.linestop -font $font\
	 -text -linestop\
	-variable opt(-linestop)\
	-command show
     ] -side left
pack [checkbutton .opt.lineanchor -font $font\
	-text -lineanchor\
	-variable opt(-lineanchor)\
	-command show
     ] -side left
pack [checkbutton .opt.nocase -font $font\
	-text -nocase\
	-variable opt(-nocase)\
	-command show
     ] -side left

pack [text .e -font [lreplace $font 0 0 Courier]\
	-width 50 -height 16
     ] -fill both -expand true

pack [spinbox .sel -font $font\
	-width 11\
	-values [list\
		"whole match"\
		"submatch 1"\
		"submatch 2"\
		"submatch 3"\
		"submatch 4"\
		"submatch 5"\
		"submatch 6"\
		"submatch 7"\
		"submatch 8"\
		"submatch 9"
	] -wrap true\
	-justify center\
	-state readonly\
	-textvariable sel\
	-command show
     ] -side left
pack [label .out -font $font\
	-anchor w\
	-padx 12\
	-textvariable out
     ]\
     -side right -fill x -expand true


.e tag configure hl -background lightgreen
bind .top.re <Return> {show; break}
bind .top.re <Key> reval
bind .e <Key> show

proc reval {} {
	set ::out ""
	.top.re configure -background yellow
}

proc back {} {
	set ::match_beg 0
	show
}

proc skip {} {
	set ::match_beg [expr {$::match_end + 1}]
	show
}

proc show {} {
	.top.re configure -background white
	.opt.skip configure -state disabled
	.e tag remove hl 1.0 end
	set in [.e get 1.0 end]
	set regex_opts [list]
	foreach {name value} [array get ::opt] {
		if {$value} {
			lappend regex_opts $name
		}
	}
	if {![string length $::match_beg]} {
		set ::match_beg 0
	}
	if {[catch {
		eval regexp -indices -start $::match_beg $regex_opts --\
			\$::re \$in\
			x(match) x(1) x(2) x(3) x(4) x(5) x(6) x(7) x(8) x(9)
	} ::out]} {
		set ::match_beg 0
		.out configure -bg red
	} elseif {$::out} {
		.out configure -bg lightgreen -fg black
		lassign $x(match) ::match_beg ::match_end
		set s [lindex $::sel 1]
		lassign $x($s) b e
		set n [expr {$e + 1 - $b}]
		if {$b < 0} {
			set ::out "no such submatch"
			.out configure -fg white
			.out configure -bg blue
		} elseif {!$n} {
			set ::out "empty string at $b"
		} else {
			set ::out "from char $b to $e → "
			set m [string range $in $b $e]
			regsub \n $m \\n m
			regsub {(.{40}).*} $m {\1...} m
			append ::out \" $m \"
			set xf [.e index "1.0 +$b display chars"]
			set xt [.e index "$xf +$n display char"]
			.e tag add hl $xf $xt
		}
		.opt.skip configure -state normal
	} else {
		set ::match_beg ""
		.out configure -bg lightblue -fg black
		set ::out "sorry, no match"
	}
}

set match_beg 0
set match_end 0
set sel [lindex [.sel cget -values] 0]
set re {(?:[(]([^)]+)[)])?\s*([[:alpha:]_][[:alnum:]_]*)\s*=\s*(\d+(?:\.\d*)?)}

.e insert end "(π)  pi =    3.14165358979323846264338327950288419716939937510\n"
.e insert end "     e  =    2.71828459045235360287471352662497757247093699959\n"
.e insert end "(√2) sqrt2 = 1.41421356237309504880168872420969807856967187537\n"

show
