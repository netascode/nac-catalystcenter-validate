*** Settings ***
Documentation   Verify Site Hierarchy Areas
Suite Setup     Login CatalystCenter
Resource        ../../catalyst_center_common.resource
Default Tags    config   catalyst_center   site_hierarchy   sites   areas

*** Test Cases ***

Get Site Hierarchy Areas
    ${r}=   GET On Session   CatalystCenter_Session   /dna/intent/api/v2/site
    Log   Response Status Code: ${r.status_code}
    Set Suite Variable   ${r}

{% for area in catalyst_center.sites.areas | default([]) %}
Verify Area {{ area.parent_name }}/{{ area.name }}
    ${area}=   Set Variable   $.response[?(@.groupNameHierarchy=='{{ area.parent_name }}/{{ area.name }}')]
    Should Be Equal Value Json String   ${r.json()}   ${area}.name  {{ area.name }}
    ${parent_id}=   Get Value From Json   ${r.json()}   $.response[?(@.groupNameHierarchy=='{{ area.parent_name }}/{{ area.name }}')]['parentId']
    ${params}=   Create Dictionary   siteId=${parent_id}[0]
    ${r}=   GET On Session   CatalystCenter_Session   /dna/intent/api/v1/site   params=${params}
    Should Be Equal Value Json String   ${r.json()}   $..response.siteNameHierarchy   {{ area.parent_name }}
{% endfor %}