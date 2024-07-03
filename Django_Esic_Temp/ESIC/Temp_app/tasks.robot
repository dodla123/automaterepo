*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}
# Library    RPA.Desktop
Library    Process
Library    DateTime    
Library    OperatingSystem
Library    Collections
Library    String
Library    RPA.Excel.Files
Library    RPA.Calendar
Library    RPA.Email.ImapSmtp
# Library    RequestLibrary
Library    RPA.JSON
Library    RPA.HTTP
Library    extract_text.py
Library    RPA.Email.ImapSmtp


*** Variables ***
${SCREENSHOT_FILE}            /home/buzzadmin/Desktop/Django_Esic_Temp/ESIC/Temp_app/screenshot.png
${CAPTCH_TEXT_FILE}           /home/buzzadmin/Desktop/Django_Esic_Temp/ESIC/cleaned_text.txt  
${API_URL}                    http://10.12.0.87/epf-cap-predict/
${BASE_URL}                   http://localhost:8000
${insert_user_data}           ${BASE_URL}/api/insert_user_data/
# {EXCEL_FILE_PATH}
${screenshot}                 /home/buzzadmin/Desktop/Django_Esic_Temp/ESIC/Temp_app
${DOWNLOAD_PATH}              /home/buzzadmin/Downloads
${DOWNLOAD_FOLDER}            /home/buzzadmin/Desktop/Django_Esic_Temp/ESIC/Temp_app/Downloaded_Temp_cards
${EMAIL_SERVER}               smtp.gmail.com
${EMAIL_PORT}                 587
${EMAIL_USERNAME}             dodla.manasa@buzzworks.com
${EMAIL_PASSWORD}             dytr ruja nwck tqwh
${EMAIL_SENDER}               dodla.manasa@buzzworks.com
${TAGGED_EMAIL}               ravikumar@buzzworks.com    #lakshmi.l@buzzworks.com    #shashwat.b@buzzworks.com      #bandari.akhil@buzzworks.com     
${ATTACHMENTS}                Pending_data.xlsx
${SUBJECT}                    Tagged Cases
# ${BODY}                       Hi Compliance Team, please go through the attached entries who's mobile number is Already Tagged.
${login_credentials_data}     ${EMPTY}
${validated_temp_data}        ${EMPTY}
${hoppr_id}                   ${EMPTY} 
${name}                       ${EMPTY} 
${status}                     ${EMPTY}
${remarks}                    ${EMPTY}
${created_esic_no}            ${EMPTY}
${Temp_card_down_path}        ${EMPTY}
${START_TIME}                 ${EMPTY}
# ${START_TIME_2}               ${EMPTY}
${END_TIME}                   ${EMPTY}
${time}                       ${EMPTY}

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
    ${result}=    Run Keyword    extract_text.extract_captcha    ${SCREENSHOT_FILE}    ${API_URL}    
    # ${result}=    Run Process    python3    extract_text.py    ${SCREENSHOT_FILE}    ${API_URL}
    # Log    ${result.stdout}
    # Log    ${result.stderr}
    # Should Be Equal As Strings    ${result.rc}    0   
    ${file_content}=    Get File    ${CAPTCH_TEXT_FILE}
    Log    File Content: ${file_content} 
    Input Text    id=txtChallanCaptcha     ${file_content}
    Wait Until Element Is Visible    xpath://*[@id="btnLogin"]    timeout=90s
    Click Button    xpath://*[@id="btnLogin"]    # Assuming this is the login button
    Sleep    5s
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    [Return]    ${current_url} 

Run captcha loop
    [Arguments]    ${user}    ${pswd}
    FOR    ${attempt}    IN RANGE    10
        ${current_url}=    Login Process Loop    ${user}    ${pswd}
        Run Keyword If    '${current_url}' == 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Log    Login attempt ${attempt + 1} failed. Retrying...
        ...    ELSE    Log    Login successful. Exiting the loop.
        Run Keyword If    '${current_url}' != 'https://www.esic.in/EmployerPortal/ESICInsurancePortal/Portal_Loginnew.aspx'    Exit For Loop
    END     

Fetch username based on location 
    [Arguments]  ${temp}    
    Log    its a match
    ${location_username}=    Set Variable    ${temp}[user_name]
    [Return]        ${location_username}    

Fetch password based on location 
    [Arguments]  ${temp}    
    Log    its a match
    ${location_password}=    Set Variable    ${temp}[password] 
    [Return]        ${location_password} 

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

Post User Data            # For pushing data into database
    [Arguments]    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}   
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${data}=    Create Dictionary    hoppr_id=${hoppr_id}    name=${name}    status=${status}    remarks=${remarks}    time=${time}       
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log    ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    Sleep    5s  

Post User Data for Updation           # For pushing data into database
    [Arguments]    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}   
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${data}=    Create Dictionary    hoppr_id=${hoppr_id}    name=${name}    status=${status}    remarks=${remarks}    time=${time}       
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log    ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    Sleep    5s    

Calculate Time Difference
    [Arguments]    ${end_time}    ${start_time}
    ${start_seconds}=    Convert Time To Seconds    ${start_time}
    ${end_seconds}=    Convert Time To Seconds    ${end_time}
    ${difference}=    Evaluate    ${end_seconds} - ${start_seconds}
    [Return]    ${difference}

Convert Time To Seconds
    [Arguments]    ${time}
    ${time_parts}=    Split String    ${time}    separator=:
    ${hours}=      Convert To Integer    ${time_parts[0]}
    ${minutes}=    Convert To Integer    ${time_parts[1]}
    ${seconds}=    Convert To Integer    ${time_parts[2]}
    ${total_seconds}=    Evaluate    ${hours}*3600 + ${minutes}*60 + ${seconds}
    [Return]    ${total_seconds}   

