#!/usr/bin/awk -f


BEGIN{
    FS = ""
}

{
    for(i = 4; i <= NF; i++){
        three_behind = $(i - 3)
        two_behind = $(i - 2)
        one_behind = $(i - 1)
        current = $i

        current_is_unique = (current != one_behind && current != two_behind && current != three_behind)
        one_behind_is_unique = (one_behind != two_behind && one_behind != three_behind)
        two_behind_is_unique = (two_behind != three_behind)
        is_start_of_packet_marker = current_is_unique && one_behind_is_unique && two_behind_is_unique

        if(is_start_of_packet_marker){
            print i
            next
        }
    }
}

