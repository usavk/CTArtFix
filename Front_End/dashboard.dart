import 'package:flutter/material.dart';  // Correct import
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // For handling media types
import 'package:artifact/login.dart';
import 'package:artifact/signup.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  XFile? imageFile;
  bool _imageLoadFailed = false;
  String? _selectedBodyPart; // Stores the selected body part

  // Pick image using ImagePicker
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }

  // Upload part and image to the server
  Future<void> uploadData() async {
    if (_selectedBodyPart == null || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a body part and upload an image')),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST', Uri.parse('http://192.168.149.82/remo/dashboard.php'), // Update with your server URL
      );

      // Add the part data
      request.fields['part'] = _selectedBodyPart!;

      // Add the image file
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile!.path,
        contentType: MediaType('image', 'jpeg'), // You can adjust based on the file type
      ));

      // Send the request
      var response = await request.send();

      // Check if the request was successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Part and image uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload data')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Navigate back when the back icon is pressed
          },
        ),
        title: const Text('Artifact Assistant'),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: _imageLoadFailed
                    ? const AssetImage('assets/radiology.jpeg') // Placeholder image
                    : const AssetImage('assets/doctor_image.jpg'),
                onBackgroundImageError: (_, __) {
                  setState(() {
                    _imageLoadFailed = true;
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Artifact Assistant',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlue),
              ),
              const SizedBox(height: 10),
              const Text('Welcome, Doctor!', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Select body part:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          // List of body parts
                          RadioListTile<String>(
                            title: const Text('Brain'),
                            value: 'Brain',
                            groupValue: _selectedBodyPart,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyPart = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Thorax'),
                            value: 'Thorax',
                            groupValue: _selectedBodyPart,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyPart = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Abdomen'),
                            value: 'Abdomen',
                            groupValue: _selectedBodyPart,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyPart = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Facial Bones'),
                            value: 'Facial Bones',
                            groupValue: _selectedBodyPart,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyPart = value;
                              });
                            },
                          ),
                          RadioListTile<String>(
                            title: const Text('Spine'),
                            value: 'Spine',
                            groupValue: _selectedBodyPart,
                            onChanged: (value) {
                              setState(() {
                                _selectedBodyPart = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Upload Image 📷'),
                  onTap: pickImage,
                ),
              ),
              if (imageFile != null)
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.file(
                      File(imageFile!.path),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: uploadData, // Call the upload function on button press
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Enter'),
              ),
              const SizedBox(height: 30),
              // Bottom Navigation Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () {
                      // Navigate to the Login page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () {
                      // Navigate to the Signup page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                      );
                    },
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
