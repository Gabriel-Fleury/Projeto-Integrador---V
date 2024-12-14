import 'package:flutter/material.dart';
import 'db.dart';

class EditContactScreen extends StatefulWidget {
  final Contato contato;

  EditContactScreen({required this.contato});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _telefoneController;
  late TextEditingController _emailController; // Novo controller para e-mail

  final DB db = DB();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.contato.nome);
    _telefoneController = TextEditingController(text: widget.contato.telefone);
    _emailController = TextEditingController(text: widget.contato.email ?? ''); // Preenche o campo de e-mail
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Contato"),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _telefoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: _emailController, // Campo de e-mail
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final nome = _nomeController.text;
                final telefone = _telefoneController.text;
                final email = _emailController.text; // Pega o e-mail

                final contato = Contato(
                  id: widget.contato.id,
                  nome: nome,
                  telefone: telefone,
                  email: email,
                );

                await db.updateContato(contato); // Método para atualizar no banco
                Navigator.pop(context); // Volta para a tela anterior
              },
              child: Text("Salvar Alterações"),
            ),
          ],
        ),
      ),
    );
  }
}


