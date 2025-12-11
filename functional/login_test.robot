*** Settings ***
Library    SeleniumLibrary

Suite Setup    Open Main Website
Suite Teardown    Close Browser Session

*** Variables ***
${LOGIN_URL}           https://darkcyan-ostrich-362407.hostingersite.com/src/page/login.html
${BROWSER}             chrome
${VALID_EMAIL}         daniro@admin.com
${VALID_PASSWORD}      admin123
${INVALID_EMAIL}       wronguser
${INVALID_PASSWORD}    wrongpas

*** Keywords ***
Open Main Website
    Open Browser    browser=${BROWSER}
    Maximize Browser Window

Redirect Login Page
    Go To    ${LOGIN_URL}
    Wait Until Element Is Visible    id:email    10s

Close Browser Session
    Close Browser

Input Login
    [Arguments]    ${email}    ${password}
    Input Text    id:email    ${email}
    Input Text    id:password    ${password}

Click Login Button
    Click Button    xpath://button[@type='submit' or contains(text(),'Login')]

Clear Login Form
    Clear Element Text    id:email
    Clear Element Text    id:password

*** Test Cases ***

TC001 - Login Page Load
    [Documentation]    Membuka Halaman Login......
    [Tags]    smoke
    Redirect Login Page
    Page Should Contain Element    id:email
    Page Should Contain Element    id:password

TC002 - Login With Invalid Username
    [Documentation]    Login dengan email tidak valid
    [Tags]    negative
    Redirect Login Page
    Input Login    ${INVALID_EMAIL}    ${VALID_PASSWORD}
    Click Login Button
    Sleep    1s
    ${ERROR}=          Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC003 - Login With Invalid Password
    [Documentation]    Login dengan password tidak valid
    [Tags]    negative
    Redirect Login Page
    Input Login    ${VALID_EMAIL}    ${INVALID_PASSWORD}
    Click Login Button
    Sleep    1s
    ${ERROR}=           Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC004 - Login With Empty Username
    [Documentation]    Login dengan email kosong
    [Tags]    negative    validation
    Redirect Login Page
    Input Login    ${EMPTY}    ${VALID_PASSWORD}
    Click Login Button
    Sleep    1s
    ${ERROR}=          Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC005 - Login With Empty Password
    [Documentation]    Login dengan password kosong
    [Tags]    negative    validation
    Redirect Login Page
    Input Login    ${VALID_EMAIL}    ${EMPTY}
    Click Login Button
    Sleep    1s
    ${ERROR}=          Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC006 - Login With Empty Credentials
    [Documentation]    Login dengan email dan password kosong
    [Tags]    negative    validation
    Redirect Login Page
    Input Login    ${EMPTY}    ${EMPTY}
    Click Login Button
    Sleep    1s
    ${ERROR}=          Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC007 - Login With SQL Injection
    [Documentation]    Keamanan terhadap SQL injection
    [Tags]    security    negative
    Redirect Login Page
    Input Login    admin' OR '1'='1    anything
    Click Login Button
    Sleep    1s
    ${ERROR}=          Run Keyword And Return Status    Page Should Contain Element    css:.notification.error
    IF    ${ERROR}
        Log     Error notification ditampilkan
    ELSE
        Log     Error notification tidak muncul
        Fail    Expected error notification
    END
    Sleep    2s

TC008 - Login With Valid Credentials
    [Documentation]    Login dengan email dan password yang valid
    [Tags]    positive
    Redirect Login Page
    Input Login    ${VALID_EMAIL}    ${VALID_PASSWORD}
    Click Login Button
    Sleep    1s
    ${SUCCESS}=             Run Keyword And Return Status    Page Should Contain Element    css:.notification.success
    IF    ${SUCCESS}
        Log     Success notification ditampilkan
    ELSE
        Log     Success notification tidak muncul
        Fail    Expected success notification
    END
    Sleep    2s
    Close Browser
