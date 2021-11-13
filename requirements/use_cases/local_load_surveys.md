# Local Load Surveys

> ## Caso de sucesso
1. ✅ Sistema solicita os dados das enquetes do cache
2. ✅ Sistema entrega os dados de enquetes

> ## Excecao - Cache vazio
1. ✅ Sistema retorna uma mensagem de erro inesperado

---

# Local Validate Surveys

> ## Caso de sucesso
1. ✅ Sistema solicita os dados das enquetes do Cache
2. ✅ Sistema valida os dados recebidos do Cache

> ## Excecao - Erro ao carregar dados do Cache
1. ✅ SSistema limpa os dados do cache

> ## Exxcecao - Dados invalidos do cache
1. ✅ sistema limpa os dados do cache

---

# Local Save Surveys

> ## Caso de sucesso
1. ✅ Sistema grava os novos dados no Cache

> ## Excecao - Erro ao gravar dados no Cache
1. ✅ Sistema retornar uma mensagem de erro inesperado