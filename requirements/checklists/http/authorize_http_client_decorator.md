# Authorize HTTP Client Decorator

> ## Sucesso
1. ✅ Obter o token de acesso do Cache
2. ✅ Executar o request do HttpClient que esta sendo decorado com um novo header (x-access-token)
3. ✅ Retornar a mesma resposta do HttpClient que esta sendo decorado

> ## Execao - Falha ao obter dados do cache
1. ✅ Retornar erro HTTP Forbidden - 403
2. ✅ Apagar token de acesso do Cache

> ## Excecao - HttpClient retornou alguma excecao (menos Forbidden)
1. ✅ Retornar a mesma exececao recebida

> ## Excecao - HttpClient Retornou erro Forbidden
1. ✅ Retornar erro HTTP Forbidden - 403
2. ✅ Apagar token de acesso do Cache