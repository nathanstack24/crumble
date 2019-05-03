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
    name = db.Column(db.String, nullable=False)
    source = db.Column(db.String, nullable=False)
    time = db.Column(db.Integer, nullable=False)
    servings = db.Column(db.Integer, nullable=False)
    comments = db.Column(db.String, nullable=False)
    calories = db.Column(db.Integer, nullable=False)    # if -1 then not filled out
    #fat = db.Column(db.Integer, nullable=False)
    #satfat = db.Column(db.Integer, nullable=False)
    #carbs = db.Column(db.Integer, nullable=False)
    #fiber = db.Column(db.Integer, nullable=False)
    #sugar = db.Column(db.Integer, nullable=False)
    #protein = db.Column(db.Integer, nullable=False)
    instructions = db.Column(db.String, nullable=False)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    ingredients = db.relationship("Ingredient", secondary = association_table, back_populates = "recipes")

    def  __init__(self, **kwargs):
        self.name = kwargs.get('name', '')
        self.source = kwargs.get('source', '')
        self.time = kwargs.get('time', -1)
        self.servings = kwargs.get('servings', -1)
        self.comments = kwargs.get('comments', '')
        self.calories = kwargs.get('calories', -1)
        self.instructions = kwargs.get('instructions', '')


    def serialize(self):

        return {
            'id': self.id,
            'name': self.name,
            'source': self.source,
            'time': self.time,
            'comments': self.comments,
            'calories': self.calories,
            'instructions': self.instructions,
            'ingredients': [i.serialize() for i in self.ingredients]
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
