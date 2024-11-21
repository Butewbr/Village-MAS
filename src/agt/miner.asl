// Agent sample_agent in project main

/* Initial beliefs and rules */

coins(0).
ore_balance("iron", 0).
ore_balance("gold", 0).
ore_balance("diamond", 0).

ore_price("iron", 5).
ore_price("gold", 20).
ore_price("diamond", 50).

/* Initial goals */

!choose_ore_to_mine("whatever").

/* Plans */

+!choose_ore_to_mine(Ore) : Ore == "whatever"
    <-  .print("While there is no specific demand, I will mine whatever.");
        .random(["iron", "gold", "diamond"], ChosenOre);
        !mine(ChosenOre).

+!choose_ore_to_mine(Ore) : Ore \== "whatever"
    <-  !mine(Ore).

+!mine(Ore): ore_balance(CurrentOre, CurrentAmount) & CurrentOre == Ore
    <-  .print("Mining ", Ore);
        .wait(5000);
        .random(["iron", "gold", "diamond", "nothing", Ore, Ore, Ore], OreFound);
        .random([1, 1, 1, 1, 1, 1 , 2, 2, 2, 3, 3, 6], AmountFound);

        !add_to_cart(OreFound, AmountFound, Ore).

+!add_to_cart(OreFound, AmountFound, OreBeingSearched): OreFound \== "nothing" & ore_balance(CurrentOre, CurrentAmount) & CurrentOre == OreFound & demand_ore(OreNeeded, AmountNeeded) & OreNeeded == OreBeingSearched & CurrentAmount + AmountFound < AmountNeeded
    <-  .print("Just found ", AmountFound, " ", OreFound, "(s)! Adding it to cart.");
        NewAmount = CurrentAmount + AmountFound;
        -ore_balance(CurrentOre, CurrentAmount);
        +ore_balance(CurrentOre, NewAmount);

        .wait(5000);

        !mine(OreBeingSearched).

+!add_to_cart(OreFound, AmountFound, OreBeingSearched): OreFound \== "nothing" & ore_balance(CurrentOre, CurrentAmount) & CurrentOre == OreFound & demand_ore(OreNeeded, AmountNeeded) & OreNeeded == OreBeingSearched & CurrentAmount + AmountFound >= AmountNeeded & ore_price(OrePriceCheck, Price) & OrePriceCheck == OreNeeded & coins(CurrentCoins)
    <-  .print("Just found ", AmountFound, " ", OreFound, "(s)! Adding it to cart.");
        NewAmount = CurrentAmount + AmountFound;
        -ore_balance(CurrentOre, CurrentAmount);
        +ore_balance(CurrentOre, NewAmount);

        TotalPrice = AmountNeeded * Price;

        .print("Now I have enough ", OreFound, "(s) to fulfill the demand. Going to sell it...");

        .wait(5000);

        -demand_ore(OreNeeded, AmountNeeded);

        .send(blacksmith, tell, ores_found(OreBeingSearched, AmountNeeded, TotalPrice));

        NewCoins = CurrentCoins + TotalPrice;
        -coins(CurrentCoins);
        +coins(NewCoins);

        .print("Just sold ", OreFound, "(s) for ", TotalPrice, " coins! Going back to mining.");
        
        .wait(5000);

        !choose_ore_to_mine("whatever").

+!add_to_cart(OreFound, AmountFound, OreBeingSearched): OreFound \== "nothing" & ore_balance(CurrentOre, CurrentAmount) & CurrentOre == OreFound
    <-  .print("Just found ", AmountFound, " ", OreFound, "(s)! Adding it to cart.");
        NewAmount = CurrentAmount + AmountFound;
        -ore_balance(CurrentOre, CurrentAmount);
        +ore_balance(CurrentOre, NewAmount);

        .wait(5000);

        !choose_ore_to_mine(OreBeingSearched).

+!add_to_cart(OreFound, AmountFound, OreBeingSearched): OreFound == "nothing"
    <-  .print("Just found nothing.");
        .wait(5000);
        !choose_ore_to_mine(OreBeingSearched).

+!check_resources(Ore, AmountNeeded): ore_balance(OreName, CurrentAmount) & Ore == OreName & CurrentAmount >= AmountNeeded & ore_price(OrePriceCheck, Price) & OrePriceCheck == Ore
    <-  .print("I have enough ", Ore, "(s) to fulfill the demand.");

        TotalPrice = AmountNeeded * Price;

        -demand_ore(OreNeeded, AmountNeeded);

        NewOreBalance = CurrentAmount - AmountNeeded;
        -ore_balance(OreName, CurrentAmount);
        +ore_balance(OreName, NewOreBalance);

        .send(blacksmith, tell, ores_found(Ore, AmountNeeded, TotalPrice));

        !choose_ore_to_mine("whatever").

+!check_resources(Ore, Amount): true
    <-  .print("I don't have enough ", Ore, "(s) to fulfill the demand.");

        !mine(Ore).

+demand_ore(Ore, Amount): true
    <-  .print("Received demand for ", Amount, " ", Ore, "(s).");

        .drop_all_intentions;

        !check_resources(Ore, Amount).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
