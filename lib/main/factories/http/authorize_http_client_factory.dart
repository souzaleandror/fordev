import 'package:fordev/data/http/http.dart';
import 'package:fordev/main/decorators/decorators.dart';

import '../factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeLocalStoarageAdapter());
