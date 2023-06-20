#!/usr/bin/awk -f

# A near-complete copy+paste of crates.awk--all that needed changing is the order by which crates are moved
# (from the 'bottom' crate to the 'top' crate instead of acting like a stack).
# Only the 'from' process changes. The 'to' portion is identical.
# The problems noted in crate.awk also apply here.


BEGIN{
    FOUR_SPACES = "    "
}

# collect info about stacks
NR == 1{
    # +1 to represent a space after the last stack's ]
    linelength = length($0) + 1
    # 3 characters for each crate, 1 character for the space between stacks
    numstacks = (linelength) / 4
}

# Load the stacks into a data structure
/\[/ {
    numrecords = NR
    # distinguish spaces between crates from spaces representing stacks without a crate in that position
    for(i = 4; i < linelength; i += 4){
        if(substr($0, i, 4) == FOUR_SPACES){
            $0 = substr($0, 1, i) "[_] " substr($0, i + 5)
        }
    }
    split($0, stack_row, " ")
    # add the crate to the multidimensional array
    for(column in stack_row){
        stack_data[NR,column] = stack_row[column]
    }
}

# This empty line from the input file separates the data from the actions,
# so it makes for a natural place to print the original data.
$0 == "" { print_stack_data() }

# Perform actions
/^move/ {
    quantity = $2
    from = $4
    to = $6
    destination = find_row_with_top_crate(stack_data, to)
    for(i = 1; i <= quantity; i++){
        destination--
        if(destination == 0) resize_stack_data()
        position_of_first_crate_to_move = find_row_with_top_crate(stack_data, from) + quantity - i #### <---- THIS IS THE ONLY LINE OF CODE THAT CHANGED BETWEEN SCENARIOS 1 AND 2
        # see the action you're taking as it happens
        printf "\nmoving stack_data[%d,%d] <<%s>> to stack_data[%d,%d] <<%s>>\n", \
               position_of_first_crate_to_move, from, stack_data[position_of_first_crate_to_move, from], \
               destination, to, stack_data[destination, to]
        stack_data[destination, to] = stack_data[position_of_first_crate_to_move, from]
        stack_data[position_of_first_crate_to_move, from] = "[_]"
        print_stack_data()
    }
}

END{
    print "\n\nThe final matrix:"
    print_stack_data()
}


function find_row_with_top_crate(crates, col_to_check) {
    for(k = 1; k <= numrecords; k++){
        if(stack_data[k, col_to_check] != "[_]"){
            return(k)
        }
    }
    return(numrecords)
}
# Add a new level if the move expands the height of the stack
# (copy every element to the 'next row down')
function resize_stack_data(){
    print "resizing array!!"
    for(k = numrecords; k >= 1; k--){
        for(j = 1; j <= numstacks; j++){
            stack_data[k + 1, j] = stack_data[k, j]
            if(k == 1){
                stack_data[k, j] = "[_]"
            }
        }
    }
    destination = 1
    numrecords++
}
# print out the stacks
function print_stack_data(){
    for(k = 1; k <= numrecords; k++){
        printf "%5d ", k
        for(j = 1; j <= numstacks; j++){
            printf "%s ", stack_data[k,j]
        }
        print ""
    }
    printf "%s  ", FOUR_SPACES
    for(j = 1; j<= numstacks; j++){
        printf " %d  ", j
    }
    print ""
}
