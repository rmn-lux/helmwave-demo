version: 0.41.1

.options: &options
  namespace: {{ requiredEnv "CI_ENVIRONMENT_NAME"}}
  wait: true
  timeout: 5m
  max_history: 3 # best practice
  create_namespace: true

releases:
{{- with readFile "releases.yaml" | fromYaml | get "releases" }}
{{ range $v := . }}
- name: {{ $v | get "name" }}
  chart:
    name: charts/{{ $v | get "name" }}
  tags: [{{ $v | get "name" }}]
  values:
    - envs-values/{{ requiredEnv "CI_ENVIRONMENT_NAME"}}/{{ $v | get "name" }}.yaml
  <<: *options
{{ end }}
{{- end }}
