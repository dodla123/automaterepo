*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    Collections
Library    OperatingSystem
Library    String
Library    RPA.Desktop
Library    RPA.JSON
*** Variables ***
${excel_file_path}    /home/buzzadmin/Downloads/UAN.xlsx
${username}           BUZZWORKS2012
${password}           Bu$$2023Work$
*** Keywords ***
Open EPF India Website
    Open Browser    https://www.epfindia.gov.in/site_en/index.php#    chrome    options=add_experimental_option("detach", True)    
    Wait Until Element Is Visible    xpath://*[@id="ecr_panel_1"]    timeout=30    error=Unable to launch EPF website

Click ECR/Returns/Payment Button
    Click Element When Visible    xpath://*[@id="ecr_panel_1"]
    Switch Window    EPFO: Home    timeout=30s
    Maximize Browser Window
    Wait Until Element Is Visible    xpath://*[@id="btnCloseModal"]    timeout=30s    error=Unable to find Alert Popup

Accept Popup
    Click Button When Visible   xpath://*[@id="btnCloseModal"]  
    Log    Opened EPFO login page

Enter Username and Password
    Wait Until Element Is Visible    xpath://*[@id="username"]    timeout=30s    error=Unable to find username input
    Input Text    xpath://*[@id="username"]    ${username}       
    Input Text    xpath://*[@id="password"]    ${password}                
    Log    Entered username and password   

Click Signin Button
    Click Button When Visible    //button[@class='btn btn-success btn-logging']

Check UAN Presence
    [Arguments]    ${uan_number}
    ${is_uan_present}=    Check UAN Presence    ${uan_number}   
    [Return]    ${is_uan_present}

Click Yes Button
    Log     'Yes Clicked'
    Select Radio Button    isPreviousEmployee    Y

Click No Button
    Log     'No Clicked'
    Select Radio Button    isPreviousEmployee    N 

Amount Extraction
    # Input Text     xpath://*[@id="memberName"]    MANASA
    Wait Until Element Is Visible    xpath://*[@id="nationality"]
    ${text}=    Get Text    xpath://*[@id="nationality"]
    Log    ${text}
    Input Text    id=fatherHusbandName   ${text}        


*** Test Cases ***
Automate EPFO Webpage
    Open EPF India Website
    Click ECR/Returns/Payment Button
    Accept Popup
    Enter Username and Password
    Click Signin Button
    Click Element When Visible   //*[contains(@class, 'dropdown-toggle') and contains(text(), 'Member')]
    Click Element When Visible  //ul[@class='dropdown-menu m1']//a[text()='REGISTER-INDIVIDUAL']
    Amount Extraction
    # Input Text    id=memberName    234




# *** Settings ***
# Library    RPA.Browser.Selenium           auto_close=${False}
# Library    Process
# Library    OperatingSystem

# *** Variables ***
# ${BROWSER}                firefox
# ${URL}                    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
# ${PYTHON_PATH}            python3
# ${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/PT_filling/PT-Telang/screenshotT.png
# ${username}               36640741797
# ${password}               e7d92
# ${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/PT_filling/PT-Telang/extracted_text.txt
# ${MAX_LOGIN_ATTEMPTS}     10
# ${TEXT}                   ${EMPTY}
# # ${URL}                    https://www.tgct.gov.in/tgportal/


# *** Keywords ***
# Login
#     [Arguments]    ${username}    ${password}
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_ptinno
#     Input Text    id=ContentPlaceHolder1_txt_ptinno    ${username}
#     Sleep    1s
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_pwd 
#     Input Password    id=ContentPlaceHolder1_txt_pwd   ${password}
#     Sleep    1s
#     Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
#     Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
#     ${text_from_python_script}=    Run Process    ${PYTHON_PATH}      extract.py  
#     ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
#     Log    File Content: ${file_content} 
#     Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
#     Click Button     xpath://*[@id="ContentPlaceHolder1_btn_submit"]
#     # Run Keyword    Handle Popup
#     ${current_url}=    Get Location
#     # Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Handle Login Failure
#     # ...    ELSE    Log    Login successful. Continuing with other steps...
#     [Return]    ${current_url}

