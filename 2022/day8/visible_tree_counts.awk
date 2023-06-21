#!/usr/bin/awk -f

# Count the number of visible trees!
# An interesting exercise would be solving this puzzle without storing
# the entire data set in RAM.

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
    for(row_of_trees = 2; row_of_trees < NR; row_of_trees++){
        for(column_of_trees = 2; column_of_trees < NF; column_of_trees++){
            tree = forest[row_of_trees, column_of_trees]
            number_of_visible_trees += !(tree_is_hidden_from_north() && tree_is_hidden_from_south() && tree_is_hidden_from_east() && tree_is_hidden_from_weast())
        }
    }
    # Add the trees on the perimeter
    number_of_visible_trees += ((NF * 2) + ((NR * 2) - 4))
    print "Number of visible trees:", number_of_visible_trees
}

# I know that in a previous day I returned 0 for success and 1 for failure only to invert it here...
# Do I treat success like exit codes, or do I treat success like the result of the if statement?
# A true moral dilemma.
# I went with 1-means-success in this case because it plays nicely with logical operators.
function tree_is_hidden_from_north(){
    for(i = row_of_trees - 1; i >= 1; i--){
        if(tree <= forest[i, column_of_trees]) return(1)
    }
    return(0)
}
function tree_is_hidden_from_south(){
    for(i = row_of_trees + 1; i <= NR; i++){
        if(tree <= forest[i, column_of_trees]) return(1)
    }
    return(0)
}
function tree_is_hidden_from_east(){
    for(j = column_of_trees - 1; j >= 1; j--){
        if(tree <= forest[row_of_trees, j]) return(1)
    }
    return(0)
}
function tree_is_hidden_from_weast(){ # That's WEST, Patrick
    for(j = column_of_trees + 1; j <= NF; j++){
        if(tree <= forest[row_of_trees, j]) return(1)
    }
    return(0)
}
