{{/*
Expand the name of the chart.
*/}}
{{- define "ci-runner-worker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "ci-runner-worker.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ci-runner-worker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ci-runner-worker.labels" -}}
helm.sh/chart: {{ include "ci-runner-worker.chart" . }}
{{ include "ci-runner-worker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
environment: {{ .Values.env }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ci-runner-worker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ci-runner-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Values.appName }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ci-runner-worker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ci-runner-worker.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for deployment
*/}}
{{- define "ci-runner-worker.deployment.apiVersion" -}}
{{- if .Values.useStatefulSet }}
apps/v1
{{- else }}
apps/v1
{{- end }}
{{- end }}

{{/*
Return the kind for deployment
*/}}
{{- define "ci-runner-worker.deployment.kind" -}}
{{- if .Values.useStatefulSet }}
StatefulSet
{{- else }}
Deployment
{{- end }}
{{- end }}

{{/*
ConfigMap checksum annotation
*/}}
{{- define "ci-runner-worker.configmapChecksum" -}}
{{- if .Values.autoReloadConfig }}
checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
{{- end }}
{{- end }}