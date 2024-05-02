*** Settings ***
Library    RPA.Browser.Selenium       auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    DateTime    
Library    OperatingSystem
Library    Collections
Library    String
Library    RPA.Excel.Files


*** Variables ***
${Year}                         2024
${Month}                        Mar
${location}                     Chennai 
${process_type}                 MonthlyContribution                          
${SCREENSHOT_FILE}              /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}             /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/cleaned_text.txt
${API_URL}                      http://10.12.0.184/epf-cap-predict/
${MONTHLT_OLD_FILE_INPUT}       /home/buzzadmin/Downloads/Jaipur - MC_Template1.xls
${CREDENTIAL_FILE_PATH}         /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
${SUPPLY_EXCEL_FILE_INPUT}      /home/buzzadmin/Downloads/OCT_ESIC_TELANGANA .xlsx
# ${location}                   Chennai(Vellore)
# ${final_username}             ${EMPTY}
# ${final_password}             ${EMPTY}
# ${OUT_PUT_FILE}               /home/buzzadmin/Downloads/Madurai - MC_Template1(1).xls 
${MONTHLY_IP_TEXT_PATH}         /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/IP_invalid.txt


*** Keywords ***
OPEN ANY BROWSER
    Open Browser    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx    firefox        
    Maximize Browser Window

LOGIN PROCESS
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=txtUserName    timeout=90s     
    Input Text    id=txtUserName    ${username}
    Sleep    1s
    Log    ${username}
    Wait Until Element Is Visible    id=txtPassword    timeout=90s    
    Input Password    id=txtPassword    ${password}
    Sleep    1s
    Log    ${password} 
    Wait Until Element Is Visible    xpath=//*[@id='img1']    timeout=90s
    Capture Element Screenshot    xpath=//*[@id='img1']    ${SCREENSHOT_FILE}
    ${result}=    Run Process    python    extract_text.py    ${SCREENSHOT_FILE}    ${API_URL}
    Log    ${result.stdout}
    Log    ${result.stderr}
    Should Be Equal As Strings    ${result.rc}    0 
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=txtChallanCaptcha     ${file_content}
    Wait Until Element Is Visible    xpath://*[@id="btnLogin"]    timeout=30s
    Click Button    xpath://*[@id="btnLogin"]  # Assuming this is the login button
    Sleep    5s
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

