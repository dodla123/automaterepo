*** Settings ***
Library    SeleniumLibrary           auto_close=${False}
Library    DateTime


*** Variables ***
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/robot_apps/PT_filling/PT-kar/Pagescreenshot.png
${username}               buzzworksbuss
${password}               2023Bu$$Work$
${Year}                   2024
${Month}                  January
${Return Type}            Original
${TEXT}                   3


*** Keywords ***
Open Any Browser
    Open Browser    https://pt.kar.nic.in/ptemployer/Login    firefox        
    Maximize Browser Window

Login Process For kar
    Wait Until Element Is Visible    id=Login_user_name    timeout=30s     
    Input Text    id=Login_user_name    ${username}
    Sleep    1s
    Wait Until Element Is Visible    id=id_pwd    timeout=30s  
    Input Password    id=id_pwd    ${password}
    Sleep    1s
    Wait Until Element Is Visible    id=CaptchaCode    timeout=30s
    Execute JavaScript    document.getElementById('CaptchaCode').focus()
    sleep    10s
    Wait Until Element Is Visible    xpath://*[@id="id_btn_login"]    timeout=30s
    Click Button     xpath://*[@id="id_btn_login"]
    Sleep    1s

Click on File Return
    # Click Element    xpath:/html/body/div[2]/main/div[1]/div[2]/div[1]/div/div/form/button
    Wait Until Element Is Visible    //button[@class="btn btnepay" and contains(text(), 'File Return')]    timeout=30s
    Click Element    //button[@class="btn btnepay" and contains(text(), 'File Return')]

Select year
    Wait Until Element Is Visible    id=return_5a_perd_year    timeout=30s
    Select From List By Label    id=return_5a_perd_year    ${Year} 

Select Month
    Wait Until Element Is Visible    id=return_5a_perd_month    timeout=30s
    Select From List By Label    id=return_5a_perd_month    ${Month}

Select Return Type
    Wait Until Element Is Visible    id=return_5a_ret_type    timeout=30s
    Select From List By Label    id=return_5a_ret_type    ${Return Type}

Click Next Button
    Wait Until Element Is Visible    //button[@id="btn-login"]    timeout=30s
    Click Button    //button[@id="btn-login"]  

Enter Emp ID
    Wait Until Element Is Visible    id=id_no_emp_0    timeout=30s              
    Input Text       id=id_no_emp_0    ${TEXT}

Take a page screenshot
    ${timestamp}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${screenshot_path}=    Capture Page Screenshot
    ...    filename=${SCREENSHOT_FILE}/screenshot_${timestamp}.png
    Log    Screenshot saved to: ${screenshot_path}     


*** Test Cases ***
Launching the karnatak PT website
    Open Any Browser

Logging into the website
    Login Process For kar

Go to Return File Page
    Click on File Return

Selecting the values from drop down    
    Select year
    Select Month
    Select Return Type
    Click Next Button

Entering total no of Emp
    Enter Emp ID  
    Sleep    2s 
    Take a page screenshot












# Login
    # Open Browser  ${URL}    ${BROWSER}    #options=add_experimental_option("detach", True)
    # Maximize Browser Window
    # Wait Until Element Is Visible    id=Login_user_name     
    # Input Text    id=Login_user_name    ${username}
    # Sleep    1s
    # Wait Until Element Is Visible    id=id_pwd  
    # Input Password    id=id_pwd    ${password}
    # Sleep    1s
    # Execute JavaScript    document.getElementById('CaptchaCode').focus()
    # sleep    10s
    # Click Button     xpath://*[@id="id_btn_login"]
    # Sleep    1s
    # Click Element    xpath:/html/body/div[2]/main/div[1]/div[2]/div[1]/div/div/form/button
    # Click Element    xpath://*[@id="return_5a_ret_per_type"]
    # Click Element    xpath://*[@id="return_5a_ret_per_type"]
    # Click Element    xpath://*[@id="return_5a_perd_year"]
    # Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[2]/select/option[1]
    # Click Element    xpath://*[@id="return_5a_perd_month"]
    # Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[3]/select/option[2]
    # Click Button     xpath://*[@id="btn-login"]
    # Input Text       id=id_no_emp_0    ${TEXT}
    # Capture Page Screenshot    ${SCREENSHOT_FILE}
    # Sleep    10s
    # Scroll Element Into View    locator

    




