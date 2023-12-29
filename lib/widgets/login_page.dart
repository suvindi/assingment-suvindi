import 'dart:convert';
import 'package:assignment_new/widgets/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'my_button.dart';
import 'my_textfeild.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) async {
    // Simulated authentication logic (replace with your actual authentication logic)
    final String username = usernameController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty) {
      // Authentication successful
      print('Authentication successful. Redirecting...');

      // Navigate to the HotelListPage on successful login
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HotelListPage()),
      );
    } else {
      // Authentication failed
      print('Authentication failed. Please enter valid credentials.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Authentication failed. Please enter valid credentials.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> loginWithFacebook(BuildContext context) async {
    final fb = FacebookLogin();

    final result = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (result.status) {
      case FacebookLoginStatus.success:
      // Successful Facebook login
        print('Facebook login successful. Redirecting...');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facebook login successful!'),
            duration: Duration(seconds: 2),
          ),
        );

        // You may want to perform additional logic here, such as linking Facebook account
        // with an existing account in your app.

        // Navigate to the HotelListPage on successful login
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HotelListPage()),
        );
        break;

      case FacebookLoginStatus.cancel:
      // User canceled the login process
        print('Facebook login canceled by user.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Facebook login canceled by user.'),
            duration: Duration(seconds: 2),
          ),
        );
        break;

      case FacebookLoginStatus.error:
      // Facebook login error
        print('Error during Facebook login: ${result.error}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during Facebook login. Please try again.'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                MyTextField(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                MyButton(
                  onTap: () => signUserIn(context),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () => loginWithFacebook(context),
                  child: Image.asset(
                    'assets/facebook.png',
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    // google button
                    // SquareTile(imagePath: 'assets/google.png'),

                    SizedBox(width: 25),

                    // apple button
                    // SquareTile(imagePath: 'assets/apple.png'),
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class HotelListPage extends StatefulWidget {
  @override
  _HotelListPageState createState() => _HotelListPageState();
}

class _HotelListPageState extends State<HotelListPage> {
  late GoogleMapController mapController;
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    // Fetch the list of hotels from the JSON file (replace with your own logic)
    final List<Hotel> hotels = loadHotelsFromJson();

    // Coordinates for the initial camera position
    final CameraPosition initialCameraPosition = CameraPosition(
      target: LatLng(37.7749, -122.4194), // Replace with your default location
      zoom: 12.0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Hotel List with Map'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: _createMarkers(hotels), // Create markers from hotel data
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hotels.length,
              itemBuilder: (context, index) {
                final hotel = hotels[index];
                return ListTile(
                  title: Text(hotel.name),
                  subtitle: Text(hotel.address),
                  onTap: () {
                    // Implement the onTap action if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _createMarkers(List<Hotel> hotels) {
    return hotels
        .map(
          (hotel) => Marker(
        markerId: MarkerId(hotel.name),
        // position: LatLng( /* Add your hotel's latitude */; /* Add your hotel's longitude */),
        infoWindow: InfoWindow(
          title: hotel.name,
          snippet: hotel.address,
        ),
      ),
    )
        .toSet();
  }

  List<Hotel> loadHotelsFromJson() {
    // Replace this with your own logic to load data from a JSON file
    // In this example, I'm using a simple JSON string for demonstration purposes
    const jsonString = '''
      [
        {"name": "Celestial Suites", "address": "123 Main St", "image": "https://example.com/image1.jpg"},
        {"name": "Serenity Haven", "address": "456 Oak St", "image": "https://example.com/image2.jpg"},
        {"name": "Mirage Oasis", "address": "789 Elm St", "image": "https://example.com/image3.jpg"},
        {"name": "Celestial Suites", "address": "123 Main St", "image": "https://example.com/image1.jpg"},
        {"name": "Serenity Haven", "address": "456 Oak St", "image": "https://example.com/image2.jpg"}
      ]
    ''';

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Hotel.fromJson(json)).toList();
  }
}