Click Close Button 
    Wait Until Element Is Visible    xpath://*[@id="div1_close"]    timeout=300s 
    Click Button    xpath://*[@id="div1_close"]
    Click Button    xpath://*[@id="btnpnlSanjeevanicolse"]
    Click Button    xpath://*[@id="btnpnlcolse"]
    Click Button    xpath://*[@id="btnpnlPwdcolse"]     

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

Click Validation Link 
    Wait Until Element Is Visible    //a[@id="ctl00_HomePageContent_lnkmobilecheck"]    timeout=300s
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_lnkmobilecheck').click() 

Click Proceed 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnmobile"]    timeout=90s
    Click Element    //input[@id="ctl00_HomePageContent_btnmobile"]    

Perform Actions For Length 2
    [Arguments]    ${NumGen}    ${START_TIME}    
    Click Proceed 
    Sleep    2s
    Click Continue after validation Link    ${NumGen}    ${START_TIME}    

Perform these actions for Unmarried
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    # check Box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=300s       
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    Sleep    1s
    # Father name
    ${Father_Name}=  Set Variable  ${NumGen}[father_name]
    Log    ${Father_Name}
    # Gender
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=300s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    ${Gender}=    Set Variable    ${NumGen}[gender]                                                                                              
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=300s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    # Pop-up   
    Handle Alert    Accept
    Submit Form
    Sleep    2s

