*** Settings ***
Documentation   This Robots solves Challengue 11 (https://forum.uipath.com/t/11-rpa-challenge-regex-to-match-invoice-number-and-order-number-on-consecutive-lines/9374)
...             The License is described in the LICENSE.md file.
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.FileSystem
Library         String


*** Variables ***
${file}    data.txt
${new_file}    data_needed.txt

*** Tasks ***
Challenge 11
    [Documentation]    Task to solve Challenge 11
    Log    ${\n}    console=True
    Log    Reading the file    console=True
    ${file_info}=    Read File    ${file}
    Log    The file has: ${\n}    console=True
    Log    ${file_info}    console=True
    ${regex}=    Set Variable    Total Invoice[\\r\\n]+([^\\r\\n]+)[\\r\\n]+([^\\r\\n]+)
    ${match}=    Get Regexp Matches    ${file_info}   ${regex}    1    2
    ${matches}=    Set Variable    ${match}[0]
    # The Next one is in Mylibrary.py
    ${match2}=    RE Search    ${regex}    ${file_info}
    
    Log    The match with Robocorp Lib is:    console=True
    Log    ${match}    console=True
    Log    The match with python is: ${match2}    console=True    
    
    # Now we add the information to a .txt file
    Create File     ${new_file}    ****************${\n}    overwrite=True    
    Append To File    ${new_file}    Order Number: ${matches}[0]${\n}  
    Append To File    ${new_file}    Invoice Number: ${matches}[1]${\n}
    Append To File    ${new_file}    ****************${\n}



