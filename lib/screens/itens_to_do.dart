import 'dart:convert';


import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/tarefas.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/itens_concluidos.dart';

int _selectedIndex = 0;

class TarefasItens extends StatefulWidget {
  final String tarefa;
  final int indicieT;

  TarefasItens(this.tarefa, this.indicieT);

  @override
  _TarefasItensState createState() => _TarefasItensState();
}

class _TarefasItensState extends State<TarefasItens> {
  String observacao;
  Item _lastRemove;
  int _lastRemovedpos;

  Future loadItens() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        itens = result;
      });
    }
  }

  saveItens() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(itens));
  }

  _TarefasItensState() {
    loadItens();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {

        Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) =>
                TarefasItensF(tarefas[widget.indicieT], widget.indicieT)));
      }
      if (_selectedIndex == 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(" Nova Tarefa"),
                content:
                    //  Text("Descrição atual:${item.descricaohab}"),
                    TextFormField(
                  //controller: newtexto,
                  maxLines: 1,
                  decoration: InputDecoration(
                      //  labelText: 'Descrição: ',
                      // hintText: 'Descrição',
                      ),

                  onChanged: (value) {

                    observacao = (value);
                  },
                ),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Criar"),

                    onPressed: () {
                      observacao != null ?
                      setState(() {
                        itens.add(Item(
                            nome: observacao,
                            done: false,
                            indice: widget.indicieT));
                        saveItens();
                      })
                      :print("OBS: $observacao");
                        observacao ='';
                        observacao=null;
                      Navigator.of(context).pop();
                    }
                  ),
                  new FlatButton(
                    child: new Text("Cancelar"),
                    onPressed: () {
                      // newdecritem = null;
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }

      for (int i = 0; i < tarefas.length; i++) {
        //print("Titulo: ${tarefas[i].titulo}");
        print("Items: ${itens[i].nome}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.tarefa),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setState(() {
                loadItens();
                  // pop
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => new MyHomePage()));
              });

            },
          ),
        ),

        //CORPO - Body
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    itemCount: itens.length, itemBuilder: buildListR))
          ],
        ),

        //BOTTOM BAR
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0.6,

          backgroundColor: Color(0xFFe3e7ed),
          //Color(0xFFeceff3),//Color(0xFFd3d9e3),//Color(0xFFf8faf8).withOpacity(1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              title: Text(
                "Concluidos",
              ),
              icon: Icon(Icons.check_circle, color: Colors.green),
            ),
            BottomNavigationBarItem(
              title: Text("Nova"),
              icon: Icon(Icons.add, color: Colors.green),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedIconTheme: null,
          fixedColor: Colors.black54,
          selectedLabelStyle: null,
          onTap: _onItemTapped,
        ),
      ),
      onWillPop: (){
      setState(() {
        loadItens();

        Navigator.pushReplacement( context,

            MaterialPageRoute(builder: (context) =>new MyHomePage()));

      });

      },
    );
  }


  //CRIA LISTA
  Widget buildListR(context, index) {
    return itens[index].indice == widget.indicieT
        ?
         itens[index].done !=true ?
        Dismissible(
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment(-0.9, 0.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: Card(
              child: CheckboxListTile(
                title: Text(itens[index].nome),
                value: itens[index].done,
                secondary: CircleAvatar(
                  child: Icon(itens[index].done ? Icons.check : Icons.error),
                ),
                onChanged: (c) {
                  setState(() {
                    itens[index].done = c;
                    saveItens();
                  });
                },
              ),
            ),
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            onDismissed: (direction) {
              setState(() {
                _lastRemove = itens[index];
                _lastRemovedpos = index;
                itens.removeAt(index);
                saveItens();
                final snack = SnackBar(
                  content: Text("Tarefa \" ${_lastRemove.nome} \" removida!"),
                  action: SnackBarAction(
                      label: "Desfazer",
                      onPressed: () {
                        setState(() {
                          itens.insert(_lastRemovedpos, _lastRemove);
                          saveItens();
                        });
                      }),
                  duration: Duration(seconds: 3),
                );
                Scaffold.of(context)
                    .removeCurrentSnackBar(); // ADICIONE ESTE COMANDO
                Scaffold.of(context).showSnackBar(snack);
              });
            },
          )
         :Container()
        : Container();
  }
}