Perform these actions for Widow if Spouse not found
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    # Check Box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=30s       
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    # Father name
    ${Father_Name}=  Set Variable  ${NumGen}[father_name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    ${Father_Name} 
    # Gender
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=300s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    ${Gender}=    Set Variable    ${NumGen}[gender]                                                                                              
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=300s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    # Pop-up   
    Handle Alert    Accept
    Submit Form
    Sleep    2s

Perform these actions for Widow if Spouse found
    [Arguments]    ${NumGen}
    ${Husband_Checkbox}=    Set Variable    Husband
    Log    ${Husband_Checkbox}
    # Check Box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_1" and @value='${Husband_Checkbox}']    timeout=30s
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_1" and @value='${Husband_Checkbox}']
    # Husband name
    ${Husband_Name}=  Set Variable  ${NumGen}[spouse_name]
    Log    ${Husband_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    ${Husband_Name} 

Perform these actions for Married
    [Arguments]    ${NumGen}

    ${Husband_Name}=    Set Variable  ${NumGen}[spouse_name]
    Log    ${Husband_Name}
    IF    "${Husband_Name}"=="None"
        Perform these actions for Widow if Spouse not found    ${NumGen}
    ELSE
        Perform these actions for Widow if Spouse found    ${NumGen}
    END

Perform these actions for Widow
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    # Check Box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=30s       
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    # Father name
    ${Father_Name}=  Set Variable  ${NumGen}[father_name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]  ${Father_Name}
    # Martial status
    ${marital_status}=    Set Variable     ${NumGen}[marital_status]                                                                             
    Wait Until Element Is Visible     //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']    timeout=30s
    Click Element    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']
    # Gender
    ${Gender}=    Set Variable    ${NumGen}[gender]                                                                                              
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=30s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    # Pop-up                                                                                                                                                              
    Handle Alert    Accept
    Submit Form
    Sleep    2s

Perform these actions for Widower
    [Arguments]    ${NumGen}
    ${Father_Checkbox}=    Set Variable    Father
    Log    ${Father_Checkbox}
    # Check Box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']    timeout=30s
    Click Element  //input[@id="ctl00_HomePageContent_ctrlFatherOrHus_0" and @value='${Father_Checkbox}']
    # father name
    ${Father_Name}=  Set Variable  ${NumGen}[father_name]
    Log    ${Father_Name}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    timeout=30s
    Input Text  //input[@id="ctl00_HomePageContent_ctrlTextFatherHusName"]    ${Father_Name}
    # Martial status
    ${marital_status}=    Set Variable     ${NumGen}[marital_status]                                                                             
    Wait Until Element Is Visible    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']    timeout=30s
    # Gender
    Click Element    //select[@id='ctl00_HomePageContent_ctrlRDMarried']/option[text()='${marital_status}']
    ${Gender}=    Set Variable    ${NumGen}[gender]                                                                                              
    ${uppercase}=    Convert To Upper Case    ${Gender}
    ${first_letter}=    Get Substring    ${uppercase}    0    1
    Log    ${first_letter}
    Wait Until Element Is Visible    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]    timeout=30s
    Click Element    //input[@name="ctl00$HomePageContent$ctrlRDMale" and @value="${first_letter}"]
    # Pop-up                                                                                                                                                             
    Handle Alert    Accept
    Submit Form
    Sleep    2s

Condition for Father or Husband checkbox and Name
    [Arguments]    ${NumGen}
    ${Status}=    Create Dictionary    Single=UnMarried    None=UnMarried    UnMarried=UnMarried    Unmarried=UnMarried    Married=Married    married=Married
    Log    Selected month value is ${Status}
    ${marital} =  Set Variable    ${NumGen}[marital_status]
    ${marital_status}=    Get From Dictionary    ${Status}    ${marital}
    Log    Selected status value is ${marital_status}
    Run Keyword If  '${marital_status}' == 'UnMarried'
    ...    Perform these actions for Unmarried    ${NumGen}    
    ...    ELSE IF    '${marital_status}' == 'Married'
    ...    Perform these actions for Married    ${NumGen}
    ...    ELSE IF    '${marital_status}' == 'Widow'  
    ...    Perform these actions for Widow    ${NumGen}
    ...    ELSE    Perform these actions for Widower    ${NumGen}  

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

    ${date}=      Set Variable    ${NumGen}[birth_date]  
    ${result}=    Split String    ${date}    separator=-
    Log    ${result}
    ${year}=    Set Variable    ${result}[0]
    ${month}=   Set Variable    ${result}[1]
    ${day}=     Set Variable    ${result}[2]

    ${day_of_week}=    Evaluate    datetime.datetime.strptime('${date}','%Y-%m-%d').strftime('%A')
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

    ${date}=    Set Variable    ${NumGen}[date_of_joining]  
    Log    ${date}
    # ${date}    Evaluate    datetime.datetime.strptime('${date}', '%Y-%m-%d %H:%M:%S').strftime('%d-%m-%Y')
    # Log    ${date}
    ${result}=    Split String    ${date}    separator=-
    Log    ${result}
    ${year}=    Set Variable    ${result}[0]
    ${month}=    Set Variable    ${result}[1]
    ${day}=    Set Variable    ${result}[2]

    ${day_of_week}=    Evaluate    datetime.datetime.strptime('${date}', '%Y-%m-%d').strftime('%A')
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

Address1 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[current_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}
    Log    ${p}

Address2 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[current_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[current_address]    50   99  
    Log    ${q}  
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress2']    ${q}    

Address3 Current
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[current_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress1']    ${p}    
    ${q}=    Get Substring    ${NumGen}[current_address]    50   99
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress2']    ${q}
    ${r}=    Get Substring    ${NumGen}[current_address]    100   
    Log    ${r}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPresentAddress3']    ${r}     

Address1 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[permanent_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}

Address2 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[permanent_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[permanent_address]    50   99 
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress2']    ${q}       

Address3 Permanant
    [Arguments]    ${NumGen}
    ${p}=    Get Substring    ${NumGen}[permanent_address]    0    49
    Log    ${p}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress1']    ${p}
    ${q}=    Get Substring    ${NumGen}[permanent_address]    50   99
    Log    ${q}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress2']    ${q}
    ${r}=    Get Substring    ${NumGen}[permanent_address]    100 
    Log    ${r}
    Input Text    //input[@id='ctl00_HomePageContent_ctrlTextPermanentAddress3']    ${r}     

Condition for filling Permanent Address in Emp Reg
    [Arguments]    ${NumGen}
    # Permanent Address
    ${Permanent_Address}=    Set Variable    ${NumGen}[permanent_address]         
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
    # Permanent state
    ${Permanent_State}=    Set Variable    ${NumGen}[permanent_state]                                                                             
    Log    ${Permanent_State}
    ${Permanent_State_a}=    Strip String    ${Permanent_State}
    Log    ${Permanent_State_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentState"]/option[text()='${Permanent_State_a}']
    # Permanent District
    ${Permanent_District}=    Set Variable    ${NumGen}[permanent_city]                                                                           
    Log    ${Permanent_District}
    ${Permanent_District_a}=    Strip String    ${Permanent_District}
    Log    ${Permanent_District_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]    timeout=90s 
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPermanentDistrict"]/option[text()='${Permanent_District_a}']
    Sleep    2s     
    # Permanent Zipcode
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextPermanentPinCode"]    timeout=90s
    ${Permanent_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextPermanentPinCode"]    ${NumGen}[permanent_zipcode]        
    Log    ${Permanent_Pin_code} 

Filling Employee Registration details
    [Arguments]    ${NumGen}    ${START_TIME}  
    # Name
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextEmpName"]    timeout=300s   
    ${Name}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextEmpName"]    ${NumGen}[name]                                      
    Log    ${Name}
    # Check Box
    Condition for Father or Husband checkbox and Name    ${NumGen}
    # Date of Birth
    Choose Date of Birth From Calendar    ${NumGen}   
    # Current_Adress
    ${Current_Address}=    Set Variable    ${NumGen}[current_address]                                                                      
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
    # Current State 
    ${Current_State}=    Set Variable    ${NumGen}[current_state]                                                                            
    Log    ${Current_State}
    ${Current_State_a}=    Strip String    ${Current_State}
    Log    ${Current_State_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTxtPresentState"]/option[text()='${Current_State_a}']
    # Current District
    ${Current_District}=    Set Variable    ${NumGen}[current_city]                                                                        
    Log    ${Current_District}
    ${Current_District_b}=    Strip String    ${Current_District}
    Log    ${Current_District_b}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextPresentDistrict"]/option[text()='${Current_District_b}']
    # Current Zipcode
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    timeout=90s
    ${Current_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTxtPresentPinCode"]    ${NumGen}[current_zipcode]         
    Log    ${Current_Pin_code}
    Sleep    1s
    # Permanent Address
    ${Permanent_Address_Element}=    Set Variable    ${NumGen}[permanent_address]
    Log      ${Permanent_Address_Element}
    ${Element_exist}=    Run Keyword If    "${Permanent_Address_Element}"=="None"    Click Element    //input[@id="ctl00_HomePageContent_chkboxCopyPresentAddress"]
    ...    ELSE    Condition for filling Permanent Address in Emp Reg    ${NumGen}   
    # Dispensary state Emp
    ${Dispensary_state_Emp}=    Set Variable    ${NumGen}[esic_state_dispensary]                                                            
    Log    ${Dispensary_state_Emp}
    ${Dispensary_state_Emp_a}=    Strip String    ${Dispensary_state_Emp}
    Log    ${Dispensary_state_Emp_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]
    Sleep    3s
    click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryState"]/option[text()='${Dispensary_state_Emp_a}']
    # Dispensary District Emp
    ${Dispensary_district_Emp}=    Set Variable    ${NumGen}[esic_district_dispensary]                                                     
    Log    ${Dispensary_district_Emp} 
    ${Dispensary_district_Emp_a}=    Strip String    ${Dispensary_district_Emp}
    Log    ${Dispensary_district_Emp_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]    timeout=90s
    click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]
    Sleep    3s
    Click Element    //select[@id="ctl00_HomePageContent_ddlDispensaryDistrict"]/option[text()='${Dispensary_district_Emp_a}']
    # Dispensary Hospital Emp
    ${Dispensary_Hospital_Emp}=    Set Variable    ${NumGen}[dispensary_employee]                                                          
    Log    ${Dispensary_Hospital_Emp}
    ${Dispensary_Hospital_Emp_a}=    Strip String    ${Dispensary_Hospital_Emp}
    Log    ${Dispensary_Hospital_Emp_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]    timeout=90s 
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]
    Sleep    3s
    Click Element    //select[@id="ctl00_HomePageContent_ctrlTextDispensary"]/option[text()='${Dispensary_Hospital_Emp_a}'] 
    # Dispensary State Fam
    ${Dispensary_state_Fam}=    Set Variable    ${NumGen}[esic_state_dispensary]                                                            
    Log    ${Dispensary_state_Fam}
    ${Dispensary_state_Fam_a}=    Strip String    ${Dispensary_state_Fam}
    Log    ${Dispensary_state_Fam_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]
    Sleep    3s
    Click Element     //select[@id="ctl00_HomePageContent_ddldependantDispensaryState"]/option[text()='${Dispensary_state_Fam_a}']
    # Dispensary District Fam
    ${Dispensary_district_Fam}=    Set Variable    ${NumGen}[esic_district_dispensary]                                                     
    Log    ${Dispensary_district_Fam} 
    ${Dispensary_district_Emp_b}=    Strip String    ${Dispensary_district_Fam}
    Log    ${Dispensary_district_Emp_b}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]
    Sleep    3s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantDispensaryDistrict"]/option[text()='${Dispensary_district_Emp_b}']  
    # Dispensary Hospital Fam
    ${Dispensary_Hospital_Fam}=    Set Variable    ${NumGen}[dispensary_employee]                                                          
    Log    ${Dispensary_Hospital_Fam}
    ${Dispensary_Hospital_Fam_b}=    Strip String    ${Dispensary_Hospital_Fam}
    Log    ${Dispensary_Hospital_Fam_b}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]
    Sleep    3s
    Click Element    //select[@id="ctl00_HomePageContent_ddldependantdispensary"]/option[text()='${Dispensary_Hospital_Fam_b}']
    Sleep    3s
    # Date of Joining
    Choose Date of Joining From Calendar    ${NumGen}
    Sleep    1s
    # Language 
    ${SMS_lang}=    Set Variable    ${NumGen}[sms]                                                                             
    Log    ${SMS_lang}
    ${SMS_lang_a}=    Strip String    ${SMS_lang}
    Log    ${SMS_lang_a}
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ddllanguage    timeout=300s
    Select From List By Label    id=ctl00_HomePageContent_ddllanguage    ${SMS_lang_a} 
    Sleep    1s   
    # Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_ddllanguage"]    timeout=90s
    # Click Element    //select[@id="ctl00_HomePageContent_ddllanguage"]
    # Sleep    2s
    # Click Element    //select[@id="ctl00_HomePageContent_ddllanguage"]/option[text()='${SMS_lang_a}']

Condition for Current Address in Nominee
    [Arguments]    ${NumGen}
    # Nominee current Address
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    timeout=300s
    ${Nominee_Address}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    ${NumGen}[current_address]                     
    Log     ${Nominee_Address}
    # Nominee current State
    ${Current_State}=    Set Variable    ${NumGen}[current_state]                                                                            
    Log    ${Current_State}
    ${Current_State_a}=    Strip String    ${Current_State}
    Log    ${Current_State_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_States"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_States"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_States"]/option[text()='${Current_State_a}']
    # Nominee current District
    ${Current_District}=    Set Variable    ${NumGen}[current_city]                                                                        
    Log    ${Current_District}
    ${Current_District_b}=    Strip String    ${Current_District}
    Log    ${Current_District_b}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_Districts"]    timeout=90s
    Click Element    //select[@id="ctl00_HomePageContent_Districts"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_Districts"]/option[text()='${Current_District_b}']  
    # Current Zipcode
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextPin"]    timeout=90s
    ${Current_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextPin"]    ${NumGen}[current_zipcode]         
    Log    ${Current_Pin_code} 

Condition for filling Permanent Address in Nominee
    [Arguments]    ${NumGen}
    # Nominee Permanent Address
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    timeout=300s
    ${Nominee_Address}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextAddress1"]    ${NumGen}[permanent_address]                    
    Log     ${Nominee_Address}
    # Nominee Permanent State
    ${Permanent_State}=    Set Variable    ${NumGen}[permanent_state]                                                                             
    Log    ${Permanent_State}
    ${Permanent_State_a}=    Strip String    ${Permanent_State}
    Log    ${Permanent_State_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_States"]    timeout=90s
    click Element    //select[@id="ctl00_HomePageContent_States"]
    Sleep    3s
    Click Element    //select[@id="ctl00_HomePageContent_States"]/option[text()='${Permanent_State_a}']
    # Nominee Permanent District
    ${Permanent_District}=    Set Variable    ${NumGen}[permanent_city]                                                                           
    Log    ${Permanent_District}
    ${Permanent_District_a}=    Strip String    ${Permanent_District}
    Log    ${Permanent_District_a}
    Wait Until Element Is Visible    //select[@id="ctl00_HomePageContent_Districts"]    timeout=90s 
    Click Element    //select[@id="ctl00_HomePageContent_Districts"]
    Sleep    2s
    Click Element    //select[@id="ctl00_HomePageContent_Districts"]/option[text()='${Permanent_District_a}']
    Sleep    2s   
    # Nominee Permanent Zipcode
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextPin"]    timeout=90s
    ${Permanent_Pin_code}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextPin"]    ${NumGen}[permanent_zipcode]        
    Log    ${Permanent_Pin_code}    

Condition for Nominee Details if not None
    [Arguments]    ${NumGen}    ${START_TIME}    
    # Nominee Details link on main page
    Wait Until Element Is Visible    //a[@onclick="openWin('NomineeDetails.aspx','','dialogWidth:1000px; dialogHeight:800px; center:yes')"]    timeout=300s
    Click Element    //a[@onclick="openWin('NomineeDetails.aspx','','dialogWidth:1000px; dialogHeight:800px; center:yes')"]
    Switch To Another New Window
    Sleep    2s
    # Nominee Name
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTextUserName"]    timeout=300s
    ${Nominee_Name_Element}=    Set Variable    ${NumGen}[nominee_name] 
    ${Nominee_Name}=    Input Text    //input[@id="ctl00_HomePageContent_ctrlTextUserName"]    ${Nominee_Name_Element}                        
    Log    ${Nominee_Name}       
    # Nominee Permanent Address
    ${Permanent_Address_Element}=    Set Variable    ${NumGen}[permanent_address]
    Log      ${Permanent_Address_Element}
    ${Element_exist}=    Run Keyword If    "${Permanent_Address_Element}"=="None"    Condition for Current Address in Nominee    ${NumGen}
    ...    ELSE    Condition for filling Permanent Address in Nominee    ${NumGen}  
    # Nominee Relation
    Wait Until Element Is Visible    id=ctl00_HomePageContent_RelationShipWithIp    timeout=300s
    ${Relation}=    Set Variable    ${NumGen}[nominee_relation]   
    ${result}=    Strip String    ${Relation}
    Log    ${result}  
    Wait Until Element Is Visible    id=ctl00_HomePageContent_RelationShipWithIp    timeout=300s
    # Select From List By Label    id=ctl00_HomePageContent_RelationShipWithIp    ${Relation} 
    Sleep    2s   
    Click Element    //select[@id="ctl00_HomePageContent_RelationShipWithIp"]/option[text()='${result}']                  
    # Check box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistNomneeAkaFamily_0"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistNomneeAkaFamily_0"]                                                            
    # Save Button 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_Save" and @type='submit']    timeout=300s                     
    Click Button    //input[@id="ctl00_HomePageContent_Save" and @type='submit']                                                                
    # switch window control
    Switch Back To Original Window
    Sleep   3s 

Filling Nominee details
    [Arguments]    ${NumGen}    ${START_TIME}    
    # Nominee Name
    ${Nominee_Name_element}=    Set Variable    ${NumGen}[nominee_name]
    Log    ${Nominee_Name_element}
    # Nominee Relation
    ${Nominee_relation_element}=    Set Variable    ${NumGen}[nominee_relation]
    Log    ${Nominee_relation_element}  
    
    IF    '${Nominee_Name_element}' == 'None' 
        Condition for Nominee details if None    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}       
    ELSE IF    '${Nominee_relation_element}' == 'None'
        Condition for Nominee relation details if None    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}  
    ELSE
        Condition for Nominee Details if not None    ${NumGen}    ${START_TIME}               
    END  

Condition for Bank Details if not None
    [Arguments]    ${NumGen}    ${START_TIME} 
    Log    ${START_TIME}   
    # Bank details link on main page
    Wait Until Element Is Visible    css=#Tr18 > td:nth-child(2) > a    timeout=300s
    Click Element    css=#Tr18 > td:nth-child(2) > a
    Switch To Another New Window
    Sleep    2s
    # IFSC Code
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtIFSCcode"]    timeout=300s
    ${IFSC_Code}=    Input Text    //input[@id="ctl00_HomePageContent_txtIFSCcode"]    ${NumGen}[ifsc_code]                                    
    Log    ${IFSC_Code}
    # Search Button
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnIFSCcode" and @value='Search']    timeout=30s
    Click Button    //input[@id="ctl00_HomePageContent_btnIFSCcode" and @value='Search']                                                       
    Sleep    1s
    # IFSC Code element exist
    ${IFSC_Code_Element}=    Run Keyword And Return Status    Element should be Visible    //span[@id="ctl00_HomePageContent_lblErrorMessage"]
    Log    ${IFSC_Code_Element}
    ${Element_exist}=    Run Keyword If    '${IFSC_Code_Element}' == 'False'    Condition for Bank if IFSC found    ${NumGen}    ${START_TIME}    
    ...    ELSE    Condition for Bank if IFSC not found    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}    

Condition for Bank if IFSC found
    [Arguments]    ${NumGen}    ${START_TIME} 
    Log    ${START_TIME}   
    # Account No
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtacc_number" and @type='text']    timeout=300s
    ${Account_No}=    Input Text    //input[@id="ctl00_HomePageContent_txtacc_number" and @type='text']    ${NumGen}[bank_account_number]      
    Log    ${Account_No}
    # Saving Account
    Wait Until Element Is Visible    id=ctl00_HomePageContent_ddlAccountType    timeout=90s                                                    
    Select From List By Label    id=ctl00_HomePageContent_ddlAccountType    ${NumGen}[account_type]
    # Submit of Bank details
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnsubmit" and @value='Submit']    timeout=90s                         
    Click Element    //input[@id="ctl00_HomePageContent_btnsubmit" and @value='Submit']
    Sleep    1s
    # Alert present or not   
    ${alert_present}=    Run Keyword And Return Status    Alert Should Be Present
    Log    ${alert_present}
    Run Keyword If    $alert_present    Condition for Account No if POP-UP    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}     
    ...    ELSE    Condition for Next Steps    ${START_TIME}    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${created_esic_no}    ${Temp_card_down_path}    ${time}    ${END_TIME}     

Filling Bank details 
    [Arguments]    ${NumGen}    ${START_TIME}  
    Log    ${START_TIME}  
    # IFSC Code 
    ${IFSC_Code_element}=    Set Variable    ${NumGen}[ifsc_code]
    Log    ${IFSC_Code_element}
    
    IF    '${IFSC_Code_element}' == 'None' 
        Condition for Bank details if None     ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME} 
    ELSE
        Condition for Bank Details if not None    ${NumGen}    ${START_TIME}    
    END


Click Continue after validation Link
    [Arguments]    ${NumGen}    ${START_TIME} 
    Log    ${START_TIME}   
    # Continue Button
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnContinue"]    timeout=300s
    Click Button    //input[@id="ctl00_HomePageContent_btnContinue"]
    Handle Alert    Accept
    Submit Form
    Sleep    2s 
    Switch To Another New Window
    Filling Employee Registration details    ${NumGen}    ${START_TIME} 
    Filling Nominee details    ${NumGen}    ${START_TIME}    
    Filling Bank details    ${NumGen}    ${START_TIME}

Condition for Number OTP validated 
    [Arguments]    ${NumGen}    ${error_data}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME} 
    Log    ${error_data}
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : ${error_data}
    ${status}=      Set Variable    Pending  
    Log    ${START_TIME}   
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time} 
    # ${subject}=    Set Variable    Update: ${name} - ${hoppr_id} 
    # ${email_body}=    Set Variable    Hi Compliance Team,\n\nplease go through the attached entries who's mobile number OTP is Validated.\n\nHoppr ID: ${hoppr_id}\nName: ${name}\nStatus: ${status}\nRemarks: ${remarks}\n\nThis is an automated email, please do not reply.\n\nThanks & Regards,\nAutomation Team.
    # Log    ${email_body}
    # Authorize SMTP    ${EMAIL_USERNAME}   ${EMAIL_PASSWORD}  ${EMAIL_SERVER}    ${EMAIL_PORT}
    # Send Message     ${EMAIL_SENDER}    ${TAGGED_EMAIL}    ${SUBJECT}    ${email_body}    

