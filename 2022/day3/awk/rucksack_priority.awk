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

# Find items that appear in both compartment types
# Find the sum of all the priorities of these matched items
{
    # 'empty' out the array
    for(k in matches){
        delete matches[k]
    }
    number_of_items_in_rucksack = length($0)
    first_compartment =  substr($0, 1, number_of_items_in_rucksack / 2)
    second_compartment = substr($0, (number_of_items_in_rucksack / 2) + 1)
    split(first_compartment,  items_in_first_compartment,  "")
    split(second_compartment, items_in_second_compartment, "")

    for(ind1 in items_in_first_compartment){
        item1 = items_in_first_compartment[ind1]
        for(ind2 in items_in_second_compartment){
            item2 = items_in_second_compartment[ind2]
            if(item1 == item2 && !(item1 in matches)){# keeping `matches` around to prevent matching more than once
                matches[item1]
                matched_priority_sum += letter_values[item1]
            }
        }
    }
}

ENDFILE{
    print "Sum of all priority items found in both compartments:", matched_priority_sum
    matched_priority_sum = 0
}
