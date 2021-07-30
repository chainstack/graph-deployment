{{- define "graph-grafana-dashboards.postgres" -}}
apiVersion: 1
datasources:
 - access: proxy
   editable: true
   name: postgres
   orgId: 1
   type: postgres
   url: {{ .Values.postgresDatasource.url }}
   user: {{ .Values.postgresDatasource.user }}
   database: {{ .Values.postgresDatasource.db }}
   secureJsonData:
     password: {{ .Values.postgresDatasource.password }}
   jsonData:
     sslmode: disable
     postgresVersion: 1200
{{- end }}
