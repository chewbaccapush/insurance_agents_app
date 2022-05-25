import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/cupertino.dart';

class SQSSender {
  static final _service = SQS(
      region: 'us-east-1',
      credentials: AwsClientCredentials(accessKey: '', secretKey: ''));

  SQSSender._privateConstructor();

  static final SQSSender _instance = SQSSender._privateConstructor();

  factory SQSSender() {
    return _instance;
  }

  Future<void> sendToSQS(String message) async {
    debugPrint("SQS: sending message...");
    await _service
        .sendMessage(
            messageBody: message,
            queueUrl:
                'https://sqs.us-east-1.amazonaws.com/921005389992/testQueue-msg')
        .then((Object res) {
      debugPrint("SQS: ${res.toString()}}");
    }).catchError((Object e, StackTrace stackTrace) {
      debugPrint("SQS ERROR DESCRIPTION: $e");
      debugPrint("SQS ERROR WARNING: $stackTrace");
      return Future.error(e);
    });
  }
}
