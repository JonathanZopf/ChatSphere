import 'package:flutter/cupertino.dart';

import '../../data/message.dart';
import 'chat_conversation_view.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

/// A single chat bubble widget.
class Bubble extends StatelessWidget {
  /// Indicates if the message belongs to the current user.
  final bool isMine;

  /// The message data to display.
  final Message message;

  /// The style of the chat bubble.
  final BubbleStyle style;

  /// The scrollable state used to determine bubble positioning.
  final ScrollableState scrollable;

  /// Creates a `Bubble` widget for a single chat message.
  ///
  /// [isMine] determines the alignment of the bubble.
  /// [message] is the content to display inside the bubble.
  /// [style] defines the bubble's visual style.
  /// [scrollable] provides scroll-related information for gradient positioning.
  const Bubble({
    super.key,
    required this.isMine,
    required this.message,
    required this.style,
    required this.scrollable,
  });

  String getTimestampFormatted() {
    // If message was sent today, show time only
    if (message.time.day == DateTime.now().day) {
      return DateFormat.Hm().format(message.time);
    }

    // If message was sent yesterday, show "Yesterday" and time
    if (message.time.day == DateTime.now().day - 1) {
      return 'Yesterday, ${DateFormat.Hm().format(message.time)}';
    }

    // If message was sent this year, show date and month but not time
    if (message.time.year == DateTime.now().year) {
      return DateFormat.MMMd().format(message.time);
    }

    // If message was sent in previous years, show date, month, and year but not time
    return DateFormat.yMMMd().format(message.time);
  }

  @override
  Widget build(BuildContext context) {
    final messageAlignment = isMine ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12.0)),
            child: BubbleBackground(
              gradient: isMine
                  ? style.gradientColorsUser
                  : style.gradientColorsOther,
              scrollable: scrollable,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 12.0,
                ),
                child: Column(
                  crossAxisAlignment: isMine
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.end,
                  children: [
                    Text(
                      message.content,
                      style: style.textStyleContent,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      getTimestampFormatted(),
                      style: style.textStyleTimestamp,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Background for a chat bubble, with a gradient that reacts to scrolling.
class BubbleBackground extends StatelessWidget {
  /// The gradient to use for the background.
  final BubbleGradient gradient;

  /// The child widget to render inside the background.
  final Widget child;

  /// The scrollable state, used to determine gradient positioning.
  final ScrollableState scrollable;

  /// Creates a `BubbleBackground` with a dynamic gradient.
  const BubbleBackground({
    super.key,
    required this.gradient,
    required this.child,
    required this.scrollable,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        colors: [gradient.getStartColor(), gradient.getEndColor()],
        bubbleContext: context,
        scrollable: scrollable,
      ),
      child: child,
    );
  }
}

/// Custom painter to draw a dynamic gradient for chat bubbles.
class BubblePainter extends CustomPainter {
  /// The scrollable state used to determine gradient positions.
  final ScrollableState _scrollable;

  /// The context of the bubble being painted.
  final BuildContext _bubbleContext;

  /// The gradient colors for the bubble.
  final List<Color> _colors;

  /// Creates a `BubblePainter`.
  ///
  /// [scrollable] is used to determine the scroll position.
  /// [bubbleContext] is the context of the widget being painted.
  /// [colors] are the gradient colors for the bubble background.
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
    bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );

    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}