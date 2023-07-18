#!/usr/bin/awk -f

BEGIN{
    FS = ""
}

# Load the grid into a data structure
{
    row_current = NR
    for(col_current = 1; col_current <= NF; col_current++){
        value = $col_current
        original_grid[row_current, col_current] = value
        if(value == "S"){
            col_start = col_current
            row_start = row_current
        } else if(value == "E"){
            col_end = col_current
            row_end = row_current
        }
    }
}

END{
    print_current_position_in_grid = 0
    numrows = NR
    numcolumns = NF
    # a-z get priorities 1-26
    for(n = 97; n <= 122; n++){
        heights[sprintf("%c", n)] = n - 96
    }
    heights["S"] = heights["a"]
    heights["E"] = heights["z"]
    construct_grid()
    print_grid() # The 'unedited' grid
    # Determine where the grid can move
    for(row = 1; row <= numrows; row++){
        for(col = 1; col <= numcolumns; col++){
            if(row != row_end || col != col_end){
                grid[row, col] = mark_move_up() + mark_move_down() + mark_move_left() + mark_move_right()
            }
        }
    }


    # Once you've run through every possible way to get to the end point, you have to find the
    # ID that has the fewest moves. The number of moves for this ID is the solution.
    coords["row"] = row_start
    coords["col"] = col_start
    origin_val = grid[row_start, col_start] # For resetting to the beginning
                                            # you will have to prevent the movement to already-checked directions after resetting the origin.

    print "The coordinate system:"
    print_coordinate_system()
    print "The original grid with the values replaced by movement markers:"
    print_grid()
    print_current_position_in_grid = 1

    while(1){

        move = identify_preferred_move()
        print move

        # This has deadly implications for unwinding. It needs more scrutiny.
        ######grid[coords["row"], coords["col"]] = 0 # Prevent later moves from entering this spot

        if(move == "up"){
            id = id "u"; used_ids[id]
            coords["row"]-- # decrement because that's the way the grid loads
            if(can_move_down(coords["row"], coords["col"])){      # Do not move to the previous position (down)
                grid[coords["row"], coords["col"]] -= 100
            }
            save_grid_state(id)

        } else if(move == "down"){
            id = id "d"; used_ids[id]
            coords["row"]++ # increment because that's the way the grid loads
            if(can_move_up(coords["row"], coords["col"])){        # Do not move to the previous position (up)
                grid[coords["row"], coords["col"]] -= 1000
            }
            save_grid_state(id)

        } else if(move == "left"){
            id = id "l"; used_ids[id]
            coords["col"]--
            if(can_move_right(coords["row"], coords["col"])){     # Do not move to the previous position (right)
                grid[coords["row"], coords["col"]] -= 1
            }
            save_grid_state(id)

        } else if(move == "right"){
            id = id "r"; used_ids[id]
            coords["col"]++
            #printf "value of grid at position (%d, %d): %d\n:", coords["row"], coords["col"], grid[coords["row"], coords["col"]]
            #print grid[2, 1]
            if(can_move_left(coords["row"], coords["col"])){      # Do not move to the previous position (left)
                grid[coords["row"], coords["col"]] -= 10
            }
            save_grid_state(id)

        } else if(move == "stuck"){

                # Unwind
                last_move = pop_id()
                restore_grid_state(id)
                # Prevent the last direction you moved to from being an option on the unwound grid
                grid[coords["row"], coords["col"]] -= (1000 * last_move == "u") + (100 * last_move == "d") + (10 * last_move == "l") + (last_move == "r")
                # Move the coordinates back to the previous location
                coords["row"] += (last_move == "d") - (last_move == "u")
                coords["col"] += (last_move == "r") - (last_move == "l")
                save_grid_state(id)

                # If you made your way back to the starting point, see which paths remain
                if(coords["row"] == row_start && coords["col"] == col_start && identify_preferred_move() == "stuck"){
                    break
                }
            }

            # This should unwind (restore state using the popped id) until it gets to a new branch to explore.
            #   when unwound all the way back to the origin (id == ""), check
            #       if all other eligible directions have been checked
            #           if not, move in that new direction
            #           else you're done -- break out of the loop and calculate the final distances.
            # Be careful on how you save the grid state here.
            ##### restore_grid_state(current_id)


        # Force a 'stuck'--the loop only ends once the coordinates are stuck at the origin
        if(coords["row"] == row_end && coords["col"] == col_end){
            print "winner winner chicken dinner"
            grid[coords["row"], coords["col"]] = 0
            # success case here -- this should probably get lumped in with the stuck block
            # Perhaps you should add a value to the grid signifying that you've completed the maze
        }


        printf "%s (%d, %d)\n", id, coords["row"], coords["col"]
        print_grid()
   }


        # When you complete the puzzle
        #   you need to mark that grid ID as complete
        #   you need to then rewind to the next eligible ID
        #
        # When you get stuck
        #   you need to mark the current position as stuck
        #   you need to rewind the to the next eligible ID
        #
        # When you are able to move (DONE)
        #   go in the direction with the highest priority and continue

        # CHALLENGES:
        #   How will you know the ID to wind back to after reaching the end or getting stuck?
        #       you pull back one character from the 'id', preventing the move in the direction you just checked, until you are either
        #           no longer stuck
        #           no longer have places to move
        #
        #  How will you know when you don't have any more places to move?
        #       The id unwinds all the way back to the very first movement and
        #           the up direction has either been checked (if that slot has a 1) or is ineligible
        #           the down direction has either beend checked (if that slot has a 1) or is ineligible
        #           ...
        #               you can check for the presence of these values in this manner:
        #                   "u" in used_ids && can_move_up <---- be mindful of side effects when using the can_move functions!
        #                   "d" in used_ids
        #                   "l" in used_ids
        #                   "r" in used_ids


}


