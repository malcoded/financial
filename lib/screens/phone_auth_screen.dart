import 'package:financial/models/Country.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:financial/services/auth_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();

  bool _codeSent = false;
  String _verificationId = "";
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _detectCountry();
  }

  Future<void> _detectCountry() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        String? countryCode = placemarks.first.isoCountryCode;
        if (countryCode != null) {
          setState(() {
            _selectedCountry = latinAmericanCountries.firstWhere(
                    (country) => country.code == countryCode,
                orElse: () => latinAmericanCountries.first);
          });
        }
      }
    } catch (e) {
      print("Error detectando país: $e");
      setState(() {
        _selectedCountry = latinAmericanCountries.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Autenticación por Teléfono'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_codeSent) ...[
              DropdownButton<Country>(
                value: _selectedCountry,
                items: latinAmericanCountries.map((Country country) {
                  return DropdownMenuItem<Country>(
                    value: country,
                    child: Text('${country.name} (${country.prefix})'),
                  );
                }).toList(),
                onChanged: (Country? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(_selectedCountry?.prefix ?? ''),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: 'Número de teléfono'),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
            ] else
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Código de verificación'),
                keyboardType: TextInputType.number,
              ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text(_codeSent ? 'Verificar Código' : 'Enviar Código'),
              onPressed: () async {
                if (!_codeSent) {
                  final phoneNumber = '${_selectedCountry?.prefix}${_phoneController.text}';
                  await authService.verifyPhoneNumber(
                    phoneNumber,
                        (PhoneAuthCredential credential) async {
                      await authService.signInWithCredential(credential);
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                        (FirebaseAuthException e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${e.message}')),
                      );
                    },
                        (String verificationId, int? resendToken) {
                      setState(() {
                        _codeSent = true;
                        _verificationId = verificationId;
                      });
                    },
                        (String verificationId) {
                      setState(() {
                        _verificationId = verificationId;
                      });
                    },
                  );
                } else {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId,
                    smsCode: _codeController.text,
                  );
                  try {
                    await authService.signInWithCredential(credential);
                    Navigator.pushReplacementNamed(context, '/home');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: Código inválido')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}