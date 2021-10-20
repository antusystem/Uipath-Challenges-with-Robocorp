*** Settings ***
Documentation   This robots solves the Challenge 13 (https://forum.uipath.com/t/13-rpa-challenge-pdf-scrapping/10432)
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.PDF


*** Variables ***
${pdf_file}    RPA dummy sample form.pdf


*** Keywords ***
Show Information
    [Documentation]    This Keyword logs the unit and the status to console
    ...    ---------- Parameters ----------
    ...    ${start_status} (boolean):  has the value of start in this round
    ...    ${stop_status} (boolean):  has the value of stop in this round
    ...    ${verify_status} (boolean):  has the value of verify in this round
    ...    ${unit} (str):  contains the unit number
    ...    ${row} (int):  contains the row number
    [Arguments]    ${start_status}    ${stop_status}    ${verify_status}    ${unit}    ${row}

    ${message}=    Run Keyword If    "${start_status}" == "/'On'"    Set Variable    START
    ...    ELSE IF    "${stop_status}" == "/'On'"     Set Variable    STOP
    ...    ELSE IF    "${verify_status}" == "/'On'"    Set Variable    VERIFY
    ...    ELSE    Set Variable    NONE SELECTED
            
    ${unit_num}=    Set Variable If    "${unit}" != "${EMPTY}"    ${unit}    ${None}
    Log    *******************    console=True
    Log    UNIT NUMBER: ${unit_num}    console=True
    Log    ${row}. ${message}    console=True         
    Log    ===================    console=True


*** Keywords ***
Search Data
    [Documentation]    This keywords searchs the input fields and log the information needed
    ...    The input are a dict, and it always shows the things in this order:
    ...    START, STOP, VERIFY, and UNIT NUMBER
    ...    ---------- Parameters ----------
    ...    ${input} (dict):  contains the inputs fields in the pdf
    [Arguments]    ${input}
    # Aux to know if we are in  START, STOP, VERIFY, or UNIT NUMBER
    ${aux}=    Set Variable    ${0}
    # row is use to show the row in the output
    ${row}=    Set Variable    ${1}
    # Loop the input dictionary
    FOR    ${key}    ${value}    IN    &{input}
        Log    ${key}: ${value}
        # Check which is the element found in this cycle
        ${status}=    Run Keyword and Return Status    Should Contain    ${key}    START
        ${status2}=    Run Keyword and Return Status    Should Contain    ${key}    STOP
        ${status3}=    Run Keyword and Return Status    Should Contain    ${key}    VERIFY
        ${status4}=    Run Keyword and Return Status    Should Contain    ${key}    UNIT NUMBERSTART
        # Gather the information about START, STOP, VERIFY, and UNIT NUMBER
        IF    ${status} == True and ${status4} == False
            ${start_status}=    Get From Dictionary     ${value}    value
            ${aux}=    Set Variable    ${aux + 1}
        ELSE IF    ${status2} == True and ${status4} == False
            ${stop_status}=    Set Variable    ${value}[value]
            ${aux}=    Set Variable    ${aux + 1}
        ELSE IF    ${status3} == True and ${status4} == False
            ${verify_status}=    Get From Dictionary     ${value}    value
            ${aux}=    Set Variable    ${aux + 1}
        ELSE IF    ${status4} == True
            ${unit}=    Set Variable    ${value}[value]
            ${aux}=    Set Variable    ${aux + 1}
        END
        # If I got all the information then I log it
        IF    ${aux} == ${4}
            Show Information    ${start_status}    ${stop_status}    ${verify_status}    ${unit}    ${row}
            ${aux}=    Set Variable    ${0}
            ${row}=    Set Variable    ${row + 1}
        END
    END

# +
*** Tasks ***
Challenge 13
    Log    ${\n}    console=True
    # Open the pdf file
    Open Pdf    ${pdf_file}
    # Get all the inputs field in the file
    ${input}=    Get Input Fields
    Log    ${input}
    # Search the inputs to find the requeriments
    Search Data    ${input}


# -



