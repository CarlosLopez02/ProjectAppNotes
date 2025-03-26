import 'package:appdenotas/services/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

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

  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController1 = TextEditingController(); //title
  final TextEditingController textController2 = TextEditingController(); //content
  final TextEditingController textTypeController = TextEditingController(); //Type
  

  SpeechToText speechToText = SpeechToText();
  bool isListening = false;


  void openNoteBox({String? docID, String? titulo, String? contenido, String? type,}) {
    textController1.text = titulo ?? '';
    textController2.text = contenido ?? '';
    textTypeController.text = type ?? '';

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController1,
                    decoration: const InputDecoration(
                      labelText: 'Titulo de la nota',
                    ),
                  ),
                  TextField(
                    controller: textController2,
                    decoration: const InputDecoration(
                      labelText: 'Contenido de la nota',
                    ),
                  ),
                   TextField(
                    controller: textTypeController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo',
                    ),
                  ),
                    IconButton(
                        onPressed: () async {
                          if (!isListening) {
                            bool available = await speechToText.initialize();
                            if (available) {
                              setState(() {
                                isListening = true;
                              });
                            }
                            speechToText.listen(
                              onResult: (result) {
                                setState(() {
                                  textController2.text = result.recognizedWords;
                                });
                              },
                            );
                          } else {
                            setState(() {
                              isListening = false;
                            });
                            speechToText.stop();
                          }
                        },
                        icon: Icon(
                            isListening ? Icons.stop : Icons.record_voice_over),
                      )

                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (textController1.text.isNotEmpty &&
                        textController2.text.isNotEmpty && textTypeController.text.isNotEmpty) {
                      if (docID == null) {
                        firestoreService.addNote(
                            textController1.text, textController2.text, textTypeController.text);
                            
                      } else {
                        firestoreService.updateNote(
                            docID, textController1.text, textController2.text, textTypeController.text);
                      }
                    }

                    textController1.clear();
                    textController2.clear();
                    textTypeController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text("Guardar"),
                )
              ],
            ));
  }



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

// //Eliminar una nota por indice (posicion)
//   void _eliminarNota(int index) {
//     setState(() => notas.removeAt(index));
    
//     notasNormales--;
  

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Nota $index eliminada"))
//     );
//   }

//     void _eliminarImportante(int index) {
//     setState(() => importante.removeAt(index));

//     notasImportantes--;
    

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Nota $index eliminada"))
//     );
//   }
 //agregar una nueva nota
  // void _agregarNota(String titulo, String contenido) {
  //   setState(() => notas.add(
  //       Nota(titulo: textController1.text, contenido: textController2.text)));
  // }


  //   void _agregarNotaImportante(String titulo, String contenido) {
  //   setState(() => notas.add(
  //       Nota(titulo: textController1.text, contenido: textController2.text)));
  // }

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

  //   // Marca una nota a importantes
  // void _marcarComoImportante(int index) {
  //   setState(() {
  //     final nota = notas.removeAt(index);
  //     importante.add(nota);
  //     notasNormales--;
  //     notasImportantes++;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Nota marcada como importante")),
  //   );
  // }

  // // Marca una nota a normales
  // void _marcarComoNormal(int index) {
  //   setState(() {
  //     final nota = importante.removeAt(index);
  //     notas.add(nota);
  //     notasImportantes--;
  //     notasNormales++;
  //   });

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text("Nota marcada como normal")),
  //   );
  // }
 
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


//       floatingActionButton:  Row(
//   mainAxisAlignment: MainAxisAlignment.end,
//   children: [
//     FloatingActionButton(
//       onPressed:() => openNoteBox(),
    
//       tooltip: "Agregar Nota normales",
//       backgroundColor: Colors.blue,
//          child: Icon(Icons.add),
//     ),
//     SizedBox(width: 10), 
//     FloatingActionButton(
//       onPressed: _agregarImportante, 
//       tooltip: "Agregar Nota a Importantes",
//       backgroundColor: Colors.green, 
//        child: Icon(Icons.add),
//     ),
//   ],
  
// ),
   
  floatingActionButton:  
       FloatingActionButton(
                onPressed: () => openNoteBox(), 
                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white),
          ),
        
   
 



        body: StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getNotasStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No hay notas disponibles"));
              }

              List notasList = snapshot.data!.docs;

              return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: notasList.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = notasList[index];
                    String docID = document.id;
                
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    String notaTitulo = data['title'] ?? 'Sin titulo';
                    String notaContenido = data['content'] ?? 'Sin contenido';
                    String notaTipo = data['type']?? 'Sin tipo';
                    print("Título: $notaTitulo, Contenido: $notaContenido, Tipo: $notaTipo");
                    
                    return GestureDetector(
                      onLongPress: () => firestoreService.deleteNote(docID),
                      
                      child: Card(
                        color: Colors.blue.shade100,
                        elevation: 4,
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListTile(
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        onPressed: () => openNoteBox(
                                            docID: docID,
                                            titulo: notaTitulo,
                                            contenido: notaContenido,
                                            type: notaTipo,
                                            ),
                                        icon: Icon(Icons.edit)),
                                        
                                    IconButton(
                                        onPressed: () =>
                                            firestoreService.deleteNote(docID),
                                        icon: Icon(Icons.remove_circle))
                                  ],
                                ),
                              ),
                              Text(notaTitulo,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(notaContenido,
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(height: 5),
                              Text(notaTipo, style: TextStyle(
                                fontWeight: FontWeight.bold
                              ))
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                
            })


        // body: TabBarView(
        //   controller: _tabController,
        //   children: [
        //     GridView.builder(
        //       padding: EdgeInsets.all(10),
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        //       itemCount: notas.length,
        //       itemBuilder: (context, index) {
        //         return GestureDetector(
        //           onLongPress: () => _eliminarNota(index),
        //            onHorizontalDragEnd: (details) => {
        //             if (details.primaryVelocity! < 0) 
        //              _marcarComoImportante(index)
                    
        //           },
        //           child: Card(
        //             color: Colors.blue.shade100,
        //             elevation: 4,
        //             child: Padding(
        //               padding: EdgeInsets.all(8),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(notas[index].titulo,
        //                       style: TextStyle(fontWeight: FontWeight.bold)),
        //                   SizedBox(height: 5),
        //                   Text(notas[index].contenido),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //     ),
            


        //      GridView.builder(
        //       padding: EdgeInsets.all(10),
        //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //           crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10),
        //       itemCount: importante.length,
        //       itemBuilder: (context, index) =>
        //          GestureDetector(
        //           onLongPress: () => _eliminarImportante(index),
        //           onHorizontalDragEnd: (details) => {
        //             if (details.primaryVelocity! > 0) 
        //              _marcarComoNormal(index)
                    
        //           },
        //           child: Card(
        //             color: Colors.blue.shade100,
        //             elevation: 4,
        //             child: Padding(
        //               padding: EdgeInsets.all(8),
        //               child: Column(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(importante[index].titulo,
        //                       style: TextStyle(fontWeight: FontWeight.bold)),
        //                   SizedBox(height: 5),
        //                   Text(importante[index].contenido),
        //                 ],
        //               ),
        //             ),
        //           ),
                  
        //         )
              
        //     ),



        //   ],
        // )

  
    );
  }
}
 