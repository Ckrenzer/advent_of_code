#!/usr/bin/awk -f

# Find which elf has the most calories
# blank lines separate the colories of different elves
#
# This implementation fails if there is more than one newline
# between elves (implicit zero calories carried by a given elf)
{
    current_elf_calories += $1
}

$0 == "" {
    if(current_elf_calories > highest_elf_calories){
        third_highest_elf_calories = second_highest_elf_calories
        second_highest_elf_calories = highest_elf_calories
        highest_elf_calories = current_elf_calories
    } else if(current_elf_calories > second_highest_elf_calories){
        third_highest_elf_calories = second_highest_elf_calories
        second_highest_elf_calories = current_elf_calories
    } else if(current_elf_calories > third_highest_elf_calories){
        third_highest_elf_calories = current_elf_calories
    }
    current_elf_calories = 0
}

END{
    print "Third most calories:", third_highest_elf_calories
    print "Second most calories:", second_highest_elf_calories
    print "Most calories:", highest_elf_calories
    print "Sum of calories for the top three elves:", highest_elf_calories + second_highest_elf_calories + third_highest_elf_calories, "calories."
}
