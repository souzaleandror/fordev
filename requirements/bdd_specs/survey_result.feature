Feature: Resultado de uma Enquete
Como um cliente
Quero poder ver o resultado de uma Enquete
Para saber a opiniao da comunidade a respeito de cada topico

Cenario: Com internet
Dado que o cliente tem conexao com a internet
Quando solicitar para ver o resultado de uma Enquete
Entao o sistema deve exibir o resultado da Enquete
E armezar os dados atualizados do cache

Cenario: Sem internet
Dado que o cliente nao tem conexao com a internet
Quando solicitar para ver o resultado de uma Enquete
Entao o sistema deve exibir o resultado da enquete que foi gravado no cache no ultimo acesso