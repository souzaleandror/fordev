# Surveys Presenter

> ## Regras
1. Chamar LoadSurveys no metodo loadData
2. Notificar o isLoadingStream como true antes de chamar o loadSurveys
3. Notificar o isLoadingStream como false no fim do LoadSurveys
4. Notificar o loadSurveysStream com erro caso o LoadSurveys retorne erro
5. Notificar o loadSurveysStream com uma lista de Surveys caso o LoadSurveys retorne sucesso
6. Levar o usuario para tela de Resultado da Enquete ao clicar em alguma enquete