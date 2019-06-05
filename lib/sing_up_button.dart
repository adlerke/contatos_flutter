import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.only(
          top: 160
      ),
      onPressed: (){
        launch('https://github.com/adlerke/contatos_flutter');

      },
      child: Text(
        "Clique aqui para ter acesso ao código-fonte",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(

            fontWeight: FontWeight.w300,
            color: Colors.white,
            fontSize: 17,
            letterSpacing: 0.5
        ),
      ),
    );
  }
}
