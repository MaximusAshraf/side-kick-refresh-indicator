import 'package:flutter/material.dart';
import 'package:waves_animation/custom_animated_switcher.dart';
import 'package:waves_animation/custom_refresh_indicator.dart';
import 'package:waves_animation/waves_animation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MAXIndicator(
          onRefresh: _onRefresh,
          indicatorHeight: 100,
          indicatorSpacing: 8,
          refreshFactor: .5,
          indicatorBuilder: (context, animationValue, isRefreshing) {
            return ColorWaveShimmer(
              colors: const [
                Colors.black26,
                Colors.black,
                Colors.black26,
              ],
              duration: const Duration(milliseconds: 1500),
              curve: Curves.slowMiddle,
              isRepeating: isRefreshing,
              child: CustomAnimatedSwitcher(
                isRefreshing: isRefreshing,
                child: Container(
                  key: ValueKey(isRefreshing),
                  alignment: Alignment.center,
                  child: Text(
                    isRefreshing ? "Loading..." : 'Refresh?',
                    style: const TextStyle(
                        fontSize: 48, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          },
          child: const DummyPage(),
        ),
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  const DummyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network(
            "https://unsplash.com/photos/KsLPTsYaqIQ/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzI0NzU5MTYzfA&force=true&w=640"),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title of the Item',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Author Name',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text(
                'Published Date: 27 Aug 2024',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 24),
              Text(
                'Description:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                // Dummy content with repeated text to make it scrollable
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Vestibulum id ligula porta felis euismod semper. '
                'Cras justo odio, dapibus ac facilisis in, egestas eget quam. '
                'Maecenas faucibus mollis interdum. '
                'Praesent commodo cursus magna, vel scelerisque nisl consectetur et. '
                'Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. '
                'Aenean lacinia bibendum nulla sed consectetur. '
                'Curabitur blandit tempus porttitor. '
                'Etiam porta sem malesuada magna mollis euismod. '
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Vestibulum id ligula porta felis euismod semper. '
                'Cras justo odio, dapibus ac facilisis in, egestas eget quam. '
                'Maecenas faucibus mollis interdum. '
                'Praesent commodo cursus magna, vel scelerisque nisl consectetur et. '
                'Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. '
                'Aenean lacinia bibendum nulla sed consectetur. '
                'Curabitur blandit tempus porttitor. '
                'Etiam porta sem malesuada magna mollis euismod. '
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Vestibulum id ligula porta felis euismod semper. '
                'Cras justo odio, dapibus ac facilisis in, egestas eget quam. '
                'Maecenas faucibus mollis interdum. '
                'Praesent commodo cursus magna, vel scelerisque nisl consectetur et. '
                'Donec sed odio dui. Donec ullamcorper nulla non metus auctor fringilla. '
                'Aenean lacinia bibendum nulla sed consectetur. '
                'Curabitur blandit tempus porttitor. '
                'Etiam porta sem malesuada magna mollis euismod.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
