## Group Members
<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>NPM</th>
      <th>GitHub Username</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Flori Andrea Ng</td>
      <td>2306171713</td>
      <td>Mcflurrins</td>
    </tr>
    <tr>
      <td>Guruprasanth Meyyarasu</td>
      <td>-</td>
      <td>Goosegamer</td>
    </tr>
    <tr>
      <td>Kevin Adriano</td>
      <td>2306172552</td>
      <td>kevinadriano1</td>
    </tr>
    <tr>
      <td>Geordie Vannese Hardjanto</td>
      <td>2306170414</td>
      <td>geordievannese</td>
    </tr>
    <tr>
      <td>Muhammad Raditya Indrastata Norman</td>
      <td>2306256450</td>
      <td>aditonorman</td>
    </tr>
    <tr>
      <td>Darren Marcello Sidabuntar</td>
      <td>2306256293</td>
      <td>DarrenM07</td>
    </tr>
  </tbody>
</table>


# Link to the APK 
[![Build status](https://build.appcenter.ms/v0.1/apps/994f8cd4-713b-4a7f-bee0-9f32bec0a8c2/branches/main/badge)](https://appcenter.ms)
https://install.appcenter.ms/orgs/urbaneat/apps/urbaneat/distribution_groups/public/releases/12 

# Mock Up
### View Full Figma Mock-Up here: 
https://www.figma.com/design/qSCRyapsGr5TNHYpj4m0Ul/UrbanEat-Mobile?node-id=0-1&node-type=canvas&t=FsljrNcOH63j4SR4-0 

<table>
  <tr>
    <td>
      <img src="https://github.com/user-attachments/assets/2fa7e926-0b4f-4b24-841f-4b936096f774" alt="Onboarding" width="200">
      <p>Onboarding</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/e022822e-ee4c-469f-a82f-c457edeaa192" alt="Login" width="200">
      <p>Login</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/a53f78d2-783e-42fa-9237-579c079fa56d" alt="Info Page" width="200">
      <p>Info Page</p>
    </td>
    <td>
      <img src="https://github.com/user-attachments/assets/262de2a9-9e45-4fbe-a8d5-59c36866dd3a" alt="Main Page" width="200">
      <p>Main Page</p>
    </td>
  </tr>
</table>


# Application description (name and purpose of the application)

UrbanEat is a food guide and review platform that focuses exclusively on restaurants and eateries in New York City (NYC), United States. UrbanEat allows users to discover, rate, and review their dining experiences. Users can also view photos of restaurants and check out detailed reviews from fellow diners. UrbanEat is a resource for locals and tourists looking to explore NYC's iconic culinary scene where one can find all types of restaurant to cater to their cravings, from Italian to Mediterranean.

# List of modules implemented and division of work among group members

## 🔐 Authentication 
#### Login/register - Darren
This feature allows for logging in and registration of existing and new users with appropriate security, allowing users to view and access the website according to their permissions.

## 🏆 Leaderboards  
#### See top restaurants - Dito
 This feature allows users to see the highest-rated restaurants based on reviews and ratings so that users are well-informed on the best places where they can choose to dine. 

## 🤵‍♀️ User role 
#### Edit User profiles - Guruprasanth
  Users can see and edit their data (i.e. profile picture). 

## 🧑‍🔧 Admin role 
#### Add/edit/delete restaurants - Flori
  This feature allows admin users to add their own restaurants with initially 0 reviews to the database. The type of data an admin user can add is as follows: `Name`, `Street Address`, `Location`, `Type`, `Reviews (initialized at 0)`, `No of Reviews (initialized at 0)`, `Comments (initialized at None)`, `Contact Number`, `Restaurant_Url`, `Menu_url`, `Image_url`.

## 📖 Collection 
#### Filtering/searching restaurants - Geordie
 This feature allows users to filter and search restaurants based on their type of cuisine. This functionality enables users to easily discover restaurants that match their preferred cuisine, such as Italian, Chinese, Indian, or any other type. Users can specify their desired cuisine in the search bar or use a filter option to narrow down the available restaurants, making the process of finding a suitable dining option more efficient and tailored to their preferences.

## 🔍 Review 
#### Users can review their favorite restaurant - Kevin 
  This feature allows users to add, edit and delete reviews of restaurants. This allows other users to know what to expect from a restaurant before they decide to go there. 

# Roles in the application
### 🤵‍♀️ User Role: 
  - See the list of restaurants.  
  - Navigate through the restaurant.  
  - Add reviews.  
  - Edit the user profile (profile picture).

### 🧑‍🔧 Admin Role:
  - Add new restaurants.  
  - Edit details of restaurants.  
  - Delete restaurants.

# Integration with the web service to connect to the web application created in the midterm project

#### In the process of integrating Django with Flutter, we will perform the following steps:

- Add the `http package/library` to the project so the application can interact with the web application.
- Use the authentication model for login, logout, and registration created in the previous task to provide users with authorization based on their roles as readers or writers.
- Utilize the `pbp_django_auth` package to manage cookies, ensuring that all requests sent to the server are authenticated and authorized.
- Use https://app.quicktype.io/ to convert JSON data into Dart objects that will be used to create an instance of data as a class in Flutter.
