// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

typedef OnCompose = void Function(String firstName, String lastName);

class PersonDataInput extends StatefulWidget {
  final OnCompose onCompose;
  const PersonDataInput({
    Key? key,
    required this.onCompose,
  }) : super(key: key);

  @override
  State<PersonDataInput> createState() => _PersonDataInputState();
}

class _PersonDataInputState extends State<PersonDataInput> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  @override
  void initState() {
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _firstNameController,
          decoration: const InputDecoration(
            hintText: 'Enter First Name',
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Enter Last Name',
            enabledBorder: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
          ),
          controller: _lastNameController,
        ),
        const SizedBox(height: 12),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextButton(
              onPressed: () {
                final firstName = _firstNameController.text;
                final lastName = _lastNameController.text;
                widget.onCompose(firstName, lastName);
                _firstNameController.clear();
                _lastNameController.clear();
                // _firstNameController.text = '';
              },
              child: const Text(
                "Add to List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
