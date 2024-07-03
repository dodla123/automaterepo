
def extract_captcha(SCREENSHOT_FILE, API_URL):
    import requests
    import json

    files = {'file': (SCREENSHOT_FILE, open(SCREENSHOT_FILE, 'rb'), 'multipart/form-data')}
    response = requests.post(API_URL, files=files)
    
    print(response.text, '$$$$$$$$$$$$$$$$$$')
    
    captcha_code = json.loads(response.text).get('prediction') 

    with open("cleaned_text.txt", "w") as file:
        file.write(captcha_code.strip())
        print("Cleaned Text written to 'cleaned_text.txt'")  

# The following code will execute only if the script is run directly, not imported as a module.
if __name__ == "__main__":
    # Example usage
    import sys
    extract_captcha(sys.argv[1], sys.argv[2])







# # extract_text.py

# def extract_captcha():
#     screenshot_path = "/home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/ESIC_Temp_Card/screenshot.png"
#     import requests
#     import json
#     url = "http://10.12.0.130/epf-cap-predict/"
#     files = {'file': (screenshot_path, open(screenshot_path, 'rb'), 'multipart/form-data')}
#     response = requests.post(url, files=files)
#     print(response.text,'$$$$$$$$$$$$$$$$$$')
#     captcha_code = json.loads(response.text).get('prediction') 

#     with open("cleaned_text.txt", "w") as file:
#         file.write(captcha_code.strip())
#         print("Cleaned Text written to 'cleaned_text.txt'")  


# extract_captcha()