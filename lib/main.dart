import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

void main() {
  runApp(MaterialApp(
      home : MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
       var contacts = await ContactsService.getContacts();
       setState(() {
         person = contacts;
       });
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
    }
  }

  @override
  void initState() {
    super.initState();
  }
  var person = [];
  var like = [0,0,0];

  addOne(givenName, familyName) async{
      var newPerson = Contact();
      newPerson.givenName = givenName;
      newPerson.familyName = familyName;
      await ContactsService.addContact(newPerson);
      getPermission();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            showDialog(context: context,
                builder: (context) {
                return DialogUI(addOne : addOne);
                },
              );
          },
        ),
        appBar: AppBar(title: Text(person.length.toString()),actions: [
          IconButton(onPressed: (){getPermission();}, icon: Icon(Icons.contact_page))
        ],),
        body: ListView.builder(
          itemCount: person.length,
          itemBuilder: (context,i){
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(person[i].displayName ?? '이름없는 놈'),
            );
          },
        ),
      );
  }
}


class DialogUI extends StatelessWidget {
 DialogUI({Key? key, this.addOne}) : super(key: key);
final addOne;
var inputGivenN = TextEditingController();
var inputFamilyN = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 300, height: 300,
        child: Column(
          children: [
            tfStyle(inputData: inputGivenN , hint: "GivenName"),
            tfStyle(inputData: inputFamilyN, hint: "FammilyName"),
            TextButton(onPressed:(){
              addOne(inputGivenN.text , inputFamilyN.text);
              Navigator.pop(context);
            }, child: Text('완료'),),
            TextButton(onPressed:(){Navigator.pop(context);},
                child: Text('Cancel'))
          ],
        ),
      ),
    );
  }
}

class tfStyle extends StatelessWidget {
  const tfStyle({Key? key, this.inputData, this.hint}) : super(key: key);
final inputData;
final hint;
  @override
  Widget build(BuildContext context) {
    return TextField(controller: inputData,

      decoration: InputDecoration(
          icon: Icon(Icons.star),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.amber,width: 3.0,
              )
          ),
        hintText: hint
      ),

    );
  }
}

