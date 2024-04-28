import 'dart:io';

import 'package:flutter/material.dart';
import 'package:torch_controller/torch_controller.dart';

void main() {
  TorchController().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Li-Fi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test Li-Fi'),
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
  final myTextController = TextEditingController();
  String decimalValues = '';
  String binValues = '';
  final TorchController _torchController = TorchController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myTextController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    var token = myTextController.text;
    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Masukkan pesan")));
      return;
    } else if (token.contains(RegExp(r'[A-Z]'))) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pesan harus berupa huruf saja")));
      return;
    } else if (token.contains("kep") || token.contains("kon") || token.contains("mek") || token.contains("tai")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Parah si")));
      token = "istigfar!";
    } else if (token.contains("roni") ||
        token.contains("zi") ||
        token.contains("dani") ||
        token.contains("rul") ||
        token.contains("lang") ||
        token.contains("peng") ||
        token.contains("fan") ||
        token.contains("zar") ||
        token.contains("ijem")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gaje pesan lu, ganti")));
      return;
    }

    const delay = 150;

    _torchController.toggle();
    sleep(const Duration(milliseconds: delay));
    _torchController.toggle();

    final codes = token.codeUnits;
    for (int code in codes) {
      var unit = code.toRadixString(2);
      for (var rune in unit.runes) {
        if (code >= 48 && code <= 57) {
          continue;
        }
        var character = String.fromCharCode(rune);
        if (character == "1") {
          _torchController.toggle();
          sleep(const Duration(milliseconds: delay));
          _torchController.toggle();
          continue;
        }
        sleep(const Duration(milliseconds: delay));
      }

      sleep(const Duration(milliseconds: delay * 2));
    }
  }

  void onTextChanged(String value) {
    setState(() {
      decimalValues = value.codeUnits.join(" ");
      binValues = value.codeUnits.map((e) => e.toRadixString(2)).join(" ");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: Container(
        margin: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: myTextController,
              maxLength: 9,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.send,
              onChanged: onTextChanged,
              onSubmitted: (value) {
                _sendMessage();
              },
              decoration: const InputDecoration(
                labelText: 'Kirim pesan',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text("Kode desimal: "),
                Expanded(child: Text(decimalValues)),
              ],
            ),
            Row(
              children: [
                const Text("Kode Biner: "),
                Expanded(child: Text(binValues)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendMessage,
        tooltip: 'Kirim',
        child: const Icon(Icons.send),
      ),
    );
  }
}
