*** Settings ***
Library    RequestsLibrary
Library    Collections
Suite Setup    Ignore SSL Warnings

*** Variables ***
${BASE_URL}    http://petstore.swagger.io/v2
${AUTH_TOKEN}  Bearer your_auth_token_here

*** Test Cases ***
TC001 Verify successful GET request for a pet by ID
    [Documentation]    Preconditions: The pet ID must exist in the system
    ...                API Endpoint: /pet/{petId}
    ...                Postconditions: Verify the response has valid pet details
    [Tags]    GET    Pet
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /pet/1    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    Should Contain    ${response.headers[Content-Type]}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${body}

TC002 Verify GET request with invalid pet ID
    [Documentation]    Preconditions: None
    ...                API Endpoint: /pet/{petId}
    ...                Postconditions: Verify the response indicates an invalid ID supplied
    [Tags]    GET    Pet
    Create Session    api    ${BASE_URL}
    ${headers}=    Create Dictionary    Content-Type=application/json    Authorization=${AUTH_TOKEN}
    ${response}=    GET On Session    api    /pet/invalid    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    400
    Should Contain    ${response.headers[Content-Type]}    application/json
    ${body}=    Set Variable    ${response.json()}
    Should Contain    ${body}    Invalid ID supplied

*** Keywords ***
Ignore SSL Warnings
    [Documentation]    Ignore SSL warnings for this test run.
    Evaluate    requests.packages.urllib3.disable_warnings()