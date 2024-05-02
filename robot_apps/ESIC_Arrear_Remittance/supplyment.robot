*** Settings ***
Library    RPA.Browser.Selenium       auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    OperatingSystem
Library    RPA.Excel.Files
Library    DateTime
Library    Collections
Library    String

*** Variables ***
${location}               Chennai(Vellore)    
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Arrear_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Arrear_Remittance/cleaned_text.txt
${API_URL}                http://10.12.0.212/epf-cap-predict/
${SCREENSHOTS_FOLDER}     /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Arrear_Remittance/screenshots
${CREDENTIAL_FILE_PATH}   /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${username}               52510855590011015
# ${password}               Telangan@123
# ${BROWSER_OPTIONS}        --headless
# ${EXCEL_FILE_PATH}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${SHEET_NAME}         Esic Logins

*** Keywords ***
Run Login Process Loop
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
    ${result}=    Run Process    python3    extract_text.py    ${SCREENSHOT_FILE}    ${API_URL}
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

Open Any Browser
    Open Browser    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx   firefox      
    Maximize Browser Window

FILL USERNAME AND PASSWORD BASED ON LOCATION
    [Arguments]  ${uan}
    ${location}    Set Variable    ${uan}[Locations]
    ${location_username}=    Set Variable    ${uan}[User Name]
    ${location_password}=    Set Variable    ${uan}[PASSWORD] 
    Set Global Variable    ${username}    ${location_username}
    Set Global Variable    ${password}    ${location_password} 

click Close Button 
    ${div1_close_visible}=    Click Element If Visible     xpath://*[@id="div1_close"]    
    ${btnpnlSanjeevanicolse_visible}=    Click Element If Visible    xpath://*[@id="btnpnlSanjeevanicolse"]    
    ${btnpnlcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlcolse"]    
    ${btnpnlPwdcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlPwdcolse"] 

    Run Keyword If    '${div1_close_visible}' == 'True'    Click Button    xpath://*[@id="div1_close"]
    Run Keyword If    '${btnpnlSanjeevanicolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlSanjeevanicolse"]
    Run Keyword If    '${btnpnlcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlcolse"]
    Run Keyword If    '${btnpnlPwdcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlPwdcolse"] 

click File Monthly contribution
    Wait Until Element Is Visible    id=lnkMonthlyContribution    timeout=30s
    Click Element    id=lnkMonthlyContribution 

Select Month
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcMonth"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcMonth"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[1]/option[11]              # OCT
    
Select Year
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcYear"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcYear"]
    Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[2]/option[3]

Switch To Another New Window
    ${window_handles}=    Get Window Handles
    ${new_window_index}=    Evaluate    len(${window_handles}) - 1
    Switch Window    ${window_handles}[${new_window_index}]  

Switch To Original Window
    ${window_handles}=    Get Window Handles
    ${original_window_index}=    Evaluate    len(${window_handles}) - 2
    Switch Window    ${window_handles}[${original_window_index}]     

Select supplyment option
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]    timeout=30s
    Select From List By Label    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]    SupplementaryContribution

Select side supplyment option
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]    timeout=60s
    Select From List By Label    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]    Supplementary Contribution

supplyment submit
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]    timeout=30s
    Click Button     xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]  

click ok and exit
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_exit"]      timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_exit"]       

click submit of added data
    Sleep    5s
    ${Submit}=    Click Element If Visible    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    Run Keyword If    '${Submit}' == 'True'    Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    Sleep    2s
    Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    # Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    # Sleep    2s
    # Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]    

Entering data from excel file
    [Arguments]    ${esic}     ${id_index}    ${lenght_var}    ${worksheet_length}    ${formatted_index}
    ${a}=   Evaluate     int(${esic}[ESIC Number])
    ${b}=   Evaluate     int(${esic}[Days])
    ${c}=   Evaluate     int(${esic}[Gross])
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl0${id_index}_CtrlTxtBxIpNo    timeout=20s
    Input Text   id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl${formatted_index}_CtrlTxtBxIpNo     ${a}
    Sleep    5s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl0${id_index}_CtrlTxtBxNoDaysWokd    timeout=20s
    Input Text   id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl${formatted_index}_CtrlTxtBxNoDaysWokd     ${b}
    Sleep    5s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl0${id_index}_CtrlTxtBxTotMnthlyWgs    timeout=5s
    Input Text   id=ctl00_HomePageContent_CtrlGrdVwSuppMc_ctl${formatted_index}_CtrlTxtBxTotMnthlyWgs    ${c}
    Run Keyword If   ${lenght_var}!=${worksheet_length}
    ...    Click Element    xpath://*[@id="ctl00_HomePageContent_ButtonAdd"]
    ...    ELSE    CLICK SUBMIT OF ADDED DATA    
    sleep    5s

