*** Settings ***
# Library    RPA.Browser.Selenium       auto_close=${False}
Library    SeleniumLibrary
Library    RPA.Desktop
Library    Process
Library    DateTime    
Library    OperatingSystem
Library    Collections
Library    String
Library    RPA.Excel.Files
Library    RPA.Calendar
Library    RPA.Email.ImapSmtp
Library    openpyxl
# Library    Send_mail.py

*** Variables ***
${TEMP_DIRECTORY_PATH}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/ESIC_Temp_Card/
${DOWNLOAD_PATH}              /home/buzzadmin/Downloads/
${API_URL}                    http://10.12.0.243/epf-cap-predict/
${SHEET_NAME}                 Sheet1
${username}                   admindemo      
${password}                   admindemo
${Pending_file_path}          ${TEMP_DIRECTORY_PATH}Pending_data.xlsx
${SCREENSHOT_FILE}            ${TEMP_DIRECTORY_PATH}screenshot.png
${CAPTCH_TEXT_FILE}           ${TEMP_DIRECTORY_PATH}cleaned_text.txt
${screenshot}                 ${TEMP_DIRECTORY_PATH}
${CREDENTIAL_FILE_PATH}       ${DOWNLOAD_PATH}Esic Login ID & Pswrd-Buzz.xlsx
${EXCEL_FILE_PATH}            ${DOWNLOAD_PATH}ESIC_No_Template (2).xlsx
${DOWNLOAD_FOLDER}            ${TEMP_DIRECTORY_PATH}/${FILE_NAME}
${FILE_NAME}                   
# ${input_txt_path}             ${TEMP_DIRECTORY_PATH}Status.txt
${EMAIL_SERVER}               smtp.gmail.com
${EMAIL_PORT}                 587
${EMAIL_USERNAME}             dodla.manasa@buzzworks.com
${EMAIL_PASSWORD}             bdws kzyb rojb yzpx
${EMAIL_SENDER}               dodla.manasa@buzzworks.com
${TAGGED_EMAIL}               lakshmi.l@buzzworks.com    #shashwat.b@buzzworks.com      #bandari.akhil@buzzworks.com     
${ATTACHMENTS}                ${TEMP_DIRECTORY_PATH}Pending_data.xlsx
${SUBJECT}                    Tagged Cases
${BODY}                       Hi Compliance Team, please go through the attached entries whose esic number couldn't be generated.

# ${SCREENSHOT_FILE}          /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/ESIC_Temp_Card/screenshot.png
# ${CAPTCH_TEXT_FILE}         /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/ESIC_Temp_Card/cleaned_text.txt
# ${API_URL}                  http://10.12.0.65/epf-cap-predict/
# ${screenshot}               /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/ESIC_Temp_Card
# ${CREDENTIAL_FILE_PATH}     /home/buzzadmin/Downloads/Esic Login ID & Pswrd-Buzz.xlsx
# ${EXCEL_FILE_PATH}          /home/buzzadmin/Downloads/ESIC_No_Template.xlsx
# ${SHEET_NAME}               Sheet1

*** Keywords *** 
Open ESIC website
    Open Browser    https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx    firefox           
    Maximize Browser Window

Login Process Loop
    [Arguments]     ${user}    ${pswd}    
    Wait Until Element Is Visible    id=txtUserName    timeout=90s     
    Input Text    id=txtUserName    ${user}
    Sleep    1s
    Wait Until Element Is Visible    id=txtPassword    timeout=90s    
    Input Password    id=txtPassword    ${pswd}
    Sleep    1s
    Wait Until Element Is Visible    xpath=//*[@id='img1']    timeout=90s
    Capture Element Screenshot    xpath=//*[@id='img1']    ${SCREENSHOT_FILE}
    ${result}=    Run Process    python3    extract_text.py    ${SCREENSHOT_FILE}    ${API_URL}
    Log    ${result.stdout}
    Log    ${result.stderr}
    Should Be Equal As Strings    ${result.rc}    0   
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=txtChallanCaptcha     ${file_content}
    Wait Until Element Is Visible    xpath://*[@id="btnLogin"]    timeout=90s
    Click Button    xpath://*[@id="btnLogin"]    # Assuming this is the login button09:41:53 AM
    Sleep    5s
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url}

Open Hoppr website
    Open Browser    https://app.hoppr.in/login    firefox
    Maximize Browser Window

Login Process of Hoppr
    Wait Until Element Is Visible    //input[@id="email" and @type='text']    timeout=60s
    Input Text    //input[@id="email" and @type='text']    ${username}

    Wait Until Element Is Visible    //input[@id="password" and @type='password']    timeout=60s
    Input Password    //input[@id="password" and @type='password']    ${password}

    Wait Until Element Is Visible    //button[@type='submit' and contains(text(), 'Login')]    timeout=60s
    Click Element    //button[@type='submit' and contains(text(), 'Login')]    

Run captcha loop
    [Arguments]    ${user}    ${pswd}
    
    FOR    ${attempt}    IN RANGE    10
        ${current_url}=    Login Process Loop    ${user}    ${pswd}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END    

fetch username based on location 
    [Arguments]  ${temp}    
    Log    its a match
    ${location_username}=    Set Variable    ${temp}[User Name]
    [Return]    ${location_username}

fetch password based on location 
    [Arguments]  ${temp}    
    Log    its a match
    ${location_password}=    Set Variable    ${temp}[PASSWORD] 
    [Return]    ${location_password} 

Click Close Button 
    Wait Until Element Is Visible    xpath://*[@id="div1_close"]    timeout=300s 
    Click Button    xpath://*[@id="div1_close"]
    Click Button    xpath://*[@id="btnpnlSanjeevanicolse"]
    Click Button    xpath://*[@id="btnpnlcolse"]
    Click Button    xpath://*[@id="btnpnlPwdcolse"]   

Switch To Another New Window
    ${window_handles}=    Get Window Handles
    ${new_window_index}=    Evaluate    len(${window_handles}) - 1
    Switch Window    ${window_handles}[${new_window_index}] 

