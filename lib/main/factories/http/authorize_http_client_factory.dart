import '../../../data/http/http.dart';
import '../../../main/decorators/decorators.dart';
import '../factories.dart';

HttpClient makeAuthorizeHttpClientDecorator() => AuthorizeHttpClientDecorator(
    decoratee: makeHttpAdapter(),
    fetchSecureCacheStorage: makeSecureStorageAdapter(),
    deleteSecureCacheStorage: );
