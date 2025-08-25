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
    return await joshReq(
      () => http.get(Uri.parse(url)),
      messageTitle: 'getCatchingJoshWithHttpOnJosh',
    ).then((value) => value.body.toString());
  }

  Future<String?> getCatchingJoshWithDioOnJosh() async {
    return await joshReq(
      () => dio.get(url),
      messageTitle: 'getCatchingJoshWithDioOnJosh',
    ).then((value) => value.data.toString());
  }


  String? getCatchingJoshWithPrefs() {
    return joshSync(
      () => globalPrefs?.getString('haloText') ?? 'null 응답',
      messageTitle: 'getCatchingJoshWithPrefs',
    );
  }

  Future<bool?> setCatchingJoshWithPrefs() async {
    return await joshAsync(
      () async => globalPrefs?.setString('haloText', 'JOSH88') ?? false,
      messageTitle: 'setCatchingJoshWithPrefs',
    );
  }


  /// Demonstrates traditional error handling without CatchingJosh
  /// Shows how complex and verbose traditional try-catch approach can be
  /// This is what you'd have to write without using our package
  Future<String> traditionalErrorHandlingWithoutCatchingJosh() async {
    try {
      // Step 1: Make HTTP request
      final response = await http.get(Uri.parse(url));

      // Step 2: Check HTTP status code manually
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = response.body;

        // Step 3: Validate response data manually
        if (data.toString().isEmpty) {
          debugPrint(
              'Warning: HTTP ${response.statusCode} success but response data is empty');
          return 'Success but no data received';
        }

        // Step 4: Log success manually
        debugPrint('HTTP ${response.statusCode} Success: $data');
        return data.toString();
      } else {
        // Step 5: Handle different error status codes manually
        String errorMessage;
        switch (response.statusCode) {
          case 400:
            errorMessage = 'Bad Request (400)';
            break;
          case 401:
            errorMessage = 'Unauthorized (401)';
            break;
          case 403:
            errorMessage = 'Forbidden (403)';
            break;
          case 404:
            errorMessage = 'Not Found (404)';
            break;
          case 500:
            errorMessage = 'Internal Server Error (500)';
            break;
          default:
            errorMessage = 'HTTP ${response.statusCode} Error';
        }

        // Step 6: Log error manually
        debugPrint('HTTP Error: $errorMessage');
        return 'Error: $errorMessage';
      }

    } catch (e) {
      throw Exception(e);
    }
  }
}