Switch Back To Original Window
    ${window_handles}=    Get Window Handles
    ${previous_window_index}=    Evaluate    len(${window_handles}) - 2
    Switch Window    ${window_handles}[${previous_window_index}] 

Close Current Window And Switch Back
    ${window_handles}=    Get Window Handles
    ${previous_window_index}=    Evaluate    len(${window_handles}) - 3
    Switch Window    ${window_handles}[${previous_window_index}]

Switch To Main Window
    ${window_handles}=    Get Window Handles
    ${previous_window_index}=    Evaluate    len(${window_handles}) - 4
    Switch Window    ${window_handles}[${previous_window_index}]

Take a page screenshot
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${screenshot_path}=    Capture Page Screenshot
    ...    filename=${screenshot}/screenshot_${timestamp}.png
    Log    Screenshot saved to: ${screenshot_path}    

Click Register New IP
    Wait Until Element Is Visible    id=lnkRegisterNewIP    timeout=300s
    Click Element    id=lnkRegisterNewIP    

Click IsRegister with Aadhar No 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_1"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_1"]
    Sleep    1s

Click Continue Button
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnContinue"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_btnContinue"] 
    Sleep    2s

Click ESIC Number No
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_1"]    timeout=300s
    Click Button    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_1"] 
    Sleep    1s

Click ESIC Number Yes 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_0"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_0"]    
    Sleep    1s 

Enter ESIC No and DOJ
    [Arguments]    ${NumGen}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtIPNumber"]    timeout=300s
    Input Text    //input[@id="ctl00_HomePageContent_ctrlTxtIPNumber"]    ${NumGen}[ESIC No]
    Sleep    1s
    
    ${DOJ_Element}=    Set Variable    ${NumGen}[Date of Joining]
    Log    ${DOJ_Element}   
    ${date}    Evaluate    datetime.datetime.strptime('${DOJ_Element}', '%Y-%m-%d %H:%M:%S').strftime('%d/%m/%Y')
    Log    ${date} 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtAppointmentDate"]    timeout=300s
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_ctrlTxtAppointmentDate').value = '${date}'    
    Sleep    2s

Condition for Personal details for YES

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']    timeout=300s             # Address detail open link
    Click Element    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']
    Sleep    2s

    Wait Until Element Is Visible    //input[@id="close_btn" and @type='submit']    timeout=300s                                         # Address details close button
    Click Element    //input[@id="close_btn" and @type='submit'] 

Condition for Bank details for YES
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio']    timeout=300s                # Bank details open link
    Click Element    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio'] 
    Sleep    2s 

    Wait Until Element Is Visible    //input[@id="btnCancel" and @type='button']    timeout=300s                                         # Bank details close button
    Click Element    //input[@id="btnCancel" and @type='button']                                                                                                                        

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @type='submit']    timeout==300s             # Update button
    Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @type='submit']

Condition for Upadation of Personal Address
    
    Click Link    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']
    Sleep    1s
    Click Element    //input[@id="btnCancel" and @value='Close']   

Condition for Upadation of Bank Details
    [Arguments]    ${row}
    
    Click Link    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']
    Sleep    1s
    Click Element    //input[@id="btnCancel" and @value='Close']  

    Close Current Window And Switch Back
    Sleep    1s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update']     timeout=300s                # Update button
    Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update'] 

    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Log    Current Date: ${current_date}
    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Updated Sucessfully
    Set Cell Value    ${row}    AG    ${current_date}
    Set Cell Value    ${row}    AH    Success
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}
    
Updating the Bank Details for YES 
    [Arguments]    ${row}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio']    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio']   
    sleep    1s

    Switch To Another New Window
    Sleep    2s
    Maximize Browser Window

    # ${is_enabled1}=    Run Keyword And Return Status    Element Should Be Enabled    id=ctl00_HomePageContent_rdAddressDetails
    # Log    ${is_enabled1}
    # ${is_enabled2}=    Run Keyword And Return Status    Element Should Be Enabled    id=ctl00_HomePageContent_rdBankDetails
    # Log    ${is_enabled2}

    ${element_disabled}    Execute Javascript    return document.getElementById('ctl00_HomePageContent_rdPersonalDetails').disabled
    Log    ${element_disabled}
    Run Keyword If    '${element_disabled}'=='False'    Click Element    id=ctl00_HomePageContent_rdPersonalDetails

    # Run Keyword If    '${is_enabled1}' == 'True'    Condition for Upadation of Personal Address    # Click the link if it's enabled
    # Run Keyword If    '${is_enabled2}' == 'True'    Condition for Upadation of Bank Details    ${row}       

    # Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update']     timeout=300s                # Update button
    # Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update'] 

    # ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    # Log    Current Date: ${current_date}
    # Open Workbook    ${EXCEL_FILE_PATH}
    # Set Cell Value    ${row}    AF    Updated Sucessfully
    # Set Cell Value    ${row}    AG    ${current_date}
    # Set Cell Value    ${row}    AH    Success
    # Save Workbook
    # Close Workbook
    # Close Window
    # [Return]    ${row}

Click Validation Link 
    Wait Until Element Is Visible    //a[@id="ctl00_HomePageContent_lnkmobilecheck"]    timeout=300s
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_lnkmobilecheck').click()  

Perform Actions For Length 2
    [Arguments]    ${NumGen}    ${row}
    Click Proceed 
    Sleep    2s
    Click Continue after validation Link    ${NumGen}    ${row}

Perform Actions For Length 3
    [Arguments]    ${NumGen}    ${row}       
    
    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Log    Current Date: ${current_date}
    Open Workbook    ${EXCEL_FILE_PATH} 
    Set Cell Value    ${row}    AF    Already Tagged
    Set Cell Value    ${row}    AG    ${current_date}
    Set Cell Value    ${row}    AH    Success
    Save Workbook
    Close Workbook
    Click Element    css=#ctl00_HomePageContent_btncancel
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_button').click();
    Sleep    4s
    [Return]    ${row}
    
