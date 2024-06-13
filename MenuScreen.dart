import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'DatabaseHelper.dart';
import 'task_model.dart';

void main() {
  runApp(MenuScreen());
}



class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Menu',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = CardScreen();
        break;
      case 2:
        page = TaskListScreen();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
        builder: (context, constraints) {
          return Scaffold(

            body: Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    backgroundColor: Colors.indigo.shade100,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.restaurant_menu),
                        label: Text('Cardápio'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.list),
                        label: Text('Pedidos'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(

                  child: Container(

                    child: page,  // ← Here.
                  ),
                ),
              ],
            ),
          );
        }
    );
  }
}

class GeneratorPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}",
        ),      ),
    );
  }
}
class CardScreen extends StatefulWidget{
  @override
  _CardScreenState createState() => _CardScreenState();
}
class _CardScreenState extends State<CardScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img2.png'),
              fit: BoxFit.cover,
            )
        ),
        child: Center(
        ),
      ),
    );
  }
}

class TaskListScreen extends StatefulWidget {
  // Classe TaskListScreen que herda de StatefulWidget
  @override
  _TaskListScreenState createState() =>
      _TaskListScreenState(); // Cria uma instância do estado para TaskListScreen
}

class _TaskListScreenState extends State<TaskListScreen> {
  // Classe privada que gerencia o estado da tela TaskListScreen
  final dbHelper =
      DatabaseHelper.instance; // Instância do helper do banco de dados
  final TextEditingController nameController =
  TextEditingController(); // Controlador para o campo de título
  final TextEditingController functionController =
  TextEditingController(); // Controlador para o campo de descrição

  @override
  Widget build(BuildContext context) {
    // Método build que retorna o widget da tela TaskListScreen
    return Scaffold(
      // Scaffold: Widget responsável por criar um layout "padrão" para a tela
      appBar: AppBar(
        // AppBar: Barra localizada na parte superior da tela
        title: Text('Faça seu Pedido'),
      ),
      body: FutureBuilder<List<Tarefa>>(

        // FutureBuilder: Widget que constrói um widget baseado em um Future
        future: dbHelper
            .fetchTasks(), // Future que busca as tarefas do banco de dados
        builder: (context, snapshot) {
          // Construtor do widget baseado no Future
          if (!snapshot.hasData) {
            // Verifica se os dados ainda não foram carregados
            return Center(
                child:
                CircularProgressIndicator());
            // Mostra um indicador de progresso
          }



          return ListView.builder(
            /* ListView.builder: Widget que constrói uma lista de itens de
            acordo com os dados*/
            itemCount: snapshot.data!.length, // Número total de itens na lista
            itemBuilder: (context, index) {
              // Construtor de itens da lista
              return ListTile(
                // ListTile: Widget que define um item de lista
                title: Text(snapshot.data![index].titulo), // Título do item
                subtitle:
                Text(snapshot.data![index].descricao), // Descrição do item
                trailing: IconButton(
                  // Botão de ação à direita do item
                  icon: Icon(Icons.delete), // Ícone do botão
                  onPressed: () {
                    // Ação ao pressionar o botão
                    dbHelper.deleteTask(snapshot.data![index]
                        .id!); // Deleta a tarefa selecionada do banco de dados
                    setState(() {}); // Atualiza a interface
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        // FloatingActionButton: Botão flutuante na parte inferior da tela
        child: Icon(Icons.add), // Ícone do botão
        onPressed: () => _showTaskDialog(), // Ação ao pressionar o botão
      ),
    );
  }

  _showTaskDialog() async {
    // Método assíncrono para mostrar o diálogo de adição de tarefa
    await showDialog(
      // showDialog: Função que exibe um diálogo
      context: context, // Contexto do aplicativo
      builder: (context) => AlertDialog(
        // AlertDialog: Diálogo de alerta
        title: Text('Registrar Pedido'), // Título do diálogo
        content: Column(
          // Conteúdo do diálogo
          mainAxisSize: MainAxisSize.min, // Tamanho mínimo do conteúdo
          children: [
            TextField(
              // Campo de texto para o título da tarefa
              controller: nameController, // Controlador do campo de texto
              decoration: InputDecoration(
                  labelText: 'Nome do Cliente'), // Decoração do campo de texto
            ),
            TextField(
              // Campo de texto para a descrição da tarefa
              controller:
              functionController, // Controlador do campo de texto
              decoration: InputDecoration(
                  labelText: 'Item Pedido'), // Decoração do campo de texto
            ),
          ],
        ),
        actions: [
          // Ações do diálogo
          TextButton(
            // Botão de cancelar
            child: Text('Cancelar'), // Texto do botão
            onPressed: () =>
                Navigator.pop(context), // Ação ao pressionar o botão
          ),
          TextButton(
            // Botão de salvar
            child: Text('Salvar'), // Texto do botão
            onPressed: () {
              // Ação ao pressionar o botão
              final tarefa = Tarefa(
                // Cria uma nova tarefa com os dados inseridos
                titulo: nameController.text, // Título da tarefa
                descricao: functionController.text, // Descrição da tarefa
              );
              dbHelper
                  .insertTask(tarefa); // Insere a nova tarefa no banco de dados
              setState(() {}); // Atualiza a interface
              Navigator.pop(context); // Fecha o diálogo
            },
          ),
        ],
      ),
    );
  }
}
