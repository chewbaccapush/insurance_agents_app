import 'package:flutter/material.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

class BuildingAssessmentForm extends StatefulWidget {
  const BuildingAssessmentForm({Key? key}) : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();

  // // Controllers for textfields
  // final _nameController = TextEditingController();
  // final _areaController = TextEditingController();

  // // Clears the controller when the widget is disposed.
  // @override
  // void dispose() {
  //   _nameController.dispose();
  //   _areaController.dispose();
  //   super.dispose();
  // }

  // static ConnectionSettings settings = ConnectionSettings(
  //     host: "10.0.2.2",
  //     maxConnectionAttempts: 3
  //   );

  // void sendMessage() async{

  //   final Client _client = Client(settings: settings);

  //     debugPrint("name:" + _nameController.text);
  //     debugPrint("area:" + _areaController.text);
  //     debugPrint("connecting..");

  //     _client
  //       .channel()
  //       .then((Channel channel) {
  //         return channel.queue("hello-world", durable: false);
  //       })
  //       .then((Queue queue) {
  //         queue.publish("hello world");
  //         _client.close();
  //       });
  // }

  // // Locally save order to users device
  // void localSave() async {
  //   final instance = await SharedPreferences.getInstance();

  //   PropretyValue propretyValue =
  //       PropretyValue(_nameController.text, _areaController.text, 0);

  //   Map<String, dynamic> map = {
  //     'name': propretyValue.name,
  //     'area': propretyValue.area,
  //     'value': propretyValue.value
  //   };

  //   instance.setString(_nameController.text, jsonEncode(map));
  //   clearText();
  // }

  // void clearText() {
  //   _nameController.clear();
  //   _areaController.clear();
  //   FocusManager.instance.primaryFocus?.unfocus();
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Column(
              children: const <Widget>[
                CustomDateFormField(),
                CustomTextFormField(
                    type: TextInputType.text, labelText: "Description"),
                CustomTextFormField(
                    type: TextInputType.text, labelText: "Assessment Cause"),
                CustomTextFormField(
                  type: TextInputType.numberWithOptions(decimal: false),
                  labelText: "Number of Apartments",
                ),
                CustomTextFormField(
                  type: TextInputType.numberWithOptions(decimal: true),
                  labelText: "Voluntary Deduction",
                ),
                CustomTextFormField(
                  type: TextInputType.numberWithOptions(decimal: true),
                  labelText: "Assessment Fee",
                ),
              ],
            ),
          ),
          Flexible(
            child: Column(
              children: const <Widget>[
                AddObjectsSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
