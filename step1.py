import json
import time
import numpy as np
import pymongo
import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
#from selenium.webdriver.firefox.firefox_binary import FirefoxBinary

recipe_list = []

def scrape_recipe(br, idnumber):
	
	#recipe title
	try:
		rtitle = br.find_element_by_tag_name('h1').text
	except Exception as e:
		print(e)
		rtitle = 'NA'

	#description
	try:
		description = br.find_element_by_class_name('submitter__description').text
	except Exception as e:
		print(e)
		description = 'NA'

	#Star rating
	try:
		starrating = br.find_element_by_class_name('rating-stars').get_attribute('data-ratingstars')
	except Exception as e:
		print(e)
		starrating = 'NA'
		
	#Number of reviews
	try:
		numReviews = br.find_element_by_class_name('review-count').text
		numReviews = numReviews.replace(' reviews', '')
		numReviews = int(float(numReviews))
	except Exception as e:
		print(e)
		numReviews = 'NA'

	#Servings
	try:
		servings = br.find_element_by_class_name('servings-count').text
		servings = servings.replace(' servings', '')
		servings = int(float(servings))
	except Exception as e:
		print(e)
		servings = 'NA'

	#images
	try:
		imageURL = br.find_element_by_id('BI_openPhotoModal1').get_attribute('src')
	except Exception as e:
		print(e)
		servings = 'NA'
		
	#calories per serving
	try:
		calcount = br.find_element_by_class_name('calorie-count').text
		calcount = calcount.replace(' cals', '')
		calcount = int(float(calcount))
	except Exception as e:
		print(e)
		calcount = 'NA'

	#fat (grams)
	try:
		fat = float(br.find_element_by_xpath('//span[@itemprop = "fatContent"]').text)
	except Exception as e:
		print(e)
		fat = 'NA'

	#carbs (grams)
	try:
		carbs = float(br.find_element_by_xpath('//span[@itemprop = "carbohydrateContent"]').text)
	except Exception as e:
		print(e)
		carbs = 'NA'

	#protein (grams)
	try:
		protein = float(br.find_element_by_xpath('//span[@itemprop = "proteinContent"]').text)
	except Exception as e:
		print(e)
		protein = 'NA'

	#cholesterol (mg)
	try:
		chol = float(br.find_element_by_xpath('//span[@itemprop = "cholesterolContent"]').text)
	except Exception as e:
		print(e)
		chol = 'NA'

	#sodium (mg)
	try:
		sodium = float(br.find_element_by_xpath('//span[@itemprop = "sodiumContent"]').text)
	except Exception as e:
		print(e)
		sodium = 'NA'
		
	# #prep time
	try:
		prepTime = br.find_element_by_xpath('//time[@itemprop = "prepTime"]').get_attribute('datetime')
		prepTime = prepTime.replace('PT', '')
		time_components = prepTime.split("H")
		if len(time_components) == 1:
			mins = time_components[0].replace('M', '')
			prepTime = int(float(mins))
		else:
			mins = time_components[1].replace('M', '')
			prepTime = int(float(time_components[0]))*60 + int(float(mins))
	except Exception as e:
		print(e)
		prepTime = 'NA'

	#Cook time
	try:
		cookTime = br.find_element_by_xpath('//time[@itemprop = "cookTime"]').get_attribute('datetime')
		cookTime = cookTime.replace('PT', '')
		time_components = cookTime.split("H")
		if len(time_components) == 1:
			mins = time_components[0].replace('M', '')
			cookTime = int(float(mins))
		else:
			mins = time_components[1].replace('M', '')
			cookTime = int(float(time_components[0]))*60 + int(float(mins))
	except Exception as e:
		print(e)
		cookTime = 'NA'

	#total time
	try:
		totalTime = br.find_element_by_xpath('//time[@itemprop = "totalTime"]').get_attribute('datetime')
		#totalTime = str(re.findall('PT(\w+)', t)[0])
		totalTime = totalTime.replace('PT', '')
		time_components = totalTime.split("H")
		if len(time_components) == 1:
			mins = time_components[0].replace('M', '')
			totalTime = int(float(mins))
		else:
			mins = time_components[1].replace('M', '')
			totalTime = int(float(time_components[0]))*60 + int(float(mins))
	except Exception as e:
		print(e)
		totalTime = 'NA'

	#instructions
	instructions_list = []
	instr = br.find_elements_by_class_name("step")
	for x in np.arange(len(instr)-1):
		instructions_list.append(str(instr[x].text))

	instructions = instructions_list[0]
	for i in range(1, len(instructions_list)):
		instructions = instructions + " " + instructions_list[i]

	#ingredients
	ingredients = []
	ingred = br.find_elements_by_class_name("checkList__item")
	for x in np.arange(len(ingred)-1):
		#ingredients.append(str(ingred[x].text.encode('ascii', 'ignore')))
		ingredients.append(str(ingred[x].text))

	#make dictionary of all scraped data and add to list of recipes
	recipe_list.append(
		{
			"title": rtitle,
			"Author" '',
			"Source": 'allrecipes',
			"description": description,
			"fat": fat,
			"carbs": carbs,
			"protein": protein,
			"cholesterol": chol,
			"sodium": sodium,
			"rating": starrating,
			"number of reviews": numReviews,
			"prep time": prepTime,
			"cook time": cookTime,
			"total time": totalTime,
			"servings": servings,
			"calories": calcount,
			"fat": fat,
			"ingredients": ingredients,
			"instructions": instructions,
			"image URL": imageURL
		}
	)

	print("done - " + rtitle)



br = webdriver.Firefox() #open firefox
br.get('https://www.allrecipes.com/recipes/'+ '14486/everyday-cooking/special-collections/hall-of-fame/1997/?internalSource=hub%20nav&referringId=14452&referringContentType=Recipe%20Hub&linkName=hub%20nav%20daughter&clickId=hub%20nav%202')


html_list = br.find_element_by_id("fixedGridSection")
urls = html_list.find_elements(By.CLASS_NAME, "favorite") # ID's are in the favorite elements

ids = []

for i, e in enumerate(urls):
		ids.append(e.get_attribute('data-id'))	
		urls[i] = 'https://allrecipes.com/recipe/' + str(ids[i]) # update urls list to current year

#remove any repeats
urls = np.unique(urls)
id = np.unique(id)

#go to each individual recipe to scrape 
for i, url in enumerate(urls):
	if i < 1:
		br.get(url)
		time.sleep(3)
		scrape_recipe(br, ids[i])

print(recipe_list)
print()
with open('recipes.json', 'w') as outfile:
	json.dump(recipe_list, outfile)