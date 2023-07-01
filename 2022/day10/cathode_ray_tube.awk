#!/usr/bin/awk -f

BEGIN{
    number_of_cycles_to_complete["noop"] = 1
    number_of_cycles_to_complete["addx"] = 2
    numcycles = 1
    registerval = 1

    PIXEL_WIDTH = 40
    PIXEL_HEIGHT = 6
    pixelrow = 1
}

{
    operation = $1
    increment = $2 # $2 is implicitly zero when a second field does not exist
    for(i = 1; i <= number_of_cycles_to_complete[operation]; i++){
        distance = registerval - ((numcycles - 1) - (PIXEL_WIDTH * (pixelrow - 1)))
        if(distance >= -1 && distance <= 1){
            pixels[numcycles - 1] = "#"
        } else {
            pixels[numcycles - 1] = "."
        }

        if( (numcycles == 20) || (((numcycles - 20) % 40) == 0) ){
            signal_strength[numcycles] = registerval * numcycles
        }
        pixelrow += numcycles % PIXEL_WIDTH == 0
        numcycles++
    }
    registerval += increment
}

END{
    for(ind in signal_strength){
        signal_strength_sum += signal_strength[ind]
    }
    printf "Sum of important signal strenghts: %f\n", signal_strength_sum

    for(k = 0; k < (PIXEL_WIDTH * PIXEL_HEIGHT); k++){
        printf "%2s", pixels[k]
        if(((k + 1) % 40) == 0){
            print ""
        }
    }
}
