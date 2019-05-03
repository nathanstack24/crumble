import json
from flask import Flask, request
from db import db, Recipe, Ingredient, User

app = Flask(__name__)
db_filename = 'crumble.db'

app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///%s' % db_filename
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SQLALCHEMY_ECHO'] = True

db.init_app(app)
with app.app_context():
    db.create_all()

@app.route('/')
def root():
    return "Who's hungry?"

@app.route('/api/recipes/')
def get_recipes():
    recipes = Recipe.query.all()
    res = {
        'success': True,
        'data': [r.serialize() for r in recipes]
    }
    return json.dumps(res), 200

@app.route('/api/recipes/all/', methods = ['POST'])
def create_all_recipes():
    post_body_dict = json.loads(request.data) # dictionary with all of the recipes
    all_keys = post_body_dict.keys()
    recipe_list = []
    for k in all_keys:
        post_body = post_body_dict[k]
        recipe = Recipe(
            name = post_body.get('name'),
            source = post_body.get('source'),
            time = post_body.get('preptime') + post_body.get('waittime') + post_body.get('cooktime'),
            servings = post_body.get('servings'),
            comments = post_body.get('comments'),
            calories = post_body.get('calories'),
            instructions = post_body.get('instructions')
        )
        if (recipe.time == 0):
            recipe.time = -1
        if (post_body.get("calories") == 0 and post_body.get("fat") == 0 and post_body.get("satfat") == 0 and post_body.get("carbs") == 0 and post_body.get("fiber") == 0 and post_body.get("sugar") == 0 and post_body.get("protein") == 0):
            recipe.calories = -1
        ingredients_list = post_body.get('ingredients')
        for i in ingredients_list:
            ingr = Ingredient.query.filter_by(name=i).first()
            if ingr is None:
                ingr = Ingredient(name = i)
                db.session.add(ingr)
            recipe.ingredients.append(ingr)
        db.session.add(recipe)
        recipe_list.append(recipe)
    
    db.session.commit()

    return json.dumps({'success': True, 'data': [r.serialize() for r in recipe_list]}), 201

@app.route('/api/recipes/', methods = ['POST'])
def create_recipe():
    post_body = json.loads(request.data)
    recipe = Recipe(
        name = post_body.get('name'),
        source = post_body.get('source'),
        time = post_body.get('preptime') + post_body.get('waittime') + post_body.get('cooktime'),
        servings = post_body.get('servings'),
        comments = post_body.get('comments'),
        calories = post_body.get('calories'),
        instructions = post_body.get('instructions')
    )
    if (recipe.time == 0):
        recipe.time = -1
    if (post_body.get("calories") == 0 and post_body.get("fat") == 0 and post_body.get("satfat") == 0 and post_body.get("carbs") == 0 and post_body.get("fiber") == 0 and post_body.get("sugar") == 0 and post_body.get("protein") == 0):
        recipe.calories = -1

    ingredients_list = post_body.get('ingredients')
    for i in ingredients_list:
        ingr = Ingredient.query.filter_by(name=i).first()
        if ingr is None:
            ingr = Ingredient(name = i)
            db.session.add(ingr)
        recipe.ingredients.append(ingr)

    db.session.add(recipe)
    db.session.commit()
    return json.dumps({'success': True, 'data': recipe.serialize()}), 201

@app.route('/api/recipe/<int:recipe_id>/')
def get_recipe(recipe_id):
    recipe = Recipe.query.filter_by(id=recipe_id).first()
    if recipe is not None:
        return json.dumps({'success': True, 'data': recipe.serialize()}), 200
    return json.dumps({'success': False, 'error': 'Recipe not found'}), 404

@app.route('/api/recipe/<int:recipe_id>/', methods = ['DELETE'])
def delete_recipe(recipe_id):
    recipe = Recipe.query.filter_by(id=recipe_id).first()
    if recipe is not None:
        db.session.delete(recipe)
        db.session.commit()
        return json.dumps({'success': True, 'data': recipe.serialize()}), 200
    return json.dumps({'success': False, 'error': 'Class not found'}), 404

