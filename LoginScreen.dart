import 'package:flutter/material.dart';
import 'MenuScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _PrincipalState createState() => _PrincipalState();
}

class _PrincipalState extends State<LoginScreen> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Login de Usuário'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.account_box, size: 120.0, color: Colors.indigo.shade100),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Login'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 23,
                    ),
                    backgroundColor: Colors.indigo.shade100,
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    minimumSize: Size(180, 50)),
                child: Text('Entrar'),
                onPressed: () {

                  Navigator.push( // Navega para a Tela2
                    context,
                    MaterialPageRoute(builder: (context) => const MenuScreen()),
                  );
                } ),


          ],

        ),
      ),
    );
  }
}
