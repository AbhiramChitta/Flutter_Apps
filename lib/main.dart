import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Incorrect email or password.'),
            actions: [
              TextButton(
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
                    child: TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
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
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
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
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const QuotationsPage()));
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Orders', style: TextStyle(fontSize: 20)),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const OrdersPage()));
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

//Quotations
enum QuoteStatus { open, orderCreated, droppedCancelled, refloated, lost, orderReceived }

extension QuoteStatusExtension on QuoteStatus {
  int get id {
    switch (this) {
      case QuoteStatus.open:
        return 0;
      case QuoteStatus.orderCreated:
        return 1;
      case QuoteStatus.droppedCancelled:
        return 2;
      case QuoteStatus.refloated:
        return 3;
      case QuoteStatus.lost:
        return 4;
      case QuoteStatus.orderReceived:
        return 5;
    }
  }

  String get title {
    switch (this) {
      case QuoteStatus.open:
        return "Open";
      case QuoteStatus.orderCreated:
        return "Order Created";
      case QuoteStatus.droppedCancelled:
        return "Dropped / Cancelled";
      case QuoteStatus.refloated:
        return "Re-floated";
      case QuoteStatus.lost:
        return "Lost";
      case QuoteStatus.orderReceived:
        return "Order Received";
    }
  }
}

class Quote {
  final String referenceNumber;
  QuoteStatus status;

  Quote({required this.referenceNumber, required this.status});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      referenceNumber: json['referenceNumber'],
      status: QuoteStatus.values[json['status']['id']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'status': {'id': status.index},
    };
  }
}

Future<List<Quote>> fetchQuotations() async {
  final response = await http.get(Uri.parse('http://192.168.29.10:8080/pfeiffer/api/v1/quotations'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['result'] != null) {
      List<dynamic> data = jsonResponse['result'];
      return data.map((json) => Quote.fromJson(json)).toList();
    } else {
      print("No 'result' key found in the response.");
      return [];
    }
  } else {
    throw Exception('Failed to load quotations');
  }
}

Future<List<Map<String, dynamic>>> fetchStatusOptions() async {
  final response = await http.get(Uri.parse('http://192.168.29.10:8080/pfeiffer/api/v1/quotation_statuses'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body)['result'];
    return jsonResponse.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to fetch status options');
  }
}