Perform Actions For Length 3
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}                
    
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Already Tagged(Provide old ESIC_No)
    ${status}=      Set Variable    Pending  
    Log    ${START_TIME}   
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time} 
    # ${subject}=    Set Variable    Update: ${name} - ${hoppr_id} 
    # ${email_body}=    Set Variable    Hi Compliance Team,\n\nplease go through the attached entries who's mobile number is Already Tagged.\n\nHoppr ID: ${hoppr_id}\nName: ${name}\nStatus: ${status}\nRemarks: ${remarks}\n\nThis is an automated email, please do not reply.\n\nThanks & Regards,\nAutomation Team.
    # Log    ${email_body}
    # Authorize SMTP    ${EMAIL_USERNAME}   ${EMAIL_PASSWORD}  ${EMAIL_SERVER}    ${EMAIL_PORT}
    # Send Message     ${EMAIL_SENDER}    ${TAGGED_EMAIL}    ${SUBJECT}    ${email_body}    
    Click Element    css=#ctl00_HomePageContent_btncancel
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_button').click();
    Sleep    2s

Condition for Nominee details if None
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}               
    
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Nominee Name not provided
    ${status}=      Set Variable    Pending  
    Log    ${START_TIME}
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED} 
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time} 

Condition for Nominee relation details if None
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}    
    
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Nominee Relation not provided
    ${status}=      Set Variable    Pending  
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}  
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}

