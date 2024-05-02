*** Settings ***
Library    SeleniumLibrary    
Library    Process
Library    OperatingSystem
Library    RPA.Desktop

*** Variables ***
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/screenshotT.png
${username}               36640741797
${password}               e7d92
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-Telang/extracted_text.txt
${TEXT}                   ${EMPTY}
${Pay_range_1}            1
${Pay_range_2}            2
${Pay_range_3}            3
# ${BROWSER}              chrome
# ${URL}                  https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx
# ${PYTHON_PATH}          python3
# ${URL}                  https://www.tgct.gov.in/tgportal/


*** Keywords ***
Open website
    Open Browser    https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx    firefox    #options=add_experimental_option("detach", True)  
    Maximize Browser Window

Login Process
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_ptinno
    Input Text    id=ContentPlaceHolder1_txt_ptinno    ${username}
    Sleep    1s
    Wait Until Element Is Visible    id=ContentPlaceHolder1_txt_pwd 
    Input Password    id=ContentPlaceHolder1_txt_pwd   ${password}
    Sleep    1s
    Wait Until Element Is Visible    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]
    Capture Element Screenshot    xpath://*[@id="ContentPlaceHolder1_lblCaptcha"]    ${SCREENSHOT_FILE}
    ${text_from_python_script}=    Run Process    python3      extract.py  
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=ContentPlaceHolder1_txt_captcha    ${file_content}
    Sleep    10s
    Click Element    id=ContentPlaceHolder1_btn_submit
    # Execute Javascript    document.querySelector('#ContentPlaceHolder1_btn_submit')
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url}  

Filling the input fields
    Wait Until Element Is Visible    id=ContentPlaceHolder1_ddltaxPeriodFrmDate    timeout=60s
    Select From List By Label    id=ContentPlaceHolder1_ddltaxPeriodFrmDate    FEB - 2024
    
    Wait Until Element Is Visible    //input[@id="ContentPlaceHolder1_tbNoOfEmp"]    timeout=30s
    Click Element    //input[@id="ContentPlaceHolder1_tbNoOfEmp"]
    Input Text    //input[@id="ContentPlaceHolder1_tbNoOfEmp"]    ${Pay_range_1}
    # Sleep    1s
    
    Wait Until Element Is Visible    //input[@id="ContentPlaceHolder1_txt_pay150"]    timeout=30s
    Click Element    //input[@id="ContentPlaceHolder1_txt_pay150"]
    Input Text    //input[@id="ContentPlaceHolder1_txt_pay150"]    ${Pay_range_2}
    # Sleep    1s
    
    Wait Until Element Is Visible    //input[@id="ContentPlaceHolder1_txt_pay200"]    timeout=30s
    Double Click Element    //input[@id="ContentPlaceHolder1_txt_pay200"]
    Sleep    1s
    Input Text    //input[@id="ContentPlaceHolder1_txt_pay200"]    ${Pay_range_3}
    Sleep    1s
    
    # Wait Until Element Is Visible    //input[@id="ContentPlaceHolder1_btn_Sub"]    timeout=30s
    # Click Element    //input[@id="ContentPlaceHolder1_btn_Sub"]
    
*** Test Cases ***
Launching the Telangana PT website
    Open website

Run Login Process Loop
    
    # FOR    ${attempt}    IN RANGE    10
    #     ${current_url}=    Login     ${username}    ${password}
    #     IF    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    
    #     RPA.Desktop.PressKeys    ENTER
    #     Sleep    2s
    #     ELSE
    #     Log    Login successful. Exiting the loop.
    #     END
    # END   
    
    # FOR    ${attempt}    IN RANGE    10
    # ${current_url}=    Login     ${username}    ${password}
    # IF    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    
    #     Handle Alert    # Handle the alert here
    #     Log    Login attempt ${attempt + 1} failed. Retrying...
    # ELSE
    #     Log    Login successful. Exiting the loop.
    #     Exit For Loop
    # Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
    # END
    # END
    
    FOR    ${attempt}    IN RANGE    10
        ${current_url}=    Login Process     ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://tgct.gov.in/tgpt_dealer/Returns/dealer_login.aspx'    Exit For Loop
    END
    
Entering data and Submit
    Wait Until Element Is Visible    xpath://*[@id="form1"]/div[4]/div[1]/ul/li[2]/a    timeout=30s
    Click Element    xpath://*[@id="form1"]/div[4]/div[1]/ul/li[2]/a
    Sleep    2s
    Filling the input fields
    