*** Settings ***
Library    SeleniumLibrary    

*** Variables ***
# ${BROWSER}            firefox
# ${URL}                https://www.suratmunicipal.gov.in/OnlineServices/Home/LogIn
${username}           kumaravel.d@buzzworks.com
${password}           Buzzworks@123
${certi_no}           SZ00032056
${No.of.Employee}     ${EMPTY}

*** Keywords ***
Open Any website
    Open Browser    https://www.suratmunicipal.gov.in/OnlineServices/Home/LogIn    firefox    #options=add_experimental_option("detach", True)
    Maximize Browser Window

Login Process For Surat
    Wait Until Element Is Visible    id=txtEmail    timeout=30s
    Input Text        id=txtEmail    ${username}
    Sleep    1s
    Wait Until Element Is Visible    id=txtPassword    timeout=30s
    Input Password    id=txtPassword    ${password}
    Sleep    1s
    Wait Until Element Is Visible    xpath://*[@id="login-form"]/div/button[1]    timeout=30s
    Click Button      xpath://*[@id="login-form"]/div/button[1]
    Sleep    1s

Click Search and Enroll
    Wait Until Element Is Visible    xpath://*[@id="serviceBox-28"]/div[5]/div/button    timeout=30s
    Click Element     xpath://*[@id="serviceBox-28"]/div[5]/div/button
    Click Element     xpath://*[@id="serviceBox-28"]/div[5]/div/ul/li[4]/a
    # Click Element     xpath://*[@id="drpZone"]
    Wait Until Element Is Visible    id=drpZone    timeout=30s
    Select From List By Label    id=drpZone    South Zone (SZ)    
    Sleep    1s    

*** Test Cases ***
Launching the Surat PT website
    Open Any website

Logging into the Surat website
    Login Process For Surat
    Click Search and Enroll    











# Login surat
    # Open Browser    https://www.suratmunicipal.gov.in/OnlineServices/Home/LogIn    firefox    #options=add_experimental_option("detach", True)
    # Maximize Browser Window
    # Input Text        id=txtEmail    ${username}
    # Sleep    1s
    # Input Password    id=txtPassword    ${password}
    # Sleep    1s
    # Click Button      xpath://*[@id="login-form"]/div/button[1]
    # Sleep    1s
    # Wait Until Element Is Visible    xpath://*[@id="serviceBox-28"]/div[5]/div/button    timeout=30s
    # Click Element     xpath://*[@id="serviceBox-28"]/div[5]/div/button
    # Click Element     xpath://*[@id="serviceBox-28"]/div[5]/div/ul/li[4]/a
    # Click Element     xpath://*[@id="drpZone"]
    # Sleep    1s
    # Click Element     xpath://*[@id="drpZone"]/option[5]
    # Input Text        id=txtCertificateNo    ${certi_no}
    # Execute JavaScript    document.getElementById('CaptchaInputText').focus()
    # Sleep    20s
    # Click Button    xpath://*[@id="btnSubmit"]
    # Scroll Element Into View    //input[@id="chkFebruary" and @type='checkbox']
    # Click Element    //input[@id="chkFebruary" and @type='checkbox']
    
    
    
    
    
    # Wait Until Element Is Visible    //tbody[@data-month-id="1"] //*[@id="txtTE_january_0"]    timeout=30s
    # Scroll Element Into View    //tbody[@data-month-id="1"] //*[@id="txtTE_january_0"]
    # Clear Element Text    //tbody[@data-month-id="1"] //*[@id="txtTE_january_0"]
    # Input Text    //tbody[@data-month-id="1"] //*[@id="txtTE_january_0"]    ${No.of.Employee}
    