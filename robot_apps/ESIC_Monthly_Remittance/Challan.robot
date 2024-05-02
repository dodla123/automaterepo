*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    DateTime
Library    OperatingSystem
Library    RPA.Excel.Files
Library    Send_mail.py

*** Variables ***
${location}                Chennai(Vellore)
${Month}                    
${Year}
${BROWSER}                 firefox
${URL}                     https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx
${MAX_LOGIN_ATTEMPTS}      10
${SCREENSHOT_FILE}         /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/cleaned_text.txt
${API_URL}                 http://10.12.0.77/epf-cap-predict/
${SCREENSHOTS_FOLDER}      /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshots
${CREDENTIAL_FILE_PATH}     /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${EXCEL_FILE_PATH}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${SHEET_NAME}         Esic Logins
${checkbox_xpath}         //span[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl04_MC_Period"]
${checkbox_text}          Nov2023

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
    ${result}=    Run Process    python    extract_text.py    ${SCREENSHOT_FILE}    ${API_URL}
    Log    ${result.stdout}
    Log    ${result.stderr}
    Should Be Equal As Strings    ${result.rc}    0 
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=txtChallanCaptcha     ${file_content}
    Click Button    xpath://*[@id="btnLogin"]  # Assuming this is the login button
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url}

FILL USERNAME AND PASSWORD BASED ON LOCATION
    [Arguments]  ${uan}
    ${location}    Set Variable    ${uan}[Locations]
    ${location_username}=    Set Variable    ${uan}[User Name]
    ${location_password}=    Set Variable    ${uan}[PASSWORD] 
    Set Global Variable    ${username}    ${location_username}
    Set Global Variable    ${password}    ${location_password}

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
    Sleep    2s
    Input Text    xpath://*[@id="ctl00_HomePageContent_CtrlTxtTotalAmtPaid"]   ${text}    

Take a page screenshot
    # ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${screenshot_path}=    Capture Page Screenshot
    ...    filename=${SCREENSHOTS_FOLDER}/screenshot_${location}_${Month}_${Year}_.png
    Log    Screenshot saved to: ${screenshot_path} 
    ${Email}=    Run Keyword    Send_mail.send_email_with_image    ${screenshot_path}   

# Take a page screenshot
#     ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
#     ${screenshot_path}=    Capture Page Screenshot
#     ...    filename=${SCREENSHOTS_FOLDER}/screenshot_${location}.png
#     Log    Screenshot saved to: ${screenshot_path}       


*** Test Cases ****
Run Login Process
    Open Browser    ${URL}    ${BROWSER}    
    Maximize Browser Window

FILL THE FORM USING THE DATA FROM THE CREDENTIAL_FILE_PATH
    Open Workbook    ${CREDENTIAL_FILE_PATH}
    ${uan_list}    Read Worksheet As Table    header=True    
    FOR    ${uan}    IN    @{uan_list}
        Run Keyword If    '${uan}[Locations]' == '${location}'   FILL USERNAME AND PASSWORD BASED ON LOCATION    ${uan}    
    END
    Log    ${username}
    Log    ${password}     
    
RUN LOGIN PROCESS LOOP     
    FOR    ${attempt}    IN RANGE    ${MAX_LOGIN_ATTEMPTS}
        ${current_url}=    Login Process    ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END
    
    Wait Until Element Is Visible    xpath://*[@id="div1_close"]    timeout=60s
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
    # Click Element    //span[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_MC_Period" and contains(text(), 'Jan2024')] 
    Wait Until Element Is Visible     xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]    timeout=30s        # OCT
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]
    # Click Element    xpath=//span[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_MC_Period" and contains(text(), 'Jan2024')]/following::input[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl02_CtrlChkSel"]
    # Click Element    //input[@type="checkbox" and ancestor::div[contains(., "Dec2023")]]
    Sleep    2s
    Amount Extraction
    Sleep    2s
    Get Window Handles
    RPA.Desktop.Press Keys     ENTER
    Sleep    5s
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_MonthlySubmit"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_MonthlySubmit"]
    Get Window Handles
    RPA.Desktop.Press Keys     ENTER
    Take a page screenshot
