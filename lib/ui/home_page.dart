import 'dart:io';

import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:agenda_contatos/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/animation.dart';

//import 'package:agenda_contatos/animated_button.dart';
import 'package:agenda_contatos/stagger_animation.dart';

enum OrderOptions { orderaz, orderza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();


    _getAllContacts();
  }



  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

//
//  @override
//  void initState() {
//    super.initState();
//
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de A-Z"),
                    value: OrderOptions.orderaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text("Ordenar de Z-A"),
                    value: OrderOptions.orderza,
                  ),
                ],
            onSelected: _orderList,
          )
        ],
      ),

      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _showContactPage();
        },
        child: Icon(Icons.add_circle_outline),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return _contactCard(context, index);
            }),

    );

//        });
  }

  Widget _dialogBuilder(BuildContext context, Contact contatos) {
    ThemeData localTheme = Theme.of(context);

    return SimpleDialog(
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
            width: 300.0,
            height: 300.0,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  image: contatos.img != null
                      ? FileImage(File(contatos.img))
                      : AssetImage("images/person.png"),
                  fit: BoxFit.fill),
            )),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                contatos.name,
                style: localTheme.textTheme.display2,
              ),
              Text(
                "Email : " + contatos.email,
                style: localTheme.textTheme.body1,
              ),
              Text(
                "Telefone : " + contatos.phone,
                style: localTheme.textTheme.body1,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Wrap(
                  children: [
                    FlatButton(
                      onPressed: () {
                        launch("sms:${contatos.phone}");
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Enviar SMS',
                        textDirection: TextDirection.ltr,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                    ),
                    RaisedButton(
                      color: Color.fromRGBO(196, 111, 111, 1),
                      onPressed: () {
                        launch("tel:${contatos.phone}");
                        Navigator.pop(context);
                      },
                      child: const Text('Ligar',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => showDialog(
          context: context,
          builder: (context) => _dialogBuilder(context, contacts[index])),
      child: Card(
        color: Color.fromRGBO(216, 203, 205, 1.0),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null
                          ? FileImage(File(contacts[index].img))
                          : AssetImage("images/person.png"),
                      fit: BoxFit.cover),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      contacts[index].name ?? "",
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onLongPress: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style:
                              TextStyle(color: Colors.black87, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showContactPage(contact: contacts[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          helper.deleteContact(contacts[index].id);
                          setState(() {
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

//// user defined function
//void _showDialog(Contact contato) {
//  // flutter defined function
//  showDialog(
//      context: context,
//      builder: (BuildContext context) {
//    // return object of type Dialog
////    return AlertDialog(
////
//        return SimpleDialog(
//          children: <Widget>[
//
//        Image.network(contato.img,
//          fit : BoxFit.fill,
////        title: new Text('${contato.name} '),
////        content: new Text('${contato.email} ${contato.phone}'),
////        actions: <Widget>[
////    // usually buttons at the bottom of the dialog
////    new FlatButton(
////    child: new Text("OK"),
////  onPressed: () {
////  Navigator.of(context).pop();
////  },
////    ),
////        ],
//     ),
//          ],
//        );
//    },
//  );
//}

  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ContactPage(
                  contact: contact,
                )));
    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }
}
