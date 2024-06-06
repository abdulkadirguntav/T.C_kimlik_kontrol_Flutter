import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

void main() {
  runApp(TCKimlikDogrulama());
}

class TCKimlikDogrulama extends StatefulWidget {
  @override
  _TCKimlikDogrulamaState createState() => _TCKimlikDogrulamaState();
}

class _TCKimlikDogrulamaState extends State<TCKimlikDogrulama>
    with SingleTickerProviderStateMixin {
  TextEditingController tcKimlikController = TextEditingController();
  String dogrulamaSonucu = '';
  String rastgeleTCKimlik = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey[800],
        scaffoldBackgroundColor: Colors.black,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('T.C. Kimlik Numarası Doğrulama'),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: tcKimlikController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'T.C. Kimlik Numarası Girin',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20.0),
                ScaleTransition(
                  scale: _animation,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.forward();
                        dogrulamaSonucu =
                            dogrulama(tcKimlikController.text.trim());
                        _showToast(dogrulamaSonucu);
                      });
                    },
                    child: Text('Doğrula'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ScaleTransition(
                  scale: _animation,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _controller.forward();
                        rastgeleTCKimlik = rastgeleTCKimlikUret();
                        _showToast('Yeni T.C. Kimlik Numarası Üretildi!');
                      });
                    },
                    child: Text('Rastgele T.C. Kimlik Numarası Üret'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[800],
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      textStyle: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  dogrulamaSonucu,
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Rastgele Üretilen T.C. Kimlik Numarası: $rastgeleTCKimlik',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String dogrulama(String tcKimlik) {
    // TC kimlik numarasının uzunluğunu kontrol etme
    if (tcKimlik.length != 11) {
      return "Geçersiz T.C. Kimlik Numarası";
    }

    // 10. rakamı hesaplama
    int toplam1 = 0;
    for (int i = 0; i < 9; i += 2) {
      toplam1 += int.parse(tcKimlik[i]);
    }
    int sonuc1 = ((toplam1 * 7) -
            (int.parse(tcKimlik[1]) +
                int.parse(tcKimlik[3]) +
                int.parse(tcKimlik[5]) +
                int.parse(tcKimlik[7]))) %
        10;

    // 11. rakamı hesaplama
    int toplam2 = 0;
    for (int i = 0; i < 10; i++) {
      toplam2 += int.parse(tcKimlik[i]);
    }
    int sonuc2 = toplam2 % 10;

    // Sonuçları kontrol etme
    if (int.parse(tcKimlik[9]) == sonuc1 && int.parse(tcKimlik[10]) == sonuc2) {
      return "Geçerli T.C. Kimlik Numarası";
    } else {
      return "Geçersiz T.C. Kimlik Numarası";
    }
  }

  String rastgeleTCKimlikUret() {
    Random rastgele = Random();
    List<int> tc = List<int>.generate(9, (_) => rastgele.nextInt(10));

    // 10. rakamı hesaplama
    int toplam1 = 0;
    for (int i = 0; i < 9; i += 2) {
      toplam1 += tc[i];
    }
    int sonuc1 = ((toplam1 * 7) - (tc[1] + tc[3] + tc[5] + tc[7])) % 10;
    tc.add(sonuc1);

    // 11. rakamı hesaplama
    int toplam2 = tc.fold(0, (prev, element) => prev + element);
    int sonuc2 = toplam2 % 10;
    tc.add(sonuc2);

    return tc.join('');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
