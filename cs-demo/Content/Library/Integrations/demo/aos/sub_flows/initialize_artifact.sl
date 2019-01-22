namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: 10.0.46.31
    - username: root
    - password: admin@123
    - artifact_url:
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/install_java.sh'
    - parameters:
        required: false
  workflow:
    - string_equals:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${artifact_url}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${artifact_url}'
        publish:
          - artifact_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${script_url}'
        publish:
          - script_name: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_file
          - FAILURE: delete_file
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file:
            - filename: '${script_name}'
        navigate:
          - SUCCESS: has_failed
          - FAILURE: on_failure
    - has_failed:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code=='0')}"
        publish: []
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      string_equals:
        x: 466
        y: 58
      execute_script:
        x: 352
        y: 373
      copy_artifact:
        x: 209
        y: 212
      copy_script:
        x: 633
        y: 204
      delete_file:
        x: 615
        y: 453
      has_failed:
        x: 833
        y: 432
        navigate:
          87f69c08-4b4a-8caf-d2df-dfcb19de2bca:
            targetId: ce2b828a-4960-85a7-6c85-bb965ad91770
            port: 'TRUE'
          b027b434-f6c8-3492-6c57-c5fca4017a71:
            targetId: fe506d36-6674-48a2-ad47-5bd7de47aef7
            port: 'FALSE'
    results:
      SUCCESS:
        ce2b828a-4960-85a7-6c85-bb965ad91770:
          x: 928
          y: 394
      FAILURE:
        fe506d36-6674-48a2-ad47-5bd7de47aef7:
          x: 934
          y: 526
