import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CreateQr extends StatefulWidget {
  const CreateQr({super.key});

  @override
  State<CreateQr> createState() => _CreateQrState();
}

class _CreateQrState extends State<CreateQr> {
  File? _image;
  String? _pdfPath;
  String? _downloadUrl;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _animalNameController = TextEditingController();
  TextEditingController _animalSexController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _animalNameController.dispose();
    _animalSexController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
  }

  Future<void> _createPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Name: ${_nameController.text}'),
              pw.Text('Phone: ${_phoneController.text}'),
              pw.Text('Animal Name: ${_animalNameController.text}'),
              pw.Text('Animal Sex: ${_animalSexController.text}'),
            ],
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/data.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      _pdfPath = file.path; // Сохраните путь к PDF
    });
    await _uploadPdfToFirebase(file);
  }

  Future<void> _uploadPdfToFirebase(File file) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final pdfRef =
      storageRef.child("pdfs/${DateTime.now().millisecondsSinceEpoch}.pdf");
      await pdfRef.putFile(file);
      final downloadUrl = await pdfRef.getDownloadURL();

      setState(() {
        _downloadUrl = downloadUrl;
      });
    } catch (e) {
      print('Error uploading PDF to Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Find My Cat'),
          centerTitle: true,
          backgroundColor: Colors.green[800],
          actions: [],
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Column(children: [
                const SizedBox(height: 10),
                _image == null
                    ? Container(
                  width: screenWidth / 2,
                  height: screenHeight / 5,
                  child: Icon(
                    Icons.image,
                    size: screenHeight / 5,
                    color: Colors.green,
                  ),
                )
                    : Container(
                  width: screenWidth / 2,
                  height: screenHeight / 5,
                  child: Image.file(
                    _image!,
                    width: screenWidth,
                    height: screenHeight / 5,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(left: -5.0),
                      iconSize: 25,
                      onPressed: _removeImage,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                    IconButton(
                      padding: const EdgeInsets.only(right: -5.0),
                      iconSize: 25,
                      onPressed: _pickImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        color: Colors.green[800],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: screenWidth / 1.1,
                    child: TextField(
                      controller: _nameController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your Name',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: screenWidth / 1.1,
                    child: TextField(
                      controller: _phoneController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter your phone',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: screenWidth / 1.1,
                    child: TextField(
                      controller: _animalNameController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter name animal',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    width: screenWidth / 1.1,
                    child: TextField(
                      controller: _animalSexController,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Enter sex animal',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createPdf,
                  child: const Text('Create PDF'),
                ),
                if (_downloadUrl != null)
                  QrImageView(
                    data: _downloadUrl!, // Используем URL для QR-кода
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
              ]),
            )));
  }
}
