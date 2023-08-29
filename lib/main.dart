import 'package:flutter/material.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dynamicData = <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: WidgetTreeLayout(
              key: GlobalKey(),
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(8),
                child: const Text('Title Here'),
              ),
              children: [
                ...dynamicData.map((e) => Container(
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Expanded(child: Text(e)),
                              IconButton(
                                  onPressed: () {
                                    dynamicData.removeWhere((element) => element==e);
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete))
                            ], 
                          ),
                        ) ).toList(),
                ElevatedButton(
                    onPressed: () {
                      dynamicData.add(DateTime.now().toString());
                      setState(() {});
                    },
                    child: const Text('TAMBAH DATA'))
              ]),
        ));
  }
}

class WidgetTreeLayout extends StatefulWidget {
  const WidgetTreeLayout({
    Key? key,
    required this.children,
    required this.title,
  }) : super(key: key);
  final List<Widget> children;
  final Widget title;

  @override
  State<WidgetTreeLayout> createState() => _WidgetTreeLayoutState();
}

class _WidgetTreeLayoutState extends State<WidgetTreeLayout> {
  final keys = <GlobalKey>[];

  @override
  void initState() {
    keys.addAll(List.generate(widget.children.length, (index) => GlobalKey()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        widget.title,
        IntrinsicHeight(
          child: Row(
            children: <Widget>[
              CustomPaint(
                  painter: _ConnectionPainter(keys),
                  size: const Size(60, double.infinity)),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      ...List.generate(
                        keys.length,
                        (i) => Container(
                          key: keys[i],
                          child: widget.children[i],
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  final List<GlobalKey> keys;

  _ConnectionPainter(this.keys);

  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawColor(Colors.yellow, BlendMode.src);
    double firstOffset = -1;
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 2;

    final circlePaint = Paint()
      ..color = Colors.blue.shade800
      ..style = PaintingStyle.fill;

    for (final key in keys) {
      RenderBox renderBox = key.currentContext?.findRenderObject() as RenderBox;
      Size widgetSize = renderBox.size;
      Offset widgetPosition = renderBox.localToGlobal(Offset.zero);
      if (firstOffset == -1) {
        firstOffset = widgetPosition.dy - 20;
      }
      final heightOfLine =
          widgetPosition.dy - firstOffset + widgetSize.height / 2;
      final endOfLine = Offset(size.width * 0.8, heightOfLine);
      final path = Path();
      path.moveTo(5, 0);
      path.lineTo(5, heightOfLine - 20);
      path.arcToPoint(Offset(30, heightOfLine),
          radius: const Radius.circular(25), clockwise: false);
      path.lineTo(endOfLine.dx, endOfLine.dy);
      // path.addOval(Rect.fromCenter(center: endOfLine, width: 5, height: 5));
      canvas.drawPath(path, linePaint);
      canvas.drawOval(Rect.fromCenter(center: endOfLine, width: 10, height: 10),
          circlePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