Open excel
    Open Workbook    /home/buzzadmin/Downloads/OCT_ESIC_TELANGANA .xlsx
    ${esic_excel_data}    Read Worksheet As Table    header=True
    ${worksheet_length}=    Get Length    ${esic_excel_data}
    Log    Length of Worksheet: ${worksheet_length}
    Close Workbook
    ${id_index}=     set variable    1
    ${lenght_var}=    Set Variable    0
    FOR    ${esic}    IN    @{esic_excel_data}
        # ${a}    Evaluate     ${esic}) 
        Log    ${id_index}   
        ${id_index} =     Evaluate   ${id_index} + 1
        Log      ${id_index}
        ${formatted_index}=    Evaluate    "${id_index}".zfill(2)
        Log      ${formatted_index}
        # ${id_index}=    Format String    %01d    ${id_index} 
        ${lenght_var}=    Evaluate    ${lenght_var} + 1
        Log      ${lenght_var}
        ENTERING DATA FROM EXCEL FILE   ${esic}     ${id_index}    ${lenght_var}    ${worksheet_length}    ${formatted_index}
    END

Click Generate Challan
    Wait Until Element Is Visible    id=lnkGenerateChallan    timeout=30s
    Click Element   id=lnkGenerateChallan  

Click View Button
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_btnView"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_btnView"]   

Click Check Box of month
    Wait Until Element Is Visible     xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl04_CtrlChkSel"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlGrdVwMC_ctl04_CtrlChkSel"]            

Amount Extraction
    Wait Until Element Is Visible    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/div/table/tbody/tr/td/div[2]/table[3]/tbody/tr[1]/td[2]
    ${text}=    Get Text    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/div/table/tbody/tr/td/div[2]/table[3]/tbody/tr[1]/td[2]
    Input Text    id=ctl00_HomePageContent_CtrlTxtTotalAmtPaid   ${text} 

Click submit Button of Challan
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_MonthlySubmit"]    timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_MonthlySubmit"]    

Take a page screenshot
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${screenshot_path}=    Capture Page Screenshot
    ...    filename=${SCREENSHOTS_FOLDER}/screenshot_${timestamp}.png
    Log    Screenshot saved to: ${screenshot_path}    

*** Test Cases ***
LAUNCHING THE ESIC WEBSITE
    Open Any Browser

FILL THE FORM USING THE DATA FROM THE CREDENTIAL_FILE_PATH
    Open Workbook    ${CREDENTIAL_FILE_PATH}
    ${uan_list}    Read Worksheet As Table    header=True    
    FOR    ${uan}    IN    @{uan_list}
        Run Keyword If    '${uan}[Locations]' == '${location}'   FILL USERNAME AND PASSWORD BASED ON LOCATION    ${uan}    
    END
    Log    ${username}
    Log    ${password} 
    
LOGGING INTI THE WEBSITE    
    
    FOR    ${attempt}    IN RANGE    10
        ${current_url}=    Run Login Process Loop    ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END
        click Close Button
        
GO TO MONTHLY CONTRI PAGE        
    click File Monthly contribution
    Sleep    5s
    Get Window Handles
    RPA.Desktop.Press Keys     ENTER 
    Sleep    5s
    Switch To Another New Window
    Sleep    1s
    
CHOOSING MONTH AND YEAR     
    Select Month
    Select Year 
        
GO TO SUPPLYMENTARY PAGE        
    Select supplyment option
    Select side supplyment option
    supplyment submit

FILLING THE EXCEL DATA        
    Open excel
    click ok and exit
    Sleep    5s
    Switch To Original Window
    
GO TO CHALLAN LINK    
    Click Generate Challan
    Sleep    5s
    Switch To Another New Window
        
GO TO VIEW PAGE
    Click View Button
    
SELECTING OF MONTH    
    Click Check Box of month
    Amount Extraction
    sleep    2s
    RPA.Desktop.Press Keys    ENTER
    Sleep    5s
    
SUMBMITTING THE DATA    
    Click submit Button of Challan
    Take a page screenshot   

    
    
    
    
    
    

