*** Settings ***
Documentation   This Robots solves the Challenge 5 (https://forum.uipath.com/t/5-rpa-challenge-reorganizing-excel-data-sheet/1036) of UiPath
Library         Collections
Library         MyLibrary
Resource        keywords.robot
Variables       MyVariables.py
Library         RPA.Excel.Files
Library         RPA.Tables

*** Variables***
${FILENAME}    My_Wokrsheet.xlsx
@{headers}    First Name    Last Name    Orders    Material Code

*** Keywords ***
Create Materials Table
    [Documentation]    This Keyword create the new table for the materials in which
    ...    every material will have an id.
    [Arguments]    ${first_table}
    
    # Obtain Materials name
    Log    ${SPACE}${SPACE} - Gettign Table Columns    console=True
    ${materials}=    Get Table Column    ${first_table}    Material Name
    ${materials}=    Remove Duplicates    ${materials}
    Log    ${SPACE}${SPACE} - The Material are: ${materials}   console=True
    # Get the number of materials
    Log    ${SPACE}${SPACE} - Getting length of materials   console=True
    ${length}=    Get Length    ${materials}
    ${num_materials}=    Evaluate    list(range(1, ${length + 1}, 1))
    Log    ${SPACE}${SPACE} - The list of materials is: ${num_materials}   console=True
    # Create the list with the column names for the new table
    Log    ${SPACE}${SPACE} - Creating Columns names    console=True
    ${column_name}=    Create List    Materials    Material Code
    # Create the table for the materials
    Log    ${SPACE}${SPACE} - Creating the Material's Table with the right headers   console=True
    ${materials_table}=    Create Table    ${materials}    columns=${column_name}
    Log    ${SPACE}${SPACE} - Adding the material codes to the table    console=True
    Set Table Column    ${materials_table}    Material Code     ${num_materials}
       
    [Return]    ${materials_table}

*** Keywords ***
Process Orders List
    [Documentation]    This Keywords converst the list of orders to a string in which
    ...    the orders are separated by a coma.
    [Arguments]     ${orders_list}
    # Getting the length of the list
    ${len}=    Get Length    ${orders_list}
    #Looping acording to the length of the list
    FOR    ${index}    IN RANGE    0     ${len}
        Log    ${index}
        Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- Concatenating Order's ID      console=True
        # If the length is 0 then I only assign the only value and exit the loop
        Run Keyword If    ${0} == ${len}    Set Variable    ${orders_list}[0]
        Run Keyword If    ${0} == ${len}    Exit For Loop
        
        # If not,  we add one by ony until we have all the elements in the list
        IF    ${index} == ${0}
            ${orders_id_string}=    Set Variable    ${orders_list}[${index}]
        ELSE IF    ${index} <= ${len}
            ${orders_id_string}=    Set Variable    ${orders_id_string}, ${orders_list}[${index}]            
        END
        Log    ${orders_id_string}
    END
    Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- The order's string is: ${orders_id_string}      console=True 
    
    [Return]    ${orders_id_string}

*** Keywords ***
Process Materials List
    [Documentation]    This Keyword creates a string in which are shown
    ...    the material id separeted by a coma.
    [Arguments]     ${materials_table}    ${materials_list}
    # Creating a list to contain the ids
    ${material_id}=    Create List
    # Looping the list of materials of this individual
    FOR    ${element}    IN    @{materials_list}
        # Then looping the list of all material to check which one does this person has
        FOR    ${row}    IN    @{materials_table}
            Log    ${row}
            IF    "${element}" == "${row}[Materials]"
                Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- Adding the material to list      console=True
                Append To List    ${material_id}    ${row}[Material Code]
            END
        END
    END
    
    # Getting the legth of the materials
    ${len}=    Get Length    ${material_id}
    #Looping acording to the length of the list
    FOR    ${index}    IN RANGE    0     ${len}
        Log    ${index}
        # If the length is 0 then I only assign the only value and exit the loop
        Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- Concatenating Material's ID      console=True
        Run Keyword If    ${0} == ${len}    Set Variable    ${material_id}[0]
        Run Keyword If    ${0} == ${len}    Exit For Loop
        # If not,  we add one by ony until we have all the elements in the list
        IF    ${index} == ${0}
            ${material_id_string}=    Set Variable    ${material_id}[${index}]
        ELSE IF    ${index} <= ${len}
            ${material_id_string}=    Set Variable    ${material_id_string}, ${material_id}[${index}]            
        END
        Log    ${material_id_string}
    END
    Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- The material string is: ${material_id_string}      console=True 
    
    [Return]    ${material_id_string}

*** Keywords ***
Create Table for Sheet2
    [Documentation]    This Keyword process the information in order to create the new table
    [Arguments]    ${first_table}    ${materials_table}
    # We create a list to contain all names and last names of the original table
    ${name_list}=    Get Table Column    ${first_table}    First Name
    Log    ${SPACE}${SPACE} - The names are: ${name_list}   console=True
    ${lastn_list}=    Get Table Column    ${first_table}    Last Name
    Log    ${SPACE}${SPACE} - The last names are: ${lastn_list}   console=True
    # We get the legth of both list
    ${len_name}=    Get Length    ${name_list}
    ${len_lastn}=    Get Length    ${lastn_list}    
    # Both List should have the same legth
    Should Be Equal    ${len_name}    ${len_lastn}
    
    # We create a list to contain the information about every person
    # this will be the rows of the new table
    ${information}=    Create List
    # Looping  acording to the numbers of people in the first table
    FOR    ${index}    IN RANGE    0    ${len_name}
        Log    ${SPACE}${SPACE} *****************************************    console=True
        Log    ${SPACE}${SPACE}${SPACE} * The index is: ${index}    console=True
        # Creating the dictionary to contain the information of the person
        # this will be a row in the new table
        ${dict}=    Create Dictionary
        # Writing the name and last name to the "row"
        Log    ${SPACE}${SPACE}${SPACE} * Adding to the dictionary First and Last Name     console=True
        Set To Dictionary    ${dict}    First Name    ${name_list}[${index}]
        Set To Dictionary    ${dict}    Last Name    ${lastn_list}[${index}]
        # Create list to contain a list of material and a list of orders of this person
        Log    ${SPACE}${SPACE}${SPACE} * Creating Materials and Orders List    console=True
        ${materials_list}=    Create List
        ${orders_list}=    Create List
        # Looping the first table to check the materials and orders of the person in this cycle of
        # the first loop
        Log    ${SPACE}${SPACE}${SPACE} * Looping the original table:    console=True
        FOR    ${row}    IN    @{first_table}
            # Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- The row is: ${row}      console=True
            # Check every row in the table to see if it corresponds to the one in the first loop
            IF    "${name_list}[${index}]" == "${row}[First Name]" and "${lastn_list}[${index}]" == "${row}[Last Name]"
                # If it does then we save the material name and order number
                Log    ${SPACE}${SPACE}${SPACE}${SPACE} -*- Adding the material and order number      console=True
                Append To List    ${materials_list}    ${row}[Material Name]
                Append To List    ${orders_list}    ${row}[Order#]
            END
        END
        Log    ${SPACE}${SPACE}${SPACE} * The Material's List is: ${materials_list}    console=True
        Log    ${SPACE}${SPACE}${SPACE} * The Order's List is: ${orders_list}    console=True
        
        # We turn the list of orders to a string
        Log    ${SPACE}${SPACE}${SPACE} * Processing the Order's List:    console=True
        ${orders_list}=    Process Orders List    ${orders_list}
        Log    ${SPACE}${SPACE}${SPACE} * Adding Order's string to a dictionary    console=True
        Set To Dictionary    ${dict}    Orders    ${orders_list}
        
        # We turn the list of materials to a string with the id of the materials
        Log    ${SPACE}${SPACE}${SPACE} * Processing the Material's List:    console=True
        ${materials_list}=    Process Materials List    ${materials_table}    ${materials_list}
        Log    ${SPACE}${SPACE}${SPACE} * Adding Material's string to a dictionary    console=True
        Set To Dictionary    ${dict}    Material Code    ${materials_list}
        # We add the "row" to the list
        Append To List    ${information}    ${dict}
        Log    ${SPACE}${SPACE} =========================================    console=True
    END
    # Because we know that some people is repeated in the first table but we do not 
    # take it to consideration in the loop, we have to remove the extra information generated
    Log    ${SPACE}${SPACE} - Removing Duplicates    console=True
    ${information}=    Remove Duplicates    ${information}
    # We create the table with the correct headers
    Log    ${SPACE}${SPACE} - Creating the new table    console=True
    ${new_table}=    Create Table    columns=${headers}
    # We loop the list to add every row
    Log    ${SPACE}${SPACE} - Looping the Information to add:    console=True
    FOR    ${row}    IN    @{information}
        Log    ${SPACE}${SPACE}${SPACE} ***********************************     console=True
        Log    ${SPACE}${SPACE}${SPACE} * The row is: ${row}     console=True
        # Now with only a row for every people we create the new table
        Log    ${SPACE}${SPACE}${SPACE} * Adding the row to the new table with the information     console=True
        Add Table Row    ${new_table}    ${row}
        Log    ${SPACE}${SPACE}${SPACE} ===================================     console=True
    END
    [Return]    ${new_table}

*** Keywords ***
Add Tables To Worksheet
    [Documentation]    This Keyword does the final steps to add the new table to the worsheet
    [Arguments]    ${new_table}    ${materials_table}
    # Create the new sheet
    Log    ${SPACE}${SPACE} - Create the new worksheet    console=True
    Create Worksheet    Sheet2
    # Go to the new sheet
    Log    ${SPACE}${SPACE} - Setting the active sheet to Sheet2    console=True
    Set Active Worksheet    Sheet2
    # Add the new table to the sheet
    Log    ${SPACE}${SPACE} - Adding the New Table to Sheet2     console=True
    Append Rows To Worksheet     ${new_table}    header=${TRUE}
    # Create a Sheet for the materials
    Log    ${SPACE}${SPACE} - Creating Sheet 3 and setting it as active    console=True
    Create Worksheet    Sheet3
    Set Active Worksheet    Sheet3
    # Add the materials tab le
    Log    ${SPACE}${SPACE} - Adding the Material's Table to Sheet3    console=True
    Append Rows To Worksheet     ${materials_table}    header=${TRUE}
    Set Active Worksheet    Sheet2
    # Remove the Sheet 1
    Log    ${SPACE}${SPACE} - Removing Sheet1    console=True
    Remove Worksheet    Sheet1
    # Save the Workbook
    Log    ${SPACE}${SPACE} - Saving Workbook     console=True
    Save Workbook    New_Worksheet.xlsx

*** Tasks ***
Challenge 5
    # We open the .xlsx with the data
    Log    Opening the .xlsx file    console=True
    Open Workbook    ${FILENAME}
    # Read it as a table
    Log    Reading the .xlsx file as a table    console=True
    ${table} =    Read Worksheet As Table   header=${TRUE}

    # Create the Materials Table
    Log    Creating the Materials Table:    console=True
    ${materials_table}=    Create Materials Table    ${table}
    # Create the sheet2 table
    Log    Creating Sheet 2:    console=True
    ${new_table}=    Create Table for Sheet2    ${table}    ${materials_table}
    # Create the new Worksheet
    Log    Adding New Table to Worksheet 2:    console=True
    Add Tables To Worksheet    ${new_table}    ${materials_table}
    [Teardown]    Close Workbook
