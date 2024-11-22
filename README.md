# **Simulação de Agentes para Produção e Comércio de Ferramentas**
Bernardo Pandolfi Costa (19207646)

## Descrição do Projeto  
Este projeto é uma simulação multiagente desenvolvida com a linguagem **Jason**. Ele modela uma cadeia produtiva onde agentes desempenham papéis distintos, como clientes, ferreiros e mineradores. Cada agente possui objetivos e planos para realizar tarefas como criar demandas, minerar recursos, produzir ferramentas e realizar transações comerciais.

## Agentes  
1. **Agente Cliente**:  
   - Gera demandas aleatórias de ferramentas de diferentes materiais.
   - Compra ferramentas produzidas pelo ferreiro.  

2. **Agente Ferreiro**:  
   - Recebe demandas de ferramentas dos clientes.  
   - Verifica se possui os recursos necessários para a produção.  
   - Solicita minérios ao agente minerador, se necessário.  
   - Produz ferramentas e as vende aos clientes.  

3. **Agente Minerador**:  
   - Minera minérios aleatoriamente ou sob demanda.  
   - Garante o fornecimento de recursos necessários ao ferreiro.  

## Estrutura dos Agentes  

### Cliente  
**Crenças Iniciais**:  
  - Quantidade de ferramentas compradas.  
  - Quantidade de dinheiro enviado.  

**Objetivos**:  
  - Criar demandas de ferramentas e enviar ao ferreiro.  

**Planos**:  
  - Gerar demanda de ferramentas aleatoriamente.  
  - Comprar ferramentas prontas.  

### Ferreiro  
**Crenças Iniciais**:  
  - Saldo de moedas.  
  - Saldo de minérios (ferro, ouro e diamante).  
  - Minérios necessários para cada ferramenta.  

**Objetivos**:  
  - Vender ferramentas e aumentar seu dinheiro.

**Planos**:  
  - Checar se os recursos são suficientes para produzir a ferramenta.  
  - Solicitar minérios ao minerador, se necessário.  
  - Produzir ferramentas e notificar o cliente.  

### Minerador  
**Crenças Iniciais**:  
  - Saldo de moedas.  
  - Saldo inicial de cada minério.  

**Objetivos**:  
  - Minerar minérios aleatórios ou específicos sob demanda.  

**Planos**:  
  - Adicionar minérios encontrados ao saldo.  
  - Notificar o ferreiro quando a demanda por minérios for atendida.  

## Pré-requisitos  
- **Jason**: Plataforma para desenvolvimento de sistemas multiagentes.  
- **Jacamo**: Framework para integração de agentes Jason com outros artefatos.  

## Como Executar  
1. Instale o **Jason** e o **Jacamo** no seu ambiente.  
2. Clone este repositório:  
   ```bash
   git clone <URL_DO_REPOSITORIO>
   ```  
3. Abra o projeto no ambiente configurado para o **Jason**.  
4. Dê permissão para o arquivo `gradlew` usando `chmod +x ./gradlew`
4. Execute o comando `./gradlew run`.

## Estrutura do Código  
- **Agente Cliente**: `sample_agent_client.asl`  
- **Agente Ferreiro**: `sample_agent_blacksmith.asl`  
- **Agente Minerador**: `sample_agent_miner.asl`  

## Exemplos de Simulação  
- O cliente gera uma demanda por uma espada de ferro.  
- O ferreiro verifica seus recursos e, se necessário, solicita ferro ao minerador.  
- O minerador minera e fornece o ferro necessário ao ferreiro.  
- O ferreiro produz a espada e notifica o cliente, que finaliza a compra.  

## Contribuições  
Sinta-se à vontade para abrir **Issues** ou enviar **Pull Requests** para melhorias.  

## Licença  
Este projeto é licenciado sob a [MIT License](LICENSE).  
