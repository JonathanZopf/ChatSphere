import 'dart:math';
import 'package:chat_sphere/data/chat_thread.dart';
import 'package:chat_sphere/data/message.dart';
import 'package:flutter/material.dart';

import 'chat_bubble.dart';

/// A widget that displays a chat conversation using a list of bubble-style messages.
class ChatConversationView extends StatelessWidget {
  /// The chat thread containing messages to be displayed.
  final ChatThread chat;

  /// Creates a `ChatConversationView`.
  ///
  /// [chat] is the chat thread whose messages will be displayed.
  const ChatConversationView({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    // Controller for managing scroll behavior.
    final ScrollController controller = ScrollController();

    // Style configuration for chat bubbles.
    final BubbleStyle bubbleStyle = BubbleStyle(
      gradientColorsUser: BubbleGradient(
        baseColor: Theme.of(context).colorScheme.primaryContainer,
        changeFactor: 0.2,
      ),
      gradientColorsOther: BubbleGradient(
        baseColor: Theme.of(context).colorScheme.tertiaryContainer,
        changeFactor: 0.2,
      ),
      textStyleContent: Theme.of(context).textTheme.bodyMedium!,
      textStyleTimestamp: Theme.of(context).textTheme.labelMedium!.copyWith(fontStyle: FontStyle.italic),
    );

    // Displays a list of messages as bubbles.
    return ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(8.0),
      itemCount: chat.messages.length,
      itemBuilder: (context, index) {
        final message = chat.messages[index];

        // Create a chat bubble for each message.
        return Bubble(
          isMine: message.isMine,
          message: message,
          style: bubbleStyle,
          scrollable: Scrollable.of(context)!, // Pass the scrollable
        );
      },
    );
  }
}

/// Defines a gradient for the background of chat bubbles.
class BubbleGradient {
  /// The base color for the gradient.
  final Color baseColor;

  /// The factor by which the base color is changed.
  final double changeFactor;

  /// Creates a `BubbleGradient` with a [baseColor] and a [changeFactor].
  const BubbleGradient({required this.baseColor, required this.changeFactor});

  /// Adjusts the color brightness based on [changeFactor].
  ///
  /// Returns a new color with the brightness altered by the given factor.
  Color _changeColor(double changeFactor) {
    return Color.fromARGB(
      baseColor.alpha,
      _changeColorComponent(baseColor.red, changeFactor),
      _changeColorComponent(baseColor.green, changeFactor),
      _changeColorComponent(baseColor.blue, changeFactor),
    );
  }

  /// Adjusts a single color component.
  ///
  /// [originalComponent] is the RGB component value, and [changeFactor]
  /// determines how much the value changes.
  int _changeColorComponent(int originalComponent, double changeFactor) {
    return (originalComponent * changeFactor).round().clamp(0, 255);
  }

  /// Returns the starting color of the gradient.
  Color getStartColor() {
    return _changeColor(1 + changeFactor);
  }

  /// Returns the ending color of the gradient.
  Color getEndColor() {
    return _changeColor(1 - changeFactor);
  }
}

/// Defines the visual style of chat bubbles.
class BubbleStyle {
  /// Gradient colors for the current user's messages.
  final BubbleGradient gradientColorsUser;

  /// Gradient colors for other users' messages.
  final BubbleGradient gradientColorsOther;

  /// Text style for the message content.
  final TextStyle textStyleContent;

  /// Text style for the message timestamp.
  final TextStyle textStyleTimestamp;

  /// Creates a `BubbleStyle` to define visual elements of chat bubbles.
  const BubbleStyle({
    required this.gradientColorsUser,
    required this.gradientColorsOther,
    required this.textStyleContent,
    required this.textStyleTimestamp,
  });
}
