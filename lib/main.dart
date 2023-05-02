import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';

void  main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'World Country 🌏'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController input = TextEditingController();
  var desc = "No Data";
  var countryName = '';
  var currencyName = '';
  var currencyCode = '';
  var countryCapital = '';
  var countryIso = '';
  var countryRegion = '';
  ImageProvider countryFlag = const NetworkImage('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 150, 153, 162),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/earth.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text("Search a Country Name 🔍",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            const SizedBox(height: 20),
          Container(
            height: 50,
            width: 300,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              controller: input,
              decoration: InputDecoration(
                  hintText: 'Enter Country Name',
                  hintStyle:
                      const TextStyle(color: Colors.grey, fontSize: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              textAlign: TextAlign.center,
            ),
          ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCountryInfo, 
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255)),
              child: const Text("SEARCH",
                style: 
                  TextStyle(color: Colors.black),
              )
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 65, 67, 90)),
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(desc,
                  style: 
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.w300, color: Colors.black),
                  textAlign: TextAlign.center,
                  )
                ],
            ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 100,
              width: 100,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 65, 67, 90)),
                color: const Color.fromARGB(255, 255, 255, 255)
              ),
              child: Column ( mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image ( image: countryFlag,
                  errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                    return const Text('');
                    },
                  )
                ],
              )
            ),
            const SizedBox(height: 77)
          ],
        ),
      ),
      )
      )
    );
  }

  Future<void> _getCountryInfo() async {
    String country = input.text;
    var apiid = "+gW9zXRvbd0Rpjx9YMa/rQ==17GerL8KauJk0kVl";
    Uri url = Uri.parse(
    'https://api.api-ninjas.com/v1/country?name=$country');
    var response = await http.get(url, headers: {"X-Api-Key": apiid});
    if (input.text.isEmpty){
      QuickAlert.show(context: context, text: 'PLEASE ENTER A COUNTRY NAME!', type: QuickAlertType.error);
    }
    else if (response.statusCode == 200){
      var jsonData = response.body;  
      var parsedJson = json.decode(jsonData);
      if (parsedJson.isNotEmpty) {
        countryName = parsedJson[0]['name'];
        currencyName = parsedJson[0]['currency']['name'];
        currencyCode = parsedJson[0]['currency']['code'];
        countryCapital = parsedJson[0]['capital'];
        countryIso = parsedJson[0]['iso2'];
        countryRegion = parsedJson[0]['region'];
        setState(() {
        desc = 
          "This country is called $countryName. Its capital is located in $countryCapital, $countryRegion. The $currencyName and $currencyCode is the official currency of the $countryName.";
        countryFlag = NetworkImage('https://flagsapi.com/$countryIso/shiny/64.png');
        });
      } else {
      setState(() {
        QuickAlert.show(context: context, text: '"$country" IS NOT EXIST. PLEASE ENTER AGAIN.', type: QuickAlertType.warning);
        desc = "No Country Record!";
        input.text = "";
        countryFlag = const NetworkImage('https://icon-library.com/images/try-again-icon/try-again-icon-1.jpg');
      });
    }
    }
  }
}