*** Comments ***

*** Settings ***
Library    DateTime


*** Test Cases ***
001 possible to use custom timestamps in both input and output
    [Tags]    tc001
    #CUSTOM INPUT FORMAT IS GIVEN
    ${date} =	Convert Date	28.05.2014 12:05	date_format=%d.%m.%Y %H:%M
    Should Be Equal	${date}	2014-05-28 12:05:00.000
    #CUSTOM OUTPUT FORMAT IS GIVEN
    ${date} =	Convert Date	${date}	result_format=%d.%m.%Y
    Should Be Equal	${date}	28.05.2014


002 Python's standard [datetime] objects can be used both in input and output
    [Tags]  tc002
    ${datetime} =	Convert Date	2014-06-11 10:07:42.123	datetime
    #extended variable syntax used and got datetime object attributes
    Should Be Equal As Integers	${datetime.year}	2014
    Should Be Equal As Integers	${datetime.month}	6
    Should Be Equal As Integers	${datetime.day}	11
    Should Be Equal As Integers	${datetime.hour}	10
    Should Be Equal As Integers	${datetime.minute}	7
    Should Be Equal As Integers	${datetime.second}	42
    Should Be Equal As Integers	${datetime.microsecond}	123000

003 datetime objects can be converted to date objects
    [Tags]  tc003
    ${datetime} =	Convert Date	2023-12-18 11:10:42	datetime
    Log To Console  ${datetime.date()}  # The time part is ignored.

004 Time given as a number is interpreted to be seconds.
    [Tags]  tc004
    ${time} =	Convert Time	3.14
    Should Be Equal	${time}	${3.14}
    #To return a time as a number, result_format argument must have value number,
    ${time} =	Convert Time	${time}	result_format=number
    Should Be Equal	${time}	${3.14}
#string that can be converted to a number.
    ${time} =	Convert Time	1 minute 42 seconds
    Should Be Equal	${time}	${102}

005 verbose format uses long specifiers week, day, hour, minute, second and millisecond
    [Tags]  tc005
    ${time} =	Convert Time	4200	verbose
    Should Be Equal	${time}	1 hour 10 minutes

006 The compact format uses shorter specifiers w, d, h, min, s and ms,
    [Tags]  tc006
    ${time} =	Convert Time	- 1.5 hours	compact
    Should Be Equal	${time}	- 1h 30min

007 Python's standard timedelta objects are also supported both in input and in output.
    [Tags]  tc007
    ${timedelta} =	Convert Time	01:10:02.123	timedelta
    Should Be Equal	${timedelta.total_seconds()}	${4202.123}

008 seconds in returned dates and times are rounded to the nearest full second
    [Tags]    tc008
    ${date} =	Convert Date	2014-06-11 10:07:42.500	exclude_millis=yes
    Should Be Equal	${date}	2014-06-11 10:07:43
#datetime object
    ${dt} =	Convert Date	2014-06-11 10:07:42.500	result_format=datetime	exclude_millis=yes
    Should Be Equal	${dt.second}	${43}
    Should Be Equal	${dt.microsecond}	${0}

009 add days or time from date
    [Tags]    tc009
    ${date} =	Add Time To Date	2014-05-28 12:05:03.111	7 days   #adding days to date
    Should Be Equal	${date}	2014-06-04 12:05:03.111
    ${date} =	Add Time To Date	2014-05-28 12:05:03.111	 01:02:03  exclude_millis=True   #adding time to date
    Should Be Equal	${date}	2014-05-28 13:07:06

0012 Subtracts date from another date and returns time between.
    [Tags]    tc012
    ${time} =	Subtract Date From Date	2014-05-28 12:05:52	2014-05-28 12:05:10
    Should Be Equal	${time}	${42}
    ${time} =	Subtract Date From Date	2014-05-28 12:05:52	2014-05-27 12:05:10	verbose
    Should Be Equal	${time}	1 day 42 seconds


0010 add time to another time
    [Tags]    tc010
    ${time} =	Add Time To Time	1 minute	42
    Should Be Equal	${time}	${102}
    ${time} =	Add Time To Time	3 hours 5 minutes	01:02:03	timer	exclude_millis=yes
    Should Be Equal	${time}	04:07:03

    #Subtracts time from date and returns the resulting date.

    ${date} =	Subtract Time From Date	2014-06-04 12:05:03.111	7 days
    Should Be Equal	${date}	2014-05-28 12:05:03.111
    ${date} =	Subtract Time From Date	2014-05-28 13:07:06.115	01:02:03  exclude_millis=True
    Should Be Equal	${date}	2014-05-28 12:05:03



0011 get current date and print every attribute of datetime separately
    [Tags]    tc011
    ${dt1}    Get Current Date    result_format=datetime
    Log To Console   ${dt1.year}
    Log To Console   ${dt1.month}
    Log To Console   ${dt1.day}
    Log To Console   ${dt1.hour}
    Log To Console   ${dt1.minute}
    Log To Console   ${dt1.second}
    Log To Console   ${dt1.microsecond}

0013 Subtracts time from another time and returns the resulting time.
    ${time} =	Subtract Time From Time	00:02:30	100
    Should Be Equal	${time}	${50}
    ${time} =	Subtract Time From Time	${time}	1 minute	compact
    Should Be Equal	${time}	- 10s