import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'bndbox.dart';

import 'camera_det.dart';
import 'loca.dart';

import 'package:flutter/services.dart';
import 'package:tflite/tflite.dart';

const String mobilenet = "MobileNet";
const String ssd = "SSD MobileNet";
const String yolo = "Tiny YOLOv2";
const String posenet = "PoseNet";
const String detect = "detect";

class CapturedObject {
  final String name;
  final double percentage;

  CapturedObject({required this.name, required this.percentage});
}

class HomePage extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomePage(this.cameras, {super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> _recognitions = [];
  int _imageHeight = 0;
  int _imageWidth = 0;
  String? _model;
  List<CapturedObject> _capturedObjects = [];
  String _formData = '';
  final GlobalKey _globalKey = GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _nameController =
      TextEditingController(); // Added name controller

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    String? res;
    switch (_model) {
      case detect:
        res = await Tflite.loadModel(
          model: "assets/new_model.tflite",
          labels: "assets/new_labels.txt",
        );
        break;

      default:
        res = await Tflite.loadModel(
          model: "assets/new_model.tflite",
          labels: "assets/new_labels.txt",
        );
    }
    print(res);
  }

  onSelect(model) {
    setState(() {
      _model = model as String;
    });
    loadModel();
  }

  int generateCustomerId() {
    final random = math.Random();
    return random
        .nextInt(100000); // Generate a random ID number between 0 and 99999
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
      _capturedObjects = []; // Clear previous captured objects
      for (final recognition in recognitions) {
        final String name = recognition['detectedClass'];
        final double percentage = recognition['confidenceInClass'] * 100;
        final CapturedObject capturedObject = CapturedObject(
          name: name,
          percentage: percentage,
        );
        _capturedObjects.add(capturedObject);
      }
    });
  }

  Future<void> storeObject(
      String name, String imagePath, double percentage) async {
    final DateTime now = DateTime.now();
    final String date = '${now.day}-${now.month}-${now.year}';

    final ObjectData object = ObjectData(
      name: name,
      image: imagePath,
      percentage: percentage,
      date: date,
    );

    await LocalDatabase.instance.insertObject(object);
  }

  Future<void> generatePDFReport() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image? image = await boundary.toImage(pixelRatio: 3.0);
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      Uint8List bytes = byteData.buffer.asUint8List();
      // String pdfPath = await PDFGenerator.generatePDF(
      //   bytes,
      //   _capturedObjects,
      //   _formData,
      //   name: _nameController.text,
      //   address: _addressController.text,
      //   generatedID: generateCustomerId(),
      // );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF report generated successfully!'),
        ),
      );
      // await OpenFile.open(pdfPath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to generate PDF report.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: _model == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 300,
                      ),
                      Container(
                        height: 50.0,
                        width: 300,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff45a7f5), Color(0xff542f95)],
                            stops: [0, 1],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: TextButton(
                          autofocus: true,
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0),
                                ),
                              ),
                              isScrollControlled: true,
                              builder: (context) => FormContainer(
                                formKey: _formKey,
                                textFieldController: _textFieldController,
                                addressController:
                                    _addressController, // Pass the address controller
                                nameController: _nameController,
                                onSubmit: () {
                                  if (_formKey.currentState!.validate()) {
                                    String formData = _textFieldController.text;
                                    String customerName = _nameController.text;
                                    String customerAddress = _addressController
                                        .text; // Use the correct controller here
                                    int customerId = generateCustomerId();

                                    onSelect(detect);
                                    setState(() {
                                      _formData = formData;
                                    });
                                    Navigator.pop(context);
                                    generatePDFReport();
                                  }
                                },
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(
                              color: Colors.red,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            detect,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    '© GK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Camera(
                    widget.cameras,
                    _model!,
                    setRecognitions,
                    storeObject,
                  ),
                ),
                BndBox(
                  _recognitions ?? [],
                  math.max(_imageHeight, _imageWidth),
                  math.min(_imageHeight, _imageWidth),
                  screen.height,
                  screen.width,
                  _model!,
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Generate PDF report
          await generatePDFReport();
        },
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}

class FormContainer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController textFieldController;
  final TextEditingController addressController;
  final TextEditingController nameController;
  final void Function() onSubmit;

  const FormContainer({
    super.key,
    required this.formKey,
    required this.textFieldController,
    required this.addressController,
    required this.nameController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Form(
          key: formKey,
          child: SizedBox(
            height: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Fill out the form:',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(
                  height: 18,
                ),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white, // Set the desired text color here
                  ),
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the customer name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  style: const TextStyle(
                    color: Colors.white, // Set the desired text color here
                  ),
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    labelStyle: const TextStyle(color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 3, color: Colors.white), //<-- SEE HERE
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the customer address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: Container(
                    height: 50.0,
                    width: 300,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff45a7f5), Color(0xff542f95)],
                        stops: [0, 1],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: TextButton(
                      onPressed: onSubmit,
                      child: const Center(
                          child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
