import 'package:find_my_animal/screens/create_qr.dart';
import 'package:find_my_animal/screens/scan_qr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    // Получаем ширину экрана
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CreateQr()),
                  );
                },
                style: ButtonStyle(
                    minimumSize:
                    WidgetStateProperty.all(Size(screenWidth / 2, 75)),
                    // Минимальный размер кнопки
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Устанавливаем радиус углов
                      ),
                    ),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.green[800]!; // Цвет при нажатии
                      }
                      return Colors.green[800]!; // Обычный цвет
                    })),
                child: const Text(
                  'Create QR', // Текст кнопки
                  style: TextStyle(
                    fontSize: 18.0, // Размер шрифта текста кнопки
                    color: Colors.white, // Цвет текста кнопки
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScanQr()),
                  );
                },
                style: ButtonStyle(
                    minimumSize:
                    WidgetStateProperty.all(Size(screenWidth / 2, 75)),
                    // Минимальный размер кнопки
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            5.0), // Устанавливаем радиус углов
                      ),
                    ),
                    backgroundColor: WidgetStateColor.resolveWith((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.green[800]!; // Цвет при нажатии
                      }
                      return Colors.green[800]!; // Обычный цвет
                    })),
                child: const Text(
                  'Scan QR', // Текст кнопки
                  style: TextStyle(
                    fontSize: 18.0, // Размер шрифта текста кнопки
                    color: Colors.white, // Цвет текста кнопки
                  ),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
