import 'package:catching_josh/catching_josh.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

SharedPreferences? globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalPrefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MockPage());
  }
}

class MockPage extends StatefulWidget {
  const MockPage({super.key});

  @override
  State<MockPage> createState() => _MockPageState();
}

class _MockPageState extends State<MockPage> {
  final dio = Dio();
  final url = "http://localhost:3000";
  String haloText = "JUST";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              haloText,
              style: TextStyle(fontSize: 32),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    final getText = await getCatchingJoshWithHttpOnJosh();
                    setState(() {
                      haloText = getText;
                    });
                  },
                  icon: Icon(
                    Icons.music_note,
                    size: 32,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    final getText = await getCatchingJoshWithDioOnJosh();
                    setState(() {
                      haloText = getText ?? 'Dio-Null';
                    });
                  },
                  icon: Icon(
                    Icons.piano,
                    size: 32,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final getText = getCatchingJoshWithPrefs();
                        setState(() {
                          haloText = getText ?? 'Prefs-Null';
                        });
                      },
                      icon: Icon(
                        Icons.get_app,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final result = await setCatchingJoshWithPrefs();
                        setState(() {
                          haloText = result.toString();
                        });
                      },
                      icon: Icon(
                        Icons.save,
                        size: 32,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String> getCatchingJoshWithHttpOnJosh() async {
    final standardResponse = await joshReq(
      () => http.get(Uri.parse(url)),
    );
    return standardResponse.data?.toString() ?? 'No data';
  }

  Future<String?> getCatchingJoshWithDioOnJosh() async {
    final standardResponse = await joshReq(
      () => dio.get(url),
    );
    return standardResponse.data?.toString();
  }

  String? getCatchingJoshWithPrefs() {
    final standardResult = joshSync(
      () => globalPrefs?.getString('haloText') ?? 'null 응답',
      logTitle: 'getCatchingJoshWithPrefs',
      showSuccessLog: true,
    );
    return standardResult.data?.toString();
  }

  Future<bool?> setCatchingJoshWithPrefs() async {
    final standardResult = await joshAsync(
      () async => globalPrefs?.setString('haloText', 'JOSH88') ?? false,
      logTitle: 'setCatchingJoshWithPrefs',
      showSuccessLog: true,
    );
    return standardResult.data as bool?;
  }

  /// Demonstrates traditional error handling without CatchingJosh
  /// Shows how complex and verbose traditional try-catch approach can be
  /// This is what you'd have to write without using our package
  ///
  /// Compare this with the simple joshReq() approach above!
  Future<String> traditionalErrorHandlingWithoutCatchingJosh() async {
    try {
      // Step 1: Make HTTP request
      final response = await http.get(Uri.parse(url));

      // Step 2: Check if request was successful (same logic as joshReq)
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Step 3: Log success manually
        debugPrint('HTTP ${response.statusCode} Success: ${response.body}');
        return response.body.toString();
      } else {
        // Step 4: Log error manually
        debugPrint(
            'HTTP Error: ${response.statusCode} - ${response.reasonPhrase}');
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      // Step 5: Handle exceptions manually
      debugPrint('Exception: $e');
      return 'Exception: $e';
    }
  }
}
