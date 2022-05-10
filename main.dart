import 'package:flutter/material.dart';
import 'dart:math';
// Alfabe veya dil kuralında herhangi bir sıkıntı var ise kuralların girildiği alanın altında
//bildirim olarak gözüküyor

Random random = new Random();

void main() {
  runApp(MaterialApp(
    routes: {"/": (context) => anaSayfa()},
  ));
}

class anaSayfa extends StatefulWidget {
  const anaSayfa({Key? key}) : super(key: key);

  @override
  _anaSayfaState createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {
  String dil = "";
  String alfabe = "";
  String kontrolEdilecekKelime = "";
  List<String> listCumle = [];
  int adet = 0;
  bool devam1 = false;
  bool devam2 = false;
  String fButtonText = "Kelime Üret";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("17-24 Mehmet TAŞLI"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(fButtonText),
        onPressed: () {
          if (_dilKontrol(dil, alfabe) == true &&
              _alfabeKontrol(alfabe) == true) {
            listCumle.clear();
            setState(() {
              for (int i = 0; i < adet; i++) {
                listCumle.add(cumleOlustur(dil, adet));
              }
            });
            showDialog(context: context, builder:(BuildContext context){
              return _dialogOlustur(context);
            });
          } else {}
        },
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Alfabeyi giriniz",
                        errorText: _alfabeKontrol(alfabe) == false
                            ? "Girdiginiz Alfabeyti Kontrol Edin,([A-Z],[a-z],[0-9],[,])"
                            : ""),
                    onChanged: (deger) {
                      setState(() {
                        alfabe = deger;
                        alfabe = alfabe.replaceAll(" ", "");
                        devam1 = _alfabeKontrol(alfabe);
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Dili Giriniz",
                        errorText: _dilKontrol(dil, alfabe) == false
                            ? "Dil ile alfabe uyuşmuyor"
                            : ""),
                    onChanged: (deger) {
                      setState(() {
                        dil = deger;
                        dil = dil.replaceAll(" ", "");
                        devam2 = _dilKontrol(dil, alfabe);
                      });
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Kaç adet cumle uretmek istersiniz ? "),
                    onChanged: (deger) {
                      setState(() {
                        adet = int.parse(deger);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: "Kontrol Edilecek Kelime "),
                    onChanged: (deger) {
                      setState(() {
                        kontrolEdilecekKelime = deger;
                      });
                    },
                  ),
                  RaisedButton(
                    onPressed: () {
                      debugPrint(_kelimeDilKontrol(dil, kontrolEdilecekKelime)
                          .toString());
                    },
                    child: Text("Kontrol Et"),
                  )
                ],
              ),
            ),
          Flexible(child:             Container(
            color: Colors.green,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.7,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(listCumle[index]),
                  ),
                );
              },
              itemCount: listCumle.length,
            ),
          ))
          
          ],
        ),
      ),
    );
  }
_dialogOlustur(BuildContext context){
    return AlertDialog(actions: [Expanded(child: Container(width: MediaQuery.of(context).size.width*0.8,height: MediaQuery.of(context).size.height*0.8,child: ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Card(
          child: ListTile(
            title: Text(listCumle[index]),
          ),
        );
      },
      itemCount: listCumle.length,
    ),))],);
}
  //karışıklığa yol açmaması için alfabede sadece harf ve sayı olmasına izin var
  _alfabeKontrol(String alfabe) {
    bool devam = false;
    for (int i = 0; i < alfabe.length; i++) {
      if (alfabe[i].contains(new RegExp(r"[A-Z]")) ||
          alfabe[i].contains(new RegExp(r"[a-z]")) ||
          alfabe[i].contains(new RegExp(r"[0-9]")) ||
          alfabe[i] == ",")
        devam = true;
      else
        return false;
    }
    return devam;
  }

  _kelimeDilKontrol(String dil, String kelime) {
    var sonuc = kelime.allMatches(dil);
    print(sonuc);
    RegExp regExp = new RegExp(r'${dil}');
    return regExp.hasMatch(kelime).toString();
  }


  //Dilde bulunan karakterler ile alfabe bulunan karakterlerin eşleşip eşleşmediğini kontrol ediyorum
  _dilKontrol(String dil, String alfabe) {
    List<String> alfabeList = alfabe.split(",");
    bool devam = false;
    for (int i = 0; i < dil.length; i++) {
      if ((alfabeList.contains(dil[i]) || dil[i] == '*') ||
          dil[i] == '+' ||
          (dil[i] == '(' || dil[i] == ')')) {
        devam = true;
      } else
        return false;
    }
    return devam;
  }

  String cumleOlustur(String dil, int adet) {
    //Girilen dili parantezlere göre ayırıyorum
    List<String> dilBolum = dil.split("(");
    List<String> dilSon = [];
    String cumle = "";
    Map<String, dynamic> yapiMap = new Map();
    for (int i = 0; i < dilBolum.length; i++) {
      Map<String, dynamic> cumleMap = new Map();
      //eğer girilen dil kuralında parantez yıldız var ise )* 'ı ! ile değiştiriyorum bu sayede o cumlenin o noktadan sonra tekrar edip etmeye
      //ceğine karar verebilirim. Oluşturduğum map içerisinde parantezYıldiz bitisDurum gibi özellikler yazmamın sebebi debug ederken kolaylık olması
      if (dilBolum[i].contains(")*")) {
        String yeniCumle = dilBolum[i].replaceAll(")*", "!");
        dilBolum[i] = yeniCumle;
        dilBolum[i].trim();
        cumleMap['parantezYildiz'] = true;
      } else {
        cumleMap['parantezYildiz'] = false;
      }
      String cml = dilBolum[i].split(")").toString().trim();

      if (cml.contains("+")) {
        cumleMap['bitisDurum'] = true;
      } else {
        cumleMap['bitisDurum'] = false;
      }
      cumleMap['cumle'] = cml.trim();
      yapiMap[i.toString()] = cumleMap;
    }
    debugPrint(yapiMap.toString());
    for (int i = 0; i < yapiMap.length; i++) {
      String cumlecik = yapiMap[i.toString()]['cumle'];
      for (int m = 0; m < cumlecik.length; m++) {
        //gelen dil kuralı parçasında bitis durumu var mı yok mu ona bakıyorum
        //Cumlenin bitip bitmeyeceği veya harfin tekrar edip etmeyeceği gibi durumlara random sayılarla karar veriyorum
        //eğer random sayı tek ise devam çift ise bitir şeklinde
        if (cumlecik[m] == "+") {
          if (random.nextInt(10) % 2 == 0) {
            String cumle1 = cumle.replaceAll("[", "");
            String cumle2 = cumle1.replaceAll("]", "");
            String cml3 = cumle2.replaceAll(",", "");
            return cml3;
          } else {
            continue;
          }
        }
        if (cumlecik[m] != "!") {
          if (cumlecik[m] != "*") {
            cumle += cumlecik[m];
          } else {
            int sayi = random.nextInt(10);
            while (sayi % 2 != 0) {
              cumle += cumlecik[m - 1];
              sayi = random.nextInt(10);
            }
          }
        }
        else if(cumlecik[m] =="!") {
          int sayi = random.nextInt(10);
          if (sayi % 2 == 0) {
            m = 0;
          } else {
            continue;
          }
        }
      }
    }

    String cumle1 = cumle.replaceAll("[", "");
    String cumle2 = cumle1.replaceAll("]", "");
    String cml3 = cumle2.replaceAll(",", "");
    return cml3;
  }
}