Future<void> updateQuoteStatus(String referenceNumber, int statusId) async {
  // Fetch the quotation details including the current status
  final response = await http.get(Uri.parse('http://localhost:8080/pfeiffer/api/v1/quotations/$referenceNumber'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonQuotation = json.decode(response.body);

    // Update the status in the fetched quotation
    jsonQuotation['status']['id'] = statusId;

    // Send the updated quotation back to the server
    final updateResponse = await http.put(
      Uri.parse('http://localhost:8080/pfeiffer/api/v1/quotations/$referenceNumber/status'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(jsonQuotation),
    );

    if (updateResponse.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(updateResponse.body);
      print("Update Response: $jsonResponse");
    } else {
      print("Failed to update status: ${updateResponse.body}");
      throw Exception('Failed to update status');
    }
  } else {
    print("Failed to fetch quotation details: ${response.body}");
    throw Exception('Failed to fetch quotation details');
  }
}

class QuotationsPage extends StatefulWidget {
  const QuotationsPage({super.key});

  @override
  _QuotationsPageState createState() => _QuotationsPageState();
}

class _QuotationsPageState extends State<QuotationsPage> {
  late Future<List<Quote>> futureQuotations;
  late Future<List<Map<String, dynamic>>> futureStatusOptions;

  @override
  void initState() {
    super.initState();
    futureQuotations = fetchQuotations();
    futureStatusOptions = fetchStatusOptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotations'),
      ),
      body: FutureBuilder<List<Quote>>(
        future: futureQuotations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('No quotations found.');
          } else {
            return ListView(
              children: snapshot.data!.map((quote) {
                return Card(
                  child: ExpansionTile(
                    title: Text(quote.referenceNumber),
                    subtitle: Text('Status: ${quote.status.title}'),
                    children: [
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: futureStatusOptions,
                        builder: (context, statusSnapshot) {
                          if (statusSnapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (statusSnapshot.hasError) {
                            return Text('Error: ${statusSnapshot.error}');
                          } else if (!statusSnapshot.hasData || statusSnapshot.data!.isEmpty) {
                            return const Text('No status options found.');
                          } else {
                            return Column(
                              children: statusSnapshot.data!.map((status) {
                                return ListTile(
                                  title: Text(status['title']),
                                  onTap: () async {
                                    try {
                                      await updateQuoteStatus(quote.referenceNumber, status['id']);
                                      setState(() {
                                        quote.status = QuoteStatus.values[status['id']];
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Failed to update status: $e')),
                                      );
                                    }
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}


//Orders
enum OrderStatus { open, shipped, cancelled, onHold }

extension OrderStatusExtension on OrderStatus {
  int get id {
    switch (this) {
      case OrderStatus.open:
        return 0;
      case OrderStatus.shipped:
        return 1;
      case OrderStatus.cancelled:
        return 2;
      case OrderStatus.onHold:
        return 3;
    }
  }

  String get title {
    switch (this) {
      case OrderStatus.open:
        return "Open";
      case OrderStatus.shipped:
        return "Shipped";
      case OrderStatus.cancelled:
        return "Cancelled";
      case OrderStatus.onHold:
        return "On-Hold";
    }
  }
}

class Order {
  final String referenceNumber;
  OrderStatus status;

  Order({required this.referenceNumber, required this.status});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      referenceNumber: json['referenceNumber'],
      status: OrderStatus.values[json['status']['id']],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'referenceNumber': referenceNumber,
      'status': {'id': status.index},
    };
  }
}

Future<List<Order>> fetchOrders() async {
  final response = await http.get(Uri.parse('http://192.168.29.10:8080/pfeiffer/api/v1/orders'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);

    if (jsonResponse['result'] != null) {
      List<dynamic> data = jsonResponse['result'];
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      print("No 'result' key found in the response.");
      return [];
    }
  } else {
    throw Exception('Failed to load orders');
  }
}

Future<List<Map<String, dynamic>>> fetchOrderStatusOptions() async {
  final response = await http.get(Uri.parse('http://192.168.29.10:8080/pfeiffer/api/v1/order_statuses'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body)['result'];
    return jsonResponse.cast<Map<String, dynamic>>();
  } else {
    throw Exception('Failed to load status options');
  }
}

Future<void> updateOrderStatus(String referenceNumber, int statusId) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/pfeiffer/api/v1/orders/$referenceNumber/status'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'id': statusId,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    print("Update Response: $jsonResponse");
  } else {
    print("Failed to update status: ${response.statusCode} - ${response.body}");
    throw Exception('Failed to update status');
  }
}

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  late Future<List<Order>> futureOrders;
  late Future<List<Map<String, dynamic>>> futureOrderStatusOptions;

  @override
  void initState() {
    super.initState();
    futureOrders = fetchOrders();
    futureOrderStatusOptions = fetchOrderStatusOptions();
  }

  Future<void> _updateOrderStatus(String referenceNumber, OrderStatus newStatus) async {
    try {
      await updateOrderStatus(referenceNumber, newStatus.id);
      setState(() {
        futureOrders = fetchOrders();
      });
    } catch (e) {
      print("Failed to update status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: FutureBuilder<List<Order>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders available.'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                child: ExpansionTile(
                  title: Text(order.referenceNumber),
                  subtitle: Text(order.status.title),
                  children: OrderStatus.values.map((OrderStatus status) {
                    return ListTile(
                      title: Text(status.title),
                      onTap: () {
                        _updateOrderStatus(order.referenceNumber, status);
                      },
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
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