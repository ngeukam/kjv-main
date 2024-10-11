import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:BibleEngama/services/login_register.dart';
import 'package:BibleEngama/pages/register_page.dart';
import 'package:BibleEngama/pages/bibleoption_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginRegisterService apiService = LoginRegisterService();

  bool _obscurePassword = true;
  bool _loading = false;

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 3,
    );
  }

  void handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty ) {
      showToast("Tous les champs sont obligatoires.");
    }else{
    try {
      setState(() {
        _loading = true;
      });
      final response = await apiService.login(
        emailController.text,
        passwordController.text,
      );

      if (response['token'] != null) {
        Get.snackbar(
          'Bonne lecture!',
          'Vous êtes connecté.e!',
          backgroundColor: Colors.white,
          borderColor: Colors.greenAccent,
          borderWidth: 2,
          duration: Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
        );
        Get.to(() => BibleOptionsPage(), transition: Transition.rightToLeft);
      }
    } catch (e) {
      showToast("Erreur de connexion. Vérifiez vos identifiants.");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  } }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/blue-fond.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.grey.withOpacity(0.4),
          ),
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400), // Adjust as needed
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/logo.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Se Connecter',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        child: Column(
                          children: [
                            TextField(
                              controller: emailController,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email, color: Colors.white),
                                labelText: 'E-mail',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: passwordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.white),
                                labelText: 'Mot de passe',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.4),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                showToast("Fonctionnalité à implémenter !");
                              },
                              child: Text(
                                'Mot de passe oublié ?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => RegisterPage(), transition: Transition.rightToLeft);
                              },
                              child: Text(
                                'Pas de compte ? S\'enregistrer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      _loading
                          ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                          : ElevatedButton(
                        onPressed: handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
