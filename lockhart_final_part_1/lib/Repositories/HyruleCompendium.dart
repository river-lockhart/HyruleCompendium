import 'package:dio/dio.dart';

const String BaseUrl = "https://botw-compendium.herokuapp.com/api/v3";

class HyruleCompendium {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchItems() async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/all");

      if (response.statusCode == 200) {
        List<dynamic> unsortedData = response.data['data'];

        unsortedData.sort((a, b) => a['name'].compareTo(b['name']));
        return unsortedData.toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print(error);
      throw Exception('Error: $error');
    }
  }

  Future<List<dynamic>> filterItems(String category, String location) async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/all");

      if (response.statusCode == 200) {
        List<dynamic> unsortedData = response.data['data'];
        if (category != "All") {
          unsortedData.removeWhere((item) => item['category'] != category);
        }
        if (location != "All") {
          unsortedData.removeWhere((item) =>
              !(item['common_locations'] is List) ||
              (item['common_locations'] != null &&
                  !item['common_locations'].contains(location)));
        }

        unsortedData.sort((a, b) => a['name'].compareTo(b['name']));
        return unsortedData.toList();
      } else {
        throw Exception('Failed to load items');
      }
    } catch (error) {
      print(error);
      throw Exception('Error: $error');
    }
  }

  Future<Map<String, dynamic>> fetchItemDetails(int itemId) async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/entry/$itemId");

      if (response.statusCode == 200) {
        return Map<String, dynamic>.from(response.data['data']);
      } else {
        throw Exception('Failed to load item details');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  //gets unique category names from the API
  Future<List<String>> fetchCategoryTypes() async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/all");
      List<String> categoryTypes = [];

      for (int i = 0; i < response.data['data'].length; i++) {
        if (!categoryTypes.contains(response.data['data'][i]['category'])) {
          categoryTypes.add(response.data['data'][i]['category']);
        }
      }

      if (response.statusCode == 200) {
        return categoryTypes.toList();
      } else {
        throw Exception('Failed to load category types');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<String>> fetchLocations() async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/all");
      List<String> locations = [];

      for (int i = 0; i < response.data['data'].length; i++) {
        for (int j = 0;
            response.data['data'][i]['common_locations'] != null &&
                j < response.data['data'][i]['common_locations'].length;
            j++) {
          if (!locations
              .contains(response.data['data'][i]['common_locations'][j])) {
            locations.add(response.data['data'][i]['common_locations'][j]);
          }
        }
      }

      if (response.statusCode == 200) {
        return locations.toList();
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<List<String>> fetchSearchData() async {
    try {
      final response = await _dio.get("$BaseUrl/compendium/all");
      List<String> searchData = [];

      for (int i = 0; i < response.data['data'].length; i++) {
        searchData.add(response.data['data'][i]['name']);
      }

      if (response.statusCode == 200) {
        return searchData.toList();
      } else {
        throw Exception('Failed to load search data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
