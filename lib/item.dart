import 'package:flutter_bloc/flutter_bloc.dart';

class HttpRequestConfig {
  final int id;
  String title;
  String url = '';
  String responseBody = '';
  String selectedMethod = 'GET';

  HttpRequestConfig(this.id, this.title);
}

class HttpRequestConfigBloc extends Cubit<HttpRequestConfig?> {
  HttpRequestConfigBloc() : super(null);

  void selectItem(HttpRequestConfig item) => emit(item);
}