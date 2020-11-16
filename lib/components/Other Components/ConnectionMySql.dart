import 'package:mysql1/mysql1.dart';







class Mysql {
  static String host = '202.187.15.224',
      user = 'WC',
      password = 'WC123456',
      db = 'FYP_TEST';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = new ConnectionSettings(
        host: host,
        port: port,
        user: user,
        password: password,
        db: db
    );
    return await MySqlConnection.connect(settings);
  }
}