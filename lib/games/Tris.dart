import 'dart:async';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

// La homepage dell'app che contiene la griglia di gioco
class Tris extends StatefulWidget {
  const Tris({super.key});

  @override
  State<Tris> createState() => _TrisState();
}

class _TrisState extends State<Tris> {
  // Lista che rappresenta lo stato delle celle della griglia
  late List<String> celle;
  // Variabile che tiene traccia del giocatore corrente (0 ==> O, 1 ==> X)
  late int currentPlayer;

  late GridView tab;

  final controller = ConfettiController();

  final dbReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    super.initState();
    startGame();
  }

  // Inizializza lo stato del gioco
  void startGame() {
    celle = List.filled(9, '-1'); // Inizializza tutte le celle con '-1'
    currentPlayer = 0; // Inizia con il giocatore 'O'
    print('Tutto pronto');
    createRecord();
  }

  void createRecord() async {
    print('Sono dentro');
    try {
      Map<String, dynamic> cellsData = {};
      for (int i = 0; i < celle.length; i++) {
        cellsData['cella $i'] = celle[i];
      }
      await dbReference.child("tris").set(cellsData);
      print("Record added successfully");
    } catch (e) {
      print("Failed to add record: $e");
    }
  }

  String currentPlayertoString() {
    return currentPlayer == 0 ? 'O' : 'X';
  }

  void restartGame() {
    setState(() {
      currentPlayer = currentPlayer == 0 ? 1 : 0;
      celle = List.filled(9, '-1');
    });
  }

  Text iconPlayer(index) {
    if (celle[index] == 'X') {
      return const Text(
        'X',
        style: TextStyle(
          color: Colors.red,
          fontSize: 60,
        ),
      );
    } else if (celle[index] == 'O') {
      return const Text(
        'O',
        style: TextStyle(
          color: Color.fromARGB(255, 0, 6, 255),
          fontSize: 60,
        ),
      );
    } else {
      return const Text(
        '',
      );
    }
  }

  GridView tabella() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 3 colonne nella griglia
        childAspectRatio: 1, // Mantiene i pulsanti quadrati
      ),
      itemCount: 9, // Numero totale di celle nella griglia
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handleButtonPress(
              index, context), // Gestisce la pressione del pulsante
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black, width: 4), // Bordo del pulsante
              color: Colors.white, // Colore di sfondo del pulsante
            ),
            child: Center(
              child: iconPlayer(index),
            ),
          ),
        );
      },
    );
  }

  // Gestisce la pressione di un pulsante nella griglia
  Future<void> _handleButtonPress(int index, BuildContext context) async {
    // Controlla se la cella non è già stata premuta
    if (celle[index] == '-1') {
      setState(() {
        // Aggiorna la cella con il simbolo del giocatore corrente
        celle[index] = currentPlayertoString();

        // Controlla se il giocatore corrente ha vinto
        if (checkWinner(currentPlayertoString())) {
          // Mostra un messaggio di vittoria
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ha vinto ${currentPlayertoString()}'),
              duration: const Duration(seconds: 2),
            ),
          );

          controller.play();
          Future.delayed(Duration(seconds: 3), () {
            controller.stop();
            restartGame();
          });
        } else {
          // Cambia il giocatore corrente
          currentPlayer = (currentPlayer + 1) % 2;
        }
      });
    }
  }

  // Controlla se il giocatore specificato ha vinto
  bool checkWinner(String player) {
    List<List<int>> winConditions = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (var condition in winConditions) {
      if (celle[condition[0]] == player &&
          celle[condition[1]] == player &&
          celle[condition[2]] == player) {
        return true;
      }
    }
    return false;
  }

  Text winnerToString() {
    if (checkWinner(currentPlayertoString())) {
      return Text(
        'HA VINTO ${currentPlayertoString()}',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),
      );
    } else {
      return const Text(
        'HA VINTO ',
        style: TextStyle(
          color: Colors.black,
          fontSize: 40,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Tris'),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          constraints: const BoxConstraints(
            maxWidth: 300, // Limita la larghezza massima della griglia
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.start, // per poszionare la tabella al centro

            children: [
              const SizedBox(
                height: 50,
              ),
              winnerToString(),
              const SizedBox(
                height: 100,
              ),
              AspectRatio(
                aspectRatio: 1, // Mantiene i pulsanti quadrati

                child: tab = tabella(),
              ),
              ConfettiWidget(
                confettiController: controller,
                shouldLoop: false,
                blastDirection: pi,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  restartGame();
                },
                child: const Text('Rigioca'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
