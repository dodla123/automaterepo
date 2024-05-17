*** Settings ***
Library        SeleniumLibrary
Library        DateTime
Library        String

*** Variables ***
${username}            Venkat2838
${password}            Buzz@2025
${input_text}          Invoice Details
${href_text}           Invoice details Supplier

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

    Wait Until Element Is Visible    //a[contains(text(),'Invoice details Supplier')]    timeout=120s
    Click Link    //a[contains(text(),'${href_text}')]

    ${current_date}=    Get Current Date
    Log    Current Date: ${current_date}
    ${new_date}=    Convert Date    ${current_date}    result_format=%d/%m/%Y
    Log    New Date: ${new_date}
    ${result}=    Split String    ${new_date}    separator=/
    Log    Result: ${result}
    ${day}=    Set Variable    02
    ${month}=    Set Variable    ${result}[1]
    ${year}=    Set Variable    ${result}[2]
    ${date}=    Set Variable    ${day}/${month}/${year}

    Wait Until Element Is Visible    //input[@id="colEndDate_z2101270738121928603792c" and @type='text']    timeout=30s
    Input Text    //input[@id="colEndDate_z2101270738121928603792c" and @type='text']    ${date}
    Sleep    1s

    Wait Until Element Is Visible    //input[@id="runReport" and @value='Run']    timeout=30s
    Click Button    //input[@id="runReport" and @value='Run']
    Sleep    15m

*** Test Cases ***
Launching the SAP website
    Open SAP website

Logging into the website    
    Login Process
    Click Analytic and all reports

Passing the criteria    
    Entering the fields