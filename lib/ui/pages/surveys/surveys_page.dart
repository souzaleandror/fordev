import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';
import 'package:fordev/ui/mixins/mixins.dart';
import '../../../ui/helpers/i18n/i18n.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget
    with LoadingManager, NavigationManager, SessionManager {
  const SurveysPage({Key key, this.presenter}) : super(key: key);

  final SurveysPresenter presenter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, presenter.isLoadingStream);

          handleNavigation(presenter.navigateToStream, clear: false);

          handleSessionExpired(presenter.isSessionExpiredStream);

          presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RealodScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                  create: (_) => presenter,
                  child: SurveyItems(
                    viewModels: snapshot.data,
                  ),
                );
              }

              return Container();
            },
          );
        },
      ),
    );
  }
}