Condition for Bank details if None
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}           
    
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Bank details not provided
    ${status}=      Set Variable    Pending  
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED} 
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}

Condition for Account No if POP-UP 
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}    

    Sleep    3s
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Bank Account is Already Tagged(Provide another Bank account)  
    ${status}=      Set Variable    Pending  
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}
    # ${subject}=    Set Variable    Update: ${name} - ${hoppr_id} 
    # ${email_body}=    Set Variable    Hi Compliance Team,\n\nplease go through the attached entries who's Account_Number is Already Tagged.\n\nHoppr ID: ${hoppr_id}\nName: ${name}\nStatus: ${status}\nRemarks: ${remarks}\n\nThis is an automated email, please do not reply.\n\nThanks & Regards,\nAutomation Team.
    # Log    ${email_body}
    # Authorize SMTP    ${EMAIL_USERNAME}   ${EMAIL_PASSWORD}  ${EMAIL_SERVER}    ${EMAIL_PORT}
    # Send Message     ${EMAIL_SENDER}    ${TAGGED_EMAIL}    ${SUBJECT}    ${email_body}    

Condition for Next Steps 
    [Arguments]    ${START_TIME}    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${created_esic_no}    ${time}    ${END_TIME}    ${Temp_card_down_path}   
    Log    ${START_TIME}
    Close Current Window And Switch Back
    Sleep    2s
    # Check box
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']    timeout=300s               
    Click Element    //input[@id="ctl00_HomePageContent_dec_chkbox" and @type='checkbox']
    Sleep    2s
    # Submit Button of all details 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_Submit"]    timeout=300s                                        
    Click Button    //input[@id="ctl00_HomePageContent_Submit"]  
    sleep    2s  
    # screenshot
    Take a page screenshot
    # Created ESIC No
    Wait Until Element Is Visible    xpath=//span[@id="ctl00_HomePageContent_ctrlLabelIPNumber"]    timeout=300s                        
    ${ESIC_NO_Created}=    Get Text    xpath=//span[@id="ctl00_HomePageContent_ctrlLabelIPNumber"]
    Log    ${ESIC_NO_Created}
    # PDF download link
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_print"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_print"]
    Sleep    5s
    # Moving file from downloads to another folder
    ${Temp_card_down_path}=    Move File    ${DOWNLOAD_PATH}/${ESIC_NO_Created}.pdf    ${DOWNLOAD_FOLDER}/${NumGen}[name] - ${ESIC_NO_Created}.pdf
    Log    Downloaded File : ${Temp_card_down_path}
    
    ${hoppr_id}=                 Set Variable    ${NumGen}[hoppr_id]    
    ${name}=                     Set Variable    ${NumGen}[name] 
    ${created_esic_no}=          Set Variable    ${ESIC_NO_Created}
    ${status}=                   Set Variable    Success 
    ${Temp_card_down_path}=      Set Variable    ${Temp_card_down_path}

    Log    ${START_TIME}
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}
    RPA.HTTP.Create Session    UserSession    http://localhost:8000
    ${data}=    Create Dictionary    hoppr_id=${hoppr_id}    name=${name}    status=${status}    time=${time}     created_esic_no=${created_esic_no}    Temp_card_down_path=${Temp_card_down_path}       
    Log    ${data}
    ${headers}=    Create Dictionary    Content-Type=application/json
    Log    ${headers}
    ${response}=    RPA.HTTP.POST On Session    UserSession    ${insert_user_data}    json=${data}    headers=${headers}
    Log    ${response}
    Sleep    5s 
    
