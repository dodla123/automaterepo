*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    Process
Library    OperatingSystem

*** Variables ***
${BROWSER}                chrome
${URL}                    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
${PYTHON_PATH}            python3
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/screenshotT.png
${username}               36640741797
${password}               e7d92
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/extracted_text.txt
${MAX_LOGIN_ATTEMPTS}     10
${TEXT}                   ${EMPTY}
# ${URL}                    https://www.tgct.gov.in/tgportal/


*** Keywords ***
Login
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_ptinno
    Input Text    id=ContentPlaceHolder1_txt_ptinno    ${username}
    Sleep    1s
    Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_pwd 
    Input Password    id=ContentPlaceHolder1_txt_pwd   ${password}
    Sleep    1s
    Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
    Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
    ${text_from_python_script}=    Run Process    ${PYTHON_PATH}      extract.py  
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
    Execute Javascript    document.querySelector('#ContentPlaceHolder1_btn_submit')
    # Click Element    id=ContentPlaceHolder1_btn_submit
    # Log    bbbbbbbb
    ${popup_present}=    Handle Popup    # Check if a pop-up is present
    Run Keyword If    ${popup_present}    Log    Pop-up handled successfully.
    ...    ELSE    Log    No pop-up present.
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url}

Handle Popup
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present    timeout=10s
    Run Keyword If    ${alert_present}    Handle Alert

Switch To Alert
    Switch To Alert

Handle Alert
    Switch To Alert    # Switch focus to the alert
    Sleep    2s   
    
*** Test Cases ***
Run Login Process Loop
    Open Browser    ${URL}    ${BROWSER}    
    Maximize Browser Window
    
    FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
        ${current_url}=    Login     ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
    END

    Click Element    xpath://*[@id="form1"]/div[4]/div[1]/ul/li[2]/a
    Sleep    10s


# *** Settings ***
# Library    RPA.Browser.Selenium           auto_close=${False}
# Library    Process
# Library    OperatingSystem

# *** Variables ***
# ${BROWSER}                chrome
# ${URL}                    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
# # ${URL}                    https://www.tgct.gov.in/tgportal/
# ${PYTHON_PATH}            python3
# ${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/screenshotT.png
# ${username}               36640741797
# ${password}               e7d92
# ${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/extracted_text.txt
# ${MAX_LOGIN_ATTEMPTS}     10
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
#     Execute Javascript    document.querySelector('#ContentPlaceHolder1_btn_submit')
#     # Click Button    id=ContentPlaceHolder1_btn_submit
#     Sleep    1s
#     # Switch Window
#     Click Element    xpath:/html/body/form/div[4]/div[1]/ul/li[2]/a
#     Sleep    10s
#     # Click Element    xpath:                                            // for selecting the month
#     # Click Element    xpath:                                            // for submit    