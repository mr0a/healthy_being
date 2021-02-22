import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helpers/data_pass_controller.dart';
import '../Login/login_screen.dart';
import '../../components/data_display.dart';
import '../../helpers/live_update.dart';
import '../../widgets/animated_toggle.dart';
import '../../constant.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

final FlutterSecureStorage storage = FlutterSecureStorage();

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _changeLiveStatus(BuildContext context) {
    Provider.of<LiveUpdate>(context, listen: false).changeLiveStatus();
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      storage.deleteAll().then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
        return MyController.showError(context, 'Logged out successfully!');
      });
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = [
    DataDashboard(),
    FileUpload(),
    Center(
      child: CircularProgressIndicator(),
    )
  ];

  void _addDataManually() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return DataEntryCard();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload_file),
            label: 'Upload Data',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addDataManually,
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: kPrimaryColor.withOpacity(.03),
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/menu.svg'),
        onPressed: () {},
      ),
      actions: [
        Center(
          child: Row(
            children: [
              Text(
                'Live Update',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AnimatedLiveTracker(_changeLiveStatus),
            ],
          ),
        )
      ],
    );
  }
}

class DataEntryCard extends StatefulWidget {
  const DataEntryCard({
    Key key,
  }) : super(key: key);

  @override
  _DataEntryCardState createState() => _DataEntryCardState();
}

class _DataEntryCardState extends State<DataEntryCard> {
  int _value = 1;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              DropdownButtonFormField(
                  value: _value,
                  items: [
                    DropdownMenuItem(
                      child: Text(
                        "Blood Pressure",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "Blood Sugar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "Body Temperature",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: 3,
                    ),
                    DropdownMenuItem(
                      child: Text(
                        "Respiration Rate",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: 4,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _value = value;
                    });
                  }),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Data Value'),
                // controller: titleController,
                // onSubmitted: (_) => submitData(),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Add Data'),
                style: TextButton.styleFrom(
                  primary: Colors.teal,
                  textStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataDashboard extends StatelessWidget {
  const DataDashboard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
      width: double.infinity,
      decoration: BoxDecoration(
          color: kPrimaryColor.withOpacity(0.05),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )),
      child: DataDisplay(),
    );
  }
}

class FileUpload extends StatefulWidget {
  @override
  _FileUploadState createState() => _FileUploadState();
}

void _fileUpload() async {
  FilePickerResult result = await FilePicker.platform.pickFiles();

  if (result != null) {
    File file = File(result.files.single.path);
    print(file);
  } else {
    // User canceled the picker
  }
}

class _FileUploadState extends State<FileUpload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FloatingActionButton(
          onPressed: _fileUpload,
          child: Icon(Icons.upload_file),
        ),
      ),
    );
  }
}
