# Remote Load Survey Result With Local Fallback

> ## Caso de sucesso
1. ✅ Sistema executa o loadBySurvey da implementacao remota
2. Sistema Substitui os dados do Cache com os dados obtidos
3. Sistema retorna esses dados

> ## Excecao - Acesso Negado
1. Sistema repassa a excecao de acesso negado

> ## Excecao - Qualquer outro erro
1. Sistema executa o metodo de validar dados do cache
2. Sistema executa o metodo de carregar dados do cache
3. Sistema retorna esse dados

> ## Excecao - Erro ao obter dados do Cache
1. Sistema retorna uma excecao de erro inesperado