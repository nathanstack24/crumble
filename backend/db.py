from flask_sqlalchemy import SQLAlchemy
import bcrypt
import datetime
import hashlib
import os

db = SQLAlchemy()

association_table_i = db.Table(
    'association_i',
    db.Column('recipe_id', db.Integer, db.ForeignKey('recipe.id')),
    db.Column('ingredient_id', db.Integer, db.ForeignKey('ingredient.id'))
)

association_table_t = db.Table(
    'association_t',
    db.Column('recipe_id', db.Integer, db.ForeignKey('recipe.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)

class Recipe(db.Model):
    __tablename__ = 'recipe'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String, nullable=False)
    author = db.Column(db.String, nullable=False)
    source = db.Column(db.String, nullable=False)
    description = db.Column(db.String, nullable=False)
    rating = db.Column(db.Float, nullable=False)
    num_reviews = db.Column(db.String, nullable=False)
    prep_time = db.Column(db.Integer, nullable=False)
    cook_time = db.Column(db.Integer, nullable=False)
    total_time = db.Column(db.Integer, nullable=False)
    servings = db.Column(db.Integer, nullable=False)
    calories = db.Column(db.Integer, nullable=False)    # if -1 then not filled out
    fat = db.Column(db.Float, nullable=False)
    carbs = db.Column(db.Float, nullable=False)
    protein = db.Column(db.Float, nullable=False)
    cholesterol = db.Column(db.Float, nullable=False)
    sodium = db.Column(db.Float, nullable=False)
    instructions = db.Column(db.String, nullable=False)
    image_url = db.Column(db.String, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    ingredients = db.relationship("Ingredient", secondary = association_table_i, back_populates = "recipes")
    tags = db.relationship("Tag", secondary = association_table_t, back_populates = "recipes")

    def  __init__(self, **kwargs):
        self.title = kwargs.get('title', '')
        self.author = kwargs.get('author', '')
        self.source = kwargs.get('source', '')
        self.description = kwargs.get('description', '')
        self.rating = kwargs.get('rating', '')
        self.num_reviews = kwargs.get('num_reviews', -1)
        self.prep_time = kwargs.get('prep_time', '')
        self.cook_time = kwargs.get('cook_time', '')
        self.total_time = kwargs.get('total_time', '')
        self.servings = kwargs.get('servings', -1)
        self.calories = kwargs.get('calories', -1)
        self.fat = kwargs.get('fat', '')
        self.carbs = kwargs.get('carbs', '')
        self.protein = kwargs.get('protein', '')
        self.cholesterol = kwargs.get('cholesterol', '')
        self.sodium = kwargs.get('sodium', '')
        self.instructions = kwargs.get('instructions', '')
        self.image_url = kwargs.get('image_url', '')


    def serialize(self):

        return {
            'id': self.id,
            'title': self.title,
            'author': self.author,
            'source': self.source,
            'description': self.description,
            'rating': self.rating,
            'num_reviews': self.num_reviews,
            'prep_time': self.prep_time,
            'cook_time': self.cook_time,
            'total_time': self.total_time,
            'servings': self.servings,
            'calories': self.calories,
            'fat': self.fat,
            'carbs': self.carbs,
            'protein': self.protein,
            'cholesterol': self.cholesterol,
            'sodium': self.sodium,
            'instructions': self.instructions,
            'image_url': self.image_url,
            'ingredients': [i.name for i in self.ingredients],
            'tags': [t.name for t in self.tags]
        }

class Ingredient(db.Model):
    __tablename__ = 'ingredient'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    recipes = db.relationship("Recipe", secondary = association_table_i, back_populates = "ingredients")

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name
        }

class Tag(db.Model):
    __tablename__ = 'tag'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    recipes = db.relationship("Recipe", secondary = association_table_t, back_populates = "tags")

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name
        }



class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    favorites = db.relationship("Recipe", cascade='delete')

    #user info
    name = db.Column(db.String, nullable=False)
    email = db.Column(db.String, nullable=False)
    password_digest = db.Column(db.String, nullable=False)

    #session info
    session_token = db.Column(db.String, nullable=False, unique=True)
    session_expiration = db.Column(db.DateTime, nullable=False)
    update_token = db.Column(db.String, nullable=False, unique=True)

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.email = kwargs.get('email')
        self.password_digest = bcrypt.hashpw(kwargs.get('password').encode('utf8'), bcrypt.gensalt(rounds=13))
        self.renew_session()

    def serialize(self):
        return {
            'session_token': self.session_token,
            'session_expiration': str(self.session_expiration),
            'update_token': self.update_token,
        }
    
    # Used to randomly generate session/update tokens
    def _urlsafe_base_64(self):
        return hashlib.sha1(os.urandom(64)).hexdigest()

    # Generates new tokens, and resets expiration time
    def renew_session(self):
        self.session_token = self._urlsafe_base_64()
        self.session_expiration = datetime.datetime.now() + \
                                datetime.timedelta(days=1)
        self.update_token = self._urlsafe_base_64()

    def verify_password(self, password):
        return bcrypt.checkpw(password.encode('utf8'),
                              self.password_digest)

    # Checks if session token is valid and hasn't expired
    def verify_session_token(self, session_token):
        return session_token == self.session_token and \
            datetime.datetime.now() < self.session_expiration

    def verify_update_token(self, update_token):
        return update_token == self.update_token
