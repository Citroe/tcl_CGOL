package require Tk

wm title . "CGOL" ;#Setting up the UI
wm resizable . 0 0

canvas .c -width 375 -height 375 -bg "#000000"
frame .btns
button .btns.play -text "Play" -command play
button .btns.pause -text "Pause" -command pause
button .btns.step -text "Step" -command frame
pack .btns.play .btns.pause .btns.step -side left -padx 5
pack .c .btns -pady 5

array set grid {} ;#Hardcoded grid, the values can be changed for a larger grid, canvas res might mess up though
for {set r 0} {$r < 25} {incr r} {
    for {set c 0} {$c < 25} {incr c} {
        set grid($r,$c) 0
    }
}

#set grid(12,11) 1 ;#Blinker starting seed 
#set grid(12,12) 1
#set grid(12,13) 1

set grid(10,2) 1; set grid(10,5) 1 ;#Traveler starting seed
set grid(11,1) 1
set grid(12,1) 1; set grid(12,5) 1
set grid(13,1) 1; set grid(13,2) 1; set grid(13,3) 1; set grid(13,4) 1

set end ""

#Drawing the grid
proc draw {} {
    global grid
    .c delete all
    for {set r 0} {$r < 25} {incr r} {
        for {set c 0} {$c < 25} {incr c} {
            if {$grid($r,$c) == 1} {
                set x1 [expr {$c * 15}]; set y1 [expr {$r * 15}]
                set x2 [expr {$x1 + 15}]; set y2 [expr {$y1 + 15}]
                .c create rectangle $x1 $y1 $x2 $y2 -fill "#f0f0f0" -outline "#000022"
            }
        }
    }
}

#CGOL logic and drawing the cell
proc frame {} {
    global grid
    array set new_grid {}
    
    for {set r 0} {$r < 25} {incr r} {
        for {set c 0} {$c < 25} {incr c} {
            set n 0
            foreach dr {-1 0 1} {
                foreach dc {-1 0 1} {
                    if {$dr == 0 && $dc == 0} continue
                    set nr [expr {$r + $dr}]; set nc [expr {$c + $dc}]
                    if {$nr >= 0 && $nr < 25 && $nc >= 0 && $nc < 25} {
                        incr n $grid($nr,$nc)
                    }
                }
            }
            if {$grid($r,$c) == 1} { ;#CGOL Rule checks (<2 or >3 cell dies, 3 alive neighbors around dead cell makes it alive)
                set new_grid($r,$c) [expr {$n == 2 || $n == 3}]
            } else {
                set new_grid($r,$c) [expr {$n == 3}]
            }
        }
    }
    array set grid [array get new_grid]
    draw
}

proc play {} {
    global end
    frame
    set end [after 150 play] ;#The number here is the time before which the frame changes, 150 is roguhly 6.6 fps
}

proc pause {} {
    global end
    catch {after cancel $end}
}

draw