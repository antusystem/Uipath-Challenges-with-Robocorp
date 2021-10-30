*** Settings ***
Documentation    This robots solves the Challenge 16 (https://forum.uipath.com/t/16-rpa-challenge-create-piechart-from-excel-file/27785)
Library         Collections
Library         PlotingLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.Excel.Files
Library         RPA.Tables


*** Variables ***
${file_name}    final_data.xlsx

*** Keywords ***
Retrieve Data
    [Documentation]    hola
    Open Workbook    ${file_name}
    ${table}=    Read Worksheet As Table
    Close Workbook
    ${labels}=    Get Table Column    ${table}    A
    Remove Values From List    ${labels}    ${None}
    Log    The labels are: ${labels}    console=True
    ${sizes}=    Get Table Column    ${table}    B
    Remove Values From List    ${sizes}    ${None}
    Log    The sizes are: ${sizes}    console=True
    [Return]    ${labels}    ${sizes}


*** Tasks ***
Challenge 16
	Log    ${\n}	console=True
    ${labels}    ${sizes}=    Retrieve Data
    # The Plot is not that good, but, it does shows the data, that is the important
    # thing in the challenge
    Log    Plotting...    console=True
    Plotting    ${labels}    ${sizes}