Condition for Bank if IFSC not found
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}     
    
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    Error : Bank Details are not available for this IFSC Code
    ${status}=      Set Variable    Pending  
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED} 
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}  

Condition if Already Tagged in ESIC No
    [Arguments]    ${START_TIME}    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}         
    Log    ${START_TIME}

    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    IP already tagged to selected employer  
    ${status}=      Set Variable    Success 
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED}
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}      
    
Updating the Personal and Bank Details for YES 
    [Arguments]    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}    
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rdPersonalDetails" and @type='radio']    timeout=300s  
    Click Element     //input[@id="ctl00_HomePageContent_rdPersonalDetails" and @type='radio']

    Switch To Another New Window
    Sleep    2s
    Maximize Browser Window
    Sleep    2s  
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio']    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rdBankDetails" and @type='radio']   
    sleep    1s

    Switch To Another New Window
    Sleep    2s                            
    Maximize Browser Window
    Sleep    2s

    Wait Until Page Contains Element    id=ctl00_HomePageContent_rdPersonalDetails    timeout=10s
    ${element_disabled_A}    Execute Javascript    return document.getElementById('ctl00_HomePageContent_rdAddressDetails').disabled
    Log    Address Details Element Disabled: ${element_disabled_A}
    ${element_disabled_B}    Execute Javascript    return document.getElementById('ctl00_HomePageContent_rdBankDetails').disabled
    Log    Bank Details Element Disabled: ${element_disabled_B}
    
    Run Keyword If    '${element_disabled_B}'=='False'    Condition for Upadation of Bank Details    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}              
    Run Keyword If    '${element_disabled_A}'=='False'    Condition for Upadation of Address Details                             # Click the link if it's enabled
    # Run Keyword If    '${element_disabled_B}'=='False'    Condition for Upadation of Bank Details    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}              

    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update']     timeout=300s                # Update button
    Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update'] 
    Log    ${START_TIME}
    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    ESIC_No Updated Sucessfully 
    ${status}=      Set Variable    Success 
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED} 
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}      


