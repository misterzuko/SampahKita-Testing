*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Main Website
Suite Teardown    Close Browser Session

*** Variables ***
${MAIN_URL}        https://darkcyan-ostrich-362407.hostingersite.com
${BROWSER}         chrome

*** Keywords ***
Open Main Website
    Open Browser    ${MAIN_URL}    ${BROWSER}
    Maximize Browser Window

Redirect Main
    Go To    ${MAIN_URL}

Close Browser Session
    Close Browser

Click Navbar Button
    [Arguments]    ${button_name}
    Click Link    ${button_name}
    Sleep    2s

Verify Page Loaded
    [Arguments]    ${expected_text}
    Wait Until Page Contains    ${expected_text}    10s

*** Test Cases ***

TC001 - Click Bank Sampah Button
    [Documentation]    Klik tombol Bank Sampah di navbar
    [Tags]    navbar
    Click Navbar Button    Bank Sampah
    Verify Page Loaded    Bank Sampah

TC002 - Click Feed Button
    [Documentation]    Klik tombol Feed di navbar
    [Tags]    navbar
    Click Navbar Button    Feed

TC003 - Click Scan Sampah Button
    [Documentation]    Klik tombol Scan Sampah di navbar
    [Tags]    navbar
    Click Navbar Button    Scan Sampah

TC004 - Click Leaderboard Button
    [Documentation]    Klik tombol Leaderboard di navbar
    [Tags]    navbar
    Click Navbar Button    Leaderboard
    Verify Page Loaded    Leaderboard

TC005 - Click Tentang Kami Button
    [Documentation]    Klik tombol Tentang Kami di navbar
    [Tags]    navbar
    Click Navbar Button    Tentang Kami

TC006 - Click Login Button
    [Documentation]    Klik tombol Login di navbar
    [Tags]    navbar
    Click Navbar Button    Login
    Wait Until Element Is Visible    id:email    10s
    Redirect Main

TC007 - All Navbar Buttons Visible
    [Documentation]    Verifikasi semua tombol navbar terlihat
    [Tags]    navbar    smoke
    Page Should Contain Element    xpath://a[contains(text(), 'Bank Sampah')]
    Page Should Contain Element    xpath://a[contains(text(), 'Feed')]
    Page Should Contain Element    xpath://a[contains(text(), 'Scan Sampah')]
    Page Should Contain Element    xpath://a[contains(text(), 'Leaderboard')]
    Page Should Contain Element    xpath://a[contains(text(), 'Tentang Kami')]
    Page Should Contain Element    xpath://a[contains(text(), 'Login')]

TC008 - Navbar Navigation Flow
    [Documentation]    Test navigasi berturut-turut antar navbar buttons
    [Tags]    navbar
    
    Log    Navigasi ke Bank Sampah
    Click Navbar Button    Bank Sampah
    Sleep    1s
    
    Log    Kembali ke Feed
    Click Navbar Button    Feed
    Sleep    1s
    
    Log    Navigasi ke Scan Sampah
    Click Navbar Button    Scan Sampah
    Sleep    1s
    
    Log    Navigasi ke Leaderboard
    Click Navbar Button    Leaderboard
    Sleep    1s
    
    Log    Navigasi ke Tentang Kami
    Click Navbar Button    Tentang Kami
    Sleep    1s
