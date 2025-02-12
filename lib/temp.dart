/*
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
//import 'package:sms_advanced/sms_advanced.dart';
import 'package:telephony/telephony.dart';
void main() {
  runApp(EmergencyContactsApp());
}

class EmergencyContactsApp extends StatelessWidget {
  const EmergencyContactsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prompt Aid',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const SignInPage(), // Set the initial page
    );
  }
}

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    ProfilePage(),
    ChatbotPage(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.blueGrey,
        backgroundColor: Colors.white,
        unselectedFontSize: 14,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Ask Me!',
          )
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Telephony telephony = Telephony.instance;

  // Function to initiate a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  // Function to get current location as a string
  // Function to get current location as a string
  Future<String> _getCurrentAddress() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied.';
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high, // Specify the accuracy
        distanceFilter: 0, // Minimum distance change to trigger an update
      ),
    );

    return 'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
  }

  // Function to send SMS with current location
  Future<void> _sendSMS(String message, String recipient) async {
    final bool? permissionsGranted = await telephony.requestSmsPermissions;
    if (permissionsGranted ?? false) {
      await telephony.sendSms(
        to: recipient,
        message: message,
      );
    } else {
      throw 'SMS permissions not granted.';
    }
  }

  // Combined function: Call and send SMS
  Future<void> _handleEmergency(String phoneNumber) async {
    try {
      await _makePhoneCall(phoneNumber);
      String address = await _getCurrentAddress();
      String message = 'Emergency! My current location is: $address';
      await _sendSMS(message, phoneNumber);
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Prompt Aid.', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/m2.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildEmergencyButton(
                  label: 'Call Police',
                  color: const Color.fromARGB(255, 115, 165, 212),
                  icon: Icons.local_police,
                  onPressed: () => _handleEmergency("100"),
                ),
                _buildEmergencyButton(
                  label: 'Call Ambulance',
                  color: const Color.fromARGB(255, 26, 123, 203),
                  icon: Icons.local_hospital,
                  onPressed: () => _handleEmergency("102"),
                ),
                _buildEmergencyButton(
                  label: 'Medical Assistance',
                  color: const Color.fromARGB(255, 19, 130, 220),
                  icon: Icons.medical_services,
                  onPressed: () => _handleEmergency("103"),
                ),
                _buildEmergencyButton(
                  label: 'Call Fire Dept',
                  color: const Color.fromARGB(255, 94, 164, 221),
                  icon: Icons.fire_extinguisher,
                  onPressed: () => _handleEmergency("101"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(500.0),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}
class UserData {
  String name;
  String email;
  String phone;
  String bloodGroup;
  String address;
  String alternatePhone;
  String photoPath;

  UserData({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.bloodGroup = '',
    this.address = '',
    this.alternatePhone = '',
    this.photoPath = '',
  });
}

UserData userData = UserData();

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  // Form controllers
  final TextEditingController _nameController =
      TextEditingController(text: userData.name);
  final TextEditingController _emailController =
      TextEditingController(text: userData.email);
  final TextEditingController _phoneController =
      TextEditingController(text: userData.phone);
  final TextEditingController _bloodGroupController =
      TextEditingController(text: userData.bloodGroup);
  final TextEditingController _addressController =
      TextEditingController(text: userData.address);
  final TextEditingController _altPhoneController =
      TextEditingController(text: userData.alternatePhone);

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        userData.photoPath = pickedFile.path;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        userData.name = _nameController.text;
        userData.email = _emailController.text;
        userData.phone = _phoneController.text;
        userData.bloodGroup = _bloodGroupController.text;
        userData.address = _addressController.text;
        userData.alternatePhone = _altPhoneController.text;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!')),
      );
    }
  }

  void _logOut() {
    // Clear user data if needed
    userData = UserData(); // Reset the shared user data

    // Navigate to the SignInPage
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
      (route) => false, // Remove all routes until SignInPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personal Information'),
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Log Out',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : userData.photoPath.isNotEmpty
                            ? FileImage(File(userData.photoPath))
                            : const AssetImage('assets/placeholder.png')
                                as ImageProvider,
                    child: _selectedImage == null &&
                            (userData.photoPath.isEmpty)
                        ? const Icon(Icons.camera_alt, size: 40)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _bloodGroupController,
                decoration: const InputDecoration(
                  labelText: 'Blood Group',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your blood group' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _altPhoneController,
                decoration: const InputDecoration(
                  labelText: 'Alternate Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty
                    ? 'Please enter an alternate phone number'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _userQuery = "Press the mic and ask your question.";
  String _botResponse = "";
  final TextToSpeech _tts = TextToSpeech();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _speech.stop();
    super.dispose();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print('Status: $status'),
        onError: (error) => print('Error: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (result) {
          if (mounted) {
            setState(() {
              _userQuery = result.recognizedWords;
              _botResponse =
                  _getEmergencyResponse(_userQuery); // Get bot response
              _speak(_botResponse); // Speak response
            });
          }
        });
      } else {
        if (mounted) {
          setState(() => _isListening = false);
        }
        print("Speech recognition not available");
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  String _getEmergencyResponse(String query) {
    // Hardcoded emergency response logic
    query = query.toLowerCase();
    if (query.contains("police") ||
        query.contains("robber") ||
        query.contains("suspicious") ||
        query.contains("thief") ||
        query.contains("unsafe") ||
        query.contains("alone") ||
        query.contains("following")) {
      return "For police assistance, please call 100.";
    } else if (query.contains("ambulance") ||
        query.contains("medical") ||
        query.contains("heart") ||
        query.contains("not well") ||
        query.contains("sick") ||
        query.contains("symptoms")) {
      return "For medical emergencies, call 102 for an ambulance.";
    } else if (query.contains("fire") ||
        query.contains("smoke") ||
        query.contains("burn") ||
        query.contains("need water") ||
        query.contains("no water") ||
        query.contains("short circuit") ||
        query.contains("hot") ||
        query.contains("fire briade")) {
      return "In case of fire, call 101 immediately.";
    } else if (query.contains("help")) {
      return "I'm here to help. You can ask about police, ambulance, fire, or medical assistance.";
    } else {
      return "I'm sorry, I didn't understand that. Can you please repeat?";
    }
  }

  void _speak(String response) {
    _tts.speak(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Chatbot'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "You said:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _userQuery,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Chatbot Response:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _botResponse,
                      style:
                          const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _listen,
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
            ),
          ],
        ),
      ),
    );
  }
}
*/