*** Settings ***
Library        SeleniumLibrary
Library        DateTime
Library        String
Library        Process
Library        RPA.Email.ImapSmtp
Library        data_removal.py

*** Variables ***
${username}                Venkat2838
${password}                Buzz@2025
${input_text}              Invoice Details
${href_text}               Invoice Details
${input_file_path}         /home/buzzadmin/Downloads/Invoice_Details.xlsx
${output_file_path}        /home/buzzadmin/Desktop/Invoice_Details.xlsx 

${EMAIL_SERVER}            smtp.gmail.com
${EMAIL_PORT}              587
${EMAIL_USERNAME}          dodla.manasa@buzzworks.com
${EMAIL_PASSWORD}          dytr ruja nwck tqwh
${EMAIL_SENDER}            dodla.manasa@buzzworks.com
${TAGGED_EMAIL}            shashwat.b@buzzworks.com     #lakshmi.l@buzzworks.com    #venkatasubbu@buzzworks.com    #bandari.akhil@buzzworks.com
# ${ATTACHMENTS}                ${TEMP_DIRECTORY_PATH}Pending_data.xlsx
${SUBJECT}                 Modified_Excel_File
# ${BODY}                        Hi Compliance Team, please go through the attached Challan No whose Challan number is generated.

*** Keywords ***
Click Element When Visible
    [Arguments]    ${PreLocator}      ${Elementtype}    ${PostLocator}
    Wait Until Element Is Visible     ${PreLocator}   timeout=120s    error=${Elementtype} not visible within 2m
    Click Element     ${PreLocator}
    Wait Until Element Is Visible    ${PostLocator}    timeout=30s    error= unable to navigate to next page
    Log    Successfully Clicked on     ${Elementtype}

Open SAP website
    Open Browser    https://www.fieldglass.net/    chrome    options=add_experimental_option("detach", True)
    Maximize Browser Window

Login Process
    Wait Until Element Is Visible    //input[@id="usernameId_new"]    timeout=30s
    Input Password    //input[@id="usernameId_new"]    ${username}
    Sleep    1s
    Wait Until Element Is Visible    //input[@id="passwordId_new"]    timeout=30s
    Input Password    //input[@id="passwordId_new"]    ${password}
    Sleep    1s
    Wait Until Element Is Visible    //button[@class="formLoginButton_new"]    timeout=30s
    Click Button    //button[@class="formLoginButton_new"]    
    Sleep    1s

Click Analytic and all reports
    Wait Until Element Is Visible    //li[@id="viewMenu_2_analytics_header_link"]    timeout=30s
    Click Element    //li[@id="viewMenu_2_analytics_header_link"]

    Wait Until Element Is Visible    //li[@id="analyticsMenu_1_viewNewReportGraph_link"]    timeout=30s
    Click Element    //li[@id="analyticsMenu_1_viewNewReportGraph_link"]

Entering the fields 
    Wait Until Element Is Visible    //div[@id="report_list_view"]//input[@tabindex='6']    timeout=30s
    Input Text    //div[@id="report_list_view"]//input[@tabindex='6']    ${input_text}
    Sleep    1s

    Wait Until Element Is Visible    //form[@id="reportListViewForm"]//input[@value='Apply Filters']    timeout=30s
    Click Button    //form[@id="reportListViewForm"]//input[@value='Apply Filters']   

    Wait Until Element Is Visible    //a[contains(text(),'${href_text}')]    timeout=120s
    Click Link    //a[contains(text(),'${href_text}')]

    Input Text    //input[@id="tpcolEndHours_z1810252005480140504292f" and @type='text']    12:00 AM
    # Click Element    //input[@id="tpcolEndHours_z1810252005480140504292f" and @type='text']
    Sleep    1s

    ${current_date}=    Get Current Date
    Log    Current Date: ${current_date}
    ${new_date}=    Convert Date    ${current_date}    result_format=%d/%m/%Y
    Log    New Date: ${new_date}
    ${result}=    Split String    ${new_date}    separator=/
    Log    Result: ${result}
    ${day}=    Set Variable    03
    ${month}=    Set Variable    ${result}[1]
    ${year}=    Set Variable    ${result}[2]
    ${date}=    Set Variable    ${day}/${month}/${year}

    Wait Until Element Is Visible    //input[@id="colEndDate_z1810252005480140504292f" and @type='text']    timeout=30s
    Click Element    //input[@id="colEndDate_z1810252005480140504292f" and @type='text']
    Input Text    //input[@id="colEndDate_z1810252005480140504292f" and @type='text']    ${date}
    # Input Text    //input[@id="colEndDate_z1810252005480140504292f"]    ${date}
    Sleep    1s

    Wait Until Element Is Visible    //input[@id="runReport" and @value='Run']    timeout=30s
    Click Button    //input[@id="runReport" and @value='Run']
    Sleep    15m

Process Invoice Details
    [Arguments]    ${input_file_path}    ${output_file_path}
    ${result}=    Run Keyword    data_removal.process_invoice_details    ${input_file_path}    ${output_file_path}
    [Return]    ${output_file_path}

Process Invoice Details and Send Email
    ${output_file_path}=    Process Invoice Details    ${input_file_path}    ${output_file_path}
    ${email_body}=    Set Variable    Hi Team, please go through the attached Modified_Excel_File which is generated.
    Authorize SMTP    ${EMAIL_USERNAME}    ${EMAIL_PASSWORD}    ${EMAIL_SERVER}    ${EMAIL_PORT}
    Send Message    ${EMAIL_SENDER}    ${TAGGED_EMAIL}    ${SUBJECT}    ${email_body}    attachments=${output_file_path}        


*** Test Cases ***
Launching the SAP website
    Open SAP website

Logging into the website    
    Login Process
    Click Analytic and all reports

Passing the criteria    
    Entering the fields

Deleting the unwanted data    
    Process Invoice Details    ${input_file_path}    ${output_file_path}

Sending Email
    Process Invoice Details and Send Email    