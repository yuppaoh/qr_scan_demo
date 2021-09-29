import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:qrscan_demo/screens/qr_generate.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController controller = TextEditingController();
  RxString qrText = "qr scan".obs;

  Future _qrScanner() async {
    qrText = "camera permission".obs;
    print(qrText);
    var cameraStatus = await Permission.camera.status;
    if (cameraStatus.isGranted) {
      String? qrData = await scanner.scan();
      // print(qrData);

      qrText = '$qrData'.obs;
      print(qrText);

    } else {
      var isGrant = await Permission.camera.request();
      if (cameraStatus.isGranted) {
        String? qrData = await scanner.scan();
        // print(qrData);

        qrText = '$qrData'.obs;
        print(qrText);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("$qrText")),
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width - 60,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.lightGreenAccent.shade100
              ),
              child: Obx(
                () => Text(qrText.toString()),
              )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _qrScanner();
                  },
                  child: Text(
                    "QR Scan",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: OutlinedButton.styleFrom(
                      shadowColor: Colors.orange,
                      elevation: 1.0,
                      backgroundColor: Colors.lightBlue[100],
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QRGenerate(title: 'QR Generate'))
                    );
                  },
                  child: Text('QR Generate', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
