# Uses the POEditorAPI to download the translated files into json key-value pairs for use in the application.

import os
import requests
from poeditor import POEditorAPI

def switch_languages(languageCode):
    switch = {
        'en': True,
        'es':True
        }   
    return switch.get(languageCode,False)

def downloadFromPOEditor(outputFilename, projectCode, languageCode, fileFormat):
    if os.path.exists(outputFilename):
        os.remove(outputFilename)
    file_from_poeditor_url = client.export(projectCode, languageCode, fileFormat)
    
    r = requests.get(file_from_poeditor_url[0])
    with open(outputFilename, "wb") as file:
        file.write(r.content)
    print("Download complete: " + outputFilename)    

currentPath = os.path.dirname(os.path.realpath(__file__))

client = POEditorAPI(api_token='ed258059c5d2a3ea672e012697b2d1db')
iiot_project_id = 401837

languages = client.list_project_languages(401837)

fileOutputs = []
for lan in languages:
    shouldProcess = switch_languages(lan['code'])
    if (shouldProcess):
        relativePath = os.path.abspath(os.path.join(currentPath, '..', 'assets'))
        relativePath = os.path.join(relativePath,'translations')
        relativePath = os.path.join(relativePath,lan['code']+'.json')
        fileOutputs.append(relativePath)
        downloadFromPOEditor(relativePath,iiot_project_id,lan['code'],"key_value_json")

print(fileOutputs)
