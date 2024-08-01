*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Ignore SSL Warnings

*** Variables ***
${BASE_URL}    http://virtserver.swaggerhub.com/MetaFactoryBV/CarStock/1.0.63/api
${AUTH_TOKEN}  Bearer your_auth_token_here

*** Test Cases ***
TC001 Verify successful GET request for advertisement titles with valid carStockIds
    [Documentation]    Preconditions: The car stock IDs must exist in the system
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response has valid advertisement titles
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    carStockIds=[1, 2, 3]
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    items

TC002 Verify GET request for advertisement titles with invalid carStockIds
    [Documentation]    Preconditions: None
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response indicates invalid parameter
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    carStockIds=['invalidId']
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    400
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    error

TC003 Verify GET request for advertisement titles without carStockIds
    [Documentation]    Preconditions: None
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response has valid advertisement titles
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    items

TC004 Verify GET request for advertisement titles without authentication
    [Documentation]    Preconditions: None
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response indicates unauthorized access
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${params}=    Create Dictionary    carStockIds=[1]
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    401
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    error

TC005 Verify GET request for advertisement titles with forbidden access
    [Documentation]    Preconditions: User must not have access to the resource
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response indicates forbidden access
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    carStockIds=[1, 2, 3]
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    403
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    error

TC006 Verify GET request for advertisement titles with non-existing carStockIds
    [Documentation]    Preconditions: None
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response indicates not found
    [Tags]    GET    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    carStockIds=[9999]
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    404
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    error

TC007 BDD - As a user, I want to fetch advertisement titles by providing carStockIds so that I can see the relevant titles
    [Documentation]    Preconditions: The car stock IDs must exist in the system
    ...                API Endpoint: /carstock/advertisement-titles
    ...                Postconditions: Verify the response has valid advertisement titles
    [Tags]    BDD    CarStock
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${params}=    Create Dictionary    carStockIds=[1]
    ${response}=    GET On Session    api    /carstock/advertisement-titles    headers=${headers}    params=${params}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.headers['Content-Type']}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    items

*** Keywords ***
Ignore SSL Warnings
    [Documentation]    Ignore SSL warnings for this test run.
    Evaluate    requests.packages.urllib3.disable_warnings()