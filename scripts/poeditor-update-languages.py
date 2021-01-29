# Uses the POEditorAPI to download the translated files into json key-value pairs for use in the application.
# :param (1) syncTerms True/False | Determines whether or not to sync terms in POEditor. 
# Syncing will allow removal of terms if they do not exist in the json file being uploaded.

import sys
import os
from poeditor import POEditorAPI

def switch_languages(languageCode):
    switch = {
        'en': True
        }   
    return switch.get(languageCode,False)

def updatePOEditor(inputFileName, projectId, syncTerms=False):
    response = client.update_terms_translations(projectId, inputFileName, 'en', sync_terms=syncTerms)
    print("Update complete: " + str(response))

syncTerms = False
if (len(sys.argv) > 1):
    syncTerms = str(sys.argv[1])

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
        updatePOEditor(relativePath,iiot_project_id,syncTerms)

print(fileOutputs)
