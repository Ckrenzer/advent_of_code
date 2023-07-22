#!/usr/bin/awk -f

BEGIN{
    # A 'rock'
    values["A"] = 1
    # B for 'paper'
    values["B"] = 2
    # C for 'scissors'
    values["C"] = 3

    counters["A"] = "B"
    counters["B"] = "C"
    counters["C"] = "A"
}

{
    opponent_value = values[$1]

    # X means 'lose'
    # The choice countering the counter to the opponent's move will always lose
    my_value = values[counters[counters[$1]]]
    # Y means 'draw'
    if($2 == "Y"){
        my_value = opponent_value
    } else if($2 == "Z"){
        # Z means 'win'
        my_value = values[counters[$1]]
    }
    # You always earn the value of your draw
    # 0 points for a loss, 3 points for a draw, 6 points for a win
    total_score += my_value + ((my_value == opponent_value) * 3) + ((my_value == 1 && opponent_value == 3 || my_value == 2 && opponent_value == 1 || my_value == 3 && opponent_value == 2) * 6)
}

ENDFILE{
    print "Final score:", total_score
    total_score = 0
}
