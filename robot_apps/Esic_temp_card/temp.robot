*** Settings ***
Library    RPA.Browser.Selenium       auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    OperatingSystem
# Library    RPA.JavaAccessBridge

*** Variables ***
${PYTHON_PATH}            python3 
${BROWSER}                firefox
${URL}                    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx
${MAX_LOGIN_ATTEMPTS}     10
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_temp_card/screenshot.png
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_temp_card/cleaned_text.txt
${API_URL}                http://10.12.0.70/epf-cap-predict/
# ${BROWSER_OPTIONS}        --headless
# ${EXCEL_FILE_PATH}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${SHEET_NAME}         Esic Logins

*** Keywords ***
Login Process
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=txtUserName    timeout=30s     
    Input Text    id=txtUserName    ${username}
    Sleep    1s
    Log    ${username}
    Wait Until Element Is Visible    id=txtPassword    timeout=30s    
    Input Password    id=txtPassword    ${password}
    Sleep    1s
    Log    ${password} 
    Wait Until Element Is Visible    xpath=//*[@id='img1']    timeout=30s
    Capture Element Screenshot    xpath=//*[@id='img1']    ${SCREENSHOT_FILE}
    ${text_from_python_script}=    Run Process    ${PYTHON_PATH}      extract_text.py  
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=txtChallanCaptcha     ${file_content}
    Click Button    xpath://*[@id="btnLogin"]  # Assuming this is the login button
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url}

Run Python Script
    ${result}=    Run Process    ${PYTHON_PATH}    credentials.py  
    ${output}=    Set Variable    ${result.stdout.strip()}
    ${username}=    Set Variable    ${output.split(',')[0].strip()}
    ${password}=    Set Variable    ${output.split()[1].strip()}
    [Return]    ${username}    ${password}

Switch To Another New Window
    ${window_handles}=    Get Window Handles
    ${new_window_index}=    Evaluate    len(${window_handles}) - 1
    Switch Window    ${window_handles}[${new_window_index}]      


*** Test Cases ***
Run Login Process Loop
    ${username}    ${password}=    Run Python Script
    Open Browser    ${URL}    ${BROWSER}    #options=add_experimental_option("detach", True)    
    Maximize Browser Window
    
    FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
        ${current_url}=    Login Process    ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END

    ${div1_close_visible}=    Click Element If Visible     xpath://*[@id="div1_close"]    
    ${btnpnlSanjeevanicolse_visible}=    Click Element If Visible    xpath://*[@id="btnpnlSanjeevanicolse"]    
    ${btnpnlcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlcolse"]    
    ${btnpnlPwdcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlPwdcolse"] 

    Run Keyword If    '${div1_close_visible}' == 'True'    Click Button    xpath://*[@id="div1_close"]
    Run Keyword If    '${btnpnlSanjeevanicolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlSanjeevanicolse"]
    Run Keyword If    '${btnpnlcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlcolse"]
    Run Keyword If    '${btnpnlPwdcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlPwdcolse"] 

    Click Element If Visible    id=lnkRegisterNewIP
    sleep    1s
    Switch To Another New Window
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_1"]
    Sleep    1s
    Click Element    //input[@id="ctl00_HomePageContent_btnContinue"]