#!/usr/bin/awk -f

# Lines starting with ## are helpful for evaluating the results of each step.
# Lines starting with ### are helpful for debugging.
# I had an issue with AWK because I couldn't figure out how to
# return something other than a scalar.

BEGIN{
    direction["L"] = -1
    direction["D"] = -1
    direction["R"] = 1
    direction["U"] = 1

    NUMBER_OF_KNOTS = 10 # the head and 9 knots

    # We're giving the arrays slices now! Great!
    # I wonder how else I can misuse this data structure...
    for(slice = 1; slice <= NUMBER_OF_KNOTS; slice++){
        x_knot[slice] = 0
        y_knot[slice] = 0
        positions_visited_by_tail[slice, x_knot[slice], y_knot[slice]]
    }

    ##printf "%-5s\t%-5d\t%-5d\t%-5d\t%-5d\t%-5d\t%-5d\t%-5d\t%-5d\t%-5d\t(START)\n", "head", 1, 2, 3, 4, 5, 6, 7, 8, 9
    ##print_knot_locations()
}

# Move the head of the rope, updating knot positions as needed
{
    move_direction = $1
    number_of_movements = $2
    for(i = 1; i <= number_of_movements; i++){
        ###printf "starting coordinates of head for movement (%s part %d): (%d,%d)\n", move_direction, i, x_knot[1], y_knot[1]
        x_knot[1] += (direction[move_direction] * (move_direction == "L" || move_direction == "R"))
        y_knot[1] += (direction[move_direction] * (move_direction == "U" || move_direction == "D"))

        ###print "coords of slice 1 before adjustment to slice 2:", "(" x_knot[1] "," y_knot[1] ")"
        for(slice = 2; slice <= NUMBER_OF_KNOTS; slice++){

            x_dist = x_knot[slice - 1] - x_knot[slice]
            y_dist = y_knot[slice - 1] - y_knot[slice]

            ###print "coords of slice", slice - 1, "before adjustment to slice", slice ":", "(" x_knot[slice - 1] "," y_knot[slice - 1] ")"
            ###print "coords of slice", slice, "before adjustment:", "(" x_knot[slice] "," y_knot[slice] ")"

            x_knot[slice] += x_adjust_tail()
            y_knot[slice] += y_adjust_tail()

            ###print "coords of slice", slice, "after adjustment:", "(" x_knot[slice] "," y_knot[slice] ")"

            positions_visited_by_tail[slice, x_knot[slice], y_knot[slice]]
        }
        ##print_knot_locations()
    }
}

END{
    tail_pattern = "^" NUMBER_OF_KNOTS
    for(ind in positions_visited_by_tail){
        number_of_positions += ind ~ tail_pattern
    }
    print "Number of distinct positions visited by the tail:", number_of_positions
}


# Helpful for debugging small examples (the grid has single-digit coordinates)
function print_knot_locations(){
    for(k = 1; k <= NUMBER_OF_KNOTS; k++){
        printf "(%d,%d)\t", x_knot[k], y_knot[k]
    }
    printf "(MOVE %d %s)\n", number_of_movements, move_direction
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

