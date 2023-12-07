import 'package:flutter/material.dart';

class CounterStatefulScreen extends StatefulWidget {
  const CounterStatefulScreen({super.key});

  @override
  State<CounterStatefulScreen> createState() => _CounterStatefulScreenState();
}

class _CounterStatefulScreenState extends State<CounterStatefulScreen> {

  // สร้างตัวแปรเก็บค่า _counter
  int _counter = 0;

  // method สำหรับเพิ่มค่า _counter
  void _counterUp() {
    setState(() {
      _counter++;
    });
  }

  // method สำหรับลดค่า _counter
  void _counterDown() {
    setState(() {
      _counter--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stateful ${DateTime.now().microsecondsSinceEpoch}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white, size: 30,),
                onPressed: _counterUp,
              ),
            ),
            Text(
              _counter.toString(),
              style: const TextStyle(fontSize: 120),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.remove, color: Colors.white, size: 30,),
                onPressed: _counterDown,
              ),
            ),
            const SizedBox(height: 200,),
            Text(
              'Open at : ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}',
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              'Timestamp : ${DateTime.now().microsecondsSinceEpoch.toString()}',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      )
    );
  }
}