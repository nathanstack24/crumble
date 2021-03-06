import json
from flask import Flask, request
from db import db, Recipe, Ingredient, Tag, User
import users_dao

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
        'num_results': len(recipes),
        'data': [r.serialize() for r in recipes]
    }
    return json.dumps(res), 200

@app.route('/api/recipes/all/', methods = ['POST'])
def create_all_recipes():
    post_body_list = json.loads(request.data) # dictionary with all of the recipes
    recipe_list = []
    for post_body in post_body_list:
        recip = Recipe.query.filter_by(title=post_body.get('title')).first()
        if recip is None:
            recipe = Recipe(
                title = post_body.get('title'),
                author = post_body.get('author'),
                source = post_body.get('source'),
                description = post_body.get('description').replace('"', ''),
                rating = post_body.get('rating') if post_body.get('rating') != 'NA' else -1,
                num_reviews = post_body.get('number of reviews'),
                prep_time = post_body.get('prep time') if post_body.get('prep time') != 'NA' else -1,
                cook_time = post_body.get('cook time') if post_body.get('cook time') != 'NA' else -1,
                total_time = post_body.get('total time') if post_body.get('total time') != 'NA' else -1,
                servings = post_body.get('servings') if post_body.get('servings') != 'NA' else -1,
                calories = post_body.get('calories') if post_body.get('calories') != 'NA' else -1,
                fat = post_body.get('fat') if post_body.get('fat') != 'NA' else -1,
                carbs = post_body.get('carbs') if post_body.get('carbs') != 'NA' else -1,
                protein = post_body.get('protein') if post_body.get('protein') != 'NA' else -1,
                cholesterol = post_body.get('cholesterol') if post_body.get('cholesterol') != 'NA' else -1,
                sodium = post_body.get('sodium') if post_body.get('sodium') != 'NA' else -1,
                instructions = post_body.get('instructions'),
                image_url = post_body.get('image URL')
            )

            ingredients_list = post_body.get('ingredients')
            for i in ingredients_list:
                ingr = Ingredient.query.filter_by(name=i).first()
                if ingr is None:
                    ingr = Ingredient(name = i)
                    db.session.add(ingr)
                recipe.ingredients.append(ingr)

            tag_list = post_body.get('tags')
            for t in tag_list:
                tag = Tag.query.filter_by(name=t).first()
                if tag is None:
                    tag = Tag(name = t)
                    db.session.add(tag)
                recipe.tags.append(tag)

            db.session.add(recipe)
            recipe_list.append(recipe)
    
    db.session.commit()

    return json.dumps({'success': True, 'data': [r.serialize() for r in recipe_list]}), 201

@app.route('/api/recipes/', methods = ['POST'])
def create_recipe():
    post_body = json.loads(request.data)
    recip = Recipe.query.filter_by(title=post_body.get('title')).first()
    if recip is None:
        recipe = Recipe(
            title = post_body.get('title'),
            author = post_body.get('author'),
            source = post_body.get('source'),
            description = post_body.get('description'),
            rating = post_body.get('rating') if post_body.get('rating') != 'NA' else -1,
            num_reviews = post_body.get('number of reviews'),
            prep_time = post_body.get('prep time') if post_body.get('prep time') != 'NA' else -1,
            cook_time = post_body.get('cook time') if post_body.get('cook time') != 'NA' else -1,
            total_time = post_body.get('total time') if post_body.get('total time') != 'NA' else -1,
            servings = post_body.get('servings') if post_body.get('servings') != 'NA' else -1,
            calories = post_body.get('calories') if post_body.get('calories') != 'NA' else -1,
            fat = post_body.get('fat') if post_body.get('fat') != 'NA' else -1,
            carbs = post_body.get('carbs') if post_body.get('carbs') != 'NA' else -1,
            protein = post_body.get('protein') if post_body.get('protein') != 'NA' else -1,
            cholesterol = post_body.get('cholesterol') if post_body.get('cholesterol') != 'NA' else -1,
            sodium = post_body.get('sodium') if post_body.get('sodium') != 'NA' else -1,
            instructions = post_body.get('instructions'),
            image_url = post_body.get('image URL')
        )

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

