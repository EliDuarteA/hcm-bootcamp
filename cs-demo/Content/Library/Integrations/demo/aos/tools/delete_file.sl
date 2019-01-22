namespace: Integrations.demo.aos.tools
flow:
  name: delete_file
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - filename: catalog.war
  workflow:
    - delete_file:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && rm -f '+filename}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_file:
        x: 316
        y: 75
        navigate:
          4b9ed817-abce-83b7-49f3-9218ab66ec75:
            targetId: 7b13f69c-0e4d-ae4c-f582-045e09dbbc4d
            port: SUCCESS
    results:
      SUCCESS:
        7b13f69c-0e4d-ae4c-f582-045e09dbbc4d:
          x: 587
          y: 81
