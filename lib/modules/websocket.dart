import 'dart:async';

import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketChannel connect(String url) {
  var channel = WebSocketChannel.connect(Uri.parse(url));
  return channel;
}

void send(WebSocketChannel channel, String body) {
  channel.sink.add(body);
}

Stream listen(WebSocketChannel channel) {
  return channel.stream;
}