Condition for Upadation of Bank Details
    [Arguments]    ${NumGen}    ${START_TIME}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}           
    
    Click Link    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']
    Sleep    1s
    Click Element    //input[@id="btnCancel" and @value='Close']  

    Close Current Window And Switch Back
    Sleep    1s
    # Update button
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update']     timeout=300s                
    Click Button    //input[@id="ctl00_HomePageContent_ctrlButtonSave" and @value='Update'] 

    ${hoppr_id}=    Set Variable    ${NumGen}[hoppr_id]    
    ${name}=        Set Variable    ${NumGen}[name] 
    ${remarks}=     Set Variable    ESIC_No Updated Sucessfully 
    ${status}=      Set Variable    Success 
    ${END_TIME}=    Get Current Date    result_format=%H:%M:%S
    ${SECONDS_ELAPSED}=    Calculate Time Difference    ${END_TIME}    ${START_TIME}
    Log    Total seconds elapsed: ${SECONDS_ELAPSED}  
    ${time}=    Set Variable    ${SECONDS_ELAPSED} 
    Post User Data    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}  

Click ESIC Number Yes 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_0"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_rbtnlistIsregistered_0"]    
    Sleep    1s 

Enter ESIC No and DOJ
    [Arguments]    ${NumGen}
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtIPNumber"]    timeout=300s
    Input Text    //input[@id="ctl00_HomePageContent_ctrlTxtIPNumber"]    ${NumGen}[esic_no]
    Sleep    1s
    
    ${DOJ_Element}=    Set Variable    ${NumGen}[date_of_joining]
    Log    ${DOJ_Element}   
    ${date}    Evaluate    datetime.datetime.strptime('${DOJ_Element}', '%Y-%m-%d').strftime('%d/%m/%Y')
    Log    ${date} 
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_ctrlTxtAppointmentDate"]    timeout=300s
    Execute JavaScript    document.getElementById('ctl00_HomePageContent_ctrlTxtAppointmentDate').value = '${date}'    
    Sleep    2s