CLICK CLOSE BUTTONS
    Wait Until Element Is Visible    xpath://*[@id="div1_close"]    timeout=90s 
    ${div1_close_visible}=    Click Element If Visible     xpath://*[@id="div1_close"]    
    ${btnpnlSanjeevanicolse_visible}=    Click Element If Visible    xpath://*[@id="btnpnlSanjeevanicolse"]    
    ${btnpnlcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlcolse"]    
    ${btnpnlPwdcolse_visible}=    Click Element If Visible     xpath://*[@id="btnpnlPwdcolse"] 

    Run Keyword If    '${div1_close_visible}' == 'True'    Click Button    xpath://*[@id="div1_close"]
    Run Keyword If    '${btnpnlSanjeevanicolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlSanjeevanicolse"]
    Run Keyword If    '${btnpnlcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlcolse"]
    Run Keyword If    '${btnpnlPwdcolse_visible}' == 'True'    Click Button    xpath://*[@id="btnpnlPwdcolse"]  

CLICK FILE MONTHLY CONTRI 
    Wait Until Element Is Visible    id=lnkMonthlyContribution    timeout=90s
    Click Element    id=lnkMonthlyContribution       

SELECT PREVIOUS MONTH 
    ${month_value}    Evaluate    {'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06', 'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'}
    ${selected_month}    Set Variable    ${month_value['${Month}']}
    Log    Selected month value is ${selected_month}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlDdlMcMonth    timeout=90s    
    Select From List by Value    id=ctl00_HomePageContent_CtrlDdlMcMonth    ${selected_month}

SELECT CURRENT YEAR    
    Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlDdlMcYear    timeout=90s
    Select From List By Value    id=ctl00_HomePageContent_CtrlDdlMcYear    ${Year}

SWITCH TO ANOTHER NEW WINDOW
    ${window_handles}=    Get Window Handles
    ${new_window_index}=    Evaluate    len(${window_handles}) - 1
    Switch Window    ${window_handles}[${new_window_index}] 

CLICK UPLOAD BUTTON
    Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_CntrlUploadLink"]    timeout=90s
    Click Element    //*[@id="ctl00_HomePageContent_CntrlUploadLink"] 
    Sleep    5s
    SWITCH TO ANOTHER NEW WINDOW 

CHOOSING FILE
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_MCFileUpload"]    timeout=90s
    Choose File    //input[@id="ctl00_HomePageContent_MCFileUpload"]    ${MONTHLT_OLD_FILE_INPUT}  

UPLOAD FILE
    Wait Until Element Is Visible    xpath://input[@id="ctl00_HomePageContent_CtrlBtnUpload"]    timeout=90s
    Click Element    xpath://input[@id="ctl00_HomePageContent_CtrlBtnUpload"]
    RPA.Desktop.Press Keys     ENTER 
    Sleep    5s

IP DELETION
    Wait Until Element Is Visible    //span[@id="ctl00_HomePageContent_CntrlLabel"]/table/tbody    timeout=90s
    ${tbody_text}=    Get Text    xpath=//span[@id="ctl00_HomePageContent_CntrlLabel"]/table/tbody
    Log    ${tbody_text}
    Append To File    ${MONTHLY_IP_TEXT_PATH}     ${tbody_text}

UPLOAD DELETED FILE
    ${text_python_script}=    Run Process    python3      IP_Number_deletion.py 

    # ${result}    Run Keyword    IP_Number_deletion.process_files    ${output_file_path} 
CLICK SUBMIT EXCEL
    Sleep    10S
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_btnSubmitExcel"]    timeout=90s 
    Click Element    xpath://*[@id="ctl00_HomePageContent_btnSubmitExcel"] 

CLICK VERIFY CHECK BOX
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_cbDataVerified"]    timeout=90s
    Click Element    xpath://*[@id="ctl00_HomePageContent_cbDataVerified"]

CLICK SUMBIT BUTTON 
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_Button1"]    timeout=90s
    Click Element    xpath://*[@id="ctl00_HomePageContent_Button1"] 
    RPA.Desktop.Press Keys     ENTER 
    Sleep    5s
    RPA.Desktop.Press Keys     ENTER 
    Sleep    5s

SELECT SUPPLYMENT OPTION
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]    timeout=30s
    Select From List By Label    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]    SupplementaryContribution
    # Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcType"]
    # Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[4]/td[2]/select/option[3]

SELECT SIDE SUPPLYMENT OPTION
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]    timeout=60s
    Select From List By Label    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]    Supplementary Contribution
    # Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDDTpyOfWgs"]
    # Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[6]/td[2]/select/option[2]   

SUPPLYMENT SUBMIT
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]    timeout=30s
    Click Button     xpath://*[@id="ctl00_HomePageContent_CtrlBtnSubmit"]  

CLICK OK AND EXIT
    Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_exit"]      timeout=30s
    Click Element    xpath://*[@id="ctl00_HomePageContent_exit"]       

CLICK SUBMIT OF ADDED DATA
    Sleep    5s
    ${Submit}=    Click Element If Visible    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    Run Keyword If    '${Submit}' == 'True'    Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    Sleep    2s
    Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    # Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]
    # Sleep    2s
    # Click Button    //input[@id="ctl00_HomePageContent_CtrlBtnSubmit"]    

ENTERING DATA FROM EXCEL FILE
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

OPEN EXCEL
    Open Workbook    ${SUPPLY_EXCEL_FILE_INPUT}
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
    
*** Test Cases ***
OPEN ESIC WEBSITE
    OPEN ANY BROWSER

FILL THE FORM USING THE DATA FROM THE CREDENTIAL_FILE_PATH
    Open Workbook    ${CREDENTIAL_FILE_PATH}
    ${uan_list}    Read Worksheet As Table    header=True    
    FOR    ${uan}    IN    @{uan_list}
        Run Keyword If    '${uan}[Locations]' in '${location}'   FILL USERNAME AND PASSWORD BASED ON LOCATION    ${uan}    
    END
    Log    ${username}
    Log    ${password}    

RUN LOGIN PROCESS LOOP    
    
    FOR    ${attempt}    IN RANGE    10
        ${current_url}=    Login Process    ${username}    ${password}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END
        
    CLICK CLOSE BUTTONS 

