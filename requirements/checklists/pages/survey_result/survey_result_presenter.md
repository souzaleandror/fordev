# Survey Result Presenter

> ## Regras
1. ✅ Chamar LoadSurveyResult no metodo loadData
2. ✅ Notificar o isLoadingStream como true antes de chamar o LoadSurveyResult
3. ✅ Notificar o isLoadingStream como false no fim do LoadSurveyResult
4. ✅ Notificar o surveyResultStream com erro no caso o LoadSurveyResult retorne erro
5. ✅ Notificar o surveyResultStream com um SurveyResult caso o LoadSurveyResult retorne sucesso
