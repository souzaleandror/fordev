Feature: Listar Enquetes
Como um cliente
Quero pode ver todas as Enquetes
Para poder saber o resultado e poder da minha opiniao

Cenario: Com internet
Dado que o cliente tem conexao com a internet
Quanto solicitar para ver as Enquetes
Entao o sistema deve exibir as Enquetes
E armazenar os dados atualizados no cache

Cenario: Sem internet
Dado que o cliete nao tem conexao com a internet
Quando solicitar para ver as Enquetes
Entao o sistema deve exibir as Enquetes que foram gravadas no cache no ultimo acesso
