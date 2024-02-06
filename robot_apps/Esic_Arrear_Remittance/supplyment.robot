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
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Arrear_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Arrear_Remittance/cleaned_text.txt
${API_URL}                http://10.12.0.78/epf-cap-predict/
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

Run Python Script for data
    ${result}=    Run Process    ${PYTHON_PATH}    Data_from_excel.py  
    ${output}=    Set Variable    ${result.stdout.strip()}
    ${IP_Number}=    Set Variable    ${output.split(',')[0].strip()}
    ${No_of_Days}=    Set Variable    ${output.split(',')[1].strip()}
    ${Amount} =    Set Variable    ${output.split()[2].strip()}
    [Return]    ${IP_Number}    ${No_of_Days}    ${Amount}    


*** Test Cases ***
Run Login Process Loop
    ${username}    ${password}=    Run Python Script
    ${IP_Number}    ${No_of_Days}    ${Amount}=    Run Python Script for data
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

    Click Element If Visible    id=lnkMonthlyContribution
    Sleep    5s
    # Handle Alert
    Get Window Handles
    RPA.Desktop.Press Keys     ENTER 
    Sleep    2s
    Switch To Another New Window
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcMonth"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[1]/option[13]
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcYear"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[2]/option[3]
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[4]/td[2]/select/option[3]
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[6]/td[2]/select/option[2]
    Click Button     xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    Input Text    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl02_CtrlTxtBxIpNo    ${IP_Number}
    Sleep    1s
    Input Text    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl02_CtrlTxtBxNoDaysWokd    ${No_of_Days}
    Sleep    1s
    Input Text    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl02_CtrlTxtBxTotMnthlyWgs    ${Amount}
    Sleep    1s
    
    
    # Click Button    xpath://*[@id="ctl00_HomePageContent_ButtonAdd"]                                          # Add more option
    # click Button    xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]                                      # Submit option 
