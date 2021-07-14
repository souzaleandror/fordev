Feature: Login
Como um cliente
Quero poder acessar minha conta e me manter logado
Para que eu possa ver e responsder enquetes de forma rapida

Cenario: Credenciais Validas
Dado que o cliente informou credenciais Validas
Quando solicitar para fazer Login
Entao o sistema deve enviar o usuario para tela de pesquisa
E manter o usuario conectado

Centario: Credenciais Invalidas
Dado que o cliente informou credenciais Invalidas
Quando solicitar para fazer LoginEntao o sitema deve retornar uma mensagem de erro