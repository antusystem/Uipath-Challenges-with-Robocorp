*** Settings ***
Documentation   This robots solves the Challenge 15 (https://forum.uipath.com/t/15-rpa-challenge-site-listener/27707)
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.Browser.Selenium
Library         RPA.FileSystem


*** Variables ***
${file_name}    information
${file_type}    .txt
${timeout}    10

*** Keywords ***
Getting the WebElements
    [Documentation]    This Keyword obtains all the web elements acording to the search parameter
    ...    ---------- Return ----------
    ...    ${elements} (list): a list with the web elements found
    Open Available Browser    https://forum.uipath.com/latest    headless=True
    ${search_parameter}=    Set Variable    title raw-link raw-topic-link
    # ${elements}=    Get WebElements    //a[contains(@class,"title raw-link raw-topic-link")]
    ${elements}=    Get WebElements    //a[contains(@class, "${search_parameter}")]
    Log    ${elements}
    
    # If you want to check the methods
    # ${dir}=    Evaluate    dir($elements[0])
    # Log   ${dir}
    # ${dir}=    Evaluate    dir($elements)
    # Log   ${dir}
    
    [Return]    ${elements}

*** Keywords ***
Adding information
    [Documentation]    This Keyword adds the information of the web elements
    ...    on a .txt file
    ...    ---------- Parameters ----------
    ...    ${elements} (string):   webelements found.
    ...    ${index} (string or int): index of the cycle
    
    [Arguments]    ${elements}    ${index}
    Create File    ${file_name}_${index}${file_type}    overwrite=True
    # Looping the elements found
    FOR    ${element}    IN    @{elements}
        Log    ${element}
        ${text}=    Evaluate    $element.text
        ${attribute}=    Evaluate    $element.get_attribute("data-topic-id")
        Log    ${SPACE} - The element text is: ${text}    console=True
        Log    ${SPACE} - The element attribute: ${attribute}    console=True
        Append To File    ${file_name}_${index}${file_type}    ${text}: ${attribute} ${\n}
        Append To File    ${file_name}_${index}${file_type}    ****************************** ${\n}
        Log    *****************************    console=True
        
    END

*** Tasks ***
Challenge 15
    [Documentation]    To repeat the process we put in a for with a sleep, you
    ...    can implement this in several ways, but I found this one usefull.
    # It will repeat the process 3 times, waiting a
    # default value of 10 seconds
    Log    ${\n}    console=True
    ${retry}=    Set Variable    ${3}
    FOR    ${index}    IN RANGE    1    ${retry + 1} 
        ${elements}=    Getting the WebElements
        Adding information    ${elements}    ${index}
        Sleep    ${timeout}
        Log    =========================    console=True
        # This should not be here because I know it will open the broser again
        # I just let it here because if it was manually it would be done that way
        Close All Browsers
    END
    [Teardown]    Close All Browsers


