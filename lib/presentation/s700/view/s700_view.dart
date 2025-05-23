// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:mek_stripe_terminal/mek_stripe_terminal.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rmnevents/app_configurations/app_environments.dart';
//
// class S700View extends StatefulWidget {
//   @override
//   _S700ViewState createState() => _S700ViewState();
// }
//
// class _S700ViewState extends State<S700View> {
//   bool isScanning = false;
//   String scanStatus = "Scan readers";
//   Terminal? _terminal;
//   Location? _selectedLocation;
//   List<Reader> _readers = [];
//   Reader? _reader;
//
//   static const bool _isSimulated = true; //if testing >> true otherwise false
//
//   //Tap & Pay
//   StreamSubscription? _onConnectionStatusChangeSub;
//
//   var _connectionStatus = ConnectionStatus.notConnected;
//
//   StreamSubscription? _onPaymentStatusChangeSub;
//
//   PaymentStatus _paymentStatus = PaymentStatus.notReady;
//
//   StreamSubscription? _onUnexpectedReaderDisconnectSub;
//
//   StreamSubscription? _discoverReaderSub;
//
//   void _startDiscoverReaders(Terminal terminal) {
//     isScanning = true;
//     _readers = [];
//     final discoverReaderStream =
//     terminal.discoverReaders(const LocalMobileDiscoveryConfiguration(
//       isSimulated: _isSimulated,
//     ));
//     setState(() {
//       _discoverReaderSub = discoverReaderStream.listen((readers) {
//         scanStatus = "Tap on Any To connect ";
//         setState(() => _readers = readers);
//       }, onDone: () {
//         setState(() {
//           _discoverReaderSub = null;
//           _readers = const [];
//         });
//       });
//     });
//   }
//
//   void _stopDiscoverReaders() {
//     unawaited(_discoverReaderSub?.cancel());
//     setState(() {
//       _discoverReaderSub = null;
//       isScanning = false;
//       scanStatus = "Scan readers";
//       _readers = const [];
//     });
//   }
//
//   Future<void> _connectReader(Terminal terminal, Reader reader) async {
//     await _tryConnectReader(terminal, reader).then((value) {
//       final connectedReader = value;
//       if (connectedReader == null) {
//         throw Exception("Error connecting to reader ! Please try again");
//       }
//       _reader = connectedReader;
//     });
//   }
//
//   Future<Reader?> _tryConnectReader(Terminal terminal, Reader reader) async {
//     String? getLocationId() {
//       final locationId = _selectedLocation?.id ?? reader.locationId;
//       if (locationId == null) throw AssertionError('Missing location');
//
//       return locationId;
//     }
//
//     final locationId = getLocationId();
//
//     return await terminal.connectMobileReader(
//       reader,
//       locationId: locationId!,
//     );
//   }
//
//   Future<void> _fetchLocations() async {
//     final locations = await _terminal!.listLocations();
//     _selectedLocation = locations.first;
//     print(_selectedLocation);
//     if (_selectedLocation == null) {
//       throw AssertionError(
//           'Please create location on stripe dashboard to proceed further!');
//     }
//   }
//
//   Future<void> requestPermissions() async {
//     final permissions = [
//       Permission.locationWhenInUse,
//       Permission.bluetooth,
//       if (Platform.isAndroid) ...[
//         Permission.bluetoothScan,
//         Permission.bluetoothConnect,
//       ],
//     ];
//
//     for (final permission in permissions) {
//       final result = await permission.request();
//       if (result == PermissionStatus.denied ||
//           result == PermissionStatus.permanentlyDenied) return;
//     }
//   }
//
//   Future<void> _initTerminal() async {
//     await requestPermissions();
//     await initTerminal();
//     await _fetchLocations();
//   }
//
//   Future<String> getConnectionToken() async {
//     http.Response response = await http.post(
//       Uri.parse("https://api.stripe.com/v1/terminal/connection_tokens"),
//       headers: {
//         'Authorization': 'Bearer ${AppEnvironments.stripePublishableKey}',
//         'Content-Type': 'application/x-www-form-urlencoded'
//       },
//     );
//     Map jsonResponse = json.decode(response.body);
//     print(jsonResponse);
//     if (jsonResponse['secret'] != null) {
//       return jsonResponse['secret'];
//     } else {
//       return "";
//     }
//   }
//
//   Future<void> initTerminal() async {
//     final connectionToken = await getConnectionToken();
//     final terminal = await Terminal.getInstance(
//       shouldPrintLogs: false,
//       fetchToken: () async {
//         return connectionToken;
//       },
//     );
//     _terminal = terminal;
//     showSnackBar("Initialized Stripe Terminal");
//
//     _onConnectionStatusChangeSub =
//         terminal.onConnectionStatusChange.listen((status) {
//           print('Connection Status Changed: ${status.name}');
//           _connectionStatus = status;
//           scanStatus = _connectionStatus.name;
//         });
//     _onUnexpectedReaderDisconnectSub =
//         terminal.onUnexpectedReaderDisconnect.listen((reader) {
//           print('Reader Unexpected Disconnected: ${reader.label}');
//         });
//     _onPaymentStatusChangeSub = terminal.onPaymentStatusChange.listen((status) {
//       print('Payment Status Changed: ${status.name}');
//       _paymentStatus = status;
//     });
//     if (_terminal == null) {
//       print('Please try again later!');
//     }
//   }
//
//   void showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(message),
//       ));
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showSnackBar("Wait initializing Stripe Terminal");
//     });
//
//     _initTerminal();
//   }
//
//   @override
//   void dispose() {
//     unawaited(_onConnectionStatusChangeSub?.cancel());
//     unawaited(_discoverReaderSub?.cancel());
//     unawaited(_onUnexpectedReaderDisconnectSub?.cancel());
//     unawaited(_onPaymentStatusChangeSub?.cancel());
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               scanStatus,
//               style: const TextStyle(fontSize: 24, color: Colors.teal),
//             ),
//             if (_readers.isNotEmpty)
//               ..._readers.map((reader) => TextButton(
//                 onPressed: () async {
//                   await _connectReader(_terminal!, reader).then((v) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => PaymentPage(
//                             terminal: _terminal!,
//                           )),
//                     );
//                   });
//                 },
//                 child: Text(
//                   reader.serialNumber,
//                   style: const TextStyle(fontSize: 20, color: Colors.grey),
//                 ),
//               )),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           isScanning
//               ? _stopDiscoverReaders()
//               : _startDiscoverReaders(_terminal!);
//         },
//         label: Text(isScanning ? 'Stop Scanning' : 'Scan Reader'),
//         icon: Icon(isScanning ? Icons.stop : Icons.scanner),
//         backgroundColor: Colors.teal,
//         elevation: 5,
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
//
// class PaymentPage extends StatefulWidget {
//   final Terminal terminal;
//
//   const PaymentPage({super.key, required this.terminal});
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }
//
// class _PaymentPageState extends State<PaymentPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _amountController = TextEditingController();
//   bool _isPaymentSuccessful = false;
//   PaymentIntent? _paymentIntent;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       showSnackBar("Connected");
//     });
//   }
//
//   @override
//   void dispose() {
//     _amountController.dispose();
//     super.dispose();
//   }
//
//   Future<bool> _createPaymentIntent(Terminal terminal, String amount) async {
//     final paymentIntent =
//     await terminal.createPaymentIntent(PaymentIntentParameters(
//       amount:
//       (double.parse(double.parse(amount).toStringAsFixed(2)) * 100).ceil(),
//       currency: "usd",
//       captureMethod: CaptureMethod.automatic,
//       paymentMethodTypes: [PaymentMethodType.cardPresent],
//     ));
//     _paymentIntent = paymentIntent;
//     if (_paymentIntent == null) {
//       showSnackBar('Payment intent is not created!');
//     }
//
//     return await _collectPaymentMethod(terminal, _paymentIntent!);
//   }
//
//   Future<bool> _collectPaymentMethod(
//       Terminal terminal, PaymentIntent paymentIntent) async {
//     final collectingPaymentMethod = terminal.collectPaymentMethod(
//       paymentIntent,
//       skipTipping: true,
//     );
//
//     try {
//       final paymentIntentWithPaymentMethod = await collectingPaymentMethod;
//       _paymentIntent = paymentIntentWithPaymentMethod;
//       await _confirmPaymentIntent(terminal, _paymentIntent!).then((value) {});
//       return true;
//     } on TerminalException catch (exception) {
//       switch (exception.code) {
//         case TerminalExceptionCode.canceled:
//           showSnackBar('Collecting Payment method is cancelled!');
//           return false;
//         default:
//           rethrow;
//       }
//     }
//   }
//
//   Future<void> _confirmPaymentIntent(
//       Terminal terminal, PaymentIntent paymentIntent) async {
//     try {
//       showSnackBar('Processing!');
//
//       final processedPaymentIntent =
//       await terminal.confirmPaymentIntent(paymentIntent);
//       _paymentIntent = processedPaymentIntent;
//       // Show the animation for a while and then reset the state
//       Future.delayed(Duration(seconds: 3), () {
//         setState(() {
//           _isPaymentSuccessful = false;
//         });
//       });
//       setState(() {
//         _isPaymentSuccessful = true;
//       });
//       showSnackBar('Payment processed!');
//     } catch (e) {
//       showSnackBar('Inside collect payment exception ${e.toString()}');
//
//       print(e.toString());
//     }
//     // navigate to payment success screen
//   }
//
//   void showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(SnackBar(
//         behavior: SnackBarBehavior.floating,
//         content: Text(message),
//       ));
//   }
//
//   void _collectPayment() async {
//     if (_formKey.currentState!.validate()) {
//       bool status =
//       await _createPaymentIntent(widget.terminal, _amountController.text);
//       if (status) {
//         showSnackBar('Payment Collected: ${_amountController.text}');
//       } else {
//         showSnackBar('Payment Canceled');
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Collect Payment',
//           style: TextStyle(
//               fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24),
//         ),
//         backgroundColor: Colors.teal,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   const SizedBox(
//                     height: 100,
//                   ),
//                   TextFormField(
//                     controller: _amountController,
//                     decoration: const InputDecoration(
//                       labelText: 'Enter Amount',
//                       border: OutlineInputBorder(),
//                     ),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an amount';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 40),
//                   ElevatedButton(
//                     onPressed: _collectPayment,
//                     child: const Text('Collect Payment'),
//                     style: ElevatedButton.styleFrom(
//                       foregroundColor: Colors.teal,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // if (_isPaymentSuccessful)
//           //   RiveAnimation.asset(
//           //     'assets/animations/success.riv',
//           //   ),
//         ],
//       ),
//     );
//   }
// }