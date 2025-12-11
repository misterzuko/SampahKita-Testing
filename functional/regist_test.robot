*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Main Website
Suite Teardown    Close Browser Session

*** Variables ***
${MAIN_URL}            https://darkcyan-ostrich-362407.hostingersite.com
${REGISTER_URL}        https://darkcyan-ostrich-362407.hostingersite.com/src/page/register
${BROWSER}             chrome
${VALID_NAME}          Daniro Admin
#Ubah Valid Email Setiap Test Case ingin Dijalankan
${VALID_EMAIL}         random123@admin.com
${VALID_PASSWORD}      admin123
${INVALID_EMAIL}       random@admin.com
${SHORT_PASSWORD}      123
${SQL_INJECTION}       admin' OR '1'='1

*** Keywords ***
Open Main Website
    Open Browser    browser=${BROWSER}
    Maximize Browser Window

Redirect Register Page
    Go To    ${REGISTER_URL}
    Wait Until Element Is Visible    id:fullname    10s

Close Browser Session
    Close Browser

Input Register
    [Arguments]    ${fullname}    ${email}    ${password}
    Input Text    id:fullname    ${fullname}
    Input Text    id:email       ${email}
    Input Text    id:password    ${password}

Click Register Button
    Click Button    xpath://button[@type='submit' or contains(translate(text(), 'REGISTER', 'register'), 'register')]

Clear Register Form
    Clear Element Text    id:fullname
    Clear Element Text    id:email
    Clear Element Text    id:password

*** Test Cases ***

TC100 - Register Page Load
    [Documentation]    Membuka Halaman Register......
    [Tags]    smoke 
    Redirect Register Page
    Page Should Contain Element    id:fullname
    Page Should Contain Element    id:email
    Page Should Contain Element    id:password

TC101 - Register With Invalid Email
    [Documentation]    Register dengan format email tidak valid
    [Tags]    negative
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${INVALID_EMAIL}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for invalid email
    END
    Sleep    2s

TC102 - Register With Empty Name
    [Documentation]    Register dengan nama lengkap kosong
    [Tags]    negative    validation
    Redirect Register Page
    Input Register    ${EMPTY}    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for empty name
    END
    Sleep    2s

TC103 - Register With Empty Email
    [Documentation]    Register dengan email kosong
    [Tags]    negative    validation
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${EMPTY}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for empty email
    END
    Sleep    2s

TC104 - Register With Empty Password
    [Documentation]    Register dengan password kosong
    [Tags]    negative    validation
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${VALID_EMAIL}    ${EMPTY}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for empty password
    END
    Sleep    2s

TC105 - Register With Short Password
    [Documentation]    Register dengan password terlalu pendek
    [Tags]    negative    validation
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${VALID_EMAIL}    ${SHORT_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for short password
    END
    Sleep    2s

TC106 - Register With SQL Injection In Name
    [Documentation]    Keamanan terhadap SQL injection di field nama
    [Tags]    security    negative
    Redirect Register Page
    Input Register    ${SQL_INJECTION}    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Error notification ditampilkan
    ELSE
        Log    Error notification tidak muncul
        Fail    Expected error notification for SQL injection attempt
    END
    Sleep    2s

TC107 - Register With Existing Email
    [Documentation]    Register dengan email yang sudah terdaftar harus menampilkan error
    [Tags]    negative    validation
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${INVALID_EMAIL}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${ERROR}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log    Notifikasi email sudah terdaftar muncul
    ELSE
        Log    Notifikasi tidak muncul padahal email sudah terdaftar
        Fail   Expected error notification for existing email
    END
    Sleep    2s

TC108 - Register With Valid Data
    [Documentation]    Register dengan data yang valid
    [Tags]    positive
    Redirect Register Page
    Input Register    ${VALID_NAME}    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Click Register Button
    Sleep    1s
    ${SUCCESS}=    Run Keyword And Return Status    Page Should Contain Element    css:.notification.success
    IF    ${SUCCESS}
        Log    Success notification ditampilkan
    ELSE
        Log    Success notification tidak muncul
        Fail    Expected success notification for valid registration
    END
    Sleep    2s
    Close Browser