Click Continue Button for ESIC No
    [Arguments]    ${NumGen}   
    
    Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_btnContinue"]    timeout=300s
    Click Element    //input[@id="ctl00_HomePageContent_btnContinue"] 
    Sleep    2s
    ${Element_exist}=    Run Keyword And Return Status    Element Should Be Enabled    //span[@id="ctl00_HomePageContent_lblErrorMessage"]
    Log    ${Element_exist}

    IF    '${Element_exist}' == 'True'
        Condition if Already Tagged in ESIC No    ${START_TIME}    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    
    ELSE
        Updating the Personal and Bank Details for YES    ${START_TIME}    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}              
    END

Condition for Upadation of Address Details
    
    Click Link    //input[@id="ctl00_HomePageContent_rdAddressDetails" and @type='radio']
    Sleep    5s
    Click Element    //input[@id="close_btn" and @value='Close'] 




*** Test Cases *** 
Get Login Credentials from Database
    Log    ${login_credentials_data}
    Log    ${validated_temp_data}
    ${pending_rows}=    Create List
    ${user_data_list}=    Evaluate    json.loads($validated_temp_data)    json
    Log    ${user_data_list}
    FOR   ${NumGen}    IN   @{user_data_list}
        Log    ${NumGen}[status]
        Log    ${NumGen}[esic_no]
        IF    '${NumGen}[status]' == 'None'
            ${location_data_list}=    Evaluate    json.loads($login_credentials_data)    json
            Log    ${location_data_list}
            ${user_location}=    Set Variable    ${NumGen}[esic_location]
            FOR    ${temp}    IN    @{location_data_list}
                ${vary_location}=    Set Variable    ${temp}[locations]
                Log    ${vary_location}
                Log    ${NumGen}[esic_location]
                ${user}=    Run Keyword If    '${user_location}' in '${vary_location}'    Fetch username based on location    ${temp}    
                            ...    ELSE  Log    not a match     
                
                ${pswd}=    Run Keyword If    '${user_location}' in '${vary_location}'    Fetch password based on location    ${temp}    
                            ...    ELSE  Log    not a match     
                Log    ${user}
                Log    ${pswd}
                
                
                IF    '${user}' != 'None'
                    ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
                    Open ESIC website
                    Run captcha loop    ${user}    ${pswd}
                    Click Close Button
                    Click Register New IP
                    Switch To Another New Window
                    Click IsRegister with Aadhar No 
                    Click Continue Button
                    
                    IF    '${NumGen}[esic_no]' != 'None'
                        ${START_TIME}=    Get Current Date    result_format=%H:%M:%S
                        Click ESIC Number Yes
                        Enter ESIC No and DOJ    ${NumGen}
                        Click Continue Button for ESIC No    ${NumGen}             
                    
                    ELSE   
                        
                        Click ESIC Number No
                        Handle Alert    Accept
                        Submit Form
                        Sleep    2s
                        Log    ${NumGen}                                 
                        
                        Wait Until Element Is Visible    //input[@id="ctl00_HomePageContent_txtmobilenumber"]    timeout=300s
                        ${Mob_No}=    Input Text   //input[@id="ctl00_HomePageContent_txtmobilenumber"]    ${NumGen}[mobile_number]                                                                                                                                               
                        Log    ${Mob_No}
                        Click Validation Link 
                        Sleep    3s
                        ${error_message}=    Run Keyword And Return Status    Element Should Be Visible     //span[@id="ctl00_HomePageContent_lblerrormobile"]       timeout=300s
                        ${error_data}=    Run Keyword If    ${error_message}   Get Text      //span[@id="ctl00_HomePageContent_lblerrormobile"]
                        IF    '${error_message}' == 'True'
                            Condition for Number OTP validated    ${NumGen}    ${error_data}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}
                        ELSE
                            ${text}=    Get Text    //div[@id="ctl00_HomePageContent_Panel3"]/table[@class='internalTable' ]
                            Log    ${text}
                            ${result}=    Split String    ${text}    separator=\n
                            Log    ${result}
                            ${length}=    Get Length    ${result}
                            Log    Length of result: ${length}
                            ${IsElementVisible}=    Run Keyword And Return Status    Element Should Be Visible    css=#ctl00_HomePageContent_btncancel
                            Log    ${IsElementVisible}
                            IF    '${IsElementVisible}'=='True'
                            Run Keyword If    '${length}' == '3'    Perform Actions For Length 2    ${NumGen}    ${START_TIME}    
                            Run Keyword If    '${length}' == '5'    Perform Actions For Length 3    ${NumGen}    ${hoppr_id}    ${name}    ${status}    ${remarks}    ${time}    ${END_TIME}    ${START_TIME}                           
                            ELSE
                            Click Continue after validation Link    ${NumGen}    ${START_TIME}    
                            END 
                        END     
                    END    
                END
            END
        END  
    END



