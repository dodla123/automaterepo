*** Settings ***
Library    RPA.Browser.Selenium           auto_close=${False}


*** Variables ***
${BROWSER}                firefox
# ${HUB_URL}                http://172.17.0.1:4444/wd/hub
${URL}                    https://pt.kar.nic.in/ptemployer/Login
${SCREENSHOT_FILE}        /home/buzzadmin/Documents/ESIC_BOT/login/PT_filling/PT-kar/Pagescreenshot.png
${username}               buzzworksbuss
${password}               2023Bu$$Work$
${TEXT}                   ${EMPTY}


*** Test Cases ***
Login
    Open Browser  ${URL}    ${BROWSER}
    Maximize Browser Window
    Wait Until Element Is Visible    id=Login_user_name     
    Input Text    id=Login_user_name    ${username}
    Sleep    1s
    Wait Until Element Is Visible    id=id_pwd  
    Input Password    id=id_pwd    ${password}
    Sleep    1s
    Execute JavaScript    document.getElementById('CaptchaCode').focus()
    sleep    10s
    Click Button     xpath://*[@id="id_btn_login"]
    Sleep    1s
    Click Element    xpath:/html/body/div[2]/main/div[1]/div[2]/div[1]/div/div/form/button
    Click Element    xpath://*[@id="return_5a_ret_per_type"]
    Click Element    xpath://*[@id="return_5a_ret_per_type"]
    Click Element    xpath://*[@id="return_5a_perd_year"]
    Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[2]/select/option[2]
    Click Element    xpath://*[@id="return_5a_perd_month"]
    Click Element    xpath:/html/body/div[2]/main/div/form/div[1]/div[3]/select/option[12]
    Click Button     xpath://*[@id="btn-login"]
    Input Text       id=id_no_emp_0    ${TEXT}
    Capture Page Screenshot    ${SCREENSHOT_FILE}
    Sleep    10s

    