Click Proceed 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnmobile"]    timeout=90s
    Click Element    //input[@id="ctl00_HomePageContent_btnmobile"]

Click Continue after validation Link
    [Arguments]    ${NumGen}    ${row}

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnContinue"]    timeout=300s
    Click Button    //input[@id="ctl00_HomePageContent_btnContinue"]
    # Handle Alert    Accept
    # Submit Form
    RPA.Desktop.Press Keys     ENTER 
    Sleep    2s 
    Switch To Another New Window
    Filling Employee Registration details    ${NumGen} 
    Filling Nominee details    ${NumGen}    ${row}
    # Filling Family details    ${NumGen} 
    Filling Bank details    ${NumGen}    ${row}
    
Choose Date of Birth From Calendar
    [Arguments]    ${NumGen}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ctrlTxtIpDate    timeout=30s
    Click Element    id=ctl00_HomePageContent_ctrlTxtIpDate
    Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]    timeout=30s
    Click Element    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]
    Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]    timeout=30s
    Click Element    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]
    Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]    timeout=30s
    Click Element    //*[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_title"]

    ${Month_dictionary}=    Create Dictionary    01=0_0    02=0_1    03=0_2    04=0_3    05=1_0    06=1_1    07=1_2    08=1_3    09=2_0    10=2_1    11=2_2    12=2_3
    ${Year_dictionary}=    Create Dictionary    0=0_1    1=0_2    2=0_3    3=1_0    4=1_1    5=1_2    6=1_3    7=2_0    8=2_1    9=2_2 
    ${loop_dictioinary}=    Create Dictionary    201=2    200=3    199=4    198=5    197=6    196=7    195=8    194=9    193=10    192=11    191=12    190=13  
    ${Month_mapping}=    Create Dictionary    01=January    02=February    03=March    04=April    05=May    06=June    07=July    08=August    09=September    10=October    11=November    12=December

    ${date}=    Set Variable    ${NumGen}[Birth Date]  
    ${result}=    Split String    ${date}    separator=-
    Log    ${result}
    ${day}=    Set Variable    ${result}[0]
    ${month}=    Set Variable    ${result}[1]
    ${year}=    Set Variable    ${result}[2]

    ${day_of_week}=    Evaluate    datetime.datetime.strptime('${date}','%d-%m-%Y').strftime('%A')
    Log    ${day_of_week}

    ${month_element}=    Get From Dictionary    ${Month_dictionary}    ${month} 
    Log    ${month_element}

    ${month_map}=    Get From Dictionary    ${Month_mapping}    ${month}
    Log    ${month_map}

    ${day_element}=    Set Variable    ${day_of_week}, ${month_map} ${day}, ${year}
    Log    ${day_element}     
    
    ${Year_first_three}=    Get Substring    ${year}    0    3
    Log    ${Year_first_three}

    ${find_year_last_num}=    Get Substring    ${year}    -1    
    Log    ${find_year_last_num}

    ${year_element}=    Get From Dictionary    ${Year_dictionary}    ${find_year_last_num}
    Log    ${year_element}
    
    ${numofloops}=    Get From Dictionary    ${loop_dictioinary}    ${Year_first_three}
    Log    ${numofloops}

    FOR    ${i}    IN RANGE   int(${numofloops})
        Log    ${year} 
        Wait Until Element Is Visible    //div[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_prevArrow"]    timeout=30s
        Click Element    xpath=//div[@id="ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_prevArrow"]
        Sleep    2s
    END 
    Sleep    2s
    ${x}=    Click Element    id=ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_year_${year_element}
    Log    ${x}
    Sleep    2s
    ${y}=    Click Element    id=ctl00_HomePageContent_CalendarExtenderCtrlTxtEndDate_month_${month_element}
    Log    ${y}
    Sleep    2s  
    ${z}=     Click Element    xpath=//div[@title="${day_element}"]  
    # ${z}=    Click Element    //div[@class="ajax__calendar_day" and contains(text(), ${day})]
    Log    ${z}

Choose Date of Joining From Calendar
    [Arguments]    ${NumGen}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ctrlDIDateOfAppointmentDy    timeout=300s
    Click Element    id=ctl00_HomePageContent_ctrlDIDateOfAppointmentDy
    Wait Until Element Is Visible    //*[@id="ctl00_HomePageContent_cEDOA_title"]    timeout=300s
    Click Element    //*[@id="ctl00_HomePageContent_cEDOA_title"]
    Click Element    //*[@id="ctl00_HomePageContent_cEDOA_title"]
    Click Element    //*[@id="ctl00_HomePageContent_cEDOA_title"]

    ${Month_dictionary}=    Create Dictionary    01=0_0    02=0_1    03=0_2    04=0_3    05=1_0    06=1_1    07=1_2    08=1_3    09=2_0    10=2_1    11=2_2    12=2_3
    ${Year_dictionary}=    Create Dictionary    0=0_1    1=0_2    2=0_3    3=1_0    4=1_1    5=1_2    6=1_3    7=2_0    8=2_1    9=2_2 
    ${loop_dictioinary}=    Create Dictionary    202=1    201=2    200=3    199=4    198=5    197=6    196=7    195=8    194=9    193=10    192=11    191=12    190=13    
    ${Month_mapping}=    Create Dictionary    01=January    02=February    03=March    04=April    05=May    06=June    07=July    08=August    09=September    10=October    11=November    12=December


    ${date}=    Set Variable    ${NumGen}[Date of Joining]  
    Log    ${date}
    ${date}    Evaluate    datetime.datetime.strptime('${date}', '%Y-%m-%d %H:%M:%S').strftime('%d-%m-%Y')
    Log    ${date}
    ${result}=    Split String    ${date}    separator=-
    Log    ${result}
    ${day}=    Set Variable    ${result}[0]
    ${month}=    Set Variable    ${result}[1]
    ${year}=    Set Variable    ${result}[2]

    ${day_of_week}=    Evaluate    datetime.datetime.strptime('${date}', '%d-%m-%Y').strftime('%A')
    Log    ${day_of_week}

    ${month_element}=    Get From Dictionary    ${Month_dictionary}    ${month}
    Log    ${month_element}

    ${month_map}=    Get From Dictionary    ${Month_mapping}    ${month}
    Log    ${month_map}

    ${day_element}=    Set Variable    ${day_of_week}, ${month_map} ${day}, ${year}
    Log    ${day_element} 
    
    ${Year_first_three}=    Get Substring    ${year}    0    3
    Log    ${Year_first_three}

    ${find_year_last_num}=    Get Substring    ${year}    -1    
    Log    ${find_year_last_num}

    ${year_element}=    Get From Dictionary    ${Year_dictionary}    ${find_year_last_num}
    Log    ${year_element}
    
    ${numofloops}=    Get From Dictionary    ${loop_dictioinary}    ${Year_first_three}
    Log    ${numofloops}

    FOR    ${i}    IN RANGE   int(${numofloops})
        Log    ${year} 
        Click Element    xpath=//div[@id="ctl00_HomePageContent_cEDOA_prevArrow"]
        Sleep    2s
    END 
    Sleep    2s
    ${X}=    Click Element    id=ctl00_HomePageContent_cEDOA_year_${year_element}
    Log    ${X}
    Sleep    2s
    ${Y}=    Click Element    id=ctl00_HomePageContent_cEDOA_month_${month_element}
    Log    ${Y}
    Sleep    2s
    ${Z}=     Click Element    xpath=//div[@title="${day_element}"] 
    # ${Element}=    Get WebElement     //div[@class="ajax__calendar_day" and contains(text(), ${day})]
    Log    ${Z}    

