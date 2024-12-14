import 'package:flutter/material.dart';
import 'db.dart';
import 'add_contato_tela.dart';
import 'edit_contato_tela.dart';

//Versão 3.0 Aplicativo Projeto Integrador

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DB db = DB();
  List<Contato> contatos = [];

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  // Carrega os contatos da base de dados
  _loadContatos() async {
    contatos = await db.getContatos();
    setState(() {});
  }

  // Exibe a confirmação de exclusão
  void _showDeleteConfirmation(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Excluir Contato"),
        content: Text("Tem certeza que deseja excluir este contato?"),
        actions: [
          TextButton(
            onPressed: () {
              _deleteContato(id); // Se o usuário confirmar, deleta o contato
              Navigator.pop(context); // Fecha o diálogo
            },
            child: Text("Sim"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context), // Fecha o diálogo sem excluir
            child: Text("Não"),
          ),
        ],
      ),
    );
  }

  // Função que deleta o contato
  _deleteContato(int id) async {
    await db.deleteContato(id); // Chama o método da base de dados para excluir o contato
    _loadContatos(); // Atualiza a lista de contatos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de Contatos"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        backgroundColor: Colors.blueGrey[900],
        elevation: 4.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Navega para a tela de adicionar contato
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddContactScreen()),
                );
                _loadContatos(); // Atualiza a lista após adicionar
              },
              child: Text("Adicionar Contato"),
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: contatos.length,
                itemBuilder: (context, index) {
                  final contato = contatos[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      title: Text(contato.nome, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contato.telefone, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                          if (contato.email != null) Text(contato.email!, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blueGrey),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditContactScreen(contato: contato)),
                              );
                              _loadContatos(); // Atualiza a lista após editar
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(contato.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
