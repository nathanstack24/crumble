from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

association_table = db.Table(
    'association',
    db.Column('recipe_id', db.Integer, db.ForeignKey('recipe.id')),
    db.Column('ingredient_id', db.Integer, db.ForeignKey('ingredient.id'))
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
    #tags
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    ingredients = db.relationship("Ingredient", secondary = association_table, back_populates = "recipes")

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
            'ingredients': [i.serialize() for i in self.ingredients]
            #tags
        }

class Ingredient(db.Model):
    __tablename__ = 'ingredient'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    #quantity = db.Column(db.Float, nullable=False)
    #units = db.Column(db.String, nullable=False)
    recipes = db.relationship("Recipe", secondary = association_table, back_populates = "ingredients")

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        #self.quantity = kwargs.get('quantity', -1)
        #self.units = kwargs.get('units', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            #'quantity': str(self.quantity) + ' ' + self.units
        }

# class Assignment(db.Model):
#     __tablename__ = 'assignment'
#     id = db.Column(db.Integer, primary_key=True)
#     description = db.Column(db.String, nullable = False)
#     due_date = db.Column(db.Integer, nullable = False)
#     class_id = db.Column(db.Integer, db.ForeignKey('class.id'), nullable=False)
#     associated_class = db.relationship('Class', back_populates = "assignments")

#     def  __init__(self, **kwargs):
#         self.description = kwargs.get('description', '')
#         self.due_date = kwargs.get('due_date', -1)
#         self.class_id = kwargs.get('class_id')

#     def serialize(self):
#         return {
#             'id': self.id,
#             'description': self.description,
#             'due_date': self.due_date,
#             'class': {
#                 "id": self.associated_class.id,
#                 "code": self.associated_class.code,
#                 "name": self.associated_class.name,
#             }
#         }

class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)
    favorites = db.relationship("Recipe", cascade='delete')

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')

    def serialize(self):
        return {
            'id': self.id,
            'name': self.name,
            'favorites': [f.serialize() for f in self.favorites]
        }
