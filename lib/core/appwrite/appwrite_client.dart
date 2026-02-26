import 'package:appwrite/appwrite.dart';
import 'appwrite_constants.dart';

class AppwriteClient {
  static Client get client => Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId);

  static Account get account => Account(client);

  static Databases get databases => Databases(client);
}
