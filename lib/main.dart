import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
//import 'database_helper.dart';
import 'dart:io';
//import 'dart:convert';
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
      home: SplashScreen(), // Set the initial page
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BottomNavBar()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black, // Classic black background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logono2.jpg',
                height: 250,
              ),
              const SizedBox(height: 20),
              const Text(
                "Prompt Aid",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Georgia', // Adding a classic font
                ),
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
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
    AboutPage(),
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
        selectedItemColor: Colors.black,
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
            label: 'Ask Me',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement_sharp),
            label: 'About Us',
          )
        ],
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: const Color.fromARGB(255, 138, 167, 216),
      ),
      body: const Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to Prompt Aid!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Finding a consolidated platform for your emergencies? We got you!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to Use the App:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Prompt Aid is a user-friendly mobile application designed to provide efficient and interactive support for emergency situations and personalized information management. Leveraging the power of Flutter, this project integrates a chatbot feature to assist users with real-time emergency response information, such as contacting police, fire, or medical services. It also includes a user profile management module to store and update personal and medical information, ensuring quick access in critical situations.'
                '\n \n Here are some steps you should follow : \n'
                '1. Fill out the form with your personal information.\n'
                '2. Tap on the "Save Profile" button to save your details.\n'
                '3. You can update your profile anytime.\n'
                '4. If needed, upload a profile picture using the camera icon.\n\n',
                style: TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 20),
              const Text(
                'If you encounter any issues, please contact support at promptaid@outlook.com',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
} /*
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About the App'),
        backgroundColor: const Color.fromARGB(255, 138, 167, 216),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to the App!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'This app allows users to create and manage their profiles, '
                'save personal information such as name, email, phone number, blood group, '
                'medical history, and more.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'How to Use the App:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '1. Fill out the form with your personal information.\n'
                '2. Tap on the "Save Profile" button to save your details.\n'
                '3. You can update your profile anytime.\n'
                '4. If needed, upload a profile picture using the camera icon.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'If you encounter any issues, please contact support at support@app.com.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/

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
        accuracy: LocationAccuracy.high,
        distanceFilter: 0,
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
        title: const Text(
          'Prompt Aid.',
          textAlign: TextAlign.center, // Centers the text within the AppBar
          style: TextStyle(
            color: Colors.blueGrey, // Text color
            fontWeight: FontWeight.bold, // Makes the text bold
          ),
        ),
        centerTitle: true, // Ensures the title is centered on iOS
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
                  color: const Color.fromARGB(255, 80, 134, 179),
                  icon: Icons.local_hospital,
                  onPressed: () => _handleEmergency("102"),
                ),
                _buildEmergencyButton(
                  label: 'Cybercrime Helpline',
                  color: const Color.fromARGB(255, 50, 126, 194),
                  icon: Icons.computer,
                  onPressed: () => _handleEmergency("1930"),
                ),
                _buildEmergencyButton(
                  label: 'Anti Poison Helpline',
                  color: const Color.fromARGB(255, 120, 187, 241),
                  icon: Icons.woman_rounded,
                  onPressed: () => _handleEmergency("1066"),
                ),
                _buildEmergencyButton(
                  label: 'Women Helpline',
                  color: const Color.fromARGB(255, 66, 136, 194),
                  icon: Icons.woman_rounded,
                  onPressed: () => _handleEmergency("1091"),
                ),
                _buildEmergencyButton(
                  label: 'Call Fire Dept',
                  color: const Color.fromARGB(255, 87, 168, 234),
                  icon: Icons.fire_extinguisher,
                  onPressed: () => _handleEmergency("101"),
                ),
                _buildEmergencyButton(
                  label: 'Senior Citizen Helpline',
                  color: const Color.fromARGB(255, 68, 120, 163),
                  icon: Icons.elderly_woman,
                  onPressed: () => _handleEmergency("1291"),
                ),
                _buildEmergencyButton(
                  label: 'Traffic Police',
                  color: const Color.fromARGB(255, 81, 142, 192),
                  icon: Icons.car_crash,
                  onPressed: () => _handleEmergency("103"),
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
      MaterialPageRoute(builder: (context) => BottomNavBar()),
      (route) => false, // Remove all routes until SignInPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 167, 216),
        title: const Text(
          'Your Personal Information',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _logOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Back to Home',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/m2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
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
                      child:
                          _selectedImage == null && (userData.photoPath.isEmpty)
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
                      value!.isEmpty ? 'Please enter your name.' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email id.' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your phone number.' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bloodGroupController,
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your blood group.' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'Important Medical History',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your medical history.'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _altPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Alternate Phone Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter an alternate phone number.'
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
  bool _isSpeaking = false; // Tracks if the chatbot is narrating
  String _userQuery =
      "Press the mic and ask your question. Turn it off my pressing it again.";
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
    _tts.stop(); // Stop text-to-speech when the widget is disposed
    super.dispose();
  }

  void _listen() async {
    if (_isListening) {
      // Stop both speech recognition and narration if listening
      _speech.stop();
      _tts.stop(); // Stop narration if speaking
      setState(() {
        _isListening = false;
        _isSpeaking = false;
      });
    } else {
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
        setState(() => _isListening = false);
        print("Speech recognition not available");
      }
    }
  }

  String _getEmergencyResponse(String query) {
    query =
        query.toLowerCase(); // Normalize input for case-insensitive matching.

    // **Police-Related Emergencies**
    if (query.contains("police") ||
        query.contains("crime") ||
        query.contains("robbery") ||
        query.contains("assault") ||
        query.contains("break-in") ||
        query.contains("stalker") ||
        query.contains("theft") ||
        query.contains("dangerous person")) {
      return "If you are witnessing or involved in a crime, your first step is to ensure your own safety. Find a secure location where you can observe without being seen. Dial 100 immediately and clearly explain the situation to the police. Provide details such as the type of crime, location, descriptions of any suspects, and any threats to your safety. Avoid intervening unless absolutely necessary for someone else's safety. If you are being followed or stalked, move to a public place, notify someone nearby, and inform the authorities immediately.";

      // **Medical Emergencies**
    } else if (query.contains("ambulance") ||
        query.contains("not feeling well") ||
        query.contains("stroke") ||
        query.contains("choking") ||
        query.contains("unconscious") ||
        query.contains("bleeding") ||
        query.contains("allergic reaction") ||
        query.contains("seizure")) {
      return "For medical emergencies, call 102 or your country's emergency medical service. If the issue is a heart attack or stroke, time is critical—try to get the patient to a hospital equipped for cardiac care. For choking, perform the Heimlich maneuver if trained. In case of unconsciousness, check for breathing and pulse. If both are absent, begin CPR immediately. For bleeding, apply firm pressure to the wound using a clean cloth. Keep the patient calm, warm, and reassured until help arrives.";

      // **Fire-Related Emergencies**
    } else if (query.contains("heart attack")) {
      return "Immediately call emergency medical services 112, have them sit down and rest, loosen tight clothing, and if they have prescribed nitroglycerin, help them take it while waiting for help to arrive; if they are unconscious and not breathing, begin CPR if trained, and use an AED if available.";
    } else if (query.contains("fracture")) {
      return "To treat a fracture, the primary goal is to immobilize the broken bone by applying a splint or cast to keep the bone fragments aligned, while managing pain with medication, and seeking immediate medical attention to determine the severity of the fracture and whether surgery is necessary; do not attempt to reposition the bone yourself unless trained to do so, and always prioritize seeking professional medical care";
    } else if (query.contains("fever")) {
      return "To treat a fever, prioritize staying hydrated by drinking plenty of fluids like water, wear light clothing, get plenty of rest, and take over-the-counter medications like acetaminophen (Tylenol) or ibuprofen (Advil, Motrin) if needed to help bring down your temperature; avoid alcohol and keep your room at a comfortable temperature; consult a doctor if your fever is very high, accompanied by severe symptoms, or persists for an extended period.";
    } else if (query.contains("fire") ||
        query.contains("smoke") ||
        query.contains("burning") ||
        query.contains("gas leak") ||
        query.contains("short circuit") ||
        query.contains("explosion")) {
      return "If you detect fire or smoke, evacuate the building immediately without taking personal belongings. Alert others as you leave, and call 101 to report the fire. Provide the exact location and any critical details (e.g., trapped individuals or hazardous materials). If you cannot exit due to smoke, stay low to the ground and cover your nose and mouth with a wet cloth. For gas leaks, avoid turning on lights or using electrical appliances, as they could ignite the gas. Move to fresh air immediately and inform authorities.";

      // **Natural Disasters**
    } else if (query.contains("earthquake") ||
        query.contains("flood") ||
        query.contains("hurricane") ||
        query.contains("cyclone") ||
        query.contains("storm") ||
        query.contains("landslide") ||
        query.contains("tsunami")) {
      return "During a natural disaster, your safety depends on preparation and quick action. For earthquakes, drop, cover, and hold on under sturdy furniture. Stay away from windows and exterior walls. In case of a flood, avoid walking or driving through water and move to higher ground immediately. For hurricanes or cyclones, secure your home and have an emergency kit ready. Follow evacuation orders and avoid staying in areas prone to landslides or tsunamis. Monitor local news for updates and instructions from authorities.";

      // **Pandemics and Public Health Crises**
    } else if (query.contains("pandemic") ||
        query.contains("covid") ||
        query.contains("virus") ||
        query.contains("infection") ||
        query.contains("fever") ||
        query.contains("symptoms")) {
      return "If you suspect illness during a pandemic, self-isolate to prevent spreading the infection. Monitor your symptoms, and if they worsen (e.g., difficulty breathing or high fever), contact a healthcare provider immediately. Practice hygiene by washing hands regularly, wearing a mask, and avoiding crowded places. If you need medical attention, inform healthcare workers about your symptoms beforehand so they can take precautions. Keep emergency contacts and essential supplies ready.";

      // **Animal-Related Emergencies**
    } else if (query.contains("snake bite") ||
        query.contains("dog bite") ||
        query.contains("wild animal") ||
        query.contains("poisonous") ||
        query.contains("bee sting")) {
      return "For a snake bite, keep the victim calm and immobilized to slow venom spread. Avoid trying to suck out venom or applying a tourniquet. Seek medical help immediately and describe the snake if possible. For dog bites, wash the wound thoroughly with soap and water, apply an antiseptic, and seek medical attention for possible rabies vaccination. In case of a bee sting, remove the stinger by scraping (not pinching) and apply a cold compress to reduce swelling. Monitor for severe allergic reactions, such as difficulty breathing.";

      // **Being Stranded or Lost**
    } else if (query.contains("stranded") ||
        query.contains("lost") ||
        query.contains("alone") ||
        query.contains("no phone") ||
        query.contains("help me")) {
      return "If you are stranded or lost, assess your surroundings for potential hazards and shelter options. Try to stay in one visible location to increase the chances of rescue. Conserve energy and signal for help using reflective objects, fires, or noise. If possible, mark your location using GPS or landmarks and inform someone about your predicament. Stay hydrated and avoid unnecessary movement unless absolutely necessary.";

      // **Mental Health or Emotional Distress**
    } else if (query.contains("mental health") ||
        query.contains("depressed") ||
        query.contains("anxious") ||
        query.contains("suicidal") ||
        query.contains("stress")) {
      return "Mental health crises are just as critical as physical emergencies. Reach out to a trusted friend, family member, or mental health professional. Breathing exercises and grounding techniques can help in the moment. If you or someone else is feeling suicidal or in severe distress, call a helpline in your region immediately. In India, you can reach out to iCall at +91 9152987821 for free mental health support.";

      // **Transportation Accidents**
    } else if (query.contains("car accident") ||
        query.contains("bike accident") ||
        query.contains("collision") ||
        query.contains("injury in road") ||
        query.contains("hit and run")) {
      return "If you witness or are involved in a road accident, first ensure your own safety. Move out of traffic if possible. Call 102 for medical assistance and 100 for police reporting. Take note of important details like the vehicle number, time, and location. If the injured person is conscious, reassure them while waiting for help. Avoid moving severely injured individuals unless absolutely necessary.";

      // **General Help**
    } else if (query.contains("help") ||
        query.contains("emergency") ||
        query.contains("assist") ||
        query.contains("what to do")) {
      return "I'm here to assist with emergencies. Please specify the type of help you need, such as police assistance, medical emergencies, fire-related situations, or guidance during natural disasters. Be as specific as possible for the most accurate advice.";

      // **Unrecognized Input**
    } else {
      return "I'm sorry, I couldn't understand your query. Please provide more details or ask about emergencies like police, medical help, fire, natural disasters, or mental health crises. I'm here to help!";
    }
  }

  void _speak(String response) {
    _tts.stop(); // Stop any ongoing narration before starting a new one
    setState(() => _isSpeaking = true);
    _tts.speak(response).then((_) {
      if (mounted) setState(() => _isSpeaking = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 45, 188, 224),
        title: const Text(
          'The AidBot',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        centerTitle: true, // Aligns the title to the center
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/logono1.jpg', // Path to the image in your assets folder
              fit: BoxFit.contain, // Adjusts the image to fill the background
            ),
          ),
          // Content of the body
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Prompt :",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _userQuery,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Prompt Aid Response :",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _botResponse,
                          style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.black),
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
        ],
      ),
    );
  }
}
