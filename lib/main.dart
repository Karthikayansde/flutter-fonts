import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CustomFontExample(),
    );
  }
}

class CustomFontExample extends StatefulWidget {
  @override
  _CustomFontExampleState createState() => _CustomFontExampleState();
}

class _CustomFontExampleState extends State<CustomFontExample> {
  List<String> customFontFamily = [];
  int count = -1;

  Future<void> pickFontFile() async {
    // Use file_picker to let user select a .ttf file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ttf'],
    );

    if (result != null && result.files.single.bytes != null) {
      Uint8List fontData = result.files.single.bytes!;
      count++;
      // Load the font dynamically using FontLoader
      String fontFamily = 'CustomFontFamily$count'; // Arbitrary name for the font family
      FontLoader fontLoader = FontLoader(fontFamily);
      fontLoader.addFont(Future.value(ByteData.view(fontData.buffer)));

      await fontLoader.load(); // Load the font

      // Set the font family name for use in the widget tree
      setState(() {
        customFontFamily.add(fontFamily);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dynamic Font Picker Example')),
      body: Column(
        children: [
          Center(
            child: customFontFamily.isNotEmpty
                ? Text(
              'ABCDEFGHIJKLMNOPQRSTUVWXYZ\nabcdefghijklmnopqrstuvwwxyz\nHARTI\nHarti',
              style: TextStyle(
                fontFamily: customFontFamily[count],
                fontSize: 48,
              ),
            )
                : Text('Pick a font file to display text'),
          ),
          Expanded(child: ListView.builder( itemCount: customFontFamily.length, itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(onTap: (){
              setState(() {
                count = index;
              });
            }, child: Container(child: Text(customFontFamily[index],style: TextStyle(color: Colors.red),),color: Colors.grey,)),
          ),))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFontFile,
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
