import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  

  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _email = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _amount = TextEditingController();

  String? _ref;
  void setRef() {
    Random rand = Random();
    int number = rand.nextInt(2000);


    if (Platform.isAndroid){
      setState(() {
       _ref = 'AndroidRef1789$number';
       
    });
  }
  else {
   setState(() {
      _ref = 'IOSRef1789$number';
   });
  }
  }

  @override
  void initState() {
    setRef();
    super.initState();
  }

  @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(title : Text('Mobile Office Payment')),
       backgroundColor: Colors.orangeAccent,
       body : Stack(
         children: [
           Padding(
             padding: const EdgeInsets.all(10.0),
             child: Column(
               children: [
                 Container(
                   margin: const EdgeInsets.only(bottom: 10),
                   child: TextFormField(
                     controller: _email,
                     decoration: InputDecoration (labelText: 'Email'),),),
                     Container(
                   margin: const EdgeInsets.only(bottom: 10),
                   child: TextFormField(
                     controller: _phoneNumber,
                     decoration: InputDecoration (labelText: 'Phone Number'),),),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: TextFormField(
                      controller: _amount,
                      decoration: InputDecoration(labelText: 'Amount'),),),
                    ],
                    ),
                  ),
                   
           
           
           
           //button
           Positioned(
             bottom : 0,
             child: GestureDetector(
               onTap: () {
                 final email = _email.text;
                 final phoneNumber = _phoneNumber.text;
                 final amount = _amount.text;

                 if (email.isEmpty || phoneNumber.isEmpty || amount.isEmpty ){
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Fields are empty')));
                 }
                 else {
                   ///flutterwave payment
                   ///
                   _makePayment(context, email.trim(), phoneNumber.trim(), amount.trim());
                 }
               },
             
              child: Container(
               padding: const EdgeInsets.all(20),
               width: MediaQuery.of(context).size.width,
               color: Colors.blueAccent,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                ///icon
               Icon(Icons.payment), 
                Text (
                  "Make Payment",
                   style: TextStyle(
                     fontSize: 20, fontWeight: FontWeight.bold), 



                 
               ),
                ]),
           
       ),
       ),
     )
     ],
    ),
    );
   }

  void _makePayment(BuildContext context, String email, String phoneNumber, String amount) async {
//beginPayment async () { 
   try { 
	     Flutterwave flutterwave = Flutterwave.forUIPayment(
                     context: this.context,
                     encryptionKey: "FLWSECK_TESTfe483e671e2e",
                     publicKey: "FLWPUBK_TEST-3178bacb2d08e365076a5a4cc963c467-X",
                     currency: 'UGX',
                     amount: amount,
                     email: email,
                     fullName: "Mobile Office",
                     txRef: _ref!,
                     isDebugMode: true,
                     phoneNumber: phoneNumber,
                     acceptCardPayment: true,
                     acceptUSSDPayment: false,
                     acceptAccountPayment: false,
                     acceptFrancophoneMobileMoney: false,
                     acceptGhanaPayment: false,
                     acceptMpesaPayment: false,
                     acceptRwandaMoneyPayment: false,
                     acceptUgandaPayment: true,
                     acceptZambiaPayment: false);
                     
         final ChargeResponse response = await flutterwave.initializeForUiPayments();

         if (response == null ) {
           print('Transaction failed');
         }

         else {
           if (response.status == 'success'){
             print(response.data);
             print(response.message);
           }
           else {
             print(response.message);
          
           }
         }
                    
         } catch(error) {
	         print('error');
         }
  }
}

//flutter run --no-sound-null-safety to solve 'package.tripledes' error