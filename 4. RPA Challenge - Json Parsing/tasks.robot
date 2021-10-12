*** Settings ***
Documentation   This bot completes the challege 4 in https://forum.uipath.com/t/4-rpa-challenge-json-parsing/871
...             The License is described in the LICENSE.md file.
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.HTTP
Library         RPA.JSON
Library         RPA.Dialogs


*** Variables ***
${FILENAME}=      inputJson.json
${DOWNLOAD_DIR}=    ${CURDIR}${/}inputJson.json

*** Keywords ***
Dialog
    [Documentation]    This Keywords generates a prompt containing the person first name, last name,
    ...    age, and mobile phone number (in case it has one). If the person does no have a mobile phone number
    ...    or is not at least 30 years old, it will show an message indicating it.
    [Arguments]    ${firstName}    ${lastName}    ${age}    ${mobile_status}    ${mobile}
    # We add the heading
    Add heading    JSON EXPLORER
    # Indiciating the personal information
    Add Text    First Name: ${firstName}
    Add Text    Last Name: ${lastName}
    Add Text    Age: ${age}
    # Checking the requirements
    IF    ${mobile_status} == True and ${age} >= ${30}
        Add Text    Mobile Number: ${mobile}
        Add Text    This person meets the requirements
        Add icon    Success
    ELSE IF    ${mobile_status} == True and ${age} < ${30}
        Add Text    Mobile Number: ${mobile}
        Add Text    This person does not meet the requirements
        Add icon    Failure
    ELSE
        Add Text    This person does not meet the requirements
        Add icon    Failure
    END
    # Running the prompt/dialog 
    Run Keyword and Return Status    Run dialog    timeout=6


*** Keywords ***
Read Json
    [Documentation]    This keywords loops the json file to find the age of the person and
    ...    also it checks if it has a mobile phone number. Later, it shows a dialog if the
    ...    person meets or not the requirements.
    [Arguments]    ${json}
    # Looping the json file, that has been read as a list with 3 elements,
    # this 3 elements are 3 dictionaries
    FOR    ${dict}    IN    @{json}
        # We read the age and change it to and integer
        Log    ${SPACE}${SPACE} ***********************************************    console=True
        Log    ${SPACE}${SPACE} - This person is called: ${dict}[firstName] ${dict}[lastName]
        ${age}=    Convert To Integer    ${dict}[age]
        Log    ${SPACE}${SPACE} - The Age is: ${age}    console=True
        # We assing the key phonenumber to a variable, the items in this key is
        # a list with dictionary containing the information about the phone numbers
        ${phoneNumber}=    Set Variable   ${dict}[phoneNumber]
        # We loop the dictionary of the phone numbers
        Log    ${SPACE}${SPACE} - Checking Phone Number:     console=True
        FOR    ${phoneNum}    IN    @{phoneNumber} 
            # We check if this dictionary contains the pair "type": "mobile"
            ${status}=    Run Keyword And Return Status
            ...    Dictionary Should Contain Item    ${phoneNum}    type    mobile
            IF    ${status} == True
                # In case it contains that pair we save it to some variables and exit the loop
                ${mobile_status}=    Set Variable    True
                ${mobile}=    Set Variable    ${phoneNum}[number]
                Exit For Loop
            ELSE
                # if it does not contains the pair, we register it in this variables
                ${mobile_status}=    Set Variable    False
                ${mobile}=    Set Variable    None
            END
        END
        Run Keyword If    ${mobile_status} == True    Log    ${SPACE}${SPACE}${SPACE} * The Mobile Phone Number is: ${mobile}     console=True
        ...    ELSE    Log    ${SPACE}${SPACE}${SPACE} * This person does not have a mobile phone number     console=True
        # Run a prompt message with information about this person
        Log    ${SPACE}${SPACE} - Execute the Dialog     console=True
        Dialog    ${dict}[firstName]    ${dict}[lastName]    ${dict}[age]    ${mobile_status}    ${mobile}
        Log    ${SPACE}${SPACE} - Closing the Dialog     console=True
        Close all dialogs
        Log    ${SPACE}${SPACE} ==============================================    console=True
    END

*** Tasks ***
Challenge 4
    [Documentation]    This Task download the json file to read and determinated
    ...    if the person is 30 years old or more and has a mobile phone number
    # First we download the json file for the challegue
    Log    Downloading the JSON File to: ${DOWNLOAD_DIR}    console=True
    Download    https://aws1.discourse-cdn.com/uipath/original/1X/a843a34b8cf05fc83f81c141a3b07e7d02544177.json    overwrite=True    target_file=${DOWNLOAD_DIR}
    # Then, we read it
    Log    Loading JSON    console=True
    ${json}=    Load JSON from file    ${FILENAME}
    # We start to read the json file and to show the state of every person in it
    Log    Reading and Looping the JSON File:    console=True
    Read Json    ${json}

