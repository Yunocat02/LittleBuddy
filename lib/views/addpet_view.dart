import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/back_button.dart';

class AddPet extends StatefulWidget {
  const AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
}

class _AddPetState extends State<AddPet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มสัตว์เลี้ยงของคุณ")),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "ชื่อสัตว์", hintText: "ตัวอย่าง : แจ้"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ชื่อสัตว์';
                  }
                  return null;
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "อายุ (ปี)", hintText: "ตัวอย่าง : 2"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่อายุ (ปี)';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                          labelText: "อายุ (เดือน)", hintText: "ตัวอย่าง : 3"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดอายุ (เดือน)';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "ประเภท", hintText: "ตัวอย่าง : สุนัข"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่ประเภท';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                    labelText: "พันธุ์", hintText: "ตัวอย่าง : Corki"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดใส่พันธุ์';
                  }
                  return null;
                },
              ),
            ),
            Stack(
              children: [
                Positioned(
                  left: 15,
                  top: 50,
                  child: PetBackButton(),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Add your onPressed logic here
                    }
                  },
                  child: const Text('submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
