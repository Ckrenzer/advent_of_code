#!/usr/bin/awk -f

BEGIN{

    #xh = 4 # comparing slice 1 (head) to slice 2
    #yh = 2
    #xt = 3
    #yt = 0
    xh = 4  # comparing slice 2 to slice 3
    yh = 1
    xt = 2
    yt = 0

    printf "head: (%d,%d)\ttail: (%d,%d)\n", xh, yh, xt, yt

    x_dist = xh - xt
    y_dist = yh - yt
    print "x distance:", x_dist
    print "y distance:", y_dist

    xt += x_adjust_tail()
    yt += y_adjust_tail()
    printf "result: (%d,%d)\n", xt, yt

}


# Determine where to move the tail's x-coordinate based on the position of the head
function x_adjust_tail(){
    #             move right one                                                    move left one
    x_movement = (x_dist == 2 || (x_dist == 1 && (y_dist == -2 || y_dist == 2))) - (x_dist == -2 || (x_dist == -1 && (y_dist == -2 || y_dist == 2)))
    return(x_movement)
}

# Determine where to move the tail's y-coordinate based on the position of the head
function y_adjust_tail(){
    #             move up one                                                       move down one
    y_movement = (y_dist == 2 || (y_dist == 1 && (x_dist == -2 || x_dist == 2))) - (y_dist == -2 || (y_dist == -1 && (x_dist == -2 || x_dist == 2)))
    return(y_movement)
}
