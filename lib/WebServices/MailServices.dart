import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:technician_car_service_system/models/classSendEmail.dart';

sendEmail(classSendEmail _sendEmailClass) async{

  String emailAddress='lokwc-wm17@student.tarc.edu.my';
  String emailPassword='lommog01';

  final smtpServer=gmail(emailAddress, emailPassword);

  //Use the smtpServer class to configure an SMTP server;

  final emailMessage=Message()

    ..from=Address(emailAddress,'YSMD Car Solution')
    ..recipients.add(_sendEmailClass.recipientAddress)
    ..subject = '${_sendEmailClass.mailSubject} 😀 :: ${DateTime.now()}'
    ..text = '${_sendEmailClass.mailText}'
    ..html= "${_sendEmailClass.mailBody}";

  try{

    final sendReport = await send(emailMessage, smtpServer);
    print('Message sent: ' + sendReport.toString());

  }on MailerException catch(e){

    print('Message not sent.');
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }

  }

  var connection = PersistentConnection(smtpServer);

  await connection.send(emailMessage);

  await connection.close();

}