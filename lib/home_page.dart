import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_app_sqlite/model/person.dart';
import 'package:flutter_crud_app_sqlite/model/person_db.dart';
import 'package:flutter_crud_app_sqlite/screens/person_data_input.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PersonDB _crudStorage;
  @override
  void initState() {
    _crudStorage = PersonDB(dbName: 'db.sqlite');
    _crudStorage.open();
    super.initState();
  }

  @override
  void dispose() {
    _crudStorage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Flutter Sqlite CRUD Example"),
      ),
      body: StreamBuilder(
        stream: _crudStorage.allPerson(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final people = snapshot.data as List<Person>;
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    PersonDataInput(
                      onCompose: (firstName, lastName) async {
                        await _crudStorage.create(firstName, lastName);
                      },
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                          itemCount: people.length,
                          itemBuilder: (context, index) {
                            final person = people[index];
                            return Card(
                              child: ListTile(
                                onTap: () async {
                                  final updatePerson =
                                      await showUpdateDialog(context, person);
                                  if (updatePerson != null) {
                                    await _crudStorage.update(updatePerson);
                                  }
                                },
                                leading: Text(
                                  "${person.id.toString()}.",
                                  style: const TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                title: Text(person.firstName),
                                subtitle: Text(person.lastName),
                                trailing: InkWell(
                                  onTap: () async {
                                    final shouldDelete =
                                        await showDeleteDialog(context);
                                    log('result: $shouldDelete');
                                    if (shouldDelete) {
                                      await _crudStorage.delete(person);
                                    }
                                  },
                                  child: const Icon(Icons.delete),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            default:
              return const Center(
                child: CircularProgressIndicator(),
              );
          }
        },
      ),
    );
  }
}

final _firstNameController = TextEditingController();
final _lastNameController = TextEditingController();

Future<Person?> showUpdateDialog(BuildContext context, Person person) {
  _firstNameController.text = person.firstName;
  _lastNameController.text = person.lastName;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Enter Your Update Value here'),
            const SizedBox(height: 10),
            TextField(controller: _firstNameController),
            const SizedBox(height: 12),
            TextField(controller: _lastNameController),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final editPerson = Person(
                id: person.id,
                firstName: _firstNameController.text,
                lastName: _lastNameController.text,
              );
              Navigator.of(context).pop(editPerson);
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  ).then((value) {
    if (value is Person) {
      return value;
    } else {
      return null;
    }
  });
}

Future<bool> showDeleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        content: const Text(
          'Are you sure you want to delete this item.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CupertinoDialogAction(
            child: const Text("Delete"),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      );
    },
  ).then((value) {
    if (value is bool) {
      return value;
    } else {
      return false;
    }
  });
}
