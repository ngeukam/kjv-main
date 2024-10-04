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

  bool _obscurePassword = true;  // Variable pour masquer le mot de passe
  bool _obscureConfirmPassword = true;  // Variable pour masquer la confirmation du mot de passe
  bool _loading = false;
  // Fonction pour afficher les messages toast
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 3
    );
  }

  // Fonction pour gérer le processus d'inscription
  void handleRegister() async {
    setState(() {
      _loading = true; // Début du chargement
    });
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      showToast("Tous les champs sont obligatoires.");
    }
    if (passwordController.text != confirmPasswordController.text) {
      showToast("Les mots de passe ne correspondent pas.");
    }
    try{
        final response = await apiService.register(
          nameController.text,
          emailController.text,
          passwordController.text,
        );
        if (response['message'] == 'Email already exists.'){
          showToast("Cette addresse email existe déjà!");
        }
        if (response['message'] == 'User registered successfully.') {
          Get.snackbar(
            'Félicitations!',
            'Enregistrement réussi!',
            backgroundColor: Colors.white,
            borderColor: Colors.greenAccent,
            borderWidth: 2,
            duration: Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          Get.to(() => LoginPage(), transition: Transition.rightToLeft);
        }
    }
    catch(e){
      showToast("Echec de l'enregistrement, vérifier les champs.");
    }finally {
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
          // Formulaire d'inscription
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/logo.png'), // Remplacez par le chemin de votre logo
                    backgroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 20),
                  // Titre
                  Text(
                    'S\'enregistrer',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Champ Nom
                  TextField(
                    controller: nameController,
                    style: TextStyle(color: Colors.white),  // Texte en blanc
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person, color: Colors.white),
                      labelText: 'Nom',
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
                  // Champ Email
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: Colors.white),  // Texte en blanc
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
                    style: TextStyle(color: Colors.white),  // Texte en blanc
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
                  // Champ Confirmation du mot de passe
                  TextField(
                    controller: confirmPasswordController,
                    style: TextStyle(color: Colors.white),  // Texte en blanc
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock, color: Colors.white),
                      labelText: 'Confirmation mot de passe',
                      labelStyle: TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
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
                            _obscureConfirmPassword = !_obscureConfirmPassword; // Bascule l'état
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Bouton S'inscrire
                  _loading
                      ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ) :ElevatedButton(
                    onPressed: handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[200],  // Couleur du bouton
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
                  // Lien Se connecter
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginPage());
                    },
                    child: Text(
                      'Se Connecter',
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
          ),
        ],
      ),
    );
  }
}