GO TO MONTHLY CONTRI PAGE
    CLICK FILE MONTHLY CONTRI
    Sleep    5s
    Execute JavaScript    document.getElementById('aspnetForm').Submit()
    # RPA.Desktop.Press Keys     ENTER 
    Sleep    5s
    SWITCH TO ANOTHER NEW WINDOW

CHOOSING MONTH AND YEAR    
    SELECT PREVIOUS MONTH 
    SELECT CURRENT YEAR

PROCESS TESTCASE
    IF    '${process_type}' == 'MonthlyContribution'
        CLICK UPLOAD BUTTON
        CHOOSING FILE
        UPLOAD FILE
        IP DELETION
        UPLOAD DELETED FILE  
        CHOOSING FILE  
        UPLOAD FILE 
        CLICK SUBMIT EXCEL 
        CLICK VERIFY CHECK BOX
        CLICK SUMBIT BUTTON
    ELSE
        SELECT SUPPLYMENT OPTION
        SELECT SIDE SUPPLYMENT OPTION
        SUPPLYMENT SUBMIT
        OPEN EXCEL
        CLICK OK AND EXIT
        Sleep    5s    
    END

# GO TO UPLOAD PAGE    
#     CLICK UPLOAD BUTTON
    

# GO TO BROWSE CHOOSE AND UPLOAD FILE   
#     CHOOSING FILE
#     UPLOAD FILE
    

# DELETING AND REUPLOADING    
#     IP DELETION
#     UPLOAD DELETED FILE
#     CHOOSING FILE  
#     UPLOAD FILE 

# VERIFY AND SUBMISSION OF FILE    
#     CLICK SUBMIT EXCEL 
#     CLICK VERIFY CHECK BOX
#     CLICK SUMBIT BUTTON








# Submit Form
#     # ${form_element} =    Execute Javascript    return document.evaluate('${FORM_XPATH}', document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue
#     # Run Keyword If    ${form_element}    Execute Javascript    ${form_element}.submit()

#     # ${form_element} =    Execute Javascript    return document.getElementById('aspnetForm')
#     # ${form_element} =    Execute Javascript    document.getElementById('aspnetForm');
#     # # Handle Alert    action=Accept
#     # ${form_element}.submit();

#     Wait Until Element Is Visible    id:aspnetForm    30
#     Execute JavaScript    document.getElementById('aspnetForm').submit();

# Send ENTER Key Press
    # Execute JavaScript    return document.activeElement.blur();
    # Execute JavaScript    alert('None');    # This will trigger an alert dialog
    # Execute JavaScript    window.alert = function() { return true; };    # Override the default alert function to return true
    # Execute JavaScript    window.confirm = function() { return true; };    # Override the default confirm function to return true


    # Send ENTER Key Press  
    # ${alert_message}=    Handle Alert    Accept=true           
    # Log    Dismissed alert with message: ${alert_message}
    # Execute JavaScript    document.getElementById('aspnetForm').submit()
    # Submit id=aspnetFormForm    id=aspnetForm
    # Click Element    xpath://*[@id="aspnetForm"]
    # Submit Form    
    # Wait Until Element Is Visible    id=aspnetForm    timeout=30s
    # Submit Form    
    # Execute JavaScript    document.getElementById('aspnetForm').submit();   
    # Execute JavaScript    document.getElementById('aspnetForm').Submit() 
    # Execute JavaScript    document.getElementById('aspnetForm').Submit Form()   
    # RPA.Desktop.Press Keys     ENTER 
    # Sleep    2s
    # SWITCH TO ANOTHER NEW WINDOW
    
        
        
        
        
        
        
        








        
        # Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_btnSubmitExcel"]    timeout=60s 
        # Click Element    xpath://*[@id="ctl00_HomePageContent_btnSubmitExcel"]
        # Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_cbDataVerified"]    timeout=30s
        # Click Element    xpath://*[@id="ctl00_HomePageContent_cbDataVerified"] 
        # Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_Button1"]    timeout=30s
        # Click Element    xpath://*[@id="ctl00_HomePageContent_Button1"]
        # RPA.Desktop.Press Keys     ENTER 
        # Sleep    5s
        # RPA.Desktop.Press Keys     ENTER 
        # Sleep    5s




        
        
        
        
        # Wait Until Element Is Visible    //span[@id="ctl00_HomePageContent_CntrlLabel"]/table/tbody    timeout=30s
        # ${tbody_text}=    Get Text    xpath=//span[@id="ctl00_HomePageContent_CntrlLabel"]/table/tbody
        # Log    ${tbody_text}



    # END    


    # xpath://*[@id="ctl00_HomePageContent_btnSaveExcel"]                # save 
    # //*[@id="ctl00_HomePageContent_btnSubmitExcel"]                    # submit
    # //*[@id="ctl00_HomePageContent_cbDataVerified"]                    # check box
    # //*[@id="ctl00_HomePageContent_Button1"]                           #  submit after check bov 
    # pop-up
    # pop-up
    # //*[@id="ctl00_HomePageContent_exit"]                              # Exit


    
    
    
    
    
    
    
    
    
    
    # Click Element If Visible    id=lnkMonthlyContribution
    # Sleep    5s
    # # Handle Alert
    # Get Window Handles
    # RPA.Desktop.Press Keys     ENTER 
    # Sleep    2s
    # Switch To Another New Window
    # Select Previous Month
    # Select Current Year 
    # Click Element    //a[@id="ctl00_HomePageContent_CntrlUploadLink"]
    # Sleep    2s
    # Switch To Another New Window
    # Sleep    2s
    # Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_MCFileUpload"]    timeout=10s   
    # Choose File      id=ctl00_HomePageContent_MCFileUpload    ${file_path} 
    # Click Element    xpath://*[@id="ctl00_HomePageContent_MCFileUpload"]                                                    #id=ctl00_HomePageContent_MCFileUpload





    #  [Arguments]    ${abbreviated_previous_month}
    # ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    # ${current_month}=    Get Current Date    result_format=%m
    # Log     ${current_month}
    # Select From List By Value    xpath=//select[@id='ctl00_HomePageContent_CtrlDdlMcMonth']    ${current_month}



