import 'package:bloc_flutterando/bloc/search_cep_bloc.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();

  final searchCepBloc = SearchCepBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Cep'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                //*Repare no .add é o sink !
                searchCepBloc.searchCep.add(textController.text);
              },
              child: const Text('Pesquisar'),
            ),
            const SizedBox(
              height: 20,
            ),
            //! =================================================================\\
            //* Somente essa parte desse código esta sendo feita gerencia de estado
            //* ou seja o rebuild só vai atuar aqui, ou atualizar somente aqui !
            StreamBuilder<Map<dynamic, dynamic>>(
                stream: searchCepBloc.cepResult,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text(
                      '${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    );
                  } else if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Column(
                    children: [
                      Text(
                          ('Rua -> ${snapshot.data!['logradouro'] ?? 'Não encontrado'}')),
                      Text(
                          ('Complemento -> ${snapshot.data!['complemento'] ?? 'Não encontrado'}')),
                      Text(
                          ('Bairro -> ${snapshot.data!['bairro'] ?? 'Não encontrado'}')),
                      Text(
                          ('Cidade -> ${snapshot.data!['localidade'] ?? 'Não encontrado'}')),
                      Text(
                          ('UF -> ${snapshot.data!['uf'] ?? 'Não encontrado'}')),
                      Text(
                          ('IBGE -> ${snapshot.data!['ibge'] ?? 'Não encontrado'}')),
                      Text(
                          ('GIA -> ${snapshot.data!['gia'] ?? 'Não encontrado'}')),
                      Text(
                          ('DDD -> ${snapshot.data!['ddd'] ?? 'Não encontrado'}')),
                      Text(
                          ('SIAFI -> ${snapshot.data!['siafi'] ?? 'Não encontrado'}')),
                    ],
                  );
                })
            //! =================================================================\\
          ],
        ),
      ),
    );
  }
}
