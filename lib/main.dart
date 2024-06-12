//import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


const List<String> options = ['Open', 'Order Created', 'Cancelled'];

void main() {
  runApp(const MaterialApp(
    home: LoginPage(),
  ));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dummy credentials
  final String correctEmail = "admin";
  final String correctPassword = "admin";

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == correctEmail && _passwordController.text == correctPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Incorrect email or password.'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Login",
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoTextFormFieldRow(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      placeholder: 'Username',
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator,
                            width: 0.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CupertinoTextFormFieldRow(
                      controller: _passwordController,
                      obscureText: true,
                      placeholder: 'Password',
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: CupertinoColors.separator,
                            width: 0.0,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  CupertinoButton.filled(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


List<Quotes> quoteData = List.generate(
    SecondPage.quotation.length,
        (index) => Quotes(SecondPage.quotation[index])
);

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
      body: Column(
        children: <Widget>[
          const SizedBox(height: 50),
          const Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Quotations', style: TextStyle(fontSize: 20)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SecondPage()));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Orders', style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Handle the Orders action
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Job Cards', style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Handle the Job Cards action
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Expenses', style: TextStyle(fontSize: 20)),
                    onTap: () {
                      // Handle the Expenses action
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


enum QuoteStatus { open, orderCreated, cancelled }

extension QuoteStatusExtension on QuoteStatus {
  String get name {
    switch (this) {
      case QuoteStatus.open:
        return 'Open';
      case QuoteStatus.orderCreated:
        return 'Order Created';
      case QuoteStatus.cancelled:
        return 'Cancelled';
      default:
        return '';
    }
  }
}

class Quotes {
  final String name;
  QuoteStatus status;

  Quotes(this.name, {this.status = QuoteStatus.open});
}

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});
  static List<String> quotation = [
    'DQ20240001', 'DQ20240002', 'DQ20240003', 'DQ20240004', 'DQ20240005',
    'DQ20240006', 'DQ20240007', 'DQ20240008', 'DQ20240009'
  ];

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
          itemCount: quoteData.length,
          itemBuilder: (context, index) {
            return Card(
              child: ExpansionTile(
                title: Text(quoteData[index].name),
                subtitle: Text("Status: ${quoteData[index].status.name}"),
                children: QuoteStatus.values.map((QuoteStatus status) {
                  return ListTile(
                    title: Text(status.name),
                    onTap: () {
                      setState(() {
                        quoteData[index].status = status;
                      });
                    },
                  );
                }).toList(),
              ),
            );
          }
      ),
    );
  }
}
class LoginService{
  String username = '';
  LoginService(this.username);
  void getMyRecords(){}
}

class QuotationsService{
  String username = '';
  QuotationsService(this.username);
  void getMyRecords(){}
}

class OrderService{
  String username = '';
  OrderService(this.username);
  void getMyRecords(){}
}

class JobCardService{
  String username = '';
  JobCardService(this.username);
  void getMyRecords(){}
}