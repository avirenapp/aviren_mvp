import time, requests
from datetime import datetime
from google.cloud import firestore

cred_path = r'/PATH/'
db = firestore.Client.from_service_account_json(cred_path)
collection_name = 'users'
collection_ref = db.collection(collection_name)
docs = collection_ref.stream()


for doc in docs:
    user_unix = doc.get('unix')
    user_email = doc.get("email")
    timestamp = datetime.utcfromtimestamp(user_unix)
    current_utc_time = time.time()
    time_difference = round(current_utc_time) - user_unix
    
    if time_difference < 86400:
        print(user_email + " is not eligible")
        continue
    
    user_clock_time = int(doc.get('readTime'))
    user_openedLetter = doc.get('openedLetter')
    user_responseLetter = doc.get('responseLetter')
    
    current_time_seconds = time.time()
    local_time_struct = time.localtime(current_time_seconds)
    current_hour = local_time_struct.tm_hour
    day = local_time_struct.tm_mday
    month = local_time_struct.tm_mon

    server_date_time = str(month)+str(day)
    server_clock_time = int(current_hour)

    print(user_clock_time)
    print(server_clock_time)

    treshold = user_clock_time * 2
    response_length = 0
    if(user_openedLetter == True):

        try:
            #Header 1   
            response1 = requests.post("REDACTED", headers={"Content-Type": "application/json"},json={"prompt_parts": user_responseLetter})
            generated_text1 = response1.text
 
            if(len(generated_text1) > 300):
                last_full_stop_index = generated_text1.rfind('.', 0, 300)
                crop_index = last_full_stop_index if last_full_stop_index != -1 else 300
                generated_text1 = generated_text1[:crop_index].strip() + "."

            print(generated_text1)
            
            doc.reference.set({
                'generatedLetter_header1': generated_text1,
                'openedLetter': False,
                'respondLetter': False,
            }, merge=True)
            response_length = len(generated_text1)
            print("Header 1 generated successfully")

        except:
            #Base case
            doc.reference.set({
                'openedLetter': True,
                'respondLetter': True,
            }, merge=True)
            print("Failed to generate text. Error")
            continue

        try:
            if(response_length >= 150):
                doc.reference.set({
                    'generatedLetter_header2': "",
                    'openedLetter': False,
                    'respondLetter': False,
                }, merge=True)
                continue
            #Header 2
            response2 = requests.post("REDACTED", headers={"Content-Type": "application/json"})

            generated_text2 = response2.text  
            print(response2.text)

            doc.reference.set({
                'generatedLetter_header2': generated_text2,
                'openedLetter': False,
                'respondLetter': False,
            }, merge=True)

            print("Header 2 generated successfully")    
            
        except: 
            #Base case
            doc.reference.set({
                'openedLetter': True,
                'respondLetter': True,
            }, merge=True)
            print("Failed to generate text. Error")
            continue
        print(user_email + " is eligible")
    else:
        print(user_email + " is not eligible")
