
import 'package:data_forms/model/fields_model/signature_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hand_signature/signature.dart';

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

class SignatureScreen extends StatelessWidget {
  final ValueSetter<String?> svgCallback;
  late FormSignatureModel model;

  SignatureScreen({required this.svgCallback, required this.model, super.key});

  setValue(String? value) {
    svgCallback.call(value);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.deepPurpleAccent,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 2.0,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              constraints: BoxConstraints.expand(),
                              color: Colors.white,
                              child: HandSignature(
                                control: control,
                                type: SignatureDrawType.shape,
                                // supportedDevices: {
                                //   PointerDeviceKind.stylus,
                                // },
                              ),
                            ),
                            CustomPaint(
                              painter: DebugSignaturePainterCP(
                                control: control,
                                cp: false,
                                cpStart: false,
                                cpEnd: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      CupertinoButton(
                        onPressed: () {
                          control.clear();
                        },
                        child: Text('Clear',
                            style: TextStyle(color: Colors.white)),
                      ),
                      CupertinoButton(
                        onPressed: () async {
                          var svg = control.toSvg(
                            color: model.color,
                            type: SignatureDrawType.shape,
                            fit: model.fit,
                          );
                          setValue(svg);
                          Navigator.pop(context);
                        },
                        child:
                            Text('Save', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
