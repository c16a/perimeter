import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:perimeter/modules/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../item.dart';
import '../views/config_view.dart';
import '../widgets/nice_text_field.dart';

enum WebsocketMessageDirection { sent, received }

class WebsocketMessage {
  final String message;
  final WebsocketMessageDirection direction;
  final DateTime dateTime;

  WebsocketMessage(this.message, this.direction, this.dateTime);
}

class WebSocketConfigViewState extends State<ConfigView> {
  final _urlController = TextEditingController();
  final _requestBodyController = TextEditingController();
  String connectionStatus = '';
  WebSocketChannel? channel;
  List<WebsocketMessage> duplexStream = List.empty(growable: true);

  @override
  void dispose() {
    // TODO: make sure the channel doesn't get fucked
    super.dispose();
  }

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
                    Expanded(
                      child: SizedBox(
                        child: NiceTextField(
                          controller: _urlController,
                          hintText: 'WebSocket URL',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final channel = connect(_urlController.text);
                        await channel.ready;
                        setState(() {
                          connectionStatus = 'Connected';
                          this.channel = channel;
                        });
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)))),
                      child: const Text('Connect'),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: NiceTextField(
                          controller: _requestBodyController,
                          hintText: 'Message',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (channel != null) {
                          var message = _requestBodyController.text;
                          send(channel!, _requestBodyController.text);
                          duplexStream.add(WebsocketMessage(message,
                              WebsocketMessageDirection.sent, DateTime.now()));
                        }
                      },
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0.0),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)))),
                      child: const Text('Send to Channel'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              IntrinsicHeight(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Connection Status',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(connectionStatus),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                child: Text("Messages"),
              ),
              Expanded(
                  child: channel == null
                      ? Container()
                      : StreamBuilder<dynamic>(
                          stream: channel!.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData) {
                              return const Text('No messages on channel yet');
                            }

                            final items = snapshot.data;
                            duplexStream.add(WebsocketMessage(
                                items,
                                WebsocketMessageDirection.received,
                                DateTime.now()));

                            return ListView.builder(
                                itemCount: duplexStream.length,
                                itemBuilder: (ctx, index) {
                                  final item = duplexStream[index];
                                  return ListTile(
                                    title: IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Opacity(
                                            opacity: 0.5,
                                            child: Text(
                                              item.direction ==
                                                      WebsocketMessageDirection
                                                          .received
                                                  ? "RECV"
                                                  : "SENT",
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: Text(item.message),
                                            ),
                                          ),
                                          Text(item.dateTime.toString())
                                        ],
                                      ),
                                    ),
                                  );
                                });

                            return Text(items);
                          }))
            ],
          ),
        );
      },
    );
  }
}