Perform these actions for Unmarried
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=300s       # check Box
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    Sleep    1s
    ${Father_Name}=  Set Variable  ${NumGen}[Father Name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=300s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    ${Gender}=    Set Variable    ${NumGen}[Gender]                                                                                              # Gender
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=300s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    RPA.Desktop.Press Keys     ENTER                                                                                                             # Pop-up                                                  
    Sleep    2s

Perform these actions for Married
    [Arguments]    ${NumGen}
    ${Husband_Checkbox}=    Set Variable    Husband
    Log    ${Husband_Checkbox}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_1" and @value='${Husband_Checkbox}']    timeout=30s
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_1" and @value='${Husband_Checkbox}']
    ${Husband_Name}=  Set Variable  ${NumGen}[Spouse Name]
    Log    ${Husband_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Husband_Name}   

Perform these actions for Widow
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=30s       # Check Box
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    ${Father_Name}=  Set Variable  ${NumGen}[Father Name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    ${marital_status}=    Set Variable     ${NumGen}[Marital Status]                                                                             # Martial status
    Wait Until Element Is Visible     //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']    timeout=30s
    Click Element    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']
    ${Gender}=    Set Variable    ${NumGen}[Gender]                                                                                              # Gender
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=30s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    RPA.Desktop.Press Keys     ENTER                                                                                                             # Pop-up                                                  
    Sleep    2s

Perform these actions for Widower
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=30s
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    ${Father_Name}=  Set Variable  ${NumGen}[Father Name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    ${marital_status}=    Set Variable     ${NumGen}[Marital Status]                                                                             # Martial status
    Wait Until Element Is Visible    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']    timeout=30s
    Click Element    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']
    ${Gender}=    Set Variable    ${NumGen}[Gender]                                                                                              # Gender
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=30s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    RPA.Desktop.Press Keys     ENTER                                                                                                             # Pop-up                                                  
    Sleep    2s

Condition for Father or Husband checkbox and Name
    [Arguments]    ${NumGen}
    ${Status}=    Create Dictionary    Single=UnMarried    None=UnMarried    UnMarried=UnMarried    Unmarried=UnMarried    Married=Married    married=Married
    Log    Selected month value is ${Status}
    ${marital} =  Set Variable    ${NumGen}[Marital Status]
    ${marital_status}=    Get From Dictionary    ${Status}    ${marital}
    Log    Selected status value is ${marital_status}
    Run Keyword If  '${marital_status}' == 'UnMarried'
    ...    Perform these actions for Unmarried    ${NumGen}    
    ...    ELSE IF    '${marital_status}' == 'Married'    
    ...    Perform these actions for Married    ${NumGen}
    ...    ELSE IF    '${marital_status}' == 'Widow'    
    ...    Perform these actions for Widow    ${NumGen}
    ...    ELSE    Perform these actions for Widower    ${NumGen} 

Condition for Current Address
    [Arguments]    ${NumGen}
    
    Wait Until Element Is Visible    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    timeout=90s
    ${Current_Address}=    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${NumGen}[Current Address]               # Curent_Adress
    Log    ${Current_Address}
    
    ${Current_State}=    Set Variable    ${NumGen}[Current State]                                                                                 # Current State  
    Log    ${Current_State}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ctrlTxtPresentState    timeout=30s
    Select From List By Label    id=ctl00_HomePageContent_ctrlTxtPresentState    ${Current_State}
    
    ${Current_District}=    Set Variable    ${NumGen}[Current City]                                                                               # Current District
    Log    ${Current_District}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ctrlTextPresentDistrict    timeout=30s
    Sleep    2s
    Select From List By Label    id=ctl00_HomePageContent_ctrlTextPresentDistrict    ${Current_District}    

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    timeout=30s
    ${Current_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    ${NumGen}[Current Zipcode]                # Current Zipcode
    Log    ${Current_Pin_code} 

Address1 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Current Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}
    Log    ${p}

Address2 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Current Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[Current Address]    50   99  
    Log    ${q}  
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress2']    ${q}    

Address3 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Current Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}    
    ${q}=    Get Substring    ${NumGen}[Current Address]    50   99
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress2']    ${q}
    ${r}=    Get Substring    ${NumGen}[Current Address]    100   
    Log    ${r}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress3']    ${r}     

Address1 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Permanent Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}

Address2 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Permanent Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[Permanent Address]    50   99 
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress2']    ${q}       

Address3 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[Permanent Address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[Permanent Address]    50   99
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress2']    ${q}
    ${r}=    Get Substring    ${NumGen}[Permanent Address]    100 
    Log    ${r}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress3']    ${r}     

Condition for filling Permanent Address in Emp Reg
    [Arguments]    ${NumGen}

    ${Permanent_Address}=    Set Variable    ${NumGen}[Permanent Address]         # Permanent Address
    Log    ${Permanent_Address}
    ${Address_length}=    Get Length    ${Permanent_Address}
    Log    ${Address_length}

    IF    $Address_length < 50
        Run Keyword    Address1 Permanant    ${NumGen}
    END

    IF    $Address_length > 50 & $Address_length < 100
        Run Keyword    Address2 Permanant    ${NumGen}
    END

    IF    $Address_length > 100
        Run Keyword    Address3 Permanant   ${NumGen}
    END
    
    ${Permanent_State}=    Set Variable    ${NumGen}[Permanant State]                                                                             # Permanent state
    Log    ${Permanent_State}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]/option[text()='${Permanent_State}']
    # Select From List By Label    id=ctl00_HomePageContent_ctrlTextPermanentState    ${Permanent_State}
    
    ${Permanent_District}=    Set Variable    ${NumGen}[Permanent City]                                                                           # Permanent District
    Log    ${Permanent_District}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]    timeout=90s 
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]/option[text()='${Permanent_District}']
    # Select From List By Label    id=ctl00_HomePageContent_ctrlTextPermanentDistrict    ${Permanent_District}  
    Sleep    2s     
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextPermanentPinCode"]    timeout=90s
    ${Permanent_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextPermanentPinCode"]    ${NumGen}[Permanent Zipcode]        # Permanent Zipcode
    Log    ${Permanent_Pin_code} 

Condition for filling Permanent Address in Nominee
    [Arguments]    ${NumGen}
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    timeout=300s
    ${Nominee_Address}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    ${NumGen}[Permanent Address]                    # Address
    Log     ${Nominee_Address}

    Wait Until Element Is Visible    id=ctl00_HomePageContent_States    timeout=300s  
    Select From List By Label    id=ctl00_HomePageContent_States    ${NumGen}[Permanant State]                                                    # State
    Sleep    2s

    Wait Until Element Is Visible    id=ctl00_HomePageContent_Districts    timeout=300s
    Select From List By Label    id=ctl00_HomePageContent_Districts    ${NumGen}[Permanent City]
    Sleep    2s

Condition for Current Address in Nominee
    [Arguments]    ${NumGen}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    timeout=300s
    ${Nominee_Address}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    ${NumGen}[Current Address]                     # Address
    Log     ${Nominee_Address}

    Wait Until Element Is Visible    id=ctl00_HomePageContent_States    timeout=90s
    Select From List By Label    id=ctl00_HomePageContent_States    ${NumGen}[Current State]                                                     # State
    Sleep    2s

    Wait Until Element Is Visible    id=ctl00_HomePageContent_Districts    timeout=90s
    Select From List By Label    id=ctl00_HomePageContent_Districts    ${NumGen}[Current City]                                                   # District
    Sleep    2s

Condition for Bank if IFSC found
    [Arguments]    ${NumGen}    ${row}

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtacc_number" and @type='text']    timeout=300s
    ${Account_No}=    Input Text    //input[@id="ctl00_HomePageContent_txtacc_number" and @type='text']    ${NumGen}[Bank Account Number]      # Account No
    Log    ${Account_No}
    
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ddlAccountType    timeout=90s                                                    # Saving Account
    Select From List By Label    id=ctl00_HomePageContent_ddlAccountType    ${NumGen}[Account type]

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnsubmit" and @value='Submit']    timeout=90s                         # Submit of Bank details
    Click Element    //input[@id="ctl00_HomePageContent_btnsubmit" and @value='Submit']
    Sleep    1s
    
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present
    Log    ${alert_present}
    Run Keyword If    $alert_present    Condition for Account No if POP-UP    ${NumGen}    ${row}
    ...    ELSE    Condition for Next Steps    ${row}    ${NumGen} 

Condition for Nominee Details if not None
    [Arguments]    ${NumGen}    ${row}

    Wait Until Element Is Visible    //a[@onclick="openWin('NomineeDetails.aspx','','dialogWidth:1000px; dialogHeight:800px; center:yes')"]    timeout=300s
    Click Element    //a[@onclick="openWin('NomineeDetails.aspx','','dialogWidth:1000px; dialogHeight:800px; center:yes')"]
    Switch To Another New Window
    Sleep    2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextUserName"]    timeout=300s
    ${Nominee_Name_Element}=    Set Variable    ${NumGen}[Nominee Name] 
    ${Nominee_Name}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextUserName"]    ${Nominee_Name_Element}                        # Nominee Name
    Log    ${Nominee_Name}    
    # ${Element_exist}=    Run Keyword If    '${Nominee_Name_Element}'=='None'    Condition for Name in Nominee    ${NumGen}  
    # Sleep    2s     
    
    ${Permanent_Address_Element}=    Set Variable    ${NumGen}[Permanent Address]
    Log      ${Permanent_Address_Element}
    ${Element_exist}=    Run Keyword If    '${Permanent_Address_Element}'=='None'    Condition for Current Address in Nominee    ${NumGen}
    ...    ELSE    Condition for filling Permanent Address in Nominee    ${NumGen}  

    Wait Until Element Is Visible    id=ctl00_HomePageContent_RelationShipWithIp    timeout=300s
    ${Relation}=    Set Variable    ${NumGen}[Nominee Relation]                                                                                # Relation
    Wait Until Element Is Visible    id=ctl00_HomePageContent_RelationShipWithIp    timeout=300s
    Select From List By Label    id=ctl00_HomePageContent_RelationShipWithIp    ${Relation}                        #${NumGen}[]

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistNomneeAkaFamily_0"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistNomneeAkaFamily_0"]                                                            # Check box

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_Save" and @type='submit']    timeout=300s                     
    Click Button    //input[@id="ctl00_HomePageContent_Save" and @type='submit']                                                               # Save Button  

    Switch Back To Original Window
    Sleep   3s     

