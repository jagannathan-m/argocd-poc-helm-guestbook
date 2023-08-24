{{/* Generate Base Name */}}
{{- define "getBaseName" -}}
    {{- if .Values.branchIdentifier -}}
        {{- printf "%s-%s-%s" .Values.global.k8sEnv .Values.appName .Values.branchIdentifier -}}
    {{- else -}}
        {{- printf "%s-%s" .Values.global.k8sEnv .Values.appName -}}
    {{- end -}}
{{- end -}}

{{/* Generate Basic Labels */}}
{{- define "getBasicLabels" }}
athena.io/logicalenv: {{ index .Values.k8sEnvConfig .Values.global.k8sEnv "logicalEnv" }}
athena.io/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "." }}
athena.io/release: {{ .Release.Name }}
athena.io/service: {{ .Release.Service }}
athena.io/namespace: {{ .Release.Namespace }}
{{- end }}