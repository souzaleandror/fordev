Feature: Responder uma Enquete
Como um cliente
Quero poder responder uma Enquete
Para dar minha contribuicao e opiniao para a comunidade

Cenario: Com internet
Dado que o cliente tem conexao com a internet
Quando solicitar para responder uma Enquete
Entao o sistema deve gravar sua resposta
E atualizar o cache com as novas estatisticas
E mostrar para o usuario o resultado atualizado

Cenario: Sem internet
Dado que o cliente nao tem conexao com a internet
Quando solicitar para responder uma Enquete
Entao o sistema deve exibir uma mensagem de erro

