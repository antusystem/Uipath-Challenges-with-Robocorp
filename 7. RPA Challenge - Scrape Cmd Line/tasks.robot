*** Settings ***
Documentation   This Robots solves Challengue 7 (https://forum.uipath.com/t/7-rpa-challenge-scrape-cmd-line/2556)
...             The License is described in the LICENSE.md file.
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         OperatingSystem
Library         RPA.Desktop


*** Keyword ***
Command without Opening Console
    Log    Identifying the operating system    console=True
    ${OS}=    Set Variable    ${{platform.system()}}
    Log    The OS is: ${OS}    console=True
    ${rc}    ${output}=    Run Keyword If    "${OS}" == "Windows"    Run And Return Rc And Output    ipconfig
    ...    ELSE IF    "${OS}" == "Linux"    Run And Return Rc And Output    ifconfig
    # ...    ELSE IF    "${OS}" == "Mac (?)"    Run And Return Rc And Output    (MacOS command for this)
    Log    The output is: ${output}    console=True
    Log    Creating a file called "ifconfig2.txt" in the root of the bot (${EXECDIR}).    console=True
    Create File    ifconfig2.txt    ${output}


*** Keyword ***
Command Opening Console
    [Documentation]    This Keyword open the terminal by searching it in the programms searcher in Lubuntu
    ...    then it opens qterminal (the terminal viewer in Lubuntu), later ir writes the command and send it
    ...    to a file in the robot folder, where it will be read
    Log    Pressing Windows/Super + D    console=True
    Press Keys    cmd    d
    Log    Pressing Windows/Super    console=True
    Press Keys    cmd
    Sleep    1
    ${terminal_name}=    Set Variable    qterminal
    Log    Searching for the terminal called: "${terminal_name}"    console=True
    Type Text     ${terminal_name}    enter= True
    Sleep    1
    Log    Writing the command: ifconfig > "${CURDIR}${/}ifconfig.txt"    console=True
    Type Text     ifconfig > "${CURDIR}${/}ifconfig.txt"    enter=True
    Sleep    1
    Log    Closing the terminal    console=True
    Press Keys    alt    f4
    ${file}=    Get File     ifconfig.txt
    Log    The file content is: ${\n} ${file}    console=True
    
    #Remove File    ifconfig.txt

*** Tasks ***
Challenge 7
    [Documentation]    Robocorp has libraries to complete this challenge without opening the console
    ...    but I will do it the 2 ways.
    Log    ${\n}    console=True
    # This is not at all the best way, but it is a way, so 
    # Command Opening Console
    # This is a better way to do it
    Command without Opening Console




#
#
