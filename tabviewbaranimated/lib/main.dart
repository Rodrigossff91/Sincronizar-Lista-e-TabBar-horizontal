// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

const productHeight = 100.0;
const categoriasHeight = 55.0;

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  late final ScrollController scrollController;

  List<Categoria> categoria = List<Categoria>.empty(growable: true);

  List<CategoriaTab> tabCategory = List<CategoriaTab>.empty(growable: true);

  List<Item> item = List<Item>.empty(growable: true);

  bool listen = true;

  @override
  void initState() {
    categoria.add(Categoria(name: 'asasaAS', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde'),
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde'),
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    categoria.add(Categoria(name: 'LoLita', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    categoria.add(Categoria(name: 'Jaca', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    categoria.add(Categoria(name: 'Banana', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    categoria.add(Categoria(name: 'Maca', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    categoria.add(Categoria(name: 'Pera', product: [
      Product('Nanina'),
      Product('dura'),
      Product('mole'),
      Product('verde')
    ]));
    scrollController = ScrollController();
    tabController = TabController(length: categoria.length, vsync: this);
    init();

    super.initState();
  }

  init() {
    setState(() {
      double offsetFrom = 0.0;
      double offsetTo = 0.0;
      for (var i = 0; i < categoria.length; i++) {
        final Categoria categoriaAtual = categoria[i];

        if (i > 0) {
          offsetFrom += categoria[i - 1].product.length * productHeight;
        }

        if (i < categoria.length - 1) {
          offsetTo =
              offsetFrom + categoria[i + 1].product.length * productHeight;
        } else {
          offsetTo = double.infinity;
        }

        tabCategory.add(CategoriaTab(
            categoriaSelecetd: (i == 0),
            offsetTo: offsetTo,
            caterogia: categoriaAtual,
            offsetFrom: categoriasHeight * i + offsetFrom));

        item.add(Item(
          categoriaa: categoriaAtual,
        ));

        for (var j = 0; j < categoriaAtual.product.length; j++) {
          final Product produtoAtual = categoriaAtual.product[j];
          item.add(Item(
            product: produtoAtual,
          ));
        }
      }
      scrollController.addListener(onScrollListener);
      print(item.toList());
    });
  }

  void onScrollListener() {
    setState(() {
      if (listen) {
        for (var i = 0; i < tabCategory.length; i++) {
          final tab = tabCategory[i];
          if (scrollController.offset >= tab.offsetFrom &&
              scrollController.offset <= tab.offsetTo &&
              tab.categoriaSelecetd == false) {
            onCategorySelected(i, animationRequired: false);
            tabController.animateTo(i);
          }
        }
      }
    });
  }

  onCategorySelected(int index, {bool animationRequired = true}) async {
    final selectedCategory = tabCategory[index];
    for (var category in tabCategory) {
      category.categoriaSelecetd =
          category.caterogia.name == selectedCategory.caterogia.name;
    }

    if (animationRequired) {
      setState(() {
        listen = false;
      });

      await scrollController.animateTo(selectedCategory.offsetFrom,
          duration: const Duration(milliseconds: 500), curve: Curves.linear);
    }
    setState(() {
      listen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: scrollController,
        slivers: <Widget>[
          const SliverAppBar(
            elevation: 0.0,
            floating: true,
            snap: true,
            expandedHeight: 90.0,
          ),
          SliverAppBar(
            pinned: true,
            title: const Text(''),
            floating: false,
            snap: false,
            elevation: 0,
            expandedHeight: 90.0,
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Container(
                color: Colors.transparent,
                height: 60,
                child: TabBar(
                  isScrollable: true,
                  onTap: (index) {
                    onCategorySelected(index);
                  },
                  controller: tabController,
                  tabs: tabCategory
                      .map((e) => CategoriaS(categoriaTab: e))
                      .toList(),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return item[index].isCategorie
                    ? CategoriaStyle(
                        category: item[index],
                      )
                    : ProdutoStyle(
                        product: item[index],
                      );
              },
              childCount: item.length,
            ),
          ),
        ],
      ),
      //SliverToBoxAdapter(
      //   child: SizedBox(
      //     height: MediaQuery.of(context).size.height - 60 - kToolbarHeight,
      //     child: ListView.builder(
      //         controller: scrollController,
      //         itemCount: item.length,
      //         itemBuilder: (((context, index) {
      //           return item[index].isCategorie
      //               ? CategoriaStyle(
      //                   category: item[index],
      //                 )
      //               : ProdutoStyle(
      //                   product: item[index],
      //                 );
      //         }))),
      //   ),
      // )
      // )
    );

    //  Scaffold(
    //   appBar: AppBar(
    //     title: const Text(''),
    //   ),
    //   body: Column(
    //     children: [
    //       Container(
    //         color: Colors.transparent,
    //         height: 60,
    //         child: TabBar(
    //             isScrollable: true,
    //             onTap: (index) {
    //               onCategorySelected(index);
    //             },
    //             controller: tabController,
    //             tabs: tabCategory
    //                 .map((e) => CategoriaS(
    //                       categoriaTab: e,
    //                     ))
    //                 .toList()),
    //       ),
    //       Expanded(
    //         child: Container(
    //             color: Colors.blue,
    //             child: ListView.builder(
    //                 controller: scrollController,
    //                 itemCount: item.length,
    //                 itemBuilder: (((context, index) {
    //                   return item[index].isCategorie
    //                       ? CategoriaStyle(
    //                           category: item[index],
    //                         )
    //                       : ProdutoStyle(
    //                           product: item[index],
    //                         );
    //                 })))),
    //       )
    //     ],
    //   ),
    // );
  }
}

class CategoriaS extends StatelessWidget {
  final CategoriaTab categoriaTab;
  const CategoriaS({super.key, required this.categoriaTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        categoriaTab.caterogia.name,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class CategoriaStyle extends StatelessWidget {
  const CategoriaStyle({
    super.key,
    required this.category,
  });
  final Item category;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: categoriasHeight,
      child: Text(
        category.categoriaa!.name,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class ProdutoStyle extends StatelessWidget {
  const ProdutoStyle({
    super.key,
    required this.product,
  });

  final Item product;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: productHeight,
      child: Text(
        product.product!.name,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

class Categoria {
  String name;
  List<Product> product;
  Categoria({
    required this.product,
    required this.name,
  });
}

class Product {
  String name;

  Product(this.name);
}

class CategoriaTab {
  Categoria caterogia;
  bool categoriaSelecetd;
  double offsetFrom;
  double offsetTo;
  CategoriaTab({
    required this.caterogia,
    required this.categoriaSelecetd,
    required this.offsetFrom,
    required this.offsetTo,
  });

  CategoriaTab copyWith({
    Categoria? caterogia,
    bool? categoriaSelecetd,
    double? offsetFrom,
    double? offsetTo,
  }) {
    return CategoriaTab(
      caterogia: caterogia ?? this.caterogia,
      categoriaSelecetd: categoriaSelecetd ?? this.categoriaSelecetd,
      offsetFrom: offsetFrom ?? this.offsetFrom,
      offsetTo: offsetTo ?? this.offsetTo,
    );
  }
}

class Item {
  Categoria? categoriaa;
  Product? product;
  bool get isCategorie => categoriaa != null;
  Item({
    this.categoriaa,
    this.product,
  });
}
