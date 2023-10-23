import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/views/config_view.dart';
import 'item.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.white, brightness: Brightness.light)),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HttpRequestConfigBloc>(
            create: (context) => HttpRequestConfigBloc(),
          ),
        ],
        child: MasterDetailLayout(),
      ),
    );
  }
}

class MasterDetailLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perimeter'),
        elevation: 0.0,
      ),
      body: Row(
        children: <Widget>[
          Expanded(
            child: MasterList(),
          ),
          if (isWideScreen)
            Expanded(
              child: ConfigView(),
            )
        ],
      ),
    );
  }
}

class MasterList extends StatefulWidget {
  @override
  _MasterListState createState() => _MasterListState();
}

class _MasterListState extends State<MasterList> {
  List<HttpRequestConfig> items = [
    HttpRequestConfig(1, 'Movie 1'),
    HttpRequestConfig(2, 'Movie 2'),
    HttpRequestConfig(3, 'Movie 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            final itemBloc = BlocProvider.of<HttpRequestConfigBloc>(context);
            final newItem = HttpRequestConfig(items.length + 1, 'New Request');
            setState(() {
              items.add(newItem); // Add the new item to the list
            });
            itemBloc.selectItem(newItem);
          },
          child: Text('New Request'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(
                  (context.read<HttpRequestConfigBloc>().state?.id == item.id)
                      ? item.title
                      : item.title,
                ),
                onTap: () {
                  final itemBloc =
                      BlocProvider.of<HttpRequestConfigBloc>(context);
                  itemBloc.selectItem(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
