import 'package:BibleEngama/utils/auth_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:BibleEngama/providers/form_provider.dart';
import 'package:flutter_html/flutter_html.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  int _currentPage = 0;
  final int _rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    _checkLogin(context);
    return Scaffold(
      appBar: AppBar(title: Text('Guide thématique', style: TextStyle(color: Colors.white)),  iconTheme: IconThemeData(
        color: Colors.white, // Couleur de la flèche de retour en blanc
      ),
        backgroundColor: Colors.blue,),
      body: Consumer<FormProvider>(
        builder: (context, formProvider, child) {
          if (formProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (formProvider.error != null) {
            return Center(child: Text('Error: ${formProvider.error}'));
          } else {
            final body2 = formProvider.formData!.body2 ?? {};
            final body3 = formProvider.formData!.body3 ?? 'N/A';

            final labels = body2.keys.toList();
            int totalPages = (labels.length / _rowsPerPage).ceil();
            int startRow = _currentPage * _rowsPerPage;
            int endRow = startRow + _rowsPerPage;
            if (endRow > labels.length) endRow = labels.length;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Html(data: formProvider.formData!.body1 ?? 'N/A'),
                    SizedBox(height: 8),
                    // Centrage et élargissement du tableau
                    Center(
                      child: Container(
                        //width: MediaQuery.of(context).size.width * 1, // Largeur de 90% de l'écran
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Table(
                            border: TableBorder.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            columnWidths: const <int, TableColumnWidth>{
                              0: IntrinsicColumnWidth(),
                              1: IntrinsicColumnWidth(),
                              2: IntrinsicColumnWidth(),
                              3: IntrinsicColumnWidth(),
                            },
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            children: [
                              // Lignes des labels avec style
                              TableRow(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                ),
                                children: labels.map((label) {
                                  return Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      label,
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }).toList(),
                              ),
                              // Lignes des titres avec mise en forme
                              for (int i = startRow; i < endRow; i++)
                                TableRow(
                                  decoration: BoxDecoration(
                                    color: (i % 2 == 0) ? Colors.grey[200] : Colors.white,
                                  ),
                                  children: labels.map((label) {
                                    final titles = body2[label] ?? [];
                                    return Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(titles.length > i ? titles[i] : ''),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Contrôles de pagination
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: _currentPage > 0
                              ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                              : null,
                        ),
                        Text('Page ${_currentPage + 1} of $totalPages'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: _currentPage < totalPages - 1
                              ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                              : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),

                    // Affichage de body3
                    Html(data: body3),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
  void _checkLogin(BuildContext context) async {
    final isLoggedIn = await AuthHelper.checkLoginStatus();
    if (!isLoggedIn) {
      Get.offAllNamed('/LoginPage'); // Redirige vers la page de connexion
    }
  }
}
