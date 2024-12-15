import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  final Function(String) onMessageSent;
  const ChatInput({super.key, required this.onMessageSent});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();

  void _sendMessage() {
    setState(() {
      widget.onMessageSent(_controller.text);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) => _sendMessage(),
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none)
                ),
              ),
              IconButton.filled(
                icon: const Icon(Icons.send),
                onPressed: _controller.text.isEmpty ? null : _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}