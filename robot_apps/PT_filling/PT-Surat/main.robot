*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}




*** Variables ***
${BROWSER}            chrome
${URL}                https://www.suratmunicipal.gov.in/OnlineServices/Home/LogIn
${username}           kumaravel.d@buzzworks.com
${password}           Buzzworks@123


*** Test Cases ***
Login surat
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    # Input Text    id=    text
