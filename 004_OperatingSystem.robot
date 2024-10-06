*** Comments ***
environment variable
    verigy environment variable is not there
    set environment variable
    verify that variable existance
    add, verify, default separator:
    get environment variable / variables
    get environment variable using ENVIRONMENT VARIABLE
    log environment varibles
    remove environment variable/s which is not exist
    remove existing environment variable


file
    file should not exist
    create file
    file should exist
    file should be empty
    apped content to existing file
    file should not be empty
    log file
    copy file and move it to other location
    copy more files and move them to other dir
    move file / files
    count files in directory
    get file
    get file size
    get modified date
    set modified time
    get few lines which match a pattern
    list files in directory


Direcotry
    verify directory is not existed
    create directory
    verify directory existance
    verify diectory is empty
    create one file and one directory in this dirctory
        verify directory is not empty
    delete all content form directory
    copy directory and move it ot other location
    move directoy
    count directories in a directory
    count all items precent in a directory
    get modified date
    list directory
    list directories in director


Removing file or directory
    remove directory which is empty
    remove directory which is not empty
    remove directory which is not existed
    use remove directory but give a filepath instead dir path

    remove file/files which is empty
    remove file/files which is not empty
    remove file/files which is not existed
    use remove file but give a filepath instead dir path

file or directory
    should exist
    should not exist

extension
    separate filename and extension and log them
    split path till last path separator

Path
    join a path/ paths to the given base path
    split path till last path separator

wait for file/dire create and remove
    wait for created
    wait for removed


*** Settings ***
Library    OperatingSystem    AS  Os

*** Variables ***
${file1}    somefile.txt
${filecontent}       SEPARATOR=\n
...    line one
    ...    line two
    ...    line there
    ...    line four

${dir1}    ${CURDIR}/SomeDir    #it contains somefile.txt

*** Test Cases ***
environment variable
    [Tags]    environvariable
    VAR    ${variable_name}    dummyvariable
    # ${variable_name}    dummyvariable
    VAR    ${variable_value}        dummyvalue
    VAR    ${variable_second_value}=    dummyvalue two

    # verigy environment variable is not there
    Os.Environment Variable Should Not Be Set    name=${variable_name}
    # set environment variable
    Os.Set Environment Variable    name=${variable_name}    value=${variable_value}
    # verify that variable existance
    Os.Environment Variable Should Be Set    name=${variable_name}    msg=not set
    # add value to existing variable
    Os.Append To Environment Variable    ${variable_name}    ${variable_second_value}
    # get environment variable / variables
    ${vrbl}=  Os.Get Environment Variable    name=${variable_name}
    BuiltIn.Log    ${vrbl}
    # get environment variable using ENVIRONMENT VARIABLE
    BuiltIn.Log    %{dummyvariable}
    # log environment varibles
    Os.Log Environment Variables
    # remove environment variable/s which is not exist
    Os.Remove Environment Variable    notexisted
    # remove existing environment variable
    Os.Remove Environment Variable    ${variable_name}
    Os.Environment Variable Should Not Be Set    name=${variable_name}


file
    [Tags]    fileoperations
    [Setup]    os.Remove File    ${file1}
    # robot -i fileoperations .\Tests\004_OperatingSystem.robot
    # file should not exist
    os.File Should Not Exist    path=${CURDIR}/${file1}
    # create file
    Os.Create File    path=${CURDIR}/${file1}
    # file should exist
    os.File Should Exist   path=${CURDIR}/${file1}
    # file should be empty
    Os.File Should Be Empty    path=${CURDIR}/${file1}
    # apped content to existing file
    Os.Append To File    path=${CURDIR}/${file1}    content=${filecontent}
    # file should not be empty
    Os.File Should Not Be Empty    path=${CURDIR}/${file1}
    # log file
    Os.Log File    path=${CURDIR}/${file1}
    # copy file and move it to other location
    Os.Copy File    source=${CURDIR}/${file1}    destination=${CURDIR}/SomeDir/${file1}
    # copy more files and move them to other dir
    # move file / files
    os.Move File    source=${CURDIR}/${file1}    destination=${CURDIR}/SomeDir2/${file1}
    # count files in directory
    ${file_count}=  Os.Count Files In Directory    path=${CURDIR}/SomeDir
    BuiltIn.Should Be Equal    ${1}    ${file_count}
    # get file
    ${content}=  os.Get File    path=${CURDIR}/SomeDir2/${file1}
    # get file size
    ${size}=  Os.Get File Size   ${CURDIR}/SomeDir2/${file1}
    # get modified date
    ${modified_date}=  Os.Get Modified Time   ${CURDIR}/SomeDir2/${file1}
    # set modified time
    ${set_date}=  Os.Set Modified Time   ${CURDIR}/SomeDir2/${file1}    NOW
    # get few lines which match a pattern
    ${matched_lines}=  Os.Grep File    ${CURDIR}/SomeDir2/${file1}    four  regexp=${True}  #getting all lines which contains string four init
    # list files in directory
    os.List Files In Directory    ${CURDIR}
