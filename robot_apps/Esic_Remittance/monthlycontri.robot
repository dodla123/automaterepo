*** Settings ***
Library    RPA.Browser.Selenium       auto_close=${False}
Library    RPA.Desktop
Library    Process
Library    DateTime    
Library    OperatingSystem
Library    Collections
Library    String
# Library    RPA.JavaAccessBridge

*** Variables ***
${PYTHON_PATH}            python3 
${BROWSER}                firefox
${URL}                    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx
${MAX_LOGIN_ATTEMPTS}     10
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/screenshot.png
${CAPTCH_TEXT_FILE}       /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/Esic_Remittance/cleaned_text.txt
${API_URL}                http://10.12.0.78/epf-cap-predict/
# ${MONTH_DROPDOWN_ID}       id=ctl00_HomePageContent_CtrlDdlMcMonth
# ${YEAR_DROPDOWN_ID}        id=ctl00_HomePageContent_CtrlDdlMcYear
# @{MONTHS}    January    February    March    April    May    June    July    August    September    October    November    December 
${MONTH_MAPPING}    Jan:01    Feb:02    Mar:03    Apr:04    May:05    Jun:06    Jul:07    Aug:08    Sep:09    Oct:10    Nov:11    Dec:12
# ${current_month}    Jan  # Replace this with the actual current month in text format
${file_path}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx

# ${MONTH_MAPPING}          Jan:01    Feb:02    Mar:03    Apr:04    May:05    Jun:06    Jul:07    Aug:08    Sep:09    Oct:10    Nov:11    Dec:12
# ${BROWSER_OPTIONS}        --headless
# ${EXCEL_FILE_PATH}    /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${SHEET_NAME}         Esic Logins

*** Keywords ***
Login Process
    [Arguments]    ${username}    ${password}
    Wait Until Element Is Visible    id=txtUserName     
    Input Text    id=txtUserName    ${username}
    Sleep    1s
    Log    ${username}
    Wait Until Element Is Visible    id=txtPassword    
    Input Password    id=txtPassword    ${password}
    Sleep    1s
    Log    ${password} 
    Wait Until Element Is Visible    xpath=//*[@id='img1']
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

Select Previous Month 
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${current_month}=    Get Current Date    result_format=%m
    Log     ${current_month}
    # Convert current month to an integer, treating it as a decimal (base 10)
    ${current_month}=    Evaluate    int('${current_month}', 10)
    # Calculate previous month
    ${previous_month}=    Evaluate    f"{(${current_month} + 10) % 12 + 1:02d}"
    Log    ${previous_month}
    # Select the previous month
    # Wait Until Element Is Visible   //select[@id='ctl00_HomePageContent_CtrlDdlMcMonth']/option[@value='${previous_month}']    timeout=60s
    Click Element    xpath=//select[@id='ctl00_HomePageContent_CtrlDdlMcMonth']/option[@value='${previous_month}']

Select Current Year    
    ${current_date}=    Get Current Date    result_format=%Y-%m-%d
    ${current_year}=    Get Current Date    result_format=%Y
    Log     ${current_year}
    Click Element    xpath=//select[@id='ctl00_HomePageContent_CtrlDdlMcYear']/option[@value='${current_year}']


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

    Click Element If Visible    id=lnkMonthlyContribution
    Sleep    5s
    # Handle Alert
    Get Window Handles
    RPA.Desktop.Press Keys     ENTER 
    Sleep    2s
    Switch To Another New Window
    Select Previous Month
    Select Current Year 
    Click Element    //a[@id="ctl00_HomePageContent_CntrlUploadLink"]
    Switch To Another New Window
    Sleep    2s
    # Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_MCFileUpload"]    timeout=90s   
    Choose File      xpath://*[@id="ctl00_HomePageContent_MCFileUpload"]    ${file_path} 





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






