//import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ListaTrasferencias(),
      ),
    );
  }
}

class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controladorCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controladorCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criando transferencia'),
      ),
      body: Column(
        children: <Widget>[
          Editor(
            controlador: _controladorCampoNumeroConta,
            dica: '0000',
            rotulo: 'Numero da conta',
          ),
          Editor(
            controlador: _controladorCampoValor,
            dica: '00.0',
            rotulo: 'Valor',
            icone: Icons.monetization_on,
          ),
          RaisedButton(
            child: Text('Confirmar'),
            onPressed: () {
              _criarTransferencia(context);
            },
          )
        ],
      ),
    );
  }

  void _criarTransferencia(BuildContext context) {
    final int numeroConta =
        int.tryParse(_controladorCampoNumeroConta.text);
    final double valor = double.tryParse(_controladorCampoValor.text);
    if (numeroConta != null && valor != null) {
      final transferenciaCriada = Transferencia(valor, numeroConta);
      Navigator.pop(context, transferenciaCriada);
    }
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('valor de $valor'),
      backgroundColor: Colors.pinkAccent,
      action: SnackBarAction(
        label: 'Ver',
        onPressed: () {},
      ),
    ));
  }
}

class Editor extends StatelessWidget {

  final TextEditingController controlador;
  final String rotulo;
  final String dica;
  final IconData icone;

  Editor({this.controlador, this.rotulo, this.dica, this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: controlador,
        style: TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
            icon: icone != null ? Icon(icone) : null,
            labelText: rotulo,
            hintText: dica
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}

class ListaTrasferencias extends StatelessWidget {

  final List<Transferencia> _transferencias = List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        title: Text('Transferências'),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            print('menu-button');
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('search-button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              print('filter-button');
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlueAccent,
              ),
              child: Text(
                'Header',
                style: TextStyle(
                  color: Colors.black87,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Mensagens'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Perfil'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Configurações'),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = _transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.pinkAccent,
        onPressed: () {
          final Future<Transferencia> future = Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FormularioTransferencia();
          }));
          future.then((transferenciaRecebida) {
          _transferencias.add(transferenciaRecebida);
          });
        },
      ),
    );
  }
}

Route _criarRota() {
  return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          FormularioTransferencia(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      });
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.monetization_on,
          color: Colors.amber,
        ),
        title: Text('$_transferencia.valor.toString()'),
        subtitle: Text('$_transferencia.numeroConta.toString()'),
      ),
    );
  }
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);

  @override
  String toString() {
    return 'Valor: $valor, Agencia: $numeroConta}';
  }
}
