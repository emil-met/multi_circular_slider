part of circular_slider;

/// CustomPainter class to draw progress bar curves
class CircularProgressBarPainter extends CustomPainter {
  //size of the widget
  final double size;

  //width of the track
  final double trackWidth;

  //width of the progressbar
  final double progressBarWidth;

  //list of total values
  final List<double> values;

  //list of colors
  final List<Color> colors;

  final List<String> labels;

  //color of track
  final Color trackColor;

  //constructor
  CircularProgressBarPainter({
    required this.size,
    this.trackWidth = 32.0,
    this.progressBarWidth = 32.0,
    required this.values,
    required this.colors,
    this.labels = const [],
    this.trackColor = Colors.grey,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //base angle of curve
    const double baseAngle = 180.0;
    //actual starting angle of arc
    final double startAngle = degreeToRadians(baseAngle);

    //length of list
    int length = values.length;
    double totalPercentage = 0.0;

    //to store values in reverse order
    List<CircularShader> progressBars = [];

    //iterating through list for calculating values
    for (int i = 0; i < length; i++) {
      double percentage = baseAngle * values[i];
      totalPercentage += percentage;
      double sweepAngle = degreeToRadians(totalPercentage);

      //progress bar paint
      final progressBarPaint = Paint()
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..color = colors[i]
        ..strokeWidth = trackWidth;

      //adding values to list
      progressBars.insert(
        0,
        CircularShader(
          startAngle: startAngle,
          sweepAngle: sweepAngle,
          paint: progressBarPaint,
          name: labels[i],
          value: values[i],
          prevSweepAngle:
              (progressBars.isNotEmpty) ? progressBars.first.sweepAngle : 0.0,
        ),
      );
    }

    //drawing actual progress bars
    for (final progressBar in progressBars) {
      drawCurve(
        canvas,
        size,
        progressBar.startAngle,
        progressBar.sweepAngle,
        progressBar.paint,
        progressBar.name,
        progressBar.value,
        progressBar.prevSweepAngle,
      );
    }
  }

  ///[Logic for drawing curve]
  drawCurve(
    Canvas canvas,
    Size size,
    double startAngle,
    double sweepAngle,
    Paint paint,
    String name,
    double value,
    double prevSweepAngle,
  ) {
    double radius = size.width / 2;
    Offset center = Offset(
      size.width / 2,
      size.height / 2,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      startAngle,
      sweepAngle,
      false,
      paint,
    );

    final previousRadians = (startAngle + prevSweepAngle);

    final currentRadians = (startAngle + sweepAngle);

    final radians = currentRadians - ((currentRadians - previousRadians) / 2);

    final x = (radius) * math.cos(radians);
    final y = (radius) * math.sin(radians);
    final side = math.min(size.width, size.height);

    _drawName(canvas, name, x * 1.4, y * 1.2, side);
  }

  ///[Logic for converting degree to radians]
  degreeToRadians(double degree) {
    return degree * (math.pi / 180);
  }

  void _drawName(
    Canvas canvas,
    String? name,
    double x,
    double y,
    double side, {
    TextStyle? style,
  }) {
    final span = TextSpan(
      style: TextStyle(color: Color(0xFF000000)),
      text: name,
    );

    TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    var dx = (side / 2 + x) - (tp.width / 2);
    var dy = (side / 2 + y) - (tp.height / 2);

    tp.paint(
      canvas,
      Offset(
        dx,
        dy,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// class for storing values of the ProgressBar
class CircularShader {
  final double startAngle;
  final double sweepAngle;
  final Paint paint;
  final String name;
  final double value;
  final double prevSweepAngle;

  CircularShader({
    required this.startAngle,
    required this.sweepAngle,
    required this.paint,
    required this.name,
    required this.value,
    required this.prevSweepAngle,
  });
}
