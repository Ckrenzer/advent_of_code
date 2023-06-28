#!/usr/bin/awk -f

BEGIN{
    direction["L"] = -1
    direction["R"] = 1
    direction["U"] = 1
    direction["D"] = -1

    # I guess this doesn't actually mean anything since this is awk,
    # but it's nice to be explicit.
    x_head = y_head = x_tail = y_tail = 0

    positions_visited_by_tail[x_tail, y_tail]
}

$1 == "L" || $1 == "R" {
    for(i = 1; i <= $2; i++){
        x_head += direction[$1]
        adjust_tail()
        #print_locations()
    }
}

$1 == "U" || $1 == "D" {
    for(i = 1; i <= $2; i++){
        y_head += direction[$1]
        adjust_tail()
        #print_locations()
    }
}

END{
    print "Number of distinct positions visited by the tail:", length(positions_visited_by_tail)
}


function print_locations(){
        printf "Movement: %s %s\tHead: (%d, %d)\tTail: (%d, %d)", $1, $2, x_head, y_head, x_tail, y_tail
        if(i == $2) printf "*"
        printf "\n"
}

# adjust and record position of tail accordingly
function adjust_tail(){
    x_dist = x_head - x_tail
    y_dist = y_head - y_tail
    #          move right one                                                    move left one
    x_tail += (x_dist == 2 || (x_dist == 1 && (y_dist == -2 || y_dist == 2))) - (x_dist == -2 || (x_dist == -1 && (y_dist == -2 || y_dist == 2)))
    #          move up one                                                       move down one
    y_tail += (y_dist == 2 || (y_dist == 1 && (x_dist == -2 || x_dist == 2))) - (y_dist == -2 || (y_dist == -1 && (x_dist == -2 || x_dist == 2)))
    # record the position visited
    # (duplicates don't make a difference)
    positions_visited_by_tail[x_tail, y_tail]
}



# Instinct told me to generalize this, though I do think it's easy to follow
# (however error-prone in writing the increments/decrements).
# To be sure, the shorter version is more compact but not generalized.
#
# I wrote out the movements on a grid on paper first, leaving the tail
# at the origin. From there, I identified all possible locations of the head that
# would trigger a movement of the tail. I then wrote out the conditions, turned
# them into if-statements, and updated the values accordingly.
function adjust_tail_the_long_way(){

    x_dist = x_head - x_tail
    y_dist = y_head - y_tail


    if((x_dist == 2) && (y_dist == 0)){# right two condition
        x_tail += 1

    } else if((x_dist == 2) && (y_dist == 1)){# two-to-the-right-and-up-one
        x_tail += 1
        y_tail += 1

    } else if((x_dist == 1) && (y_dist == 2)){# one-to-the-right-and-up-two
        x_tail += 1
        y_tail += 1

    } else if((x_dist == 0) && (y_dist == 2)){# up two condition
        y_tail += 1

    } else if((x_dist == -1) && (y_dist == 2)){# one-to-the-left-and-up-two
        x_tail -= 1
        y_tail += 1

    } else if((x_dist == -2) && (y_dist == 1)){# two-to-the-left-and-up-one
        x_tail -= 1
        y_tail += 1

    } else if((x_dist == -2) && (y_dist == 0)){# left two condition
        x_tail -= 1

    } else if((x_dist == -2) && (y_dist == -1)){# two-to-the-left-and-down-one
        x_tail -= 1
        y_tail -= 1

    } else if((x_dist == -1) && (y_dist == -2)){# one-to-the-left-and-down-two
        x_tail -= 1
        y_tail -= 1

    } else if((x_dist == 0) && (y_dist == -2)){# down two condition
        y_tail -= 1

    } else if((x_dist == 1) && (y_dist == -2)){# one-to-the-right-and-down-two
        x_tail += 1
        y_tail -= 1

    } else if((x_dist == 2) && (y_dist == -1)){# two-to-the-right-and-down-one
        x_tail += 1
        y_tail -= 1

    }

    # record the position visited
    # (duplicates shouldn't make a difference)
    positions_visited_by_tail[x_tail, y_tail]
}
