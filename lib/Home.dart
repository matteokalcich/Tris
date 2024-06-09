import 'package:confetti/confetti.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({super.key});

  TextEditingController _n_stanza = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: SizedBox(
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Column(
                  children: [
                    const Text('Per giocare 1 vs 1 sullo stesso dispositivo'),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/tris');
                      },
                      child: const Text('Gioca?'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                child: Column(
                  children: [
                    TextField(
                      controller: _n_stanza,
                      decoration:
                          const InputDecoration(label: Text('Numero stanza')),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          print('${_n_stanza.toString()}');
                        },
                        child: const Text('Invia'))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
