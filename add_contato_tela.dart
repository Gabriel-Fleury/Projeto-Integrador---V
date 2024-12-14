import 'package:flutter/material.dart';
import 'db.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController(); // Novo controller para e-mail

  final DB db = DB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar Contato"),
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

                if (nome.isEmpty || telefone.isEmpty) {
                  // Validar se os campos obrigatórios estão preenchidos
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Nome e Telefone são obrigatórios!'),
                  ));
                  return;
                }

                final contato = Contato(
                  nome: nome,
                  telefone: telefone,
                  email: email.isNotEmpty ? email : null, // Se o e-mail não for vazio, inclui
                );

                // Tente adicionar o contato
                try {
                  await db.insertContato(contato); // Método para inserir no banco
                  Navigator.pop(context); // Volta para a tela anterior
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Erro ao adicionar contato: $e'),
                  ));
                }
              },
              child: Text("Salvar Contato"),
            ),
          ],
        ),
      ),
    );
  }
}