Condition for Bank Details if not None
    [Arguments]    ${NumGen}    ${row}
    
    Wait Until Element Is Visible    css=#Tr18 > td:nth-child(2) > a    timeout=300s
    Click Element    css=#Tr18 > td:nth-child(2) > a
    Switch To Another New Window
    Sleep    2s
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtIFSCcode"]    timeout=300s
    ${IFSC_Code}=    Input Text    //input[@id="ctl00_HomePageContent_txtIFSCcode"]    ${NumGen}[IFSC Code]                                    # IFSC Code
    Log    ${IFSC_Code}
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnIFSCcode" and @value='Search']    timeout=30s
    Click Button    //input[@id="ctl00_HomePageContent_btnIFSCcode" and @value='Search']                                                       # Search Button
    Sleep    1s
    
    ${IFSC_Code_Element}=    Run Keyword And Return Status    Element should be Visible    //span[@id="ctl00_HomePageContent_lblErrorMessage"]
    Log    ${IFSC_Code_Element}
    ${Element_exist}=    Run Keyword If    '${IFSC_Code_Element}' == 'False'    Condition for Bank if IFSC found    ${NumGen}    ${row} 
    ...    ELSE    Condition for Bank if IFSC not found    ${row}       

Condition for Nominee details if None
    [Arguments]    ${row}
    
    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Nominee Name not provided
    Set Cell Value    ${row}    AH    Pending
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}