@app.route('/api/users/', methods = ['POST'])
def create_user():
    post_body = json.loads(request.data)
    user = User(
        name = post_body.get('name')
    )
    db.session.add(user)
    db.session.commit()
    return json.dumps({'success': True, 'data': user.serialize()}), 201

@app.route('/api/users/')
def get_users():
    users = User.query.all()
    return json.dumps({'success': True, 'data': [u.serialize() for u in users]}), 404

@app.route('/api/user/<int:user_id>/')
def get_user(user_id):
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        return json.dumps({'success': True, 'data': user.serialize()}), 200
    return json.dumps({'success': False, 'error': 'User not found'}), 404

@app.route('/api/user/<int:user_id>/favorite/', methods = ['POST'])
def favorite(user_id):
    post_body = json.loads(request.data)
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        recipe = Recipe.query.filter_by(id=post_body.get("recipe_id")).first()
        if recipe is not None:
            user.favorites.append(recipe)
            db.session.commit()
            return json.dumps({'success': True, 'data': user.serialize()}), 200

        return json.dumps({'success': False, 'error': 'Recipe not found'}), 404
    return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404

@app.route('/api/user/<int:user_id>/unfavorite/', methods = ['POST'])
def unfavorite(user_id):
    post_body = json.loads(request.data)
    user = User.query.filter_by(id=user_id).first()
    if user is not None:
        recipe = Recipe.query.filter_by(id=post_body.get("recipe_id")).first()
        if recipe is not None:
            user.favorites.remove(recipe)
            db.session.commit()
            return json.dumps({'success': True, 'data': user.serialize()}), 200

        return json.dumps({'success': False, 'error': 'Recipe not found'}), 404
    return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404

@app.route('/api/ingredients/', methods = ['POST'])
def create_ingredient():
    post_body = json.loads(request.data)
    i = Ingredient(
        name = post_body.get('name'),
        #quantity = post_body.get('quantity'),
        #units = post_body.get('units')
    )
    db.session.add(i)
    db.session.commit()
    return json.dumps({'success': True, 'data': i.serialize()}), 201

@app.route('/api/ingredients/')
def get_ingredients():
    ingredients = Ingredient.query.all()
    return json.dumps({'success': True, 'data': [i.serialize() for i in ingredients]}), 404

@app.route('/api/ingredient/<int:ingredient_id>/')
def get_ingredient(ingredient_id):
    i = Ingredient.query.filter_by(id=ingredient_id).first()
    if i is not None:
        return json.dumps({'success': True, 'data': i.serialize()}), 200
    return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404

@app.route('/api/recipe/<int:recipe_id>/add/', methods = ['POST'])
def add_ingredient(recipe_id):
    post_body = json.loads(request.data)
    recipe = Recipe.query.filter_by(id=recipe_id).first()
    if recipe is not None:
        ingredient = Ingredient.query.filter_by(id=post_body.get("ingredient_id")).first()
        if ingredient is not None:
            recipe.ingredients.append(ingredient)
            db.session.commit()
            return json.dumps({'success': True, 'data': recipe.serialize()}), 200

        return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404
    return json.dumps({'success': False, 'error': 'Recipe not found'}), 404

@app.route('/api/recipe/<int:recipe_id>/remove/', methods = ['POST'])
def remove_ingredient(recipe_id):
    post_body = json.loads(request.data)
    recipe = Recipe.query.filter_by(id=recipe_id).first()
    if recipe is not None:
        ingredient = Ingredient.query.filter_by(id=post_body.get("ingredient_id")).first()
        if ingredient is not None:
            recipe.ingredients.remove(ingredient)
            db.session.commit()
            return json.dumps({'success': True, 'data': recipe.serialize()}), 200

        return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404
    return json.dumps({'success': False, 'error': 'Recipe not found'}), 404


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
