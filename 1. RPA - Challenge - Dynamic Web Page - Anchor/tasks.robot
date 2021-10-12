*** Settings ***
Documentation     Robot to solve the first challenge at rpachallenge.com, which consists of
...               filling a form that randomly rearranges itself for ten times, with data
...               taken from a provided Microsoft Excel file.
Library           RPA.Browser.Selenium
Library           RPA.Excel.Files
Library           RPA.HTTP


*** Variables ***
${FILENAME}=      challenge.xlsx
${DOWNLOAD_DIR}=    ${CURDIR}${/}downloads

*** Keywords ***
Get The List Of People From The Excel File
    Log    ${SPACE}${SPACE} - Opening Workbook     console=True
    Open Workbook    ${CURDIR}${/}downloads${/}challenge.xlsx
    Log    ${SPACE}${SPACE} - Reading Worksheet as Table    console=True
    ${table}=    Read Worksheet As Table    header=True
    Log    ${SPACE}${SPACE} - Closing Workbook and returning table    console=True
    Close Workbook
    [Return]    ${table}


*** Keywords ***
Set Value By Xpath
    [Arguments]    ${xpath}    ${value}
    ${result}=    Execute Javascript    document.evaluate('${xpath}',document.body,null,9,null).singleNodeValue.value='${value}';
    [Return]    ${result}

*** Keywords ***
Fill And Submit The Form
    [Arguments]    ${person}
    Log    ${SPACE}${SPACE} - Writing the First Name: ${person}[First Name]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelFirstName"]  ${person}[First Name]
    Log    ${SPACE}${SPACE} - Writing the Last Name: ${person}[Last Name]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelLastName"]  ${person}[Last Name]
    Log    ${SPACE}${SPACE} - Writing the Company Name: ${person}[Company Name]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelCompanyName"]  ${person}[Company Name]
    Log    ${SPACE}${SPACE} - Writing the Role in Company: ${person}[Role in Company]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelRole"]  ${person}[Role in Company]
    Log    ${SPACE}${SPACE} - Writing the Address: ${person}[Address]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelAddress"]  ${person}[Address]
    Log    ${SPACE}${SPACE} - Writing the Email: ${person}[Email]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelEmail"]  ${person}[Email]
    Log    ${SPACE}${SPACE} - Writing the Phone Number: ${person}[Phone Number]     console=True
    Set Value By Xpath    //input[@ng-reflect-name="labelPhone"]  ${person}[Phone Number]
    Click Button    Submit

*** Tasks ***
Start The Challenge
    Log    ${\n}    console=True
    Log    Setting the Download Directory to: ${DOWNLOAD_DIR}    console=True
    Set Download Directory     ${DOWNLOAD_DIR}
    Log    Opening the Available Browser    console=True
    Open Available Browser    http://rpachallenge.com/
    Log    Downloading the file    console=True
    Download  http://rpachallenge.com/assets/downloadFiles/challenge.xlsx    overwrite=True    target_file=${DOWNLOAD_DIR}
    Log    Starting the Challenge    console=True
    Click Button    Start

*** Tasks ***
Fill The Forms
    Log    ${\n}    console=True
    Log    Reading the Excel file:    console=True
    ${people}=    Get The List Of People From The Excel File
    Log    Looping the table:    console=True
    FOR  ${person}  IN  @{people}
        Log    ${SPACE} *****************************************    console=True
        Fill And Submit The Form  ${person}
        Log    ${SPACE} *****************************************    console=True
    END

*** Tasks ***
Collect The Results
    Log    ${\n}    console=True
    Log    Capturing a Screenshot    console=True
    Capture Element Screenshot    css:div.congratulations    ${CURDIR}/screenshot.png
    Log    Closing the Browser    console=True
    [Teardown]  Close All Browsers

