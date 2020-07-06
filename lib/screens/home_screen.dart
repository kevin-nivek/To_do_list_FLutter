import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/data/tarefas.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:todo/screens/itens_to_do.dart';

List tarefas;
List tarefasV;
var itens = new List<Item>();
int _selectedIndex = 0;

class MyHomePage extends StatefulWidget {
  MyHomePage() {
    tarefas = [];
    itens = [];

  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String observacao;
  int _counter = 0;

  void initState() {
    super.initState();
    setState(() {
      loadItens();
    });
    readTitulo().then((data) {
      setState(() {
        tarefas = json.decode(data);
      });
    });
  }

  //CARREGA OS ITENS DA LISTA ITENS
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

  //SALVA OS ITENS DA LISTA ITENS
  saveItens() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(itens));
  }

  //CRIA NOVA TAREFA
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //Tarefas Ja  Concluidas
      if (_selectedIndex == 0) {
        //Abrir uma nova pagiana
      }

      //ADICIONA NOVA TAREFA
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

                  //BOTAO DE CRIAR NOVA TAREFA
                  new FlatButton(
                    child: new Text("Criar"),
                    onPressed: () {
                      if (observacao.isNotEmpty) {
                        setState(() {
                          tarefas.add(observacao);
                          saveData();
                        });
                      }
                      setState(() {});
                      //print("OBS: $observacao    \n count: $_counter");
                      observacao = '';
                      observacao = null;
                      Navigator.of(context).pop();
                    },
                  ),

                  //BOTAO DE CANCELAR
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
        print("Titulo: ${tarefas[i]}");
        //print("Items: ${itens[i].nome}");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,

      //APP BAR
      appBar: AppBar(
        title: Text("TO DO List"),
        centerTitle: true,
//        actions: <Widget>[
//
//          //Botao de Configurações de layout
//          IconButton(icon: Icon(Icons.account_circle), onPressed: () {
//            setState(() {
////
//            });
//          }),
//        ],
      ),

      //Corpo - Body
      body: Column(
        children: <Widget>[
          //Problemas
//          Container(
//              height: 200,
//              color: Colors.white,
//              child: Text(
//                  "\n PROBLEMAS : \n"
//                      "\n  1-Fazer Telas que faltam"
//                      "\n  2-  "
//                      "\n  3- Criar filtro para os itens.done se forem igual a true nao aparecer na lista de itens  "
//
//
//              ),
//          ),

          tarefas.length > 0
              ?
              //Lista
              Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 5),
                    itemCount: tarefas.length,
                    itemBuilder: buildList,
                  ),
                )

              //Caso nao tenha nenhum item

              : Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                      child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(100),
                    child: Text(
                      "Nenhuma Tarefa Criada",
                      style: TextStyle(fontSize: 22),
                    ),
                  )),
                )
        ],
      ),

      //Bottombar
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.6,

        backgroundColor: Color(0xFFe3e7ed),
        //Color(0xFFeceff3),//Color(0xFFd3d9e3),//Color(0xFFf8faf8).withOpacity(1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title: Text(
              '',
            ),
            icon: Icon(null),
          ),
          BottomNavigationBarItem(
            title: Text("Nova"),
            icon: Icon(Icons.add, color: Colors.green),
          ),
          BottomNavigationBarItem(
            title: Text(
              '',
            ),
            icon: Icon(null),
          ),
        ],
        currentIndex: 1,

        fixedColor: Colors.black54,

        onTap: _onItemTapped,
      ),
    );
  }

//Funções

  //Cria Lista de tarefas

  Widget buildList(context, index) {
    int Tdones = 0;
    int i = index;
    double porcentagem;
    int qtdtarefas = 0;

    //PORCENTAGEM
    for (int j = 0; j < itens.length; j++) {
      if (itens[j].indice == i) {
        qtdtarefas++;
        if (itens[j].done) {
          Tdones++;
        }
      }
    }
    porcentagem = Tdones != 0 ? (Tdones) / (qtdtarefas) : 0;
    print("Tarefas ok  ${Tdones}");

    return Dismissible(
      //AO ARRASTAR
      onDismissed: (direction) {
        setState(() {
          String lastRemove = tarefas[index];
          int _lastRemovedpos = index;
          List excluir = [];
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:
                      new Text(" Deseja Remover Tarefa \'${tarefas[index]}\'"),

                  //  Text("Descrição atual:${item.descricaohab}"),

                  actions: <Widget>[
                    //Botao de Excluir
                    new FlatButton(
                      child: new Text("Excluir"),
                      onPressed: () {
                        print("INDEX : ${index}");

                        for (int j = 0; j < itens.length; j++) {
                          print(
                              "J[${j}]   Item: ${itens[j].nome}      Indice: ${itens[j].indice}");
                          if (index == itens[j].indice) {
                            print(
                                " Item REMOVIDO : ${itens[j].nome}    INDICE: ${itens[j].indice} ");
                            excluir.add(j);
                          }
                          if (index < itens[j].indice) {
                            print("-------------");
                          }
                        }

                        for (int i = excluir.length - 1; i >= 0; i--) {
                          print("INDEX === ${index}");
                          print(
                              " Item REMOVIDO : ${itens[excluir[i]].nome}    INDICE: ${itens[excluir[i]].indice} ");
                          itens.removeAt(excluir[i]);
                        }
                        excluir = [];
                        for (int i = 0; i < itens.length; i++) {
                          if (itens[i].indice > index) {
                            print("INDEX === ${index}");
                            print(
                                " Item REDUZIDO : ${itens[i].nome}    INDICE: ${itens[i].indice} -> INDICE: ${itens[i].indice - 1} ");
                            itens[i].indice--;
                          }
                        }
                        print("Tarefa REMOVIDO : ${tarefas[index]}");
                        tarefas.removeAt(index);

                        //Navigator.of(context).pop();
                        saveItens();
                        saveData();
                        loadItens();
                        readTitulo();

                        Navigator.of(context).pop();
                      },
                    ),
                    new FlatButton(
                      child: new Text("Cancelar"),
                      onPressed: () {
                        // newdecritem = null;
                        setState(() {});
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        });
      },
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

      //TITULO DA TAREFA E ACESSO A TAREFA
      child: Card(
        elevation: 0.4,
        color: Colors.white70,
        child: ListTile(
          //PORCENTAGEM
          leading: CircularPercentIndicator(
            radius: 50,
            lineWidth: 3,
            backgroundColor: Colors.black,
            animation: true,
            percent: (porcentagem),
            center: new Text(
              "${(porcentagem * 100).toStringAsFixed(2)}%",
              style: TextStyle(fontSize: 10),
            ),
            progressColor: Colors.blue,
          ),

          //TITULO
          title: Text(
            tarefas[index],
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),

          //ICONE SETA
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TarefasItens(tarefas[index], index)));
          },
        ),
      ),
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
    );
  }

  //Pega o endereço do arquivo
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    print("DIRETORIO: ${directory.path}");
    return File("${directory.path}/todolists.json");
  }

  //Salva no arquivo
  Future<File> saveData() async {
    String data = json.encode(tarefas);
    final file = await _getFile();
    print("File Save: ${file}");
    return file.writeAsString(data);
  }

  //LE o arquivo
  Future<String> readTitulo() async {
    try {
      final file = await _getFile();
      print("File: ${file.readAsString()}");
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
