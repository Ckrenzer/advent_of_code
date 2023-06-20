#!/usr/bin/awk -f

BEGIN{
    # A, X for 'rock'
    values["A"] = 1
    values["X"] = 1
    # B, Y for 'paper'
    values["B"] = 2
    values["Y"] = 2
    # C, Z for 'scissors'
    values["C"] = 3
    values["Z"] = 3
}

{
    opponent_value = values[$1]
    my_value = values[$2]
    # You always earn the value of your draw
    # 0 points for a loss, 3 points for a draw, 6 points for a win
    total_score += my_value + ((my_value == opponent_value) * 3) + ((my_value == 1 && opponent_value == 3 || my_value == 2 && opponent_value == 1 || my_value == 3 && opponent_value == 2) * 6)
}

END{
    print "Final score:", total_score
}
