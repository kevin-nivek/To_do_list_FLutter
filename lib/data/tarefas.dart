class Item{
  String nome;
  bool done;
  int indice;

  Item({this.nome , this.done,this.indice});

  Item.fromJson(Map<String , dynamic> json){
    nome = json['nome'];
    done = json['done'];
    indice = json['indice'];
  }
  Map<String , dynamic> toJson()
  {
    final Map<String, dynamic> data = new Map<String , dynamic>();

    data['nome'] = this.nome;
    data['done'] = this.done;
    data['indice'] = this.indice;
    return data;
  }

}

