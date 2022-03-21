import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textValue = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final focus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("API Function"),
        ),
        body: InkWell(
          onDoubleTap: () {
            focus.unfocus();
          },
          onTap: () {
            focus.unfocus();
          },
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      focusNode: focus,
                      controller: textValue,
                      decoration:
                          const InputDecoration(labelText: 'Type something'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Something';
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      focus.unfocus();

                      print('read button');
                      var url = Uri.parse(
                          'https://us-central1-argutes-learning.cloudfunctions.net/app/entries/${textValue.text}');

                      var response = await http.get(url);
                      if (response.statusCode == 200) {
                        print("response value ${response.body.runtimeType}");
                        var jsonResponse = response.body.runtimeType == String
                            ? convert.jsonDecode(response.body)
                            : convert.jsonDecode(response.body)
                                as Map<String, dynamic>;

                        print('Response value: $jsonResponse ');
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Read Function'),
                                  content: Text(jsonResponse.runtimeType ==
                                          String
                                      ? jsonResponse
                                      : 'field value is ${jsonResponse['title']}'),
                                )).then((value) => textValue.clear());
                      } else {
                        print(
                            'Request failed with status: ${response.statusCode}.');
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text('Read Function'),
                                  content: Text(
                                      'Incorrect Request... Status code: ${response.statusCode}'),
                                )).then((value) => textValue.clear());
                        // textValue.clear();

                      }
                    },
                    child: const Text('Read'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      focus.unfocus();
                      print('create button');
                      var url = Uri.parse(
                          'http://ec2-13-234-30-3.ap-south-1.compute.amazonaws.com:8000/Product_Master/product_list/');
                      // https://us-central1-argutes-learning.cloudfunctions.net/app/entries/${textValue.text}

                      var response = await http.get(url, headers: {
                        'Content-Type': 'application/json; charset=UTF-8',
                        'Accept': 'application/json',
                        'Access-Control-Allow-Origin': '*/*',
                      });
                      print('response value $response');
                      if (response.statusCode == 200) {
                        var jsonResponse = response.body.runtimeType == String
                            ? convert.jsonDecode(response.body)
                            : convert.jsonDecode(response.body)
                                as Map<String, dynamic>;

                        print('Response value: $jsonResponse ');
                      } else {
                        print('not work properly');
                      }

                      // print('create button');
                      // var url = Uri.parse(
                      //     'https://us-central1-argutes-learning.cloudfunctions.net/app/entries');
                      // Map<String, dynamic> mapvalue = {
                      //   "title": textValue.text,
                      //   "text": "textvalue",
                      // };
                      // var response = await http.post(url, body: mapvalue);
                      // if (response.statusCode == 200) {
                      //   var jsonResponse = convert.jsonDecode(response.body)
                      //       as Map<String, dynamic>;

                      //   print('Response value: $jsonResponse ');
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //             title: const Text('Post Function'),
                      //             content: Text(jsonResponse['message']),
                      //           )).then((value) => textValue.clear());
                      // } else {
                      //   print(
                      //       'Request failed with status: ${response.statusCode}.');
                      //   showDialog(
                      //       context: context,
                      //       builder: (context) => AlertDialog(
                      //             title: const Text('Post Function'),
                      //             content: Text(
                      //                 'Incorrect Request... Status code: ${response.statusCode}'),
                      //           )).then((value) => textValue.clear());
                      //   // textValue.clear();

                      // }
                    },
                    child: const Text('Create'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      focus.unfocus();
                      print('delete button ${textValue.text}');
                      try {
                        final baseUrl =
                            "https://us-central1-argutes-learning.cloudfunctions.net/app/entries/${textValue.text}";
                        final url = Uri.parse(baseUrl);

                        final response = await http.delete(url);

                        if (response.statusCode != 200) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Delete Function'),
                                    content: Text(
                                        'Incorrect Request... Status code: ${response.statusCode}'),
                                  )).then((value) => textValue.clear());
                        } else if (response.statusCode == 200) {
                          var jsonResponse = convert.jsonDecode(response.body)
                              as Map<String, dynamic>;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Delete Function'),
                                    content: Text(jsonResponse['message']),
                                  )).then((value) => textValue.clear());
                          print(
                              "${textValue.text}  Document Deleted and the status code is ${response.statusCode}");
                        }
                      } on Exception {
                        print('exception $Exception');
                      }
                      textValue.clear();
                    },
                    child: const Text('Delete'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      print('update button');
                      try {
                        final baseUrl =
                            "https://us-central1-argutes-learning.cloudfunctions.net/app/entries/${textValue.text}";
                        final url = Uri.parse(baseUrl);

                        Map<String, dynamic> mapvalue = {
                          "title": "New Title Value",
                        };

                        final response = await http.put(url, body: mapvalue);

                        if (response.statusCode != 200) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Put Function'),
                                    content: Text(
                                        'Incorrect Request... Status code: ${response.statusCode}'),
                                  )).then((value) => textValue.clear());
                        } else if (response.statusCode == 200) {
                          var jsonResponse = convert.jsonDecode(response.body)
                              as Map<String, dynamic>;
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: const Text('Put Function'),
                                    content: Text(jsonResponse['message']),
                                  )).then((value) => textValue.clear());
                          print(
                              "${textValue.text}  Document Updated and the status code is ${response.statusCode}");
                        }
                      } on Exception {
                        print('exception $Exception');
                      }
                      textValue.clear();
                    },
                    child: const Text('Update'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}


// var data= {'id':1,"name":"Akshay","age":25,"salary":25000};

//  button1;
// Button?=  

// if(data['id']!=null)
// {
//   button1;
// }
// else if(data['items']!=null)
// {
//   button2;
// }
// else
// {
//   button1;
// }])
// {
//   button1
// }
// button2

// var data1= {"items":[
//   {'id':1,"name":"Akshay","age":25,"salary":25000}
//   ],
//   };