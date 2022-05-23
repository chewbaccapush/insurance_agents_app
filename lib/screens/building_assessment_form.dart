import 'package:flutter/material.dart';
import 'package:msg/models/BuildingAssessment/building_assessment.dart';
import 'package:msg/models/BuildingPart/building_part.dart';
import 'package:msg/screens/building_part_form.dart';
import 'package:msg/validators/Validators.dart';
import 'package:msg/widgets/add_objects_section.dart';
import 'package:msg/widgets/custom_text_form_field.dart';
import 'package:msg/widgets/date_form_field.dart';

<<<<<<< HEAD
import '../models/BuildingPart/construction_class.dart';
import '../models/BuildingPart/fire_protection.dart';
import '../models/BuildingPart/insured_type.dart';
import '../models/BuildingPart/risk_class.dart';
import '../models/Database/database_helper.dart';
import '../models/Measurement/measurement.dart';
=======
import '../services/sqs_sender.dart';
import '../widgets/alert.dart';
>>>>>>> fac67acebafaba1acabe70789bf1d720459b9f98

class BuildingAssessmentForm extends StatefulWidget {
  final BuildingAssessment? buildingAssessment;
  const BuildingAssessmentForm({Key? key, this.buildingAssessment})
      : super(key: key);

  @override
  State<BuildingAssessmentForm> createState() => _BuildingAssessmentFormState();
}

class _BuildingAssessmentFormState extends State<BuildingAssessmentForm> {
  final _formKey = GlobalKey<FormState>();
  BuildingAssessment buildingAssessment = BuildingAssessment();

  @override
  void initState() {
    buildingAssessment = widget.buildingAssessment ?? BuildingAssessment();
    super.initState();
  }

  final SQSSender sqsSender = SQSSender();

  void sendMessage(String message) async {
    try {
      await sqsSender.sendToSQS(message);
      showDialogPopup("Info", "Assessment successfully sent.");
    } catch (e) {
      showDialogPopup("Error", "Assessment not sent.");
    }
  }
  void showDialogPopup(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Alert(title: title, content: content);
        });
  }
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
  void localSave() async {
    Measurement measurement1 = Measurement(
        description: "ME1",
        height: 2.2,
        width: 23.0,
        length: 12.0,
        radius: 23.0);
    Measurement measurement2 = Measurement(
        description: "ME2", height: 2.0, width: 33.0, length: 2.0, radius: 9.0);

    List<Measurement> measurements = [measurement1, measurement2];

    BuildingPart buildingPart1 = BuildingPart(
        description: "BP1",
        buildingYear: 2022,
        fireProtection: FireProtection.bma,
        constructionClass: ConstructionClass.solidConstruction,
        riskClass: RiskClass.four,
        unitPrice: 12.2,
        insuredType: InsuredType.newValue,
        devaluationPercentage: 0.33,
        cubature: 0.0,
        value: 0.0,
        sumInsured: 0.0,
        measurements: measurements);
    BuildingPart buildingPart2 = BuildingPart(
        description: "BP2",
        buildingYear: 2022,
        fireProtection: FireProtection.bma,
        constructionClass: ConstructionClass.solidConstruction,
        riskClass: RiskClass.four,
        unitPrice: 12.2,
        insuredType: InsuredType.newValue,
        devaluationPercentage: 0.33,
        cubature: 0,
        value: 0,
        sumInsured: 0,
        measurements: measurements);

    List<BuildingPart> buildingParts = [buildingPart1, buildingPart2];

    BuildingAssessment assessment = BuildingAssessment(
        appointmentDate: DateTime(2017, 9, 7, 17, 30),
        description: "neki",
        assessmentCause: "sdsdsd",
        numOfAppartments: 12,
        voluntaryDeduction: 22.2,
        assessmentFee: 22.2);

    await DatabaseHelper.instance.createAssessment(assessment, buildingParts);
  }

  // void clearText() {
  //   _nameController.clear();
  //   _areaController.clear();
  //   FocusManager.instance.primaryFocus?.unfocus();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Building Assessment")),
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          key: _formKey,
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  children: <Widget>[
                    CustomDateFormField(
                      initialValue: buildingAssessment.appointmentDate,
                      onDateSaved: (newValue) => {
                        setState((() =>
                            {buildingAssessment.appointmentDate = newValue}))
                      },
                    ),
                    CustomTextFormField(
                      type: TextInputType.text,
                      labelText: "Description",
                      initialValue: buildingAssessment.description,
                      onChanged: (newValue) => {
                        setState(() => {buildingAssessment.description = newValue})
                      },
                      validator: (value) => Validators.defaultValidator(value!),
                    ),
                    CustomTextFormField(
                      type: TextInputType.text,
                      labelText: "Assessment Cause",
                      initialValue: buildingAssessment.assessmentCause,
                      onChanged: (newValue) => {
                        setState(() =>
                            {buildingAssessment.assessmentCause = newValue})
                      },
                      validator: (value) => Validators.defaultValidator(value!),
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: false),
                      labelText: "Number of Apartments",
                      initialValue:
                          buildingAssessment.numOfAppartments.toString(),
                      onChanged: (newValue) => {
                        setState(() => {
                              buildingAssessment.numOfAppartments =
                                  int.parse(newValue)
                            })
                      },
                      validator: (value) => Validators.numberOfApartmentsValidator(value!),
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Voluntary Deduction",
                      initialValue:
                          buildingAssessment.voluntaryDeduction.toString(),
                      onChanged: (newValue) => {
                        setState(() => {
                              buildingAssessment.voluntaryDeduction =
                                  double.parse(newValue)
                            })
                      },
                      validator: (value) => Validators.floatValidator(value!),
                    ),
                    CustomTextFormField(
                      type:
                          const TextInputType.numberWithOptions(decimal: true),
                      labelText: "Assessment Fee",
                      initialValue: buildingAssessment.assessmentFee.toString(),
                      onChanged: (newValue) => {
                        setState(() => {
                              buildingAssessment.assessmentFee =
                                  double.parse(newValue)
                            })
                      },
                      validator: (value) => Validators.floatValidator(value!),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Column(
                  children: <Widget>[
                    AddObjectsSection(
                      objectType: ObjectType.buildingPart,
                      buildingAssessment: buildingAssessment,
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => BuildingPartForm(
                              buildingAssessment: buildingAssessment,
                            ),
                          ),
                        )
                      },
                    ),
                    OutlinedButton(
                        onPressed: () {
                          // Validates form
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sending..')),
                            );
                            _formKey.currentState!.save();
                            print(buildingAssessment.toMessage());
                            
                            sendMessage(buildingAssessment.toMessage().toString());

                            // print(buildingAssessment.toJson());
                            // print(buildingAssessment.buildingParts[0].toJson());
                            // print(buildingAssessment
                            //   .buildingParts[0].measurements[1]
                            //   .toJson());
                          }                     
                        },
                        child: const Text("Send"))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