@app.route('/api/ingredients/')
def get_ingredients():
    ingredients = Ingredient.query.all()
    return json.dumps({'success': True, 'num_results': len(ingredients), 'data': [i.serialize() for i in ingredients]}), 404

@app.route('/api/ingredient/<int:ingredient_id>/')
def get_ingredient(ingredient_id):
    i = Ingredient.query.filter_by(id=ingredient_id).first()
    if i is not None:
        return json.dumps({'success': True, 'data': i.serialize()}), 200
    return json.dumps({'success': False, 'error': 'Ingredient not found'}), 404

@app.route('/api/tags/')
def get_tags():
    tags = Tag.query.all()
    return json.dumps({'success': True, 'num_results': len(tags), 'data': [t.name for t in tags]}), 404


# User stuff

def extract_token(request):
    auth_header = request.headers.get('Authorization')
    if auth_header is None:
        return False, json.dumps({'success': False, 'error': 'Missing authorization header.'})

    bearer_token = auth_header.replace('Bearer ', '').strip()
    if not bearer_token:
        return False, json.dumps({'success': False, 'error': 'Invalid authorization header.'}) 

    return True, bearer_token

@app.route('/api/user/register/', methods=['POST'])
def register_account():
    post_body = json.loads(request.data)
    name = post_body.get('name')
    email = post_body.get('email')
    password = post_body.get('password')

    if email is None or password is None:
        return json.dumps({'success': False, 'error': 'Invalid email or password'})
    
    created, user = users_dao.create_user(name, email, password)

    if not created:
        return json.dumps({'success': False, 'error': 'User already exists'})

    return json.dumps({
        'success': True,
        'data': user.serialize(),
    })

@app.route('/api/user/login/', methods=['POST'])
def login():
    post_body = json.loads(request.data)
    email = post_body.get('email')
    password = post_body.get('password')

    if email is None or password is None:
        return json.dumps({'success': False, 'error': 'Invalid email or password'})

    success, user = users_dao.verify_credentials(email, password)

    if not success:
        return json.dumps({'success': False, 'error': 'Incorrect email or password'}) 
    
    return json.dumps({
        'success': True,
        'data': user.serialize()
    })


@app.route('/api/user/session/update/', methods=['GET'])
def update_session():
    success, update_token = extract_token(request)

    if not success:
        return update_token 

    try:
        user = users_dao.renew_session(update_token)
    except:
        return json.dumps({'success': False, 'error': 'Invalid update token'})

    return json.dumps({
        'success': True,
        'data': user.serialize()
    })

@app.route('/api/user/favorites/', methods=['GET'])
def get_favorites():
    success, session_token = extract_token(request)

    if not success:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'success': False, 'error': 'Invalid session token'})

    return json.dumps({'success': True, 'favorites': [f.serialize() for f in user.favorites]})

@app.route('/api/user/favorite/add/', methods = ['POST'])
def favorite():
    post_body = json.loads(request.data)
    
    #check session token
    success, session_token = extract_token(request)

    if not success:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'success': False, 'error': 'Invalid session token'})

    recipe = Recipe.query.filter_by(id=post_body.get("recipe_id")).first()
    if recipe is not None:
        user.favorites.append(recipe)
        db.session.commit()
        return json.dumps({'success': True, 'favorites': [f.serialize() for f in user.favorites]}), 200

    return json.dumps({'success': False, 'error': 'Recipe not found'}), 404

@app.route('/api/user/favorite/remove/', methods = ['POST'])
def unfavorite():
    post_body = json.loads(request.data)
    #check session token
    success, session_token = extract_token(request)

    if not success:
        return session_token
    
    user = users_dao.get_user_by_session_token(session_token)
    if not user or not user.verify_session_token(session_token):
        return json.dumps({'success': False, 'error': 'Invalid session token'})

    recipe = Recipe.query.filter_by(id=post_body.get("recipe_id")).first()
    if recipe is not None:
        if recipe in user.favorites:
            user.favorites.remove(recipe)
            db.session.commit()
            return json.dumps({'success': True, 'favorites': [f.serialize() for f in user.favorites]}), 200
        return json.dumps({'success': False, 'error': 'Recipe not found in favorites'})

    return json.dumps({'success': False, 'error': 'Recipe not found'}), 404

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
