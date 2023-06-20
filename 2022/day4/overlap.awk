#!/usr/bin/awk -f

BEGIN{
    FS = ","
}

{
    split($1, range1, "-")
    split($2, range2, "-")

    # Used to order the ranges--min1 and max1 correspond to the range with the highest max
    first_max_is_greater = ((range1[2] - range2[2]) > 0)
    min1 = (first_max_is_greater  * range1[1]) + (!first_max_is_greater * range2[1])
    max1 = (first_max_is_greater  * range1[2]) + (!first_max_is_greater * range2[2])
    min2 = (!first_max_is_greater * range1[1]) + (first_max_is_greater  * range2[1])
    max2 = (!first_max_is_greater * range1[2]) + (first_max_is_greater  * range2[2])

    # is the min for 1 greater than the max for 2?
    overlaps += ((min1 - max2) <= 0)
    # You would use this to figure out the total number of intersections between the two ranges
    #for(i = (min1 - max2); i <= 0; i++){
        #overlaps++
    #}
}

END{
    print "The number of ranges with overlaps:", overlaps
}
