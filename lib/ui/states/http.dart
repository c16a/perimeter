import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perimeter/ui/widgets/nice_text_field.dart';

import '../../item.dart';
import '../../modules/http.dart';
import '../views/config_view.dart';

class HttpRequestConfigViewState extends State<ConfigView> {
  final _urlController = TextEditingController();
  final _requestBodyController = TextEditingController();
  String responseBody = '';
  final httpMethods = ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];
  String selectedMethod = 'GET';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HttpRequestConfigBloc, HttpRequestConfig?>(
      builder: (context, selectedItem) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton<String>(
                      value: selectedMethod,
                      onChanged: (newValue) {
                        setState(() {
                          selectedMethod = newValue!;
                        });
                      },
                      items: httpMethods.map((method) {
                        return DropdownMenuItem<String>(
                          value: method,
                          child: Text(method),
                        );
                      }).toList(),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: NiceTextField(
                        controller: _urlController,
                        hintText: 'HTTP URL',
                      ),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () async {
                        final response = await sendHttpRequest(
                            url: _urlController.text,
                            body: _requestBodyController.text,
                            method: selectedMethod);
                        setState(() {
                          responseBody = prettyPrint(response);
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)))),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              NiceTextField(
                  controller: _requestBodyController, hintText: 'Request Body'),
              const SizedBox(height: 16.0),
              const Text(
                'Response Body:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Text(responseBody),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
