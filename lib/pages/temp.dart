/*
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';

void main() {
  runApp(EmergencyContactsApp());
}

class EmergencyContactsApp extends StatelessWidget {
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
      home: BottomNavBar(),
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
  // Function to initiate a phone call
  void _makePhoneCall(String phoneNumber) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Prompt Aid.', style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/m2.jpg"),
                  fit:
                      BoxFit.cover, // Ensure the image covers the entire screen
                ),
              ),
            ),
          ),
          // Foreground content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2, // Two buttons per row
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: [
                _buildEmergencyButton(
                  label: 'Call Police',
                  color: Color.fromARGB(255, 115, 165, 212),
                  icon: Icons.local_police,
                  onPressed: () => _makePhoneCall("100"),
                ),
                _buildEmergencyButton(
                  label: 'Call Ambulance',
                  color: Color.fromARGB(255, 26, 123, 203),
                  icon: Icons.local_hospital,
                  onPressed: () => _makePhoneCall("102"),
                ),
                _buildEmergencyButton(
                  label: 'Medical Assistance',
                  color: Color.fromARGB(255, 19, 130, 220),
                  icon: Icons.medical_services,
                  onPressed: () => _makePhoneCall("103"),
                ),
                _buildEmergencyButton(
                  label: 'Call Fire Dept',
                  color: Color.fromARGB(255, 94, 164, 221),
                  icon: Icons.fire_extinguisher,
                  onPressed: () => _makePhoneCall("101"),
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
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
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

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Personal Information.'),
      ),
      body: const Center(
        child: Text(
          'This is the Profile Page.',
          style: TextStyle(fontSize: 18),
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
        title: Text('Emergency Chatbot'),
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
                    Text(
                      "You said:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _userQuery,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Chatbot Response:",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _botResponse,
                      style:
                          TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
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