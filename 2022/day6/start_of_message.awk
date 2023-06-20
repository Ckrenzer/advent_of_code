#!/usr/bin/awk -f


BEGIN{
    FS = ""
}

{
    for(current_field = 14; current_field <= NF; current_field++){
        load_contents_of_stream()
        if(check_for_uniqueness() == 0){
            print current_field
            next
        }
    }
}


# check for uniqueness of the 14 elements
function check_for_uniqueness() {
    for(k = 14; k > 1; k--){
        for(m = (k - 1); m >= 1; m--){
            if(vals[k] == vals[m]) return(1) # FAILURE!
        }
    }
    return(0)
}
# Load in the previous 14 values from the stream
function load_contents_of_stream() {
    vals[14] = $current_field
    for(k = 1; k < 14; k++){
        vals[k] = $(current_field - k)
    }
}
