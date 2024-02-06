*** Settings ***
Library    RPA.Browser.Selenium    auto_close=${False}

*** Variables ***
${BROWSER}            chrome
${URL}                https://mahagst.gov.in/en/assessment-order-advance-payment                                  #https://mahagst.gov.in/en/node/6374
${username}           27715215587
${password}           Buzzworks@123
${IFRAME}             id=embeddedvideoiframe0
${FILE_PATH}          /home/buzzadmin/Documents/Practise.xlsx

*** Test Cases ***
Login Maha
    # Set Selenium Implicit Wait    60s
    Open Browser    ${URL}    ${BROWSER}    options=add_experimental_option("detach", True)  
    Maximize Browser Window
    Sleep    5s
    Click Element      //*[@id="block-block-16"]/div/ul/li[2]/div
    Wait Until Element Is Visible   //*[@id="block-block-16"]/div/ul/li[2]/a     timeout=30s
    Click Element      //*[@id="block-block-16"]/div/ul/li[2]/a 
    Select Frame    ${IFRAME}
    Input Text         //input[@id="USERNAME_FIELD-inner"]    ${username}
    Sleep    1s
    Input Password     //input[@id="PASSWORD_FIELD-inner"]    ${password}
    Sleep    1s
    Click Button       //button[@id="LOGIN_LINK"]                                                                        #login
    Sleep    1s
    Click Element      //div[@id="__content10"]                                                                          #Return 
    Sleep    1s
    Wait Until Element Is Visible    //div[@id="idview11--otheract"]    timeout=30s                                      # option 3
    Click Element      //div[@id="idview11--otheract"]
    Sleep    1s
    # Scroll Element Into View    //span[@id="__xmlview1--selectact-label"]                                                
    Wait Until Element Is Visible     //span[@id="__xmlview1--selectact-arrow"]    timeout=30s                           # drop-down arrow
    Click Element    //span[@id="__xmlview1--selectact-arrow"]                                                           # drop-down arrow
    Sleep    2s
    Wait Until Element Is Enabled    xpath=//li[contains(text(), '27715215587P - PTRC ACT')]
    Click Element    xpath=//li[contains(text(), '27715215587P - PTRC ACT')]                                                         # 27712345 id selection   
    Sleep    1s
    Wait Until Element Is Visible    //*[@id="__xmlview1--tabButton-BDI-content"]     timeout=30s                        # next button
    Click Element    //*[@id="__xmlview1--tabButton-BDI-content"]                                                        # next button
    Click Element    //span[@id="__xmlview1--TypeReturnStmt-arrow"]                                                      # original selection dropdown   
    Wait Until Element Is Visible    xpath://*[@id="__item6-__xmlview1--TypeReturnStmt-1"]    timeout=60s                # original option    
    Click Element    xpath://*[@id="__item6-__xmlview1--TypeReturnStmt-1"]                                               # original option
    Wait Until Element Is Visible    //bdi[@id="__xmlview1--tabButton1-BDI-content"]    timeout=30s
    Click Element    //bdi[@id="__xmlview1--tabButton1-BDI-content"]                                                     # next option
    Wait Until Element Is Visible    xpath://*[@id="__xmlview1--fiscalyear-arrow"]    timeout=30s
    Click Element    xpath://*[@id="__xmlview1--fiscalyear-arrow"]                                                       # drop-down arrow select year
    Wait Until Element Is Visible    xpath://*[@id="__item7-__xmlview1--fiscalyear-8"]
    Click Element    xpath://*[@id="__item7-__xmlview1--fiscalyear-8"]                                                   # year 2023-2024
    Wait Until Element Is Visible    xpath://*[@id="__xmlview1--tabButton4-BDI-content"]    timeout=30s
    Click Element    xpath://*[@id="__xmlview1--tabButton4-BDI-content"]                                                 # next button
    Wait Until Element Is Visible    xpath://*[@id="__xmlview1--yesBtn-BDI-content"]    timeout=30s
    Click Element    xpath://*[@id="__xmlview1--yesBtn-BDI-content"]                                                     # yes button  
    Wait Until Element Is Visible    //div//input[@type='text'][@placeholder='Choose a file for Upload...']
    Choose File      xpath=//div//input[@type='text'][@placeholder='Choose a file for Upload...']    ${FILE_PATH}
    
    
    
    
    # Choose File      xpath://*[@id="__xmlview1--fileUploader0-fu_button-BDI-content"]    /home/buzzadmin/Documents/Practise.xlsx
    
    # Wait Until Element Is Visible    //*[@id="__xmlview1--tabButton-BDI-content"]/select/option[@value='Revised Return U/s 6(4)(a)']     timeout=80s
    # Click Element    //*[@id="__xmlview1--tabButton-BDI-content"]/select/option[@value='Revised Return U/s 6(4)(a)']
    
    






    # Wait Until Element Is Visible    xpath://*[@id="__item2-__xmlview1--selectact-1"]    timeout=60s
    # Click Element      xpath://*[@id="__item2-__xmlview1--selectact-1"]
    # Wait Until Element Is Visible     //li[contains(text(), '27715215587P - PTRC ACT')]    timeout=30s
    # ${dropdown_toggle}=  Get WebElement    //li[contains(text(), '27715215587P - PTRC ACT')]
    # Click Element    ${dropdown_toggle}
    # Sleep    1s
    # Wait Until Element Is Visible    //*[@id="__xmlview1--tabButton-BDI-content"]     timeout=30s
    # Click Element    //*[@id="__xmlview1--tabButton-BDI-content"] 
    # Click Element    //span[@id="__xmlview1--TypeReturnStmt-arrow"]
    # Wait Until Element Is Visible    xpath://*[@id="__item6-__xmlview1--TypeReturnStmt-1"]    timeout=30s
    # Click Element    xpath://*[@id="__item6-__xmlview1--TypeReturnStmt-1"]
    # Wait Until Element Is Visible    //*[@id="__xmlview1--tabButton-BDI-content"]/select/option[@value='Revised Return U/s 6(4)(a)']     timeout=80s
    # Click Element    //*[@id="__xmlview1--tabButton-BDI-content"]/select/option[@value='Revised Return U/s 6(4)(a)']
    # Wait Until Element Is Visible    //bdi[@id="__xmlview1--tabButton1-BDI-content"]    timeout=30s
    # Click Element    //bdi[@id="__xmlview1--tabButton1-BDI-content"]
    # Wait Until Element Is Visible    xpath://*[@id="__xmlview1--fiscalyear-arrow"]    timeout=30s
    # Click Element    xpath://*[@id="__xmlview1--fiscalyear-arrow"]
    # Wait Until Element Is Visible    xpath://*[@id="__item7-__xmlview1--fiscalyear-8"]
    # Click Element    xpath://*[@id="__item7-__xmlview1--fiscalyear-8"]
    # Wait Until Element Is Visible    xpath://*[@id="__xmlview1--tabButton4-BDI-content"]    timeout=30s
    # Click Element    xpath://*[@id="__xmlview1--tabButton4-BDI-content"]
    # Wait Until Element Is Visible    xpath://*[@id="__xmlview1--yesBtn-BDI-content"]    timeout=30s
    # Click Element    xpath://*[@id="__xmlview1--yesBtn-BDI-content"]
    # Choose File      xpath://*[@id="__xmlview1--fileUploader0-fu_button-BDI-content"]    /home/buzzadmin/Documents/Practise.xlsx






