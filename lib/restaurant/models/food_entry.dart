// To parse this JSON data, do
//
//     final foodEntry = foodEntryFromJson(jsonString);

import 'dart:convert';

List<FoodEntry> foodEntryFromJson(String str) => List<FoodEntry>.from(json.decode(str).map((x) => FoodEntry.fromJson(x)));

String foodEntryToJson(List<FoodEntry> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodEntry {
    String model;
    String pk;
    Fields fields;

    FoodEntry({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory FoodEntry.fromJson(Map<String, dynamic> json) => FoodEntry(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String streetAddress;
    String location;
    String foodType;
    double reviewsRating;
    int numberOfReviews;
    String comments;
    String contactNumber;
    String tripAdvisorUrl;
    String menuInfo;
    String imageUrl;
    String avgRating;

    Fields({
        required this.name,
        required this.streetAddress,
        required this.location,
        required this.foodType,
        required this.reviewsRating,
        required this.numberOfReviews,
        required this.comments,
        required this.contactNumber,
        required this.tripAdvisorUrl,
        required this.menuInfo,
        required this.imageUrl,
        required this.avgRating,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        streetAddress: json["street_address"],
        location: json["location"],
        foodType: json["food_type"],
        reviewsRating: json["reviews_rating"]?.toDouble(),
        numberOfReviews: json["number_of_reviews"],
        comments: json["comments"],
        contactNumber: json["contact_number"],
        tripAdvisorUrl: json["trip_advisor_url"],
        menuInfo: json["menu_info"],
        imageUrl: json["image_url"],
        avgRating: json["avg_rating"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "street_address": streetAddress,
        "location": location,
        "food_type": foodType,
        "reviews_rating": reviewsRating,
        "number_of_reviews": numberOfReviews,
        "comments": comments,
        "contact_number": contactNumber,
        "trip_advisor_url": tripAdvisorUrl,
        "menu_info": menuInfo,
        "image_url": imageUrl,
        "avg_rating": avgRating,
    };
}