Condition for Nominee relation details if None
    [Arguments]    ${row}
    
    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Nominee relation not provided
    Set Cell Value    ${row}    AH    Pending
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}

Condition for Bank details is None
    [Arguments]    ${row}
    
    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Bank details not provided
    Set Cell Value    ${row}    AH    Pending
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}

Condition for Account No if POP-UP 
    [Arguments]    ${NumGen}    ${row}

    RPA.Desktop.Press Keys    ENTER
    Sleep    2s

    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Bank Account is Already Tagged    
    Set Cell Value    ${row}    AH    Pending  
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}

Condition for Bank if IFSC not found
    [Arguments]    ${row}  

    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    Bank IFSC not Found
    Set Cell Value    ${row}    AH    Pending
    Save Workbook
    Close Workbook  
    Close Window
    [Return]    ${row}

Condition for Next Steps 
    [Arguments]    ${row}    ${NumGen}   
    
    Close Current Window And Switch Back
    Sleep   2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']    timeout=300s               # Check box
    Click Element    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']
    Sleep    2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_Submit"]    timeout=300s                                        # Submit Button of all details 
    Click Button    //input[@id="ctl00_HomePageContent_Submit"]  
    sleep    2s  

    Take a page screenshot
    
    Wait Until Element Is Visible    xpath=//span[@id="ctl00_HomePageContent_ctrlLabelIPNumber"]    timeout=300s                           # Updating details to EXCEL
    ${ESIC_NO_Created}=    Get Text    xpath=//span[@id="ctl00_HomePageContent_ctrlLabelIPNumber"]
    Log    ${ESIC_NO_Created}

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_print"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_print"]
    Sleep    5s
    # ${download_path}=    Get Location
    # Copy File    ${download_path}    ${DOWNLOAD_FOLDER}/${FILE_NAME}

    ${current_date}=    Get Current Date    result_format=%d-%m-%Y
    Log    Current Date: ${current_date}
    Open Workbook    ${EXCEL_FILE_PATH}
    Set Cell Value    ${row}    AF    ${ESIC_NO_Created}
    Set Cell Value    ${row}    AG    ${current_date}
    Set Cell Value    ${row}    AH    Success
    Save Workbook
    Close Workbook
    Close Window
    [Return]    ${row}
    
