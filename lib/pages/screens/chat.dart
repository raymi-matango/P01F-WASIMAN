import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat de WhatsApp',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    // Aquí puedes enviar el mensaje a través de una API o hacer cualquier acción necesaria
    print('Mensaje enviado: $text');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat de WhatsApp'),
      ),
      body: _buildTextComposer(),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration.collapsed(
                hintText: 'Enviar un mensaje',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _handleSubmitted(_textController.text),
          ),
        ],
      ),
    );
  }
}
