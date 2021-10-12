*** Settings ***
Documentation   This Robots solves Challengue 9 (https://forum.uipath.com/t/9-rpa-challenge-dynamic-selectors-on-google/2709)
...             The License is described in the LICENSE.md file.
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.Browser.Selenium


*** Variables ***
@{COMPANIES}    Mphasis    Infosys    Google    Dell    HP    Lenovo    Twitter    Facebook

*** Tasks ***
Challenge 9
    Log    ${\n}    console=True   
    Log    Opening the Available Browser    console=True
    # You can change headless=False to see how the browser  is managed
    Open Available Browser    https://www.google.com/    #headless=True
    Wait Until Element Is Visible    name:q
    FOR    ${element}    IN    @{COMPANIES}
        Wait Until Element Is Visible    name:q
        Input Text    name:q    ${element} CEO
        Click Button When Visible    name:btnK
        Wait Until Element Is Visible    class:FLP8od
        ${name}=    Get Text    class:FLP8od
        Log    The Company is ${element}, and the CEO is ${name}    console=True
        Go To    https://www.google.com/
    END
    [Teardown]    Close Browser