Filling Employee Registration details
    [Arguments]    ${NumGen}  

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextEmpName"]    timeout=300s   
    ${Name}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextEmpName"]    ${NumGen}[Name]                                      # Name
    Log    ${Name}
    
    Condition for Father or Husband checkbox and Name    ${NumGen}

    Choose Date of Birth From Calendar    ${NumGen}   

    ${Current_Address}=    Set Variable    ${NumGen}[Current Address]                                                                      # Current_Adress
    Log    ${Current_Address}
    ${Address_length}=    Get Length    ${Current_Address}
    Log    ${Address_length}

    IF    $Address_length < 50
        Run Keyword    Address1 Current    ${NumGen}
    END

    IF    $Address_length > 50 & $Address_length < 100
        Run Keyword    Address2 Current    ${NumGen}
    END

    IF    $Address_length > 100
        Run Keyword    Address3 Current    ${NumGen}
    END

    ${Current_State}=    Set Variable    ${NumGen}[Current State]                                                                          # Current State  
    Log    ${Current_State}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]/option[text()='${Current_State}']
    # Select From List By Label    id=ctl00_HomePageContent_ctrlTxtPresentState    ${Current_State}

    ${Current_District}=    Set Variable    ${NumGen}[Current City]                                                                        # Current District
    Log    ${Current_District}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]/option[text()='${Current_District}']
    # Select From List By Label    id=ctl00_HomePageContent_ctrlTextPresentDistrict    ${Current_District}    

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    timeout=90s
    ${Current_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    ${NumGen}[Current Zipcode]         # Current Zipcode
    Log    ${Current_Pin_code}

    ${Permanent_Address_Element}=    Set Variable    ${NumGen}[Permanent Address]
    Log      ${Permanent_Address_Element}
    ${Element_exist}=    Run Keyword If    '${Permanent_Address_Element}'=='None'    Click Element    //input[@id="ctl00_HomePageContent_chkboxCopyPresentAddress"]
    ...    ELSE    Condition for filling Permanent Address in Emp Reg    ${NumGen}   

    ${Dispensary_state_Emp}=    Set Variable    ${NumGen}[ESIC State Dispensary]                                                            # Dispensary state Emp
    Log    ${Dispensary_state_Emp} 
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]
    Sleep    2s
    click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]/option[text()='${Dispensary_state_Emp}']
    # Sleep    2s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ddlDispensaryState    timeout=60s
    # Select From List By Label    id=ctl00_HomePageContent_ddlDispensaryState    ${Dispensary_state_Emp}    
    # # Sleep    2s

    ${Dispensary_district_Emp}=    Set Variable    ${NumGen}[ESIC District Dispensary]                                                     # Dispensary District Emp
    Log    ${Dispensary_district_Emp} 
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]    timeout=90s
    click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]/option[text()='${Dispensary_district_Emp}']
    # click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]
    # Sleep    2s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ddlDispensaryDistrict    timeout=60s
    # Select From List By Label    id=ctl00_HomePageContent_ddlDispensaryDistrict    ${Dispensary_district_Emp}
    # # Sleep    5s 

    ${Dispensary_Hospital_Emp}=    Set Variable    ${NumGen}[Dispensary Employee]                                                          # Dispensary Hospital Emp
    Log    ${Dispensary_Hospital_Emp}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]    timeout=90s 
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]/option[text()='${Dispensary_Hospital_Emp}']
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ctrlTextDispensary    timeout=60s
    # Select From List By Label    id=ctl00_HomePageContent_ctrlTextDispensary     ${Dispensary_Hospital_Emp} 
    # Sleep    5s   

    ${Dispensary_state_Fam}=    Set Variable    ${NumGen}[ESIC State Dispensary]                                                            # Dispensary State Fam
    Log    ${Dispensary_state_Fam}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]
    Sleep    2s
    Click Element     //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]/option[text()='${Dispensary_state_Fam}']
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ddldependantDispensaryState    timeout=60s 
    # Select From List By Label    id=ctl00_HomePageContent_ddldependantDispensaryState    ${Dispensary_state_Fam}
    # Sleep    5s

    ${Dispensary_district_Fam}=    Set Variable    ${NumGen}[ESIC District Dispensary]                                                     # Dispensary District Fam
    Log    ${Dispensary_district_Fam} 
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]/option[text()='${Dispensary_district_Fam}']
    # Sleep    2s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ddldependantDispensaryDistrict    timeout=60s   
    # Select From List By Label    id=ctl00_HomePageContent_ddldependantDispensaryDistrict    ${Dispensary_district_Fam} 
    # Sleep    5s   

    ${Dispensary_Hospital_Fam}=    Set Variable    ${NumGen}[Dispensary Employee]                                                          # Dispensary Hospital Fam
    Log    ${Dispensary_Hospital_Fam}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]/option[text()='${Dispensary_Hospital_Fam}']
    Sleep    3s
    # Wait Until Element Is Visible    id=ctl00_HomePageContent_ddldependantdispensary    timeout=60s    
    # Select From List By Label    id=ctl00_HomePageContent_ddldependantdispensary    ${Dispensary_Hospital_Fam}
    # Sleep    8s 

    Choose Date of Joining From Calendar    ${NumGen}
    # Sleep    1s

    Wait Until Element Is Visible    id=ctl00_HomePageContent_ddllanguage    timeout=30s                                                        # Language
    Select From List By Label    id=ctl00_HomePageContent_ddllanguage    ${NumGen}[SMS]
    Sleep    2s

Filling Nominee details
    [Arguments]    ${NumGen}    ${row}

    ${Nominee_Name_element}=    Set Variable    ${NumGen}[Nominee Name]
    Log    ${Nominee_Name_element}

    ${Nominee_relation_element}=    Set Variable    ${NumGen}[Nominee Relation]
    Log    ${Nominee_relation_element}  
    
    IF    '${Nominee_Name_element}' == 'None' 
        Condition for Nominee details if None     ${row}
    ELSE IF    '${Nominee_relation_element}' == 'None'
        Condition for Nominee relation details if None    ${row}
    ELSE
        Condition for Nominee Details if not None    ${NumGen}    ${row}            
    END    

Filling Family details
    [Arguments]    ${NumGen}

    # ${Martial_element}=    Set Variable    ${NumGen}[Marital Status]
    # Log    ${Martial_element}

    # IF    '${Martial_element}' == 'Single'
    #     Condition for single
    # ELSE
    #     Condition for Married        ...    Perform these actions for Married    ${NumGen}

    # END

    Wait Until Element Is Visible    css=#Tr12 > td:nth-child(2) > a:nth-child(1)    timeout=300s
    Click Element    css=#Tr12 > td:nth-child(2) > a     
    Switch To Another New Window
    Sleep    2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtName"]    timeout=300s
    ${Family_Name}=    Input Text    //input[@id="ctl00_HomePageContent_txtName"]    ${NumGen}[Father Name]                                    # Father name
    Log    ${Family_Name}

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_CtrlDOB"]    timeout=30s
    ${DOB}=    Set Variable   ${NumGen}[Date of Birth(Family)]                                                                                 # Date of Birth(family)
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_CtrlDOB').value = '${DOB}'    
    Sleep    2s

    Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlRelation    timeout=90s
    Select From List By Label    id=ctl00_HomePageContent_CtrlRelation    ${NumGen}[Nominee Relation]                                          # Family Relation
    # Sleep    2s

    Wait Until Element Is Visible    id=ctl00_HomePageContent_CtrlTrans    timeout=90s
    Select From List By Label    id=ctl00_HomePageContent_CtrlTrans    Male                                                                    # Gender
    # Sleep    2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlRDIpDisable_0" and @type='radio']    timeout=30s
    Click Button    //input[@id="ctl00_HomePageContent_ctrlRDIpDisable_0" and @type='radio']                                                   # Yes button
    Sleep    2s

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']    timeout=30s
    Click Element    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']                                                      # Check box

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonAdd"]    timeout=30s
    Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonAdd"]                                                                         # Add Button
    Sleep    2s

    Close Current Window And Switch Back
    Sleep    5s

    # Close Window

