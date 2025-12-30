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
{% if area.name != "Global" %}
Verify Area {{ area.parent_name | default(defaults.catalyst_center.sites.areas.parent_name) }}/{{ area.name }}
    # Dynamically construct the nameHierarchy without a leading slash if area.parent_name is empty
    ${nameHierarchy}=   Evaluate   '{{ area.parent_name | default(defaults.catalyst_center.sites.areas.parent_name) }}/{{ area.name }}' if '{{ area.parent_name | default(defaults.catalyst_center.sites.areas.parent_name) }}' else '{{ area.name }}'

    # Check if area exists in API response
    ${area}=   Set Variable   $.response[?(@.groupNameHierarchy=='${nameHierarchy}')]
    Should Be Equal Value Json String   ${r.json()}   ${area}.name  {{ area.name }}
    ${parent_id}=   Get Value From Json   ${r.json()}   ${area}.parentId
    ${params}=   Create Dictionary   siteId=${parent_id}[0]
    ${r}=   GET On Session   CatalystCenter_Session   /dna/intent/api/v1/site   params=${params}
    Should Be Equal Value Json String   ${r.json()}   $..response.siteNameHierarchy   {{ area.parent_name }}
{% endif %}
{% endfor %}