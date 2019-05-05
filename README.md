# Crumble
Cook smarter.



## Images

## Description
Search for recipes by filtering the results to match the ingredients you actually have. Sign up/login to favorite the recipes you love most and quickly find them again. Recipes include nutrition facts to help you keep track of metrics such as calories, fat, and cholesterol.

## iOS Requirements Met
- 

## Backend Requirements Met
- Multiple GET requests implemented:
  - get all recipes
  - get a particular recipe by ID
  - get a list of all ingredients in the database
  - get a particular ingredient by ID
  - get all tags in the database
  - get a user's favorites
  
- Multiple POST requests implemented:
  - make multiple recipes
  - make one recipe
  - 'favorite' a recipe
  - 'unfavorite' a recipe
  - register a new user
  - login an existing user
  
- Implemented authenticaion using username/password with session ID's that expire and can be updated
- Implemented many-to-many relationships using association tables for:
  - recipes <-> ingredients
  - recipes <-> tags
  
- Implemented one-to-many relationship (to implement favorites):
  - user -> recipes

- Deployed to Google Cloud
