namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: "${get_sp('host')}"
    - account_service_host: "${get_sp('host')}"
    - db_host: "${get_sp('host')}"
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - artifact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: "${get_sp('script_deploy_war')}"
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - artifact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 197
        y: 136
      deploy_tm_wars:
        x: 345
        y: 139
        navigate:
          0d4351a9-6c62-5059-a881-f6fe763218bb:
            targetId: 2d13dbcb-26f4-ddf8-244f-f7a58795618f
            port: SUCCESS
    results:
      SUCCESS:
        2d13dbcb-26f4-ddf8-244f-f7a58795618f:
          x: 564
          y: 146
