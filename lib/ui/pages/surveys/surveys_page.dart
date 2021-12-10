import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/surveys/surveys.dart';
import '../../../ui/mixins/mixins.dart';
import '../../../ui/helpers/i18n/i18n.dart';

import 'components/components.dart';

class SurveysPage extends StatefulWidget {
  const SurveysPage({Key? key, required this.presenter}) : super(key: key);

  final SurveysPresenter presenter;

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with LoadingManager, NavigationManager, SessionManager, RouteAware {
  @override
  void didPopNext() {
    widget.presenter.loadData();
    super.didPopNext();
  }

  @override
  void dispose() {
    Get.find<RouteObserver>().unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.find<RouteObserver>()
        .subscribe(this, ModalRoute.of(context) as PageRoute);

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleLoading(context, widget.presenter.isLoadingStream);

          handleNavigation(widget.presenter.navigateToStream, clear: false);

          handleSessionExpired(widget.presenter.isSessionExpiredStream);

          widget.presenter.loadData();

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return RealodScreen(
                  error: '${snapshot.error}',
                  reload: widget.presenter.loadData,
                );
              }
              if (snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
                  child: SurveyItems(
                    viewModels: snapshot.data!,
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
