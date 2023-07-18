#!/usr/bin/awk -f

BEGIN{
    FS = ""
    # a-z get priorities 1-26
    for(n = 97; n <= 122; n++){
        heights[sprintf("%c", n)] = n - 96
    }
    heights["S"] = heights["a"]
    heights["E"] = heights["z"]
}

# Load the grid into a data structure
{
    row_current = NR
    for(col_current = 1; col_current <= NF; col_current++){
        value = $col_current
        grid[row_current, col_current] = heights[value]
        if(value == "E"){
            col_start = col_current
            row_start = row_current
        }
    }
}

END{
    priority = 1
    idstring = priority ";0;" row_start ";" col_start
    split(idstring, id_info, ";")
    coordstring = id_info[3] ";" id_info[4]
    q[idstring] = 0
    checked_coordinates[coordstring]
    while(length(q) > 0){
        # Pop off the queue
        idstring = determine_highest_priority_id()
        split(idstring, id_info, ";")
        current_distance = id_info[2] + 1
        row = id_info[3]
        col = id_info[4]
        delete q[idstring]
        # check up, down, left, right
        for(direction_ind = 1; direction_ind <= 4; direction_ind++){
            row_to_check = row + (direction_ind == 1) - (direction_ind == 2)
            col_to_check = col + (direction_ind == 3) - (direction_ind == 4)

            priority++
            idstring = priority ";" current_distance ";" row_to_check ";" col_to_check
            split(idstring, id_info, ";")
            current_distance = id_info[2]
            coordstring = id_info[3] ";" id_info[4]

            # Ensure the node is in bounds
            if(row_to_check < 1  || \
               row_to_check > NR || \
               col_to_check < 1  || \
               col_to_check > NF){
                   continue
            }
            # Ensure the node has not already been visited
            if(coordstring in checked_coordinates){
                continue
            }
            # Ensure the node meets movement rules
            if(grid[row, col] - grid[row_to_check, col_to_check] > 1){
                continue
            }
            # Check whether you've reached the end
            if(grid[row_to_check, col_to_check] == heights["a"]){
                print current_distance
                exit(0)
            }
            checked_coordinates[coordstring]
            q[idstring]
        }
   }
}

function determine_highest_priority_id(){
    top_priority = 100000000000
    for(ind in q){
        priority_value = substr(ind, 1, index(ind, ";") - 1) + 0
        if(priority_value < top_priority){
            top_priority = priority_value
        }
    }
    top_priority_pattern = "^" top_priority ";"
    for(ind in q){
        if(ind ~ top_priority_pattern){
            return(ind)
        }
    }
}
