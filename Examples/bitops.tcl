# =============================================================================
# Some helpers for bitwise operations
# =============================================================================

proc binary {args} {
    set bits [join $args ""]
    set val 0
    while {[string length $bits] > 0} {
        set val [expr {($val << 1) | [string index $bits 0]}]
        set bits [string range $bits 1 end]
    }
    return $val
}

# puts [format %04X [binary 0]]
# puts [format %04X [binary 1]]
# puts [format %04X [binary 0001 1000]]
# puts [format %04X [binary 0101 1101 0010]]
 
proc binfmt {val {len 0}} {
    set result [expr {$val & 1}]
    while {$val > 0 || $val < -1 || [string length $result] < $len} {
        set val [expr {$val >> 1}]
        set result [string cat [expr {$val & 1}] $result]
    }
    return $result
}

# for {set i 0} {$i <= 10} {incr i} { puts [binfmt $i] }
# for {set i 0} {$i <= 10} {incr i} { puts [binfmt -$i] }
# for {set i 0} {$i <= 10} {incr i} { puts [binfmt $i 8] }
# for {set i 0} {$i <= 10} {incr i} { puts [binfmt -$i 8] }
