import 'package:flutter/material.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    
    return MaterialApp(
  
      title: 'Notas Rápidas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 
class Nota {
  String titulo;
  String contenido;
 
  Nota({required this.titulo, required this.contenido});
}
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}
 
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int contador = 0;
  int notasNormales = 0;
  int notasImportantes = 0;

  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this );
    _tabController.addListener(_actualizarContador);
  }
  
  List<Nota> notas = [];
  List<Nota> importante =[];

  //Actualizar contador
    void _actualizarContador() {
    setState(() {}); 
  }
 
 @override
 void dispose() {
    _tabController.removeListener(_actualizarContador);
    _tabController.dispose();
    super.dispose();
  }

//Eliminar una nota por indice (posicion)
  void _eliminarNota(int index) {
    setState(() => notas.removeAt(index));
    
    notasNormales--;
  

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nota $index eliminada"))
    );
  }

    void _eliminarImportante(int index) {
    setState(() => importante.removeAt(index));

    notasImportantes--;
    

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nota $index eliminada"))
    );
  }
 //agregar una nueva nota
  void _agregarNota({String title = "Nueva nota", String content = "Contenido"}) {
    setState(
        () => notas.add(Nota(titulo: title, contenido: content)));
        notasNormales++;
    
  }

    void _agregarImportante({String title = "Nueva nota importante", String content = "Contenido"}) {
    setState(
        () => importante.add(Nota(titulo: title, contenido: content)));
        notasImportantes++;
    
  }

  //void _limpiarNotas()=> setState(()=> notas.clear());

  void _limpiarNotas(){
    setState(()=> notas.clear());
    

    notasNormales = 0;
    

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Todas las notas eliminadas"))
    );
  }

    void _limpiarNotasImportantes(){

    setState(()=> importante.clear());

  
    notasImportantes = 0;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Todas las notas eliminadas"))
    );
  }

    // Marca una nota a importantes
  void _marcarComoImportante(int index) {
    setState(() {
      final nota = notas.removeAt(index);
      importante.add(nota);
      notasNormales--;
      notasImportantes++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nota marcada como importante")),
    );
  }

  // Marca una nota a normales
  void _marcarComoNormal(int index) {
    setState(() {
      final nota = importante.removeAt(index);
      notas.add(nota);
      notasImportantes--;
      notasNormales++;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Nota marcada como normal")),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Row(
          children: [
            Text('Blog de Notas', style: TextStyle(color: Colors.white)),
            Padding(padding: EdgeInsets.all(10)),
             Text(
              _tabController.index == 0
                  ? "Notas normales: $notasNormales"
                  : "Notas importantes: $notasImportantes",
            ),
          ],
        ),
        bottom: TabBar(controller:_tabController,
        tabs: [Tab(text: "Normales"),Tab(text:"Importantes")],),
        
        
      ),
      drawer: Drawer(child: ListView(
        children: [
          ListTile(
            title: Text("Limpiar notas normales"),
            onTap: _limpiarNotas,
          ),
          ListTile(
             title: Text("Limpiar notas importantes"),
            onTap: _limpiarNotasImportantes,
          )
        ],
      ),),


      floatingActionButton:  Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    FloatingActionButton(
      onPressed: _agregarNota, 
    
      tooltip: "Agregar Nota normales",
      backgroundColor: Colors.blue,
         child: Icon(Icons.add),
    ),
    SizedBox(width: 10), 
    FloatingActionButton(
      onPressed: _agregarImportante, 
      tooltip: "Agregar Nota a Importantes",
      backgroundColor: Colors.green, 
       child: Icon(Icons.add),
    ),
  ],
),


        body: TabBarView(
          controller: _tabController,
          children: [
            GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: notas.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onLongPress: () => _eliminarNota(index),
                   onHorizontalDragEnd: (details) => {
                    if (details.primaryVelocity! < 0) 
                     _marcarComoImportante(index)
                    
                  },
                  child: Card(
                    color: Colors.blue.shade100,
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(notas[index].titulo,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(notas[index].contenido),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            


             GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemCount: importante.length,
              itemBuilder: (context, index) =>
                 GestureDetector(
                  onLongPress: () => _eliminarImportante(index),
                  onHorizontalDragEnd: (details) => {
                    if (details.primaryVelocity! > 0) 
                     _marcarComoNormal(index)
                    
                  },
                  child: Card(
                    color: Colors.blue.shade100,
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(importante[index].titulo,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(importante[index].contenido),
                        ],
                      ),
                    ),
                  ),
                  
                )
              
            ),



          ],
        )

    //   body: TabBarView(
    //     controller: _tabController,
    //     children: [
    //        ListView.builder(
    //     itemCount: notas.length,
    //     itemBuilder: (context, index) => GestureDetector(
    //        onHorizontalDragEnd: (details) {
    //               if (details.primaryVelocity! > 0) {
    //                 _marcarComoImportante(index);
    //               }
    //             },
    //       onLongPress: () => _eliminarNota(index),
    //       child: ListTile(
    //           title: Text(notas[index].titulo),
    //           subtitle: Text(notas[index].contenido)),
    //     ),
        
        
       
    //   ),
      
      

    //  ListView.builder(
    //     itemCount: importante.length,
    //     itemBuilder: (context, index) => GestureDetector(
    //         onHorizontalDragEnd: (details) {
    //               if (details.primaryVelocity! < 0) {
    //                 _marcarComoNormal(index);
    //               }
    //             },
    //       onLongPress: () => _eliminarImportante(index),
    //       child: ListTile(
    //           title: Text(importante[index].titulo),
    //           subtitle: Text(importante[index].contenido)),
    //     ),
    //   ),
    //     ],
    //   )
    );
  }
}
 