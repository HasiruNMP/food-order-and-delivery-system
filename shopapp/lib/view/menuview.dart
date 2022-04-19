import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:shopapp/model/postCategory.dart';
import 'package:shopapp/model/postItems.dart';
import 'package:shopapp/view/deliveryview.dart';
import 'package:shopapp/view/homeview.dart';
//import 'package:image_picker_web/image_picker_web.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class Category {
  final int CategoryId;
  final String Name;
  final String ImgUrl;

  Category(
      {required this.CategoryId, required this.Name, required this.ImgUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      CategoryId: json['CategoryId'],
      Name: json['Name'],
      ImgUrl: json['ImgUrl'],
    );
  }
}

class Product {
  final int ProductId;
  final int CategoryId;
  final String Name;
  final String Description;
  final double Price;
  final String ImgUrl;

  Product(
      {required this.ProductId,
      required this.CategoryId,
      required this.Name,
      required this.Description,
      required this.Price,
      required this.ImgUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      ProductId: json['ProductId'],
      CategoryId: json['CategoryId'],
      Name: json['Name'],
      Description: json['Description'],
      Price: json['Price'],
      ImgUrl: json['ImgUrl'],
    );
  }
}

class MenuHomeView extends StatefulWidget {
  const MenuHomeView({Key? key}) : super(key: key);

  @override
  State<MenuHomeView> createState() => _MenuHomeViewState();
}

