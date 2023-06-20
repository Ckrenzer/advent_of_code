#!/usr/bin/awk -f

# Find which elf has the most calories
# blank lines separate the colories of different elves
#
# This implementation fails if there is more than one newline
# between elves (implicit zero calories carried by a given elf)
BEGIN{ elf_index = 1 }

$0 == "" {

    elf_index++
    current_elf_calories = 0
    next

}

{

    current_elf_calories += $1
    if(current_elf_calories > highest_elf_calories){

        third_highest_elf_calories = second_highest_elf_calories
        second_highest_elf_calories = highest_elf_calories
        highest_elf_calories = current_elf_calories

        elf_with_third_most_calories = elf_with_second_most_calories
        elf_with_second_most_calories = elf_with_most_calories
        elf_with_most_calories = elf_index

    } else if(current_elf_calories > second_highest_elf_calories){

        third_highest_elf_calories = second_highest_elf_calories
        second_highest_elf_calories = current_elf_calories

        elf_with_third_most_calories = elf_with_second_most_calories
        elf_with_second_most_calories = elf_index

    } else  if(current_elf_calories > third_highest_elf_calories){

        third_highest_elf_calories = current_elf_calories
        elf_with_third_most_calories = elf_index

    }

}

END{

    print "Elf with the third most calories:", elf_with_third_most_calories, "(" third_highest_elf_calories,  "calories)"
    print "Elf with the second most calories:", elf_with_second_most_calories, "(" second_highest_elf_calories,  "calories)"
    print "Elf with the most calories:", elf_with_most_calories, "(" highest_elf_calories,  "calories)"
    print "Sum of calories for the top three elves:", highest_elf_calories + second_highest_elf_calories + third_highest_elf_calories, "calories."

}
