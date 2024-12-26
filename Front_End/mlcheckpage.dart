import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart'; // Import the package
import 'package:artifact/login.dart'; // Import login page
import 'package:artifact/signup.dart'; // Import signup page

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _className = "";
  double _confidenceScore = 0.0;
  bool _isLoading = false;

  // Function to pick an image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _isLoading = true;
      });
      await _uploadImage(_image!);
    }
  }

  // Function to upload image to server and get prediction result
  Future<void> _uploadImage(File image) async {
    try {
      final uri = Uri.parse('http://192.168.148.82:5000/predict'); // Replace with your Flask server IP
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('image', image.path));
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final result = json.decode(String.fromCharCodes(responseData));

      setState(() {
        _className = result['class_name'];
        _confidenceScore = result['confidence_score'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _className = "Error occurred";
        _confidenceScore = 0.0;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          // Top Rounded Header
          Container(
            decoration: const BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: const Center(
              child: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 90,
                      backgroundImage: const AssetImage('assets/radiology.jpeg'),
                      backgroundColor: Colors.transparent,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome, Doctor!',
                      style: TextStyle(fontSize: 20, color: Colors.black87),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 28, color: Colors.white),
                      label: const Text(
                        'Take a Picture',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo, size: 28, color: Colors.white),
                      label: const Text(
                        'Select from Gallery',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (_image != null)
                      Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _image!,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Display the class name based on the server response
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: _className.trim().toLowerCase() == "with"
                                      ? 'CT shows artifact'
                                      : 'CT is artifact free!!!',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: () {
                                      if (_className.trim().toLowerCase() == "with") {
                                        if ((_confidenceScore <= 0.7)) {
                                          return Colors.orange; // Orange for "With" and score < 70
                                        }
                                        return Colors.red; // Red for "With" and score >= 70
                                      }
                                      return const Color.fromARGB(255, 31, 164, 71); // Green for "artifact free"
                                    }(),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          // Circular progress indicator with confidence score
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // Inner padding
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: () {
                                    if (_className.trim().toLowerCase() == "with") {
                                      if ((_confidenceScore <= 0.7)) {
                                        return const Color.fromARGB(255, 196, 79, 0); // Orange for "With" and score < 70
                                      }
                                      return const Color.fromARGB(255, 179, 17, 17); // Red for "With" and score >= 70
                                    }
                                    return const Color.fromARGB(255, 18, 132, 37); // Green for "artifact free"
                                  }(),
                                ),
                              ),
                              // Circular Percent Indicator
                              // Circular Percent Indicator
                              CircularPercentIndicator(
                                radius: 50.0, // Size of the indicator
                                lineWidth: 20.0, // Thickness of the outer progress line
                                percent: _confidenceScore,
                                center: Text(
                                  '${(_confidenceScore * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                // Change the progressColor dynamically based on _className and _confidenceScore
                                progressColor: _className.trim().toLowerCase() == "with"
                                    ? (_confidenceScore <= 0.7
                                    ? Colors.orange  // Orange for scores <= 70%
                                    : Colors.red)     // Red for scores > 70
                                    : const Color.fromARGB(255, 31, 164, 71),  // Green for "artifact free"
                                // Green for other cases
                                backgroundColor: Colors.grey[300]!, // Background color for the indicator
                              ),
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'Pick an image to proceed with your journey!',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom Rounded Section for Buttons
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -3),
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.logout, size: 30, color: Colors.red),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.person_add, size: 30, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Signup()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