# Select Previous Month
    # [Arguments]    ${abbreviated_previous_month}
    # ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    # ${current_month}=    Get Current Date    result_format=%B
    # ${abbreviated_month}=    Set Variable    ${current_month}[0:3]  # Extract the first three letters
    # ${current_index}=    Get Index From List    ${MONTHS}    ${abbreviated_month}
    # ${previous_index}=    Evaluate    (${current_index} - 1 + len(${MONTHS})) % len(${MONTHS})
    # ${previous_month}=    Set Variable    ${MONTHS}[${previous_index}]
    # ${abbreviated_previous_month}=    Set Variable    ${previous_month}[0:3]
    # Log    Current Date: ${current_date}
    # Log    Current Month: ${abbreviated_month}
    # Log    Previous Month: ${abbreviated_previous_month}
    # [Return]    ${abbreviated_previous_month}

# Select Previous Month
#     ${current_month}    Evaluate    datetime.datetime.now().strftime('%b')
#     ${months}    Create List    Jan    Feb    Mar    Apr    May    Jun    Jul    Aug    Sep    Oct    Nov    Dec

#     # Find the index of the current month in the list
#     ${current_index}=    Get From List    ${months}    ${current_month}

#     # Calculate the previous month index, considering the cyclic nature of months
#     ${previous_index}=    Evaluate    (${current_index} - 1 + len(${months})) % len(${months})

#     # Get the previous month abbreviation
#     ${previous_month}=    Get From List    ${months}    ${previous_index}

#     Log    Current Month: ${current_month}
#     Log    Previous Month: ${previous_month}

#     Select From List By Label    ${MONTH_DROPDOWN_ID}    ${previous_month}


    

# Select Previous Month In Dropdown
#     ${current_date}=    Get Current Date    result_format=%b
#     ${current_month}=    Get From Dictionary    ${MONTH_MAPPING}    ${current_date}
#     ${previous_month_index}=    Evaluate    int(${current_month}) - 1
#     ${previous_month_abbreviated}=    Get Index From List    ${MONTH_MAPPING.values()}    ${previous_month_index}
#     Log    Selecting previous month: ${previous_month_abbreviated}
#     Select From List By Label    ${MONTH_DROPDOWN_ID}    ${previous_month_abbreviated}



