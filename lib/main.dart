// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:personalrecipeassistant1/ui/auth/login.dart';
// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'ui/tflite_model/tflite_model.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   runApp(const GetMaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: TextRecognitionScreen(),
//   ));
// }

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => const Login()));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                   image: DecorationImage(
//                 image: AssetImage('images/splash.png'),
//                 fit: BoxFit.cover,
//               )),
//             ),
//             const Center(
//               child: CircularProgressIndicator(
//                 color: Color(0xffD8D83F),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

///
///
///
///
///
///

// yeh uper wala us ka apna code tha....

///
///
///
///
///
///

///
///
///
///
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:tflite/tflite.dart';

// import 'cat/home.dart';

// List<CameraDescription>? cameras;

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
//   runApp(MyApp());
// }

// // List<CameraDescription> cameras;

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.dark(),
//       home: HomePage(),
//     );
//   }
// }
///
///
///
///
///
///
//
//

///
///
///
//////
///
///
///
/////
///
///
///
///yeh jo home par lay kar ja raha hay wo by camera and gallery wala hay jo last image aap ko bhaijhi hay
///

import 'package:flutter/material.dart';
import 'cat/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recipe Classifier',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}








///
/// Working Tflite code live detection wala code  yeh agar run karo gay to uper wala main comment kar dayna
///

//
//

///
///
/// 
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// import 'dart:math' as math;

// import 'package:tflite/tflite.dart';

// List<CameraDescription>? cameras;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     cameras = await availableCameras();
//   } on CameraException catch (e) {
//     debugPrint('Error: $e.code\nError Message: $e.message');
//   }
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Recipe',
//       theme: ThemeData(
//         brightness: Brightness.dark,
//       ),
//       home: const Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({super.key});

//   @override
//   State<Home> createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   String tipo = "";
//   animal(String animal) {
//     setState(() {
//       tipo = animal;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     loadModel().then((_) {
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Camera(cameras: cameras!, tipo: animal),
//           Center(
//             child: Text(
//               tipo,
//               style: const TextStyle(fontSize: 25, color: Colors.white70),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   // loadModel() async {
//   //   await Tflite.loadModel(
//   //     model: "assets/model_unquant.tflite",
//   //     labels: "assets/model.txt",
//   //   );
//   // }
// }

// loadModel() async {
//   await Tflite.loadModel(
//     model: "assets/new_model.tflite",
//     labels: "assets/new_labels.txt",
//   );
// }

// class Camera extends StatefulWidget {
//   final List<CameraDescription> cameras;
//   final Function(String value) tipo;

//   const Camera({super.key, required this.cameras, required this.tipo});

//   @override
//   State<Camera> createState() => _CameraState();
// }

// class _CameraState extends State<Camera> {
//   CameraController? controller;
//   bool isDetecting = false;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.cameras.isEmpty) {
//       debugPrint("Camara no encontrada");
//     } else {
//       controller = CameraController(widget.cameras[0], ResolutionPreset.high);
//       controller?.initialize().then((_) {
//         if (!mounted) return;
//         setState(() {});
//         controller?.startImageStream((image) {
//           if (!isDetecting) {
//             isDetecting = true;
//             Tflite.runModelOnFrame(
//               bytesList: image.planes.map((plane) {
//                 return plane.bytes;
//               }).toList(),
//               imageHeight: image.height,
//               imageWidth: image.width,
//               numResults: 2,
//             ).then((value) {
//               widget.tipo(value![0]["label"]);
//               isDetecting = false;
//             });
//           }
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     controller?.stopImageStream();
//     controller?.dispose();
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (controller == null || !controller!.value.isInitialized) {
//       return const SizedBox();
//     }

//     var tmp = MediaQuery.of(context).size;
//     var screenH = math.max(tmp.height, tmp.width);
//     var screenW = math.min(tmp.height, tmp.width);
//     tmp = controller!.value.previewSize!;
//     var previewH = math.max(tmp.height, tmp.width);
//     var previewW = math.min(tmp.height, tmp.width);
//     var screenRatio = screenH / screenW;
//     var previewRatio = previewH / previewW;

//     return OverflowBox(
//         maxHeight: screenRatio > previewRatio
//             ? screenH
//             : screenW / previewW * previewH,
//         maxWidth: screenRatio > previewRatio
//             ? screenH / previewH * previewW
//             : screenW,
//         child: CameraPreview(controller!));
//   }
// }
