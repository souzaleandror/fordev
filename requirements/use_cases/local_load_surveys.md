# Local Load Surveys

> ## Caso de sucesso
1. ✅ Sistema solicita os dados das enquetes do cache
2. ✅ Sistema entrega os dados de enquetes

> ## Excecao - Cache vazio
1. ✅ Sistema retorna uma mensagem de erro inesperado

---

# Local Validate Surveys

> ## Caso de sucesso
1. Sistema valida os dados recebidos do Cache

> ## Excecao - Dados Invalidos no cache
1. Sistema limpa os dados do cache

---

# Local Save Surveys

> ## Caso de sucesso
1. Sistema valida os dados das enquetes
2. Sistema apaga os dados do Cache Antigo
3. Sistema grava os novos dados no Cache

> ## Excecao - Erro ao apagar dados do Cache
1. Sistema valida os dados das enquetes
2. Sistema apaga os dados do Cache Antigo
3. Sistema grava os novos dados no Cache

> ## Excecao - Erro ao apagar dados do Cache
1. Sistema retorna uma mensagem de erro

> ## Excecao - Erro ao gravar dados no Cache
1. Sistema retorna uma mensagem de erro