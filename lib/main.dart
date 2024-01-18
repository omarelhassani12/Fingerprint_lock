import 'package:fingerprint_lock/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> checkBiometrics() async {
    var localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        // Biometrics are available
      } else {
        // Biometrics are not available or not set up
      }
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> authenticate(BuildContext context) async {
    var localAuth = LocalAuthentication();

    try {
      bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Authenticate to unlock',
      );

      if (didAuthenticate) {
        // User authenticated successfully
        print('User authenticated successfully');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WelcomePage()),
        );
      } else {
        // Authentication failed
        print('Authentication failed');
      }
    } catch (e) {
      // Handle errors
      print('Error during authentication: $e');
    }
  }

  bool isFingerprintRegistered = false;

  Future<void> registerFingerprint() async {
    var localAuth = LocalAuthentication();

    try {
      bool canCheckBiometrics = await localAuth.canCheckBiometrics;
      List<BiometricType> availableBiometrics =
          await localAuth.getAvailableBiometrics();

      if (canCheckBiometrics && availableBiometrics.isNotEmpty) {
        // Biometrics are available
        isFingerprintRegistered = true;
        print('Fingerprint registered successfully');
      } else {
        // Biometrics are not available or not set up
        print('Biometrics not available or not set up');
      }
    } catch (e) {
      // Handle errors
      print('Error during fingerprint registration: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await checkBiometrics();
                  await registerFingerprint();
                  await authenticate(_scaffoldKey.currentContext!);
                },
                child: const Text('Register and Unlock with Fingerprint'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