# Handle Login Failure
#     Log    Login failed. Handling popup and retrying...
#     Handle Popup
#     # Add additional steps if needed for handling login failure
#     # For example, you can take a screenshot, log relevant information, etc.
#     # ...
#     [Return]    ${EMPTY}

# Handle Popup
#     Handle Alert
#     # Add additional steps to handle other types of pop-ups if needed
#     # ...
#     [Return]    ${EMPTY}
# # Handle Popup
# #     Handle Alert    


# *** Test Cases ***
# Run Login Process Loop
#     Open Browser    ${URL}    ${BROWSER}    
#     Maximize Browser Window
#     # Scroll Element Into View    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a
#     # Sleep    2s
#     # Click Element    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a
#     FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
#         ${current_url}=    Login    ${username}    ${password}
#         Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
#         ...    ELSE    Log    Login successful. Exiting the loop.
#         Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Handle Login Failure
#         Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
#     END
    
#     Click Element    xpath://*[@id="form1"]/div[4]/div[1]/ul/li[2]/a
#     Sleep    10s



# *** Settings ***
# Library    RPA.Browser.Selenium           auto_close=${False}
# Library    Process
# Library    OperatingSystem

# *** Variables ***
# ${BROWSER}                chrome
# ${URL}                    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
# # ${URL}                    https://www.tgct.gov.in/tgportal/
# ${PYTHON_PATH}            python3
# ${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/screenshotT.png
# ${username}               36640741797
# ${password}               e7d92
# ${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/extracted_text.txt
# ${MAX_LOGIN_ATTEMPTS}     2
# ${TEXT}                   ${EMPTY}

# *** Test Cases ***
# Login
#     # [Arguments]    ${username}    ${password}
#     Open Browser    ${URL}    ${BROWSER}
#     Maximize Browser Window
#     # Scroll Element Into View    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a
#     # Click Element    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_ptinno
#     Input Text    id=ContentPlaceHolder1_txt_ptinno    ${username}
#     Sleep    1s
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_pwd
#     Input Password    id=ContentPlaceHolder1_txt_pwd    ${password}
#     Sleep    1s
#     Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
#     Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
#     ${text_from_python_script}=    Run Process    ${PYTHON_PATH}    extract.py
#     ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
#     Log    File Content: ${file_content}
#     Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
#     Sleep    1s
#     Click Button     xpath://*[@id="ContentPlaceHolder1_btn_submit"]
#     Sleep    1s
#     Click Element    xpath:/html/body/form/div[4]/div[1]/ul/li[2]/a
#     Sleep    10s


    # Run Keyword If    Element Exists    Handle Popup   
    # ${current_url}=    Get Location
    # Log    Current URL: ${current_url}
    # [Return]    ${current_url}

# Enter Captcha
#     Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
#     Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
#     ${text_from_python_script}=    Run Process    ${PYTHON_PATH}    extract.py
#     ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
#     Log    File Content: ${file_content}
#     Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
#     Sleep    1s

# Handle Popup
#     Handle Alert

# *** Test Cases ***
# Run Login Process Loop
#     Open Browser    ${URL}    ${BROWSER}
#     Maximize Browser Window
#     # Scroll Element Into View    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a
#     # Click Element    xpath:/html/body/div/div[2]/div/div[4]/div[1]/div/div/div/div[1]/div[1]/div[5]/ul/li[3]/a

#     FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
#         ${current_url}=    Login    ${username}    ${password}
#         Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
#         ...    ELSE    Log    Login successful. Exiting the loop.
#         Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
#         # Handle Popup
#     END
    
#     Click Element    xpath://*[@id="form1"]/div[4]/div[1]/ul/li[2]/a
#     Sleep    10s

# *** Settings ***
# Library    RPA.Browser.Selenium           auto_close=${False}
# Library    Process
# Library    OperatingSystem

