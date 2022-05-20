import 'package:aws_sqs_api/sqs-2012-11-05.dart';
import 'package:flutter/cupertino.dart';

class SQSSender {

  static final _service = SQS(
      region: 'us-east-1', 
      credentials: AwsClientCredentials(
        accessKey: 'AKIAUGVLRA7EVBXT7LH4', 
        secretKey: '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'
      )
  );

  SQSSender._privateConstructor();

  static final SQSSender _instance = SQSSender._privateConstructor();

  factory SQSSender() {
    return _instance;
  }

  Future<void> sendToSQS(String message) async {
    debugPrint("SQS: sending message...");
    await _service.sendMessage(
      messageBody: message, 
      queueUrl: 'https://sqs.us-east-1.amazonaws.com/289196279753/testQueue'
    ).then((Object res) {
      debugPrint("SQS: ${res.toString()}}");
      }
    ).catchError((Object e, StackTrace stackTrace) {
      debugPrint("SQS ERROR DESCRIPTION: $e");
      debugPrint("SQS ERROR WARNING: $stackTrace");
      return Future.error(e);
    });
  } 
}