# Select Previous Month
#     [Arguments]    ${month_dropdown_locator}
#     ${current_month}=    Get Current Date    result_format=%b  # Get the current month in "Jan" format
#     ${months}    Create List    Jan    Feb    Mar    Apr    May    Jun    Jul    Aug    Sep    Oct    Nov    Dec
#     ${current_index}=    Get from List    ${months}    ${current_month}
#     ${previous_index}=    Evaluate    ${current_index} - 1
#     ${previous_month}=    Set Variable If    ${previous_index} >= 0    ${months}[${previous_index}]    ${months}[11]
    
#     Log    Previous Month: ${previous_month}
    
#     Log    Selecting from dropdown: ${month_dropdown_locator} with label: ${previous_month}
#     Execute JavaScript    document.querySelector('${month_dropdown_locator}').value='${previous_index}';
#     Log    Selection completed
    
#     Log    Checking selected value in the dropdown
#     ${selected_value}=    Get Selected List Label    ${month_dropdown_locator}
#     Log    Selected value: ${selected_value}


# Select Previous Month and Year
#     [Arguments]    ${month_dropdown_locator}    ${year_dropdown_locator}
#     ${current_month}=    Get Current Date    result_format=%b  # Get the current month in "Jan" format
#     ${current_year}=    Get Current Date    result_format=%Y

#     # Calculate the previous month
#     ${previous_month}=    Get Previous Month    ${current_month}
#     ${previous_year}=    Set Variable If    '${previous_month}' == 'dec'    ${current_year - 1}    ${current_year}

#     # Convert single-digit months to double digits
#     ${previous_month}=    Run Keyword If    '${previous_month}' < 10    Set Variable    0${previous_month}    ELSE    Set Variable    ${previous_month}

#     # Open the website and select the previous month in the dropdown
#     # Open Browser    ${BASE_URL}    Chrome
#     Select From List By Label    ${month_dropdown_locator}    '${previous_month}'
#     Select From List By Label    ${year_dropdown_locator}    ${previous_year}

# Get Previous Month
#     [Arguments]    ${current_month}
#     ${months}    Create List    Jan    Feb    Mar    Apr    May    Jun    Jul    Aug    Sep    Oct    Nov    Dec
#     ${index}=    Get Index From List    ${months}    ${current_month}
#     ${previous_index}=    Evaluate    ${index} - 1
#     ${previous_month}=    Get From List    ${months}    ${previous_index}
#     [Return]    ${previous_month}         
# Select Previous Month
#     # Open Browser    ${BASE_URL}    ${BROWSER}
#     # Maximize Browser Window
#     ${current_month}    Evaluate    datetime.datetime.now().strftime('%b')
#     ${previous_month}    Run Keyword If    "${current_month}" == "Jan"    Evaluate    datetime.datetime.now().strftime('%b')    
#     ...    ELSE    Evaluate    (datetime.datetime.now() - relativedelta(months=1)).strftime('%b')
#     Log    Current Month: ${current_month}
#     Log    Previous Month: ${previous_month}
    
    # Select From List By Label    xpath=//*[@id="ctl00_HomePageContent_CtrlDdlMcMonth"]    ${previous_month}
    # Click Element    ${MONTH_DROPDOWN_ID}
    # Select Previous Month In Dropdown   
    # Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcMonth"]
    # Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[1]/option[13]
    # Click Element    xpath://*[@id="ctl00_HomePageContent_CtrlDdlMcYear"]
    # Click Element    xpath:/html/body/form/div[3]/table[2]/tbody/tr[2]/td/div/table[2]/tbody/tr/td/div/table[1]/tbody/tr[3]/td[2]/select[2]/option[3]
    # Click Element    xpath://*[@id="ctl00_HomePageContent_CntrlUploadLink"]
    # Switch To Another New Window
    # Wait Until Element Is Visible    xpath://*[@id="ctl00_HomePageContent_MCFileUpload"]    
    
    
    
    # Choose File    xpath://*[@id="ctl00_HomePageContent_MCFileUpload"]    /home/buzzadmin/Desktop/ESic_dummy data.xlsx
    # Get Window Handles
    # RPA.Desktop.Press Keys     ENTER 
    # Sleep    2s
    # Click Element    xpath:                           // submit botton
    # Click Element    xpath:                           // data verify
    # Click Element    xpath:                           // Excel verify
    # Get Window Handles                                // pop-up
    # RPA.Desktop.Press Keys     ENTER 
    # Sleep    2s
    # Click Element    xpath:                           // close button






