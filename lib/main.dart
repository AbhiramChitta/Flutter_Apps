//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/Quotes.dart';

void main() {
  runApp(const MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile App Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SecondPage()));
                },
                child: const Text(
                  'Quotations',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                ),
                onPressed: () {
                  // Handle the login action
                },
                child: const Text(
                  'Orders',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                ),
                onPressed: () {
                  // Handle the login action
                },
                child: const Text(
                  'Job Cards',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(25),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                ),
                onPressed: () {
                },
                child: const Text(
                  'Expenses',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage({super.key});
  static List<String> quotation = ['DQ20240001','DQ20240002','DQ20240003','DQ20240004','DQ20240005',
    'DQ20240006','DQ20240007','DQ20240008','DQ20240009'];

  final List<Quotes> quotedata = List.generate(quotation.length, (index)=> Quotes('${quotation[index]}'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Quotations'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: quotedata.length,
          itemBuilder: (context,index)
          {
            return Card(
              child: ListTile(
                title: Text(quotedata[index].name),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      ThirdPage(quotes: quotedata[index])));
                },
              ),
            );
          }
      ),
    );
  }
}

const List<String> options = ['Open', 'Order Created', 'Cancelled'];

class ThirdPage extends StatefulWidget {
  ThirdPage({super.key, required this.quotes});
  final Quotes quotes;

  @override
  _ThirdPageState createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  String currentoption = options[0];

  //static get options => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quotes.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (var option in options)
              ListTile(
                title: Text(option),
                leading: Radio<String>(
                  value: option,
                  groupValue: currentoption,
                  onChanged: (value) {
                    setState(() {
                      currentoption = value!;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

