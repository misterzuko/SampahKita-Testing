*** Settings ***
Library    RequestsLibrary
Library    DateTime
Library    Collections
Library    BuiltIn

Suite Setup    Suppress SSL Warning

*** Variables ***
${MAIN_URL}    https://darkcyan-ostrich-362407.hostingersite.com
${TIMEOUT}     30

*** Keywords ***
#Menghilangkan peringatan SSL
Suppress SSL Warning
    Run Keyword And Ignore Error    Evaluate    __import__('urllib3').disable_warnings()

Ukur Response Time
    [Arguments]    ${endpoint}
    ${start}=    Get Current Date    result_format=epoch
    ${response}=    GET On Session    api    ${endpoint}    expected_status=any    verify=${False}
    ${end}=    Get Current Date    result_format=epoch
    ${response_time}=    Evaluate    (${end} - ${start}) * 1000
    RETURN    ${response}    ${response_time}

*** Test Cases ***

TC001 - Ukur Response Time Login Page
    [Documentation]    Mengukur kecepatan loading halaman login
    [Tags]    response-time
    Create Session    api    ${MAIN_URL}
    ${response}    ${time}=    Ukur Response Time    /src/page/login.html
    Log    Response Time Login: ${time} ms
    Log    Status: ${response.status_code}
    Delete All Sessions

TC002 - Ukur Response Time Register Page
    [Documentation]    Mengukur kecepatan loading halaman register
    [Tags]    response-time
    Create Session    api    ${MAIN_URL}
    ${response}    ${time}=    Ukur Response Time    /src/page/register
    Log    Response Time Register: ${time} ms
    Log    Status: ${response.status_code}
    Delete All Sessions

TC003 - Stress Test Login 30 Requests
    [Documentation]    Stress test login dengan 30 request berurutan
    [Tags]    stress-test
    Create Session    api    ${MAIN_URL}
    
    ${sukses}=    Set Variable    0
    ${gagal}=    Set Variable    0
    
    FOR    ${i}    IN RANGE    30
        ${response}    ${time}=    Ukur Response Time    /src/page/login.html
        IF    ${response.status_code} == 200
            ${sukses}=    Evaluate    ${sukses} + 1
        ELSE
            ${gagal}=    Evaluate    ${gagal} + 1
        END
    END
    
    Log    Total: 30 Requests
    Log    Sukses: ${sukses}
    Log    Gagal: ${gagal}
    Delete All Sessions

TC004 - Stress Test Register 30 Requests
    [Documentation]    Stress test register dengan 30 request berurutan
    [Tags]    stress-test
    Create Session    api    ${MAIN_URL}
    
    ${sukses}=    Set Variable    0
    ${gagal}=    Set Variable    0
    
    FOR    ${i}    IN RANGE    30
        ${response}    ${time}=    Ukur Response Time    /src/page/register
        IF    ${response.status_code} == 200
            ${sukses}=    Evaluate    ${sukses} + 1
        ELSE
            ${gagal}=    Evaluate    ${gagal} + 1
        END
    END
    
    Log    Total: 30 Requests
    Log    Sukses: ${sukses}
    Log    Gagal: ${gagal}
    Delete All Sessions

TC005 - Load Test Login & Register
    [Documentation]    Mengukur response time login dan register pages secara bergantian
    [Tags]    load-test
    Create Session    api    ${MAIN_URL}
    
    FOR    ${i}    IN RANGE    10
        ${response}    ${time}=    Ukur Response Time    /src/page/login.html
        Log    Request ${i} - Login Response Time: ${time} ms
        
        ${response}    ${time}=    Ukur Response Time    /src/page/register
        Log    Request ${i} - Register Response Time: ${time} ms
    END
    
    Delete All Sessions
