#!/usr/bin/awk -f

BEGIN{
    # a-z gets priorities 1-26
    for(n = 97; n <= 122; n++){
        letter_values[sprintf("%c", n)] = n - 96
    }
    # A-Z gets priorities 27-52
    for(n = 65; n <= 90; n++){
        letter_values[sprintf("%c", n)] = n - 38  # 38 == (64 - 26)
    }
}

# Find the sum of all priorities of items appearing in each group of three
FNR % 3 == 1 { split($0,  first_elf_items,  "") }
FNR % 3 == 2 { split($0,  second_elf_items,  "") }
FNR % 3 == 0 {
    split($0,  third_elf_items,  "")
    # 'empty' out the array
    for(k in matches){
        delete matches[k]
    }

    # find the match between the first and second elves
    for(ind1 in first_elf_items){
        item1 = first_elf_items[ind1]
        for(ind2 in second_elf_items){
            item2 = second_elf_items[ind2]
            if(item1 == item2){
                matches[item1]
            }
        }
    }
    # find the match between the first and third elves, summing the priority when found
    for(item1 in matches){
        for(ind3 in third_elf_items){
            item3 = third_elf_items[ind3]
            if(item1 == item3){
                matched_priority_sum += letter_values[item1]
                next
            }
        }
    }
}

ENDFILE{
    print "Sum of all badge priorities:", matched_priority_sum
    matched_priority_sum = 0
}
