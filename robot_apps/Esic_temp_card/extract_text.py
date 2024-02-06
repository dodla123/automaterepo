# extract_text.py

def extract_captcha():
    screenshot_path = "/home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_temp_card/screenshot.png"
    import requests
    import json
    url = "http://10.12.0.70/epf-cap-predict/"
    files = {'file': (screenshot_path, open(screenshot_path, 'rb'), 'multipart/form-data')}
    response = requests.post(url, files=files)
    print(response.text,'$$$$$$$$$$$$$$$$$$')
    captcha_code = json.loads(response.text).get('prediction') 

    with open("cleaned_text.txt", "w") as file:
        file.write(captcha_code.strip())
        print("Cleaned Text written to 'cleaned_text.txt'")  


extract_captcha()