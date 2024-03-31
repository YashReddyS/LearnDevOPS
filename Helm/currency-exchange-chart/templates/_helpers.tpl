{{/*
Create a default fully qualified app name.
*/}}
{{- define "currency-exchange-chart.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

{{/*
Create a default app name.
*/}}
{{- define "currency-exchange-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}
