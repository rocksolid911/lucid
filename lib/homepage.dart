import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucid/luciddatabase.dart';
import 'package:lucid/model.dart';

var country = ['India', 'Nepal', 'US'];

class MyCustomForm extends StatefulWidget {
  final LucidForm? lucidForm;
  const MyCustomForm({Key? key, this.lucidForm}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  TextEditingController distributionDateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? imageFile;
  String? countryvalue;
  String genderItem = '';
  late String name;
  late int mark;
  late String dob;
  late String nation;
  late String gender;

  late String _base64image;
  late DateTime _date = DateTime.now();
  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void initState() {
    name = widget.lucidForm?.name ?? '';
    mark = widget.lucidForm?.mark ?? '' as int;
    dob = widget.lucidForm?.dob ?? '';
    nation = widget.lucidForm?.nation ?? '';
    gender = widget.lucidForm?.nation ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("lucid demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // labelText: 'Full Name',
                    hintText: 'Name',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.none,
                  controller: distributionDateController,
                  onTap: _handerlDatePicker,
                  // validator: validateEmail(TexEd),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.blue,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // labelText: 'Full Name',
                    hintText: 'Enter Date ',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter Date ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    // labelText: 'Full Name',
                    hintText: 'Mark',
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                    focusColor: Colors.white,
                    hint: const Text("Select Country"),
                    isExpanded: true,
                    icon: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.arrow_drop_down, color: Colors.blue)),
                    items: country.map((String dropDownStringItem) {
                      return DropdownMenuItem<String>(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    value: countryvalue,
                    onChanged: (valueSelected) {
                      setState(
                        () {
                          countryvalue = valueSelected as String?;

                          debugPrint('User selected $countryvalue');
                        },
                      );
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Select Your Country';
                      }

                      return null;
                    },
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RadioListTile(
                      groupValue: genderItem,
                      title: const Text('Male'),
                      value: 'Male',
                      onChanged: (val) {
                        setState(() {
                          genderItem = val as String;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile(
                      groupValue: genderItem,
                      title: const Text('Female'),
                      value: 'Female',
                      onChanged: (val) {
                        setState(() {
                          genderItem = val as String;
                        });
                      },
                    ),
                  ),
                ],
              ),
              InkWell(
                child: imageFile != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        color: Colors.black12,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(
                            imageFile!,
                            width: 180,
                            height: 150,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.only(left: 20, right: 40),
                        color: Colors.black12,
                        height: 180,
                        width: 200,
                        child: const Icon(
                          Icons.image,
                          size: 40,
                        ),
                        // width: 3.w,
                      ),
                onTap: () {
                  _showPicker(context);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false otherwise.
                  if (_formKey.currentState!.validate()) {
                    // If the form is valid, display a snackbar. In the real world,
                    // you'd often call a server or save the information in a database.
                    addOrUpdateForm;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addOrUpdateForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.lucidForm != null;

      if (isUpdating) {
        await updateForm();
      } else {
        await addForm();
      }

      Navigator.of(context).pop();
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _getFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _getFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  _getFromGallery() async {
    var pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        _base64image = base64Encode(imageFile!.readAsBytesSync());
        String fileName = imageFile!.path.split("/").last;
        print(fileName);
      });
    }
  }

  _getFromCamera() async {
    try {
      var pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 25,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          _base64image = base64Encode(imageFile!.readAsBytesSync());
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  _handerlDatePicker() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _date) {
      setState(() {
        _date = date;
      });
      distributionDateController.text = dateFormat.format(date);
    }
  }

  Future updateForm() async {
    final lucidForm = widget.lucidForm!.copy(
      name: name,
      mark: mark,
      img: _base64image,
      gender: gender,
      dob: dob,
      nation: nation,
    );
    await FormDatabase.instance.update(lucidForm);
  }

  Future addForm() async {
    final lucidForm = LucidForm(
        name: name,
        mark: mark,
        img: _base64image,
        gender: gender,
        dob: dob,
        nation: nation,
    );
    await FormDatabase.instance.create(lucidForm);
  }
}
