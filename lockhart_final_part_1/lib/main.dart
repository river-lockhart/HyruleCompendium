import 'package:flutter/material.dart';
import 'package:lockhart_final_part_1/Repositories/HyruleCompendium.dart';
import 'Views/aboutView.dart';
import 'Views/itemDetailView.dart';
import 'Views/loginView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hyrule Compendium',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor:
                const Color.fromARGB(255, 157, 215, 217).withOpacity(.3)),
        useMaterial3: true,
        fontFamily: 'BOTW',
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLocation = "";
  String selectedCategory = "";

  void initState() {
    super.initState();
    _fetchHyruleCategories();
    _fetchHyruleLocations();
    _fetchHyruleItems();
    _fetchSearchData();
  }

  TextEditingController searchController = TextEditingController();
  List<String> hyruleCategories = [];
  List<String> hyruleLocations = [];
  List<dynamic> hyruleItems = [];
  double hyruleItemsCount = 0;
  List<String> searchData = [];

  Future<void> _fetchHyruleItems() async {
    try {
      List<dynamic> retrievedHyruleItems =
          await HyruleCompendium().fetchItems();
      setState(() {
        hyruleItems = retrievedHyruleItems;
        hyruleItemsCount = hyruleItems.length.toDouble();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchHyruleCategories() async {
    try {
      List<String> retrievedHyruleCategories =
          await HyruleCompendium().fetchCategoryTypes();
      setState(() {
        hyruleCategories = retrievedHyruleCategories;
        hyruleCategories.sort();
        hyruleCategories.insert(0, "All");
        selectedCategory = hyruleCategories[0];
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchHyruleLocations() async {
    try {
      List<String> retrievedHyruleLocations =
          await HyruleCompendium().fetchLocations();
      setState(() {
        hyruleLocations = retrievedHyruleLocations;
        hyruleLocations.sort();
        hyruleLocations.insert(0, "All");
        selectedLocation = hyruleLocations[0];
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _fetchSearchData() async {
    try {
      List<String> retrievedSearchData =
          await HyruleCompendium().fetchSearchData();
      searchData = retrievedSearchData;
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> _filterDisplayedItems(String category, String location) async {
    try {
      List<dynamic> retrievedHyruleItems =
          await HyruleCompendium().filterItems(category, location);
      setState(() {
        hyruleItems = retrievedHyruleItems;
        hyruleItemsCount = hyruleItems.length.toDouble();
      });
    } catch (error) {
      print('Error: $error');
    }
  }

  String capitalizeFirstLetterOfName(String text) {
    return text
        .split(" ")
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(" ");
  }

  void _navigateToItemDetail(int itemId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetail(itemId),
      ),
    );
  }

  void onChanged(dynamic value) {}

  void onPressed() {}

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom == 0.0;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Color.fromARGB(255, 0, 0, 0),
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutView()),
              );
            },
          ),
          title: const Text("Hyrule Compendium"),
          titleTextStyle: const TextStyle(
            fontFamily: 'BOTW',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 0, 0, 0),
            letterSpacing: 1,
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(224, 109, 198, 201),
          foregroundColor: const Color.fromARGB(91, 231, 239, 239),
          actions: [
            IconButton(
              color: const Color.fromARGB(255, 0, 0, 0),
              icon: Image.asset("assets/shieldicon.png"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                );
              },
            ),
          ],
        ),
        body: Container(
          height: screenHeight,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/botw.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: screenWidth - 40),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
              color: const Color.fromARGB(255, 157, 215, 217).withOpacity(.3),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  SearchAnchor(
                    builder:
                        (BuildContext context, SearchController controller) {
                      return SearchBar(
                        hintText: "Search...",
                        constraints: BoxConstraints(
                            maxHeight: 80, maxWidth: screenWidth - 40),
                        backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(255, 109, 198, 201)
                                .withOpacity(.4)),
                        controller: searchController,
                        onChanged: onChanged,
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      return List<ListTile>.generate(3, (int index) {
                        final String item = 'item $index';

                        return ListTile(
                            title: Text(item),
                            onTap: () {
                              setState(() {
                                controller.closeView(item);
                              });
                            });
                      });
                    },
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: searchData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                title: Text(searchData[index].toString()));
                          })),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Filter",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1),
                      ),
                    ],
                  ),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Category:", style: TextStyle(letterSpacing: 1)),
                        Text("Location:")
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          items: hyruleCategories.map((category) {
                            return DropdownMenuItem(
                              value: category,
                              child: Text(capitalizeFirstLetterOfName(
                                  category.toString())),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() => selectedCategory = value!);

                            _filterDisplayedItems(
                                selectedCategory, selectedLocation);
                          },
                          alignment: Alignment.center,
                          value: selectedCategory,
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton(
                          items: hyruleLocations.map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(location.toString()),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() => selectedLocation = value!);

                            _filterDisplayedItems(
                                selectedCategory, selectedLocation);
                          },
                          alignment: Alignment.center,
                          value: selectedLocation,
                        ),
                      ),
                    ],
                  ),
                  keyboardIsOpen
                      ? SizedBox(
                          height: screenHeight * .6,
                          child: ListWheelScrollView(
                            itemExtent: 390,
                            diameterRatio: 5,
                            children: hyruleItems.map((item) {
                              return GestureDetector(
                                onTap: () {
                                  _navigateToItemDetail(item['id']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Card(
                                    color: const Color.fromARGB(255, 81, 85, 85)
                                        .withOpacity(.3),
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (item['image'] != null)
                                          Image.network(
                                            item['image'],
                                            width: null,
                                            height: 250,
                                            fit: BoxFit.cover,
                                            alignment: Alignment.center,
                                          ),
                                        ListTile(
                                          title: Text(
                                            capitalizeFirstLetterOfName(
                                                item['name']),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25,
                                              letterSpacing: 1,
                                              color: Color.fromARGB(
                                                  255, 231, 239, 239),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : const Text(""),
                ]),
          ),
        ));
  }
}
