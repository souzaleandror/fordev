# Login Presenter

> ## Regras

1. ✅ Chamar Validation ao alterar o email
2. ✅ Notificar o emailErrorStream com o mesmo erro do Validation, caso retorne o erro
3. Notificar o emailErrorStream com null, caso o Validation nao retorne erro
4. ✅ Nao notificar o emailErrorStream se o valor for igual ao ultimo
5. Notificar o isFormValidStream apos alterar o email
6. Chamar Validation ao alterar a senha
7. Notificar o passwordErrorStream com o mesmo erro do Validation, caso retorno o erro
8. Notificar o passwordErrorStream com o null, caso o Validation nao retorne erro
9. Nao notificar o passwordErrorStream se o valor for igual ao ultimo
10. Notificar o isFormValidStream apos alterar a senha
11. Para o forumario estar valido todos os Streams de erro precisam estar null e todo os campos obrigatorios nao podem esstar vazios
12. Nao notificar o isFormValidStream se o valor for igual ao ultimo
13. Chamar o Authentication com email e senha corretos
14. Notificar o isLoadingStream como true antes de chamar o Authentication
15. Notificar o isLoadingStream como false no fim do Authentication
16. Notificar o mainErrorStream caso o Authentication retorn um DomainError
17. Fechar todos os Streams no dispose
18. ⛔️ Gravar o Account no cache em caso de sucesso
19. ⛔️ Levar o usuario para tela de Enquetes em caso de sucesso