function pop_id(){
    most_recent_value = substr(id, length(id))
    if(length(id) == 1){
        id = ""
    } else {
        id = substr(id, 1, length(id) - 1)
    }
    return(most_recent_value)
}


# Effectively resets the values of the grid to safely edit its contents
function construct_grid(){
    for(coordinates in original_grid){
        grid[coordinates] = original_grid[coordinates]
    }
}
# For preserving intermediate copies of the working grid
function save_grid_state(grid_id){
    for(i = 1; i <= numrows; i++){
        for(j = 1; j <= numcolumns; j++){
            grid_copies[grid_id, i, j] = grid[i, j]
        }
    }
}
function restore_grid_state(grid_id){
    for(i = 1; i <= numrows; i++){
        for(j = 1; j <= numcolumns; j++){
            grid[i, j] = grid_copies[grid_id, i, j]
        }
    }
}
# Print it out!
function print_grid(){
    for(i = 1; i <= numrows; i++){
        for(j = 1; j <= numcolumns; j++){
            if(print_current_position_in_grid && i == coords["row"] && j == coords["col"]){
                printf "%4s", "X "
            } else {
                printf "%4s ", grid[i, j]
            }
        }
        print ""
    }
    print ""
}
function print_coordinate_system(){
    for(i = 1; i <= numrows; i++){
        for(j = 1; j <= numcolumns; j++){
            printf "(%d, %d) ", i, j
        }
        print ""
    }
    print ""
}

# Conditions for moving:
#   The value is in bounds
#   The coordinate has not yet been visited
#   The current position has the correct marker for moving in that direction
# Be mindful of causing side-effects on the grid
function mark_move_up(){# 1000 means you can move up
    can_move = row > 1
    if(can_move){
        height_of_current_position = heights[original_grid[row, col]]
        height_of_upward_position = heights[original_grid[row - 1, col]]
        can_move = (height_of_current_position + 1) >= height_of_upward_position
    }
    return(1000 * can_move)
}
function mark_move_down(){# 100 means you can move down
    can_move = row < numrows
    if(can_move){
        height_of_current_position = heights[original_grid[row, col]]
        height_of_below_position = heights[original_grid[row + 1, col]]
        can_move = (height_of_current_position + 1) >= height_of_below_position
    }
    return(100 * can_move)
}
function mark_move_left(){# 10 means you can move left
    can_move = col > 1
    if(can_move){
        height_of_current_position = heights[original_grid[row, col]]
        height_of_leftward_position = heights[original_grid[row, col - 1]]
        can_move = (height_of_current_position + 1) >= height_of_leftward_position
    }
    return(10 * can_move)
}
function mark_move_right(){# 1 means you can move right
    can_move = col < numcolumns
    if(can_move){
        height_of_current_position = heights[original_grid[row, col]]
        height_of_rightward_position = heights[original_grid[row, col + 1]]
        can_move = (height_of_current_position + 1) >= height_of_rightward_position
    }
    return(can_move)
}
function can_move_up(row, col){
    return(grid[row, col] >= 1000)
}
function can_move_down(row, col){
    val = grid[row, col]
    val = val % 1000
    return(val >= 100)
}
function can_move_left(row, col){
    val = grid[row, col]
    val = val % 1000
    val = val % 100
    return(val >= 10)
}
function can_move_right(row, col){
    return(grid[row, col] % 2 == 1)
}
function identify_preferred_move(){
    # If the point's value is zero, prevent the algo from moving to it by supplying a disqualifyingly large distance.
    pretty_big_number = 10000000000000
    distance_from_end["up"] = distance_from_end["down"] = distance_from_end["left"] = distance_from_end["right"] = pretty_big_number
    if(can_move_up(coords["row"], coords["col"])){
        distance_from_end["up"] =    euclidean_distance(coords["row"] - 1, coords["col"], row_end, col_end) + ((grid[coords["row"] - 1, coords["col"]] == 0) * pretty_big_number)
    }
    if(can_move_down(coords["row"], coords["col"])){
        distance_from_end["down"] =  euclidean_distance(coords["row"] + 1, coords["col"], row_end, col_end) + ((grid[coords["row"] + 1, coords["col"]] == 0) * pretty_big_number)
    }
    if(can_move_left(coords["row"], coords["col"])){
        distance_from_end["left"] =  euclidean_distance(coords["row"], coords["col"] - 1, row_end, col_end) + ((grid[coords["row"], coords["col"] - 1] == 0) * pretty_big_number)
    }
    if(can_move_right(coords["row"], coords["col"])){
        distance_from_end["right"] = euclidean_distance(coords["row"], coords["col"] + 1, row_end, col_end) + ((grid[coords["row"], coords["col"] + 1] == 0) * pretty_big_number)
    }
    # Identify the direction that gets us closest to the end point
    minimum_distance = distance_from_end["up"]
    for(direction in distance_from_end){
        if(minimum_distance >= distance_from_end[direction]){
            minimum_distance = distance_from_end[direction]
            preferred_direction = direction
        }
    }
    # Handle cases where no moves are possible
    if(minimum_distance >= pretty_big_number){
        preferred_direction = "stuck"
    }
    return(preferred_direction)
}


function euclidean_distance(x1, y1, x2, y2){
    x_term = (x1 - x2) * (x1 - x2)
    y_term = (y1 - y2) * (y1 - y2)
    dist = sqrt(x_term + y_term)
    return(dist)
}
