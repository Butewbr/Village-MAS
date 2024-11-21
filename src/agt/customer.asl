// Agent sample_agent in project main

/* Initial beliefs and rules */

/* Initial goals */

!create_demand.

/* Plans */

+!create_demand : .findall(demand(Tool, Ore), demand(ToolDemand, OreDemand), Demands) & .length(Demands, DemandsAmount) & DemandsAmount < 3
    <-  .print("Let's see what we need...");

        .print("We have ", DemandsAmount, " demand(s).");
        // Escolher um objeto aleatório
        .random(["hammer", "sword", "axe", "pickaxe", "shovel"], ChosenObject);
        
        // Escolher um minério aleatório
        .random(["iron", "gold", "diamond"], ChosenOre);

        +demand(ChosenObject, ChosenOre);
        
        // Criar e enviar a demanda
        .send(blacksmith, tell, demand(ChosenObject, ChosenOre));
        
        // Exibir o que foi escolhido
        .print("We currently need: ", ChosenOre, " ", ChosenObject);

        .wait(10000);

        !create_demand.

+!create_demand : true
    <-  .wait(15000);
        !create_demand.

+tool_done(Tool, Ore, Price): demand(DemandTool, DemandOre) & DemandTool == Tool & DemandOre == Ore
    <-  .print("Blacksmith told me he finished the tool. Time to buy it!");
    
        // Comprar a ferramenta
        .send(blacksmith, tell, buy(Tool, Ore, Price));

        -demand(DemandTool, DemandOre);

        !create_demand.


{ include("$jacamo/templates/common-cartago.asl") }
{ include("$jacamo/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moise/asl/org-obedient.asl") }
