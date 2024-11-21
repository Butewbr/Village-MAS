// Agent sample_agent in project main

/* Initial beliefs and rules */

coins(100).
ore_balance("iron", 10).
ore_balance("gold", 1).
ore_balance("diamond", 0).

// Minérios necessários para cada ferramenta
tool_requirement("hammer", 1).
tool_requirement("sword", 2).
tool_requirement("axe", 3).
tool_requirement("pickaxe", 3).
tool_requirement("shovel", 1).

ore_price("iron", 5).
ore_price("gold", 20).
ore_price("diamond", 50).

/* Initial goals */

!wait_demand.

/* Plans */

+!wait_demand : true
    <-  .wait(3000);
        !wait_demand.

+!check_resources(Tool, Ore) : tool_requirement(ToolName, OreRequirement) & ore_balance(OreName, OreAmount) & Tool == ToolName & Ore == OreName & OreAmount >= OreRequirement & ore_price(OrePriceCheck, Price) & OrePriceCheck == Ore
    <-  .print("I have resources to smith the tool!");

        // Atualizar o saldo de minérios
        NewOreAmount = OreAmount - OreRequirement;
        -ore_balance(OreName, OreAmount);
        +ore_balance(OreName, NewOreAmount);

        .print("Smithing ", Ore, " ", Tool, "...");

        .wait(5000);

        .print(Ore, " ", Tool, " smithed!");

        TotalPrice = 100 + Price * OreAmount;

        .send(customer, tell, tool_done(Tool, Ore, TotalPrice));

        !wait_demand.

+!check_resources(Tool, Ore) : tool_requirement(ToolName, OreRequirement) & ore_balance(OreName, OreAmount) & Tool == ToolName & Ore == OreName & OreAmount < OreRequirement
    <-  .print("I don't have the resources to create the tool. Asking miner...");

        OreAmountNeeded = OreRequirement - OreAmount;

        .send(miner, tell, demand_ore(Ore, OreAmountNeeded));

        !wait_demand.

+buy(Tool, Ore, Price) : coins(Coins)
    <-  .print("Customer just bought the tool for ", Price, " coins!");

        // Atualizar o saldo de moedas
        NewCoins = Coins + Price;
        -coins(Coins);
        +coins(NewCoins);

        !wait_demand.

+demand(Tool, Ore): true
    <-  .print("Received new demand for: ", Ore, " ", Tool);

        !check_resources(Tool, Ore).

+ores_found(Ore, AmountBought, TotalPrice): demand(DemandTool, DemandOre) & tool_requirement(ToolName, ToolOreRequirement) & DemandTool == ToolName & coins(Coins) & ore_balance(OreName, OreAmount) & Ore == OreName
    <-  .print("Miner sold ", AmountBought, " ", Ore, "(s) for ", TotalPrice, " coins!");

        // Atualizar o saldo de moedas
        -coins(Coins);
        +coins(Coins - TotalPrice);

        NewOreAmount = OreAmount + AmountBought;

        -ore_balance(OreName, OreAmount);
        +ore_balance(OreName, NewOreAmount);

        !check_resources(DemandTool, DemandOre).

{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
