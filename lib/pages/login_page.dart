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

  bool _obscurePassword = true; // Variable pour masquer le mot de passe
  bool _loading = false; // État de chargement

  // Fonction pour afficher les messages toast
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

  // Fonction pour gérer le processus de connexion
  void handleLogin() async {
    setState(() {
      _loading = true; // Début du chargement
    });

    try {
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
        _loading = false; // Fin du chargement, même en cas d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Image.asset(
            'assets/blue-fond.jpg',
            fit: BoxFit.cover,
          ),
          // Couche semi-transparente
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Formulaire de connexion
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.png'), // Remplacez par le chemin de votre logo
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 20), // Espace sous le logo
                  // Titre
                  Text(
                    'Se Connecter',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Limiter la largeur des champs à 300
                  SizedBox(
                    width: 300, // Largeur fixe de 300
                    child: Column(
                      children: [
                        // Champ Email
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white), // Texte en blanc
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.white),
                            labelText: 'E-mail',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Champ Mot de passe
                        TextField(
                          controller: passwordController,
                          style: TextStyle(color: Colors.white), // Texte en blanc
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.white),
                            labelText: 'Mot de passe',
                            labelStyle: TextStyle(color: Colors.white),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
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
                                  _obscurePassword = !_obscurePassword; // Bascule l'état
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Lien Mot de passe oublié
                        GestureDetector(
                          onTap: () {
                            showToast("Fonctionnalité à implémenter !");
                          },
                          child: Text(
                            'Mot de passe oublié ?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Lien S'enregistrer
                        GestureDetector(
                          onTap: () {
                            Get.to(() => RegisterPage(), transition: Transition.rightToLeft);
                          },
                          child: Text(
                            'Pas de compte ? S\'enregistrer',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  // Bouton Se connecter
                  _loading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200], // Couleur du bouton
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
        ],
      ),
    );
  }
}