class _MenuHomeViewState extends State<MenuHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue,
              child: const SideBar(),
            ),
          ),
          const Expanded(
            flex: 14,
            child: MenuView(),
          ),
        ],
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Icon(Icons.food_bank), Text('FODS')],
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const MenuHomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                Text(
                  'MENU',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.black,
        ),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const HomeView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.store,
                  color: Colors.black,
                ),
                Text(
                  'ORDERS',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
        AspectRatio(
          aspectRatio: 1,
          child: TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const DeliveryView();
              }));
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.pedal_bike,
                  color: Colors.black,
                ),
                Text(
                  'DELIVERY',
                  style: TextStyle(color: Colors.black),
                )
              ],
            ),
          ),
        ),
        const Divider(color: Colors.black),
      ],
    );
  }
}

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  int CategoryId = 0;
  String Name = 'null';
  String ImgUrl = 'null';
  late String imagePath;
  late var file;

  void setCategoryId(int CategoryId, String Name, String ImgUrl) {
    setState(() {
      this.CategoryId = CategoryId;
      this.Name = Name;
      this.ImgUrl = ImgUrl;
    });
  }

  String prodId = "null";
  String categoryIdItem = "null";
  String description = "null";
  String imgUrl = "null";
  String name = "null";
  String price = "null";

  void updateItemDetails(
    prodId,
    categoryIdItem,
    description,
    imgUrl,
    name,
    price,
  ) {
    setState(() {
      this.prodId = prodId;
      this.categoryIdItem = categoryIdItem;
      this.description = description;
      this.imgUrl = imgUrl;
      this.name = name;
      this.price = price;
    });
  }

  TextEditingController newDescription = TextEditingController();
  TextEditingController newImgUrl = TextEditingController();
  TextEditingController newName = TextEditingController();
  TextEditingController newPrice = TextEditingController();

  TextEditingController newCategory = TextEditingController();

  TextEditingController updateDescription = TextEditingController();
  TextEditingController updateName = TextEditingController();
  TextEditingController updatePrice = TextEditingController();

  Future<List<Category>> fetchCategories() async {
    final response = await http
        .get(Uri.parse('https://localhost:7072/api/Category/getcategories'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future addCategory(String Name, String ImgUrl) async {
    final response = await http.post(
        Uri.parse(
            'https://localhost:7072/api/Category/postcategory?Name=$Name&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add.');
    }
  }

  Future deleteCategory(int CategoryId) async {
    final response = await http.delete(
        Uri.parse(
            '  https://localhost:7072/api/Category?CategoryId=$CategoryId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add.');
    }
  }

  ////////////////////////////////////////////////////////////
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(
        'https://localhost:7072/products/getcategoryproducts?categoryId=$CategoryId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future addProduct(int CategoryId, String Name, String Description,
      double Price, String ImgUrl) async {
    final response = await http.post(
        Uri.parse(
            'https://localhost:7072/products/postproduct?CategoryId=$CategoryId&Name=$Name&Description=$Description&Price=$Price&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add.');
    }
  }

  Future updateProduct(int ProductId, int CategoryId, String Name,
      String Description, double Price, String ImgUrl) async {
    final response = await http.put(
        Uri.parse(
            'https://localhost:7072/products/putproductdetails?ProductId=$ProductId&CategoryId=$CategoryId&Name=$Name&Description=$Description&Price=$Price&ImgUrl=$ImgUrl'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to Update.');
    }
  }

  Future deleteProduct(int ProductId) async {
    final response = await http.delete(
        Uri.parse('  https://localhost:7072/products?ProductId=$ProductId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //return Data.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to add.');
    }
  }

  late Future<List<Category>> futureCategoryData;
  late Future<List<Product>> futureProductData;
  @override
  void initState() {
    super.initState();
    futureCategoryData = fetchCategories();
    futureProductData = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _formKey2 = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Menu'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: FutureBuilder<List<Category>>(
                    future: futureCategoryData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Category>? data = snapshot.data;
                        return ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  setCategoryId(data[index].CategoryId,
                                      data[index].Name, data[index].ImgUrl);
                                  updateItemDetails("null", "null", "null",
                                      "null", "null", "null");
                                  fetchProducts();
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data[index].Name),
                                    const Icon(Icons.navigate_next),
                                  ],
                                ),
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      // By default show a loading spinner.
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                Divider(),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(Name),
                    ElevatedButton(
                        onPressed: () {
                          deleteCategory(CategoryId);
                        },
                        child: Text("Delete Category"))
                  ],
                )),
                Divider(),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextField(
                          decoration: InputDecoration(hintText: "New Category"),
                          controller: newCategory,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            if (_formKey2.currentState!.validate()) {
                              addCategory(newCategory.text, newImgUrl.text);
                            }
                          },
                          child: Text("Add New"),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Category Items",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  flex: 2,
                  child: FutureBuilder<List<Product>>(
                      future: futureProductData,
                      builder: (context, snapshot) {
                        List<Product>? data = snapshot.data;
                        return ListView.builder(
                            itemCount: data!.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: TextButton(
                                  onPressed: () {
                                    updateItemDetails(
                                      data[index].ProductId,
                                      data[index].CategoryId,
                                      data[index].Description,
                                      data[index].ImgUrl,
                                      data[index].Name,
                                      data[index].Price,
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data[index].Name),
                                      const Icon(Icons.navigate_next),
                                    ],
                                  ),
                                ),
                              );
                            });
                      }),
                ),
                Divider(),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Category Name: " + Name),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Item Name"),
                            controller: newName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: "Description"),
                            controller: newDescription,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            decoration: InputDecoration(hintText: "Price"),
                            controller: newPrice,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: selectFile,
                            child: Text('Select Image'),
                          ),
                          /*TextFormField(
                            decoration: InputDecoration(hintText: "imgUrl"),
                            controller: newImgUrl,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                          ),*/
                          OutlinedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                addProduct(
                                    CategoryId,
                                    newName.text,
                                    newDescription.text,
                                    double.parse(newPrice.text),
                                    imgUrl);
                              }
                            },
                            child: Text("Add New"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 5,
            child: Column(
              children: [SizedBox()],
            ),
          ),
        ],
      ),
    );
  }

  Future selectFile() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    Uint8List data = await image!.readAsBytes();
    List<int> list = data.cast();

    var request = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://d21f-2402-d000-a400-52ba-fc34-b963-a9c3-6e76.ngrok.io/uploads'));
    request.files.add(
        await http.MultipartFile.fromBytes('image', list, filename: '123.png'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
