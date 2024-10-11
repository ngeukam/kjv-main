import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:BibleEngama/services/login_register.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final LoginRegisterService apiService = LoginRegisterService();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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

  void handleRegister() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      showToast("Tous les champs sont obligatoires.");
    } else if (passwordController.text != confirmPasswordController.text) {
      showToast("Les mots de passe ne correspondent pas.");
    } else if (passwordController.text.length < 6) { // Vérification de la longueur
      showToast("Le mot de passe doit contenir au moins 6 caractères.");
    } else {
      try {
        setState(() {
          _loading = true;
        });
        final response = await apiService.register(
          nameController.text,
          emailController.text,
          passwordController.text,
        );
        if (response['message'] == 'Email already exists.') {
          showToast("Cette adresse email existe déjà!");
        } else if (response['message'] == 'User registered successfully.') {
          Get.snackbar(
            'Enregistrement réussi!',
            'Connectez-vous',
            backgroundColor: Colors.white,
            borderColor: Colors.greenAccent,
            borderWidth: 2,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          Get.to(() => LoginPage(), transition: Transition.rightToLeft);
        }
      } catch (e) {
        showToast("Échec de l'enregistrement, vérifier les champs.");
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

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
                constraints: BoxConstraints(maxWidth: 400), // Adjust the max width as needed
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
                        'S\'enregistrer',
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
                              controller: nameController,
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person, color: Colors.white),
                                labelText: 'Nom',
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
                              onChanged: (value) {
                                emailController.value = emailController.value.copyWith(
                                  text: value.toLowerCase(),
                                  selection: TextSelection.collapsed(offset: value.length),
                                );
                              },
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
                                fillColor: Colors.grey.withOpacity(0.3),
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
                            TextField(
                              controller: confirmPasswordController,
                              style: TextStyle(color: Colors.white),
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock, color: Colors.white),
                                labelText: 'Confirmation mot de passe',
                                labelStyle: TextStyle(color: Colors.white),
                                filled: true,
                                fillColor: Colors.grey.withOpacity(0.3),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword = !_obscureConfirmPassword;
                                    });
                                  },
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
                        onPressed: handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'S\'enregistrer',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => LoginPage());
                        },
                        child: Text(
                          'Se Connecter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
