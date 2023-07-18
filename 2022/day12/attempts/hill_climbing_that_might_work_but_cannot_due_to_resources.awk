#!/usr/bin/awk -f

BEGIN{
    FS = ""
    enable_printing = 0
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
    FS = " "
    pretty_big_number = 10000000000000
    coords["row"] = row_start
    coords["col"] = col_start
    numrows = NR
    numcolumns = NF
    # a-z get priorities 1-26
    for(n = 97; n <= 122; n++){
        heights[sprintf("%c", n)] = n - 96
    }
    heights["S"] = heights["a"]
    heights["E"] = heights["z"]
    construct_grid()
    for(ind in grid){
        grid_copy[ind] = grid[ind]
    }

    if(enable_printing){
        print "The coordinate system:"
        print_coordinate_system()
        print "The original grid with the values replaced by movement markers:"
        print_grid()
    }
    id = "_"
    ####save_grid_state(id)
    while(1){
        move = identify_preferred_move()
        if(enable_printing) { print move }
        if(move == "up"){
            id = id "u"; used_ids[id]
            coords["row"]-- # decrement because that's the way the grid loads
            if(can_move_down(coords["row"], coords["col"])){      # Prevent movement to the previous position (down)
                grid[coords["row"], coords["col"]] -= 100
            }
            prevent_adjacent_elements_from_moving_to_current_position()
            ####save_grid_state(id)

        } else if(move == "down"){
            id = id "d"; used_ids[id]
            coords["row"]++ # increment because that's the way the grid loads
            if(can_move_up(coords["row"], coords["col"])){        # Prevent movement to the previous position (up)
                grid[coords["row"], coords["col"]] -= 1000
            }
            prevent_adjacent_elements_from_moving_to_current_position()
            ####save_grid_state(id)

        } else if(move == "left"){
            id = id "l"; used_ids[id]
            coords["col"]--
            if(can_move_right(coords["row"], coords["col"])){     # Prevent movement to the previous position (right)
                grid[coords["row"], coords["col"]] -= 1
            }
            prevent_adjacent_elements_from_moving_to_current_position()
            ####save_grid_state(id)

        } else if(move == "right"){
            id = id "r"; used_ids[id]
            coords["col"]++
            if(can_move_left(coords["row"], coords["col"])){      # Prevent movement to the previous position (left)
                grid[coords["row"], coords["col"]] -= 10
            }
            prevent_adjacent_elements_from_moving_to_current_position()
            ####save_grid_state(id)

        } else if(move == "stuck"){
            delete used_ids["_"]
            unwind_to_previous_state()
            if(enable_printing) { printf "last_move: <<%s>>\n", last_move }
            # If you made your way back to the starting point, see which paths remain
            if(coords["row"] == row_start && coords["col"] == col_start && identify_preferred_move() == "stuck"){
                break
            }
       }
       # Force a 'stuck'--the loop only ends once the coordinates are stuck at the origin
       if(coords["row"] == row_end && coords["col"] == col_end){
           if(enable_printing) { print "winner winner chicken dinner" }
           grid[coords["row"], coords["col"]] = 0
           winning_ids[id]
       }
        if(enable_printing) { printf "%s (%d, %d)\n", id, coords["row"], coords["col"] }
        print_grid()
   }
   winning_length = pretty_big_number
   for(winning_id in winning_ids){
       print "A winning ID was found: ", winning_id
       id_length = length(winning_id)
       if(id_length < winning_length){
           winning_length = id_length
       }
   }
   winning_length = winning_length - 1 # The leading underscore does not correspond to a move
   print "winning length:", winning_length
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
function unwind_to_previous_state(){
    last_move = pop_id()
    restore_grid_state(id)
    # Move the coordinates back to the previous location
    ####coords["row"] += (last_move == "u") - (last_move == "d")
    ####coords["col"] += (last_move == "l") - (last_move == "r")
    # Prevent the last direction you moved to from being an option on the unwound grid
    grid[coords["row"], coords["col"]] -= (1000 * (last_move == "u")) + (100 * (last_move == "d")) + (10 * (last_move == "l")) + (last_move == "r")
}


# Initializes the grid
function construct_grid(){
    for(coordinates in original_grid){
        grid[coordinates] = original_grid[coordinates]
    }
    print_grid() # The 'unedited' grid
    # The grid with markers indicating where each space can move
    for(row = 1; row <= numrows; row++){
        for(col = 1; col <= numcolumns; col++){
            if(row != row_end || col != col_end){
                grid[row, col] = mark_move_up() + mark_move_down() + mark_move_left() + mark_move_right()
            }
        }
    }
}
# For preserving intermediate copies of the working grid
###### This implementation failed because RAM requirements became too great
####function save_grid_state(grid_id){
####    for(i = 1; i <= numrows; i++){
####        for(j = 1; j <= numcolumns; j++){
####            grid_copies[grid_id, i, j] = grid[i, j]
####        }
####    }
####}
####function restore_grid_state(grid_id){
####    for(i = 1; i <= numrows; i++){
####        for(j = 1; j <= numcolumns; j++){
####            grid[i, j] = grid_copies[grid_id, i, j]
####        }
####    }
####}
#
#### This failed due to 'no more space on disk' errors (despite not being out of disk space--something internal must be the cause)
####function save_grid_state(grid_id){
####    fname = "grid_states/" grid_id ".txt"
####    system("[ -e " fname " ] && rm " fname)
####    for(i = 1; i <= numrows; i++){
####        for(j = 1; j <= numcolumns; j++){
####            printf "%4s ", grid[i, j] >> fname
####        }
####        print "" >> fname
####    }
####    close(fname)
####}
####function restore_grid_state(grid_id){
####    fname = "grid_states/" grid_id ".txt"
####    for(i = 1; i <= numrows; i++){
####        getline < fname
####        for(j = 1; j <= numcolumns; j++){
####            grid[i, j] = $j
####        }
####    }
####    close(fname)
####}
#
# The solution to work around both of the above issues is to reconstruct the grid from the origin using the id
function restore_grid_state(grid_id){
    for(ind in grid_copy){
        grid[ind] = grid_copy[ind]
    }
    split(grid_id, movements, "")
    coords["row"] = row_start
    coords["col"] = col_start
    for(movements_ind = 2; movements_ind <= length(movements); movements_ind++){
        movement = movements[movements_ind]
        if(movement == "u"){
            coords["row"]-- # decrement because that's the way the grid loads
            if(can_move_down(coords["row"], coords["col"])){      # Prevent movement to the previous position (down)
                grid[coords["row"], coords["col"]] -= 100
            }
            prevent_adjacent_elements_from_moving_to_current_position()

        } else if(movement == "d"){
            coords["row"]++ # increment because that's the way the grid loads
            if(can_move_up(coords["row"], coords["col"])){        # Prevent movement to the previous position (up)
                grid[coords["row"], coords["col"]] -= 1000
            }
            prevent_adjacent_elements_from_moving_to_current_position()

        } else if(movement == "l"){
            coords["col"]--
            if(can_move_right(coords["row"], coords["col"])){     # Prevent movement to the previous position (right)
                grid[coords["row"], coords["col"]] -= 1
            }
            prevent_adjacent_elements_from_moving_to_current_position()

        } else if(movement == "r"){
            coords["col"]++
            if(can_move_left(coords["row"], coords["col"])){      # Prevent movement to the previous position (left)
                grid[coords["row"], coords["col"]] -= 10
            }
            prevent_adjacent_elements_from_moving_to_current_position()
        }
    }
}

function print_grid(){
    if(enable_printing){
        for(i = 1; i <= numrows; i++){
            for(j = 1; j <= numcolumns; j++){
                if(i == coords["row"] && j == coords["col"]){
                    printf "%4sx ", grid[i, j]
                } else {
                    printf "%5s ", grid[i, j]
                }
            }
            print ""
        }
        print ""
    }
}
function print_coordinate_system(){
    if(enable_printing){
        for(i = 1; i <= numrows; i++){
            for(j = 1; j <= numcolumns; j++){
                printf "(%d, %d) ", i, j
            }
            print ""
        }
        print ""
    }
}

# Conditions for moving:
#   The value is in bounds
#   The coordinate has not yet been visited (the move is part of a unique ID)
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
        potential_next_id = id "" substr(direction, 1, 1)
        if(minimum_distance >= distance_from_end[direction] && !(potential_next_id in used_ids)){
            minimum_distance = distance_from_end[direction]
            preferred_direction = direction
        }
    }
    # Handle cases where no moves are possible
    if(grid[coords["row"], coords["col"]] == 0 || minimum_distance >= pretty_big_number){
        preferred_direction = "stuck"
    }
    return(preferred_direction)
}
# Being careful to not adjust the end position, of course.
function prevent_adjacent_elements_from_moving_to_current_position(){
    above_position_exists     = coords["row"] > 1
    below_position_exists     = coords["row"] < numrows
    leftward_position_exists  = coords["col"] > 1
    rightward_position_exists = coords["col"] < numcolumns
    if(below_position_exists){# Prevent upward movement of the element below
        below_position_is_able_to_move_up = can_move_up(coords["row"] + 1, coords["col"])
        below_position_is_not_end_position = !((coords["row"] + 1) == row_end && coords["col"] == col_end)
        if(below_position_is_not_end_position && below_position_is_able_to_move_up){
            grid[coords["row"] + 1, coords["col"]] -= 1000
        }
    }
    if(above_position_exists){# Prevent downward movement of the element above
        above_position_is_able_to_move_down = can_move_down(coords["row"] - 1, coords["col"])
        above_position_is_not_end_position = !((coords["row"] - 1) == row_end && coords["col"] == col_end)
        if(above_position_is_not_end_position && above_position_is_able_to_move_down){
            grid[coords["row"] - 1, coords["col"]] -= 100
        }
    }
    if(rightward_position_exists){# Prevent leftward movement of the element to the right
        right_position_is_able_to_move_left = can_move_left(coords["row"], coords["col"] + 1)
        right_position_is_not_end_position = !(coords["row"] == row_end && (coords["col"] + 1) == col_end)
        if(right_position_is_not_end_position && right_position_is_able_to_move_left){
            grid[coords["row"], coords["col"] + 1] -= 10
        }
    }
    if(leftward_position_exists){# Prevent rightward movement of the element to the left
        left_position_is_able_to_move_right = can_move_right(coords["row"], coords["col"] - 1)
        left_position_is_not_end_position = !(coords["row"] == row_end && (coords["col"] - 1) == col_end)
        if(left_position_is_not_end_position && left_position_is_able_to_move_right){
            grid[coords["row"], coords["col"] - 1] -= 1
        }
    }
}

function euclidean_distance(x1, y1, x2, y2){
    x_term = (x1 - x2) * (x1 - x2)
    y_term = (y1 - y2) * (y1 - y2)
    dist = sqrt(x_term + y_term)
    return(dist)
}
