*** Settings ***
Library   pabot.PabotLib
Library   RequestsLibrary
Library   JSONLibrary
Library   Collections
Library   OperatingSystem

*** Keywords ***
Get CatalystCenter Token
    ${auth}=   Create List   %{CC_USERNAME}   %{CC_PASSWORD}
    ${cc_insecure}=   Get Environment Variable   CC_INSECURE   True
    ${verify}=   Set Variable If   '${cc_insecure}' == 'True' or '${cc_insecure}' == 'true'   False   True
    Create Session   CatalystCenter_Session   %{CC_URL}   auth=${auth}   verify=${verify}   headers={"Accept": "application/json", "Content-Type": "application/json"}
    ${response}=  POST On Session   CatalystCenter_Session   /api/system/v1/auth/token
    ${token}=     Set Variable   ${response.json()["Token"]}
    [Return]   ${token}

Login CatalystCenter
    ${token}=   Get CatalystCenter Token
    ${headers}=   Create Dictionary   x-auth-token=${token}
    Create Session   CatalystCenter_Session   %{CC_URL}   headers=${headers}

Should Be Equal Value Json String
    [Arguments]   ${json}   ${json_path}   ${value}=${EMPTY}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${EMPTY}"   Should Be Equal As Strings   ${r_value}[0]   ${value}

Should Be Equal Value Json List
    [Arguments]   ${json}   ${json_path}   ${value}=${None}
    ${r_value}=   Get Value From Json   ${json}   ${json_path}
    Run Keyword If   "${value}" != "${None}"   Lists Should Be Equal   ${r_value}[0]   ${value}   ignore_order=True
