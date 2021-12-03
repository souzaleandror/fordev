# Remote Save Survey Result

> ## Caso de Sucesso
1. ✅ Sistema faz uma requisicao para a URL da API de save survey result
2. Sistema valida o token de acesso para saber se o usuario tem permissao para ver esses dados
3. Sistema valida os dados recebidos da API
4. Sistema entrega os dados do resultado da enquete

> ## Excecao - URL invlida
1. Sistema retorna uma mensagem de erro inesperado

> ## Excecao - Acesso negado
1. Sistema retorna uma mensagem de acesso negado

> ## Exceccao - Resposta Invalida
1. Sistema retorna uma mensagem de erro inesperado

> ## Excecao - Falha no Servidor
1. Sistema retorna uma mensagem de erro inesperado