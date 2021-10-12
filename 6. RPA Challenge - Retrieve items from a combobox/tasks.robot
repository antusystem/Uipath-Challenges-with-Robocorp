*** Settings ***
Documentation   This Robots solves Challengue 6 (https://forum.uipath.com/t/6-rpa-challenge-retrieve-items-from-a-combobox/2411)
...    to obtain the elements in a dropdown list or combobox. Thouhg, due to the page suggested to
...    use is a not so "stable" I use the web page https://ccxuf.csb.app/ in order to do what was asked.
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.Browser.Selenium


*** Keyword ***
Get Combobox items
    [Documentation]    This Keyword should obtain the list of element in the combobox, but I
    ...    can't understand why, maybe is because the page is for learning and it's no made for
    ...    this particular example.
    Open Available Browser    https://www.w3schools.com/tags/tryit.asp?filename=tryhtml_select    #headless=True 
    Wait Until Element Is Visible    xpath://*[@id="cars"]
    ${element}=    Get List Items    xpath://*[@id="cars"]
    Log    ${element}
    Close Browser

*** Tasks ***
Challenge 6
    # Open the browser in the indicated web page
    Log    ${\n}
    Log    Openning Available Browser    console=True
    Open Available Browser    https://ccxuf.csb.app/
    # Wait until the element loads
    Log    Wait for the element "famous-robots"    console=True
    Wait Until Element Is Visible    xpath://*[@id="famous-robots"]
    # Get the element and log it
    Log    Listing the Items in the Combobox    console=True
    ${element}=    Get List Items    id:famous-robots
    Log    The elements in the list are: ${element}    console=True
    [Teardown]    Close Browser


