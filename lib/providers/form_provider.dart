import 'package:BibleEngama/models/form.dart';
import 'package:flutter/material.dart';
import 'package:BibleEngama/services/fetch_form.dart';

class FormProvider with ChangeNotifier {
  FormModel? _formData;
  bool _isLoading = true;
  String? _error;

  FormProvider() {
    fetchFormData();
  }

  FormModel? get formData => _formData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFormData() async {
    try {
      _isLoading = true;
      notifyListeners();

      _formData = await FetchForm().fetchFormData();

      _error = null;  // Réinitialiser l'erreur
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
