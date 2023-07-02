#!/usr/bin/awk -f


# I cheated on this one. The take-the-modulus-of-the-worry-score-using-the-product-of-the-monkey-divisors
# solution was a bit of a reach for me. I feel dirty now.
# But, before resorting to cheating, I tried using GAWK's --bignum flag.
# Some say GAWK is calculating worry scores to this day.

/^Monkey/{
    # Monkey name
    current_monkey = substr($2, 1, 1)
    monkey_names[current_monkey] # This will contain the number of items inspected by each monkey

    # Starting items
    getline
    monkey_items[current_monkey] = substr($0, 19)
    gsub(" ", "", monkey_items[current_monkey])

    # Operation
    getline
    if($NF == "old"){
        monkey_operations[current_monkey] = "**"
        monkey_operation_values[current_monkey] = 2
    } else {
        monkey_operations[current_monkey] = $(NF - 1)
        monkey_operation_values[current_monkey] = $NF
    }

    # Test condition
    getline
    monkey_divisors[current_monkey] = $NF

    # Recipient monkey
    getline
    success_recipients[current_monkey] = $NF
    getline
    failure_recipients[current_monkey] = $NF
}

END{
    divisor_product = 1
    for(monkey in monkey_divisors){
        divisor_product *= monkey_divisors[monkey]
    }
    for(round = 1; round <= 10000; round++){
        for(monkey in monkey_names){
            split(monkey_items[monkey], items, ",")
            monkey_items[monkey] = ""
            if(items[1] == ""){
                continue
            }
            monkey_names[monkey] += length(items)
            for(item in items){# Order is importatnt here--split() creates the indices in ascending order
                item_removal_pattern = ",?" items[item]
                # Monkey inspection
                if(monkey_operations[monkey] == "+"){
                     items[item] += monkey_operation_values[monkey]
                } else if(monkey_operations[monkey] == "*"){
                     items[item] *= monkey_operation_values[monkey]
                } else if(monkey_operations[monkey] == "**"){
                     items[item] **= monkey_operation_values[monkey]
                }
                items[item] %= divisor_product # Monkey cheese...
                # Monkey test
                recipient = (items[item] % monkey_divisors[monkey] == 0) ? recipient = success_recipients[monkey] : recipient = failure_recipients[monkey]
                # Monkey throw
                monkey_items[recipient] = monkey_items[recipient] == "" ? items[item] : monkey_items[recipient] "," items[item]
            }
        }
    }
    # Monkey business
    for(monkey in monkey_names){
        printf "Monkey %s investigated %d items\n", monkey, monkey_names[monkey]
        if(monkey_names[monkey] > max1){
            max2 = max1
            max1 = monkey_names[monkey]
        } else if(monkey_names[monkey] > max2){
            max2 = monkey_names[monkey]
        }
    }
    printf "Level of monkey business: %f\n", max1 * max2
}

