import 'package:flutter/material.dart';
import 'package:sqlite/report_helper.dart';
import 'package:sqlite/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _journals = [];

  bool _isLoading = true;
  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _journals = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshJournals(); 
  }

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
          _journals.firstWhere((element) => element['id'] == id);
      _titleController.text = existingJournal['title'];
      _descriptionController.text = existingJournal['category'];
      _valueController.text = existingJournal['value'];
    }

    showModalBottomSheet(
        context: context,
        elevation: 5,
        isScrollControlled: true,
        builder: (_) => Container(
              padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery.of(context).viewInsets.bottom + 120,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(hintText: 'Title'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(hintText: 'Category'),
                  ),
                   const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _valueController,
                    decoration: const InputDecoration(hintText: 'Value'),
                  ),
                  
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (id == null) {
                        await _addItem();
                      }

                      if (id != null) {
                        await _updateItem(id);
                      }

                      _titleController.text = '';
                      _descriptionController.text = '';
                      _valueController.text = '';

                      if (!mounted) return;
                      Navigator.of(context).pop();
                    },
                    child: Text(id == null ? 'Create New' : 'Update'),
                  )
                ],
              ),
            ));
  }

  Future<void> _addItem() async {
    await SQLHelper.createItem(
        _titleController.text, _descriptionController.text, _valueController.text);
    _refreshJournals();
  }

  Future<void> _updateItem(int id) async {
    await SQLHelper.updateItem(
        id, _titleController.text, _descriptionController.text, _valueController.text);
    _refreshJournals();
  }

  void _deleteItem(int id) async {
    await SQLHelper.deleteItem(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Successfully deleted a journal!'),
    ));
    _refreshJournals();
  }
final TextEditingController _filterController = TextEditingController();

void _filterItems() async {
  final data = await SQLHelper.getItemsByCategory(_filterController.text);
  setState(() {
    _journals = data;
  });
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('CRUD App'),
      actions: [
        IconButton(
  onPressed: () async {
    await ReportHelper.exportToCSV(_journals);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Arquivo CSV salvo no diretório de documentos!'),
    ));
  },
  icon: Icon(Icons.download),
),

 


        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _showFilterForm(),
        ),
      ],
    ),
    body: _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: _journals.length,
            itemBuilder: (context, index) => Card(
              color: Colors.orange[200],
              margin: const EdgeInsets.all(15),
              child: ListTile(
                title: Text(_journals[index]['title']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_journals[index]['category']),
                    Text("R\$ ${_journals[index]['value']}"),
                  ],
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showForm(_journals[index]['id']),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Delete Confirmation'),
                                  content: const Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          _deleteItem(_journals[index]['id']);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Yes')),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Cancel'),
                                    )
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () => _showForm(null),
    ),

  );
}

void _showFilterForm() {
  showModalBottomSheet(
      context: context,
      builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _filterController,
                  decoration: const InputDecoration(hintText: 'Category'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    _filterItems();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Filter'),
                ),
              ],
            ),
          ));
}
}