* Settings *
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    DateTime
Library    OperatingSystem

* Variables *
# ${HUB_URL}                http://172.18.0.1:4444/wd/hub
${PYTHON_PATH}            python3 
${BROWSER}                firefox
${URL}                    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx
${MAX_LOGIN_ATTEMPTS}     10
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/cleaned_text.txt
${API_URL}                http://10.12.0.70/epf-cap-predict/
${SCREENSHOTS_FOLDER}     /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshots
# ${EXCEL_FILE_PATH}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${SHEET_NAME}         Esic Logins

* Keywords *
Login Process
    [Arguments]    ${username}    ${password}
    Input Text    id=txtUserName    ${username}
    Sleep    1s
    Input Password    id=txtPassword    ${password}
    Sleep    1s
    Log    ${password} 
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

# Switch To Original Window
#     ${window_handles}=    Get Window Handles
#     ${original_window_index}=    Evaluate    len(${window_handles}) - 2
#     Switch Window    ${window_handles}[${original_window_index}]     

Switch To Another New Window
    ${window_handles}=    Get Window Handles
    ${new_window_index}=    Evaluate    len(${window_handles}) - 1
    Switch Window    ${window_handles}[${new_window_index}]  

Close Current Window And Switch Back
    Close Window
    ${window_handles}=    Get Window Handles
    ${previous_window_index}=    Evaluate    len(${window_handles}) - 2
    Switch Window    ${window_handles}[${previous_window_index}]

Amount Extraction
    Wait Until Element Is Visible    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/div/table/tbody/tr/td/div[2]/table[3]/tbody/tr[1]/td[2]
    ${text}=    Get Text    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/div/table/tbody/tr/td/div[2]/table[3]/tbody/tr[1]/td[2]
    Input Text    id=ctl00_HomePageContent_CtrlTxtTotalAmtPaid   ${text}     

# Get Current Date
#     [Documentation]    Returns the current date and time in the specified format.
#     [Arguments]    ${result_format}
#     ${current_date}=    Get Current Date    result_format=${result_format}
#     [Return]    ${current_date}    

Take a page screenshot
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${screenshot_path}=    Capture Page Screenshot
    ...    filename=${SCREENSHOTS_FOLDER}/screenshot_${timestamp}.png
    Log    Screenshot saved to: ${screenshot_path}       


* Test Cases *
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

    Click Element   id=lnkGenerateChallan 
    Switch To Another New Window
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_btnView"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_btnView"]
    Wait Until Element Is Visible     xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]
    RPA.Desktop.Press Keys     ENTER
    
    # Close Current Window And Switch Back
    # Take a page screenshot

                                                
   
   
   
#    xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]
   
   
    # RPA.Desktop.Press Keys    ENTER
    # sleep  2s
    # RPA.Desktop.Press Keys    ENTER
    # sleep  5s
    # RPA.Desktop.Press Keys    TAB
    # RPA.Desktop.Press Keys    TAB
    # RPA.Desktop.Press Keys    SPACE