# *** Variables ***
# ${BROWSER}                chrome
# ${URL}                    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
# ${PYTHON_PATH}            python3
# ${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/screenshotT.png
# ${username}               36640741797
# ${password}               e7d92
# ${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/extracted_text.txt
# ${MAX_LOGIN_ATTEMPTS}     10
# ${TEXT}                   ${EMPTY}


# *** Keywords ***
# Login
#     [Arguments]    ${username}    ${password}    ${enter_username}=True    ${enter_captcha}=True
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_ptinno
#     Run Keyword If    ${enter_username}    Input Text    id=ContentPlaceHolder1_txt_ptinno    ${username}
#     Sleep    1s
#     Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_pwd
#     Input Password    id=ContentPlaceHolder1_txt_pwd    ${password}
#     Sleep    1s
#     Run Keyword If    ${enter_captcha}    Enter Captcha
#     Click Button    xpath://*[@id="ContentPlaceHolder1_btn_submit"]
#     ${current_url}=    Get Location
#     Log    Current URL: ${current_url}
#     [Return]    ${current_url}

# Enter Captcha
#     Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
#     Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
#     ${text_from_python_script}=    Run Process    ${PYTHON_PATH}    extract.py
#     ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
#     Log    File Content: ${file_content}
#     Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
#     Sleep    1s

# Handle Popup
#     Handle Alert

# *** Test Cases ***
# Run Login Process Loop
#     Open Browser    ${URL}    ${BROWSER}
#     Maximize Browser Window

#     FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
#         ${current_url}=    Login    ${username}    ${password}      
#         Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
#         ...    ELSE    Log    Login successful. Exiting the loop.
#         Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
#         Run Keyword    Handle Popup
#     END

    
    # Wait Until Element Is Visible    id=Login_user_name     
    # Input Text    id=Login_user_name    ${username}
    # Sleep    1s
    # Wait Until Element Is Visible    id=id_pwd  
    # Input Password    id=id_pwd    ${password}
    # Sleep    1s
    # Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
    
    
    
    # Execute JavaScript    document.getElementById('ContentPlaceHolder1_txt_captcha').focus()
    # sleep    10s
    # Click Button     xpath://*[@id="id_btn_login"]
    # Sleep    1s
    # Click Element    xpath:/html/body/div[2]/main/div[1]/div[2]/div[1]/div/div/form/button
    # Click Element    xpath://*[@id="return_5a_ret_per_type"]
    # Click Element    xpath://*[@id="return_5a_ret_per_type"]
    # Click Element    xpath://*[@id="return_5a_perd_year"]
    # Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[2]/select/option[2]
    # Click Element    xpath://*[@id="return_5a_perd_month"]
    # Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[3]/select/option[12]
    # Click Button     xpath://*[@id="btn-login"]


    
    
# *** Keywords ***
# Login Process
#     [Arguments]    ${username}    ${password}
#     Wait Until Element Is Visible    id=txtUserName     
#     Input Text    id=txtUserName    ${username}
#     Sleep    1s
#     Log    ${username}
#     Wait Until Element Is Visible    id=txtPassword    
#     Input Password    id=txtPassword    ${password}
#     Sleep    1s
#     Log    ${password} 
#     Wait Until Element Is Visible    xpath=//*[@id='img1']
#     Capture Element Screenshot    xpath=//*[@id='img1']    ${SCREENSHOT_FILE}
#     ${text_from_python_script}=    Run Process    ${PYTHON_PATH}      extract_text.py  
#     ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
#     Log    File Content: ${file_content} 
#     Input Text    id=txtChallanCaptcha     ${file_content}
#     Click Button    xpath://*[@id="btnLogin"]  # Assuming this is the login button
#     ${current_url}=    Get Location
#     Log    Current URL: ${current_url}
#     [Return]    ${current_url}


    
    # ${timestamp}=    Get Current Date    result_format=%Y%m%d_%H%M%S
    # ${SCREENSHOT_FILE}    Catenate    SEPARATOR=    ${BASE_SCREENSHOT_PATH}_${timestamp}${EXTENSION}
    
    # Capture Element Screenshot    xpath=//*[@id="captcha_image"]    ${SCREENSHOT_FILE}
    # END






