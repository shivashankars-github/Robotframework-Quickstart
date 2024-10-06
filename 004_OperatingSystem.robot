*** Settings ***
Documentation    this robot uses all keywords from OperatingSystem library and do some acitvites on given files|directories
Name    File|Directories acitivites
Suite Setup    BuiltIn.No Operation
Suite Teardown    BuiltIn.No Operation
Metadata    Version    00.1
...          level    Basic

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
    [Documentation]    system environment variable operations using oprating system library
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
    [Documentation]    file opeations using operating system library
    [Tags]    fileoperations
    [Setup]    os.Remove File    ${file1}
    # robot -i fileoperations .\Tests\004_OperatingSystem.robot
    # file should not exist
    os.File Should Not Exist    path=${CURDIR}/${file1}
    # create file
    Os.Create File    path=${CURDIR}/${file1}
    # file should exist
    os.File Should Exist   path=${CURDIR}/${file1}
    #veiry the same with should exist
    os.Should Exist    ${CURDIR}/${file1}
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

Direcotry
    [Documentation]    directory opeations using operating system library
    [Tags]    dirs
    [Setup]    os.Remove Directory    ${CURDIR}/SomeDir    recursive=${True}
    # verify directory is not existed
    os.Directory Should Not Exist    path=somedummy
    # create directory
    os.Create Directory    path=${CURDIR}/SomeDir/insideDir
    os.Should Exist    ${CURDIR}/SomeDir/insideDir
    # verify directory existance
    os.Directory Should Exist  ${CURDIR}/SomeDir/insideDir
    # verify diectory is empty
    os.Directory Should Be Empty    ${CURDIR}/SomeDir/insideDir
    # create one file and one directory in this dirctory
    os.Create Directory    ${CURDIR}/SomeDir/insideDir/nestedDir
    os.Directory Should Exist    ${CURDIR}/SomeDir/insideDir/nestedDir
    os.Create File    ${CURDIR}/SomeDir/insideDir/nestedDir/insidenestedDir.txt
    os.File Should Exist  ${CURDIR}/SomeDir/insideDir/nestedDir/insidenestedDir.txt
    #verify directory is not empty
    os.Directory Should Not Be Empty    ${CURDIR}/SomeDir
    # delete all content form directory
    # os.Empty Directory    ${CURDIR}/SomeDir
    # copy directory and move it ot other location
    os.Copy Directory    ${CURDIR}/SomeDir/insideDir/nestedDir  ${CURDIR}/someDir
    # move directoy
    Os.Move Directory    ${CURDIR}/SomeDir/nestedDir    ${CURDIR}/SomeDir/insideDir/
    # count directories in a directory
    os.Count Directories In Directory     ${CURDIR}/SomeDir
    # count all items precent in a directory
    os.Count Items In Directory    ${CURDIR}/SomeDir
    # get modified date
    os.Get Modified Time    ${CURDIR}/SomeDir
    # list directory
    os.List Directory    ${CURDIR}/SomeDir
    # list directories in director
    os.List Directories In Directory  ${CURDIR}/SomeDir

Removing file or directory
    [Documentation]    file | directory removing operations
    [Tags]    rmkfldir
    # [Setup]    os.Create Directory    ${CURDIR}/emptrydir
    # remove directory which is empty
    os.Remove Directory    ${CURDIR}/nestedDir
    os.Directory Should Not Exist    ${CURDIR}/nestedDir
    # remove directory which is not empty
    BuiltIn.Run Keyword And Expect Error   *      os.Remove Directory    path=${CURDIR}/SomeDir2
    os.Remove Directory    path=${CURDIR}/SomeDir2     recursive=${True}   #no error
    # remove directory which is not existed
    #If the directory pointed to by the path does not exist, the keyword passes
    os.Remove Directory    ${CURDIR}/notexited
    # use remove directory but give a filepath instead dir path
    #  but it fails, if the path points to a file.
    # os.Remove Directory    ${CURDIR}/insidenestedDir.txt
    BuiltIn.Run Keyword And Expect Error   *   os.Remove Directory    ${CURDIR}/SomeDir/insideDir/nestedDir/nestedDir/insidenestedDir.txt
    # remove file/files which is empty
    os.Remove File     ${CURDIR}/nestedDir/insidenestedDir.txt
    # remove file/files which is not empty
    os.Remove File    ${CURDIR}/SomeDir2/somefile.txt
    # remove file/files which is not existed
    os.Remove File    ${CURDIR}/SomeDir2/not exited.tx
    # use remove file but give a filepath instead dir path
    os.Remove File    ${CURDIR}/nestedDir

extension
    [Documentation]    getting file extension | file name | path
    # separate filename and extension and log them
    ${path}  ${ext}  os.Split Extension     ${CURDIR}/SomeDir/insideDir/nestedDir/insidenestedDir.txt
    BuiltIn.Log Many    ${path}  ${ext}
    # split path till last path separator
    ${p1}  os.Split Path    ${CURDIR}/SomeDir/insideDir
    ${p2}  os.Split Path    ${CURDIR}/SomeDir/insideDir/nestedDir/insidenestedDir.txt
    BuiltIn.Log Many    ${p1}  ${p2}

Path
    # join a path/ paths to the given base path
    ${path}  os.Join Path    ${CURDIR}/ p1/ p2/ file.txt
    BuiltIn.Log    ${path}

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
