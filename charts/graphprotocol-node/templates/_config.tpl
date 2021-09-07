# Config.toml based on https://github.com/graphprotocol/graph-node/blob/5613dca92213810b3cca57979f5facc2d670e34a/docs/config.md#configuring-multiple-databases
{{- define "graphprotocol-node.config" -}}
{{- $pgHost := required "postgres.host wasn't specified" .Values.postgres.host }}
{{- $pgDB := required "postgres.db wasn't specified" .Values.postgres.db }}
{{- $pgUser := required "postgres.user wasn't specified" .Values.postgres.user }}
[store]
[store.primary]
  connection = "postgresql://{{ $pgUser }}:$PG_PASS@{{ $pgHost }}/{{ $pgDB }}"
  weight = 1
  pool_size = 10

{{- if .Values.postgres.replicaHost }}
[store.primary.replicas.replica]
  connection = "postgresql://{{ $pgUser }}:$PG_PASS@{{ .Values.postgres.replicaHost }}/{{ $pgDB }}"
  weight = 1
{{- end }}

[chains]
  ingestor = "{{ .Values.blockIngestorNodeId }}"
  {{- range $name, $conf := .Values.config.chains }}
  [chains.{{ $name }}]
    shard = "primary"
    {{- range $conf.providers }}
    [[chains.{{ $name }}.provider]]
      label = {{ .label | quote }}
      url = {{ .url | quote }}
      features = {{ toJson .features }}
      transport = {{ default "rpc" .transport | quote }}
      {{- with .headers }}
      [headers]
        {{- range $k, $v := . }}
        {{ $k }} = {{ $v | quote }}
        {{- end }}
      {{- end}}
    {{- end }}
  {{- end }}

[deployment]
[[deployment.rule]]
  shard = "primary"
  indexers = [ "{{ .Values.blockIngestorNodeId }}" ]
{{- end }}
