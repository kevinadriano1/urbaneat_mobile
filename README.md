# UrbanEat

## Group Members
- Flori Andrea Ng - 2306171713
- Guruprasanth Meyyarasu
- Kevin Adriano - 2306172552
- Geordie Vannese Hardjanto - 2306170414
- Muhammad Raditya Indrastata Norman - 2306256450
- Darren Marcello Sidabuntar - 2306256293

# Link to the APK (not required at Stage I. The APK link can be added to README.md after completing Stage II.)

# Application description (name and purpose of the application)

UrbanEat is a food guide and review platform that focuses exclusively on restaurants and eateries in New York City (NYC), United States. UrbanEat allows users to discover, rate, and review their dining experiences. Users can also view photos of restaurants and check out detailed reviews from fellow diners. UrbanEat is a resource for locals and tourists looking to explore NYC's iconic culinary scene where one can find all types of restaurant to cater to their cravings, from Italian to Mediterranean.

# List of modules implemented and division of work among group members

- **Authentication - Login/register - Daren:**  
  Allow for logging in and registration of existing and new users with appropriate security, allowing users to view and access the website according to their permissions.

- **Leaderboards - See top restaurants - Dito:**  
  Allow users to see the highest-rated restaurants based on reviews and ratings so that users are well-informed on the best places where they can choose to dine. 

- **User role - Edit User profiles - Guruprasanth Meyyarasu:**  
  Users can see and edit their data (i.e. profile picture). 

- **Admin role - Add/edit/delete restaurants - Flori:**  
  Allow admin users to add their own restaurants with initially 0 reviews to the database. The type of data an admin user can add is as follows: Name, Street Address, Location, Type, Reviews (initialized at 0), No of Reviews (initialized at 0), Comments (initialized at None), Contact Number, Restaurant_Url, Menu_url, Image_url.

- **Collection - Filtering/searching restaurants - Geordie:**  
  Filter and search the restaurant based on their type of cuisine.  
  The feature "Collection - Filtering/searching restaurants" allows users to filter and search restaurants based on their type of cuisine. This functionality enables users to easily discover restaurants that match their preferred cuisine, such as Italian, Chinese, Indian, or any other type. Users can specify their desired cuisine in the search bar or use a filter option to narrow down the available restaurants, making the process of finding a suitable dining option more efficient and tailored to their preferences.

- **Review - Users can review their favorite restaurant - Kevin:**  
  Allow users to add, edit and delete reviews of restaurants. This allows other users to know what to expect from a restaurant before they decide to go there. 

# Roles or actors of the user application

- **User Role:**  
  - See the list of restaurants.  
  - Navigate through the restaurant.  
  - Add reviews.  
  - Edit the user profile (profile picture).

- **Admin Role:**  
  - Add new restaurants.  
  - Edit details of restaurants.  
  - Delete restaurants.

# Integration with the web service to connect to the web application created in the midterm project

We will integrate our Flutter final project with the Django web application developed during the midterm project.