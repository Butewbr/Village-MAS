// Agent sample_agent in project main

/* Initial beliefs and rules */

tools_bought(0).
money_sent(0).

/* Initial goals */

!create_demand.

/* Plans */

+!create_demand : .findall(demand(Tool, Ore), demand(ToolDemand, OreDemand), Demands) & .length(Demands, DemandsAmount) & DemandsAmount < 1
    <-  .print("Let's see what we need...");

        .wait(10000);

        // Escolher um objeto aleatório
        .random(["hammer", "sword", "axe", "pickaxe", "shovel"], ChosenObject);
        
        // Escolher um minério aleatório
        .random(["iron", "gold", "diamond"], ChosenOre);

        +demand(ChosenObject, ChosenOre);
        
        // Criar e enviar a demanda
        .send(blacksmith, tell, demand(ChosenObject, ChosenOre));
        
        // Exibir o que foi escolhido
        .print("We now need: ", ChosenOre, " ", ChosenObject);

        !create_demand.

+!create_demand : true
    <-  .wait(15000);
        !create_demand.

+tool_done(Tool, Ore, Price): demand(DemandTool, DemandOre) & DemandTool == Tool & DemandOre == Ore & tools_bought(ToolsBought) & money_sent(MoneySent)
    <-  .print("Blacksmith told me he finished the tool. Time to buy it!");
    
        .drop_all_intentions;

        -demand(DemandTool, DemandOre)[source(_)];
        -tool_done(Tool, Ore, Price)[source(_)];

        NewToolsBought = ToolsBought + 1;
        NewMoneySent = MoneySent + Price;

        -tools_bought(ToolsBought);
        -money_sent(MoneySent);

        +tools_bought(NewToolsBought);
        +money_sent(NewMoneySent);

        // Comprar a ferramenta
        .send(blacksmith, tell, buy(Tool, Ore, Price));

        !create_demand.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
