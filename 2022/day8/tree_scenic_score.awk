#!/usr/bin/awk -f


BEGIN{
    FS = ""
}

# store the values in a data structure
{
    for(i = 1; i <= NF; i++){
        forest[NR, i] = $i
    }
}

END{
    # Count the number of interior trees that are visible
    for(row_of_trees = 1; row_of_trees <= NR; row_of_trees++){
        for(column_of_trees = 1; column_of_trees <= NF; column_of_trees++){
            tree = forest[row_of_trees, column_of_trees]
            current_score = number_of_trees_visible_to_north() * \
                            number_of_trees_visible_to_south() * \
                            number_of_trees_visible_to_east() * \
                            number_of_trees_visible_to_west()
            if(current_score > max_score) max_score = current_score
        }
    }
    # Add the trees on the perimeter
    print "Highest scenic score:", max_score
}

# This really should have been generalized to use a single function
function number_of_trees_visible_to_north(){
    num_trees = 0
    for(i = row_of_trees - 1; i >= 1; i--){
        num_trees++
        if(tree <= forest[i, column_of_trees]) return(num_trees)
    }
    return(num_trees)
}
function number_of_trees_visible_to_south(){
    num_trees = 0
    for(i = row_of_trees + 1; i <= NR; i++){
        num_trees++
        if(tree <= forest[i, column_of_trees]) return(num_trees)
    }
    return(num_trees)
}
function number_of_trees_visible_to_east(){
    num_trees = 0
    for(j = column_of_trees - 1; j >= 1; j--){
        num_trees++
        if(tree <= forest[row_of_trees, j]) return(num_trees)
    }
    return(num_trees)
}
function number_of_trees_visible_to_west(){
    num_trees = 0
    for(j = column_of_trees + 1; j <= NF; j++){
        num_trees++
        if(tree <= forest[row_of_trees, j]) return(num_trees)
    }
    return(num_trees)
}