Filling Bank details 
    [Arguments]    ${NumGen}    ${row}

    ${IFSC_Code_element}=    Set Variable    ${NumGen}[IFSC Code]
    Log    ${IFSC_Code_element}
    
    IF    '${IFSC_Code_element}' == 'None' 
        Condition for Bank details is None     ${row}
    ELSE
        Condition for Bank Details if not None    ${NumGen}    ${row}
    END

Send Email With Pending Data
    [Arguments]    ${pending_rows}    
    ${excel_data}=    Create List
    Append To List    ${excel_data}    ['Name', 'Status']  # Adding header row
    FOR    ${row}    IN    @{pending_rows}
        Append To List    ${excel_data}    [${row['Name']}, ${row['Status']}]  # Adding each row of data
    END
    ${excel_file_path}=    Set Variable    ${Pending_file_path}
    Open Workbook    ${excel_file_path}
    Append Rows To Worksheet    ${excel_data}    Sheet1
    Save Workbook    ${excel_file_path}
    
    # Construct the email body
    ${email_body}=    Set Variable     Hi Compliance Team, please find the pending data in the attached Excel file.
    
    # Send the email with the Excel file as attachment
    Authorize SMTP    ${EMAIL_USERNAME}   ${EMAIL_PASSWORD}  ${EMAIL_SERVER}    ${EMAIL_PORT}
    Send Message     ${EMAIL_SENDER}    ${TAGGED_EMAIL}    ${SUBJECT}    ${email_body}    attachments=${excel_file_path}
    Close Workbook    # Close the workbook after sending the email


*** Test Cases ***
# Launching the Hoppr website
#     Open Hoppr website

# Logging into the Hoppr website
#     Login Process of Hoppr

Fill the form using the data from the excel_file_path
    ${row}=    Set Variable    2
    ${pending_rows}=    Create List
    Open Workbook    ${EXCEL_FILE_PATH}
    ${detail_list}    Read Worksheet As Table    ${SHEET_NAME}    header=True   
    FOR   ${NumGen}    IN   @{detail_list}
        Log    ${NumGen}[Status]
        Log    ${NumGen}[ESIC No]
        IF    '${NumGen}[Status]' == 'None'
            ${user_location}=          Set Variable    ${NumGen}[ESIC Location]   
            Open Workbook    ${CREDENTIAL_FILE_PATH}
            ${temp_list}    Read Worksheet As Table    header=True 
            FOR    ${temp}    IN    @{temp_list}
                ${vary_location}=    Set Variable    ${temp}[Locations]
                Log    ${vary_location}
                Log    ${NumGen}[ESIC Location]
                ${user}=    Run Keyword If    '${user_location}' in '${vary_location}'    fetch username based on location    ${temp}    
                            ...    ELSE  Log    not a match     

                ${pswd}=    Run Keyword If    '${user_location}' in '${vary_location}'    fetch password based on location    ${temp}    
                            ...    ELSE  Log    not a match     
                Log    ${user}
                Log    ${pswd}

                IF    '${user}' != 'None'
                    Open ESIC website
                    Run captcha loop    ${user}    ${pswd}
                    Click Close Button
                    Click Register New IP
                    Switch To Another New Window
                    Click IsRegister with Aadhar No 
                    Click Continue Button
                    
                    IF    '${NumGen}[ESIC No]' != 'None'
                        Click ESIC Number Yes
                        Enter ESIC No and DOJ    ${NumGen}
                        Click Continue Button
                        Updating the Bank Details for YES    ${row} 
                    
                    ELSE    
                        
                        Click ESIC Number No
                        # Handle Alert    Accept
                        # Submit Form
                        RPA.Desktop.Press Keys     ENTER 
                        Sleep    2s
                        Log    ${NumGen}                                 
                        
                        Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtmobilenumber"]    timeout=300s
                        ${Mob_No}=    Input Text   //input[@id="ctl00_HomePageContent_txtmobilenumber"]    ${NumGen}[Mobile Number]                                                                                                                                               
                        Log    ${Mob_No}
                        Click Validation Link 
                        Sleep    3s
                        ${text}=    Get Text    //div[@id="ctl00_HomePageContent_Panel3"]/table[@class='internalTable' ]
                        Log    ${text}
                        ${result}=    Split String    ${text}    separator=\n
                        Log    ${result}
                        ${length}=    Get Length    ${result}
                        Log    Length of result: ${length}
                        ${IsElementVisible}=    Run Keyword And Return Status    Element Should Be Visible    css=#ctl00_HomePageContent_btncancel
                        Log    ${IsElementVisible}
                        IF    '${IsElementVisible}'=='True'
                        Run Keyword If    '${length}' == '3'    Perform Actions For Length 2    ${NumGen}    ${row}    
                        Run Keyword If    '${length}' == '5'    Perform Actions For Length 3    ${NumGen}    ${row}                 
                        ELSE
                        Click Continue after validation Link    ${NumGen}    ${row}
                        END  
                    END
                    Append To List    ${pending_rows}    ${NumGen}
                END
            END
        END
        ${row}=    Evaluate   ${row} + 1
        Log    ${row}
    END  
    Send Email With Pending Data    ${pending_rows}  
    Close Workbook

    
    
    
    
    
    
    
    
    
    
    # ${Email}=    Run Keyword    Send_mail.send_email_with_data    ${EXCEL_FILE_PATH}
    # ${Pending_file_path}=    Run Keyword    Send_mail.send_email_with_data    ${EXCEL_FILE_PATH}
    # ${Email}=    Run Keyword    Send_mail.send_email_with_data    ${EXCEL_FILE_PATH}    ${Pending_file_path}   
    # Append To File    ${input_txt_path}    


    # ${Email}=    Run Keyword    Send_mail.send_email_with_data    ${EXCEL_FILE_PATH}


