{{/*
Common metadata.
This template takes an array of values:
- the top context
- optional one or more resource values
- optional template name of the overrides

# Example values.yaml
global:               # Will be added to all resources
  labels: {}
  selectors: {}
  annotations: {}

resource:
  name: myresource    # Optional. Will be prefixed with .Chart.Name
  labels: {}
  selectors: {}
  annotations: {}
  checksums: []       # File names relative to templates folder.
*/}}
{{- define "common.metadata" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- if typeIs "string" (last $args) -}}
{{- template "common.util.merge" (append . "common.metadata.tpl") -}}
{{- else -}}
{{- template "common.metadata.tpl" . -}}
{{- end -}}
{{- end -}}

{{- define "common.metadata.tpl" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $resource := last     $args | default (dict) -}}
{{- $fullName := include "common.fullname" $top -}}
{{- $labels   := include "common.metadata.labels" . -}}
{{- $annotations := include "common.metadata.annotations" . -}}
name: {{ list $fullName $resource.name | compact | join "-" | quote }}
{{- with $labels }}
labels:
  {{- . | nindent 2 }}
{{- end }}
{{- with $annotations }}
annotations:
  {{- . | nindent 2 }}
{{- end }}
{{- end -}}

{{/*
Common labels.
This template takes an array of values:
- the top context
- optional one or more resource values

# Example values.yaml
global:
  labels: {}
  selectors: {}

resource:
  labels: {}
  selectors: {}
*/}}
{{- define "common.metadata.labels" -}}
{{- include "common.metadata.labels.tpl" . | trim -}}
{{- end -}}

{{- define "common.metadata.labels.tpl" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $labels   := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.labels -}}
{{- $labels = $labels | merge . -}}
{{- end -}}
{{- end -}}
{{- with $labels -}}
{{- toYaml . }}
{{- end }}
{{- include "common.metadata.selectors" . | nindent 0 }}
{{- with $top.Chart.AppVersion }}
app.kubernetes.io/version: {{ . | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ $top.Release.Service | quote }}
helm.sh/chart: {{ include "common.chart" $top | quote }}
{{- end -}}

{{/*
Selector labels.
This template takes an array of values:
- the top context
- optional one or more resource valuess

# Example values.yaml
global:
  selectors: {}

resource:
  selector: {}
*/}}
{{- define "common.metadata.selectors" -}}
{{- include "common.metadata.selectors.tpl" . | trim -}}
{{- end -}}

{{- define "common.metadata.selectors.tpl" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $labels   := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.selectors -}}
{{- $labels = $labels | merge . -}}
{{- end -}}
{{- end -}}
{{- with $labels -}}
{{- toYaml . }}
{{- end }}
app.kubernetes.io/name: {{ include "common.name" $top | quote }}
app.kubernetes.io/instance: {{ $top.Release.Name | quote }}
{{- end -}}

{{/*
Common annotations.
This template takes an array of values:
- the top context
- optional one or more resource values

# Example values.yaml
global:
  annotations: {}

resource:
  annotations: {}
  checksums: []     # File names relative to templates folder
*/}}
{{- define "common.metadata.annotations" -}}
{{- include "common.metadata.annotations.tpl" . | trim -}}
{{- end -}}

{{- define "common.metadata.annotations.tpl" -}}
{{- $args     := compact  . -}}
{{- $top      := first    $args -}}
{{- $args     := rest     $args -}}
{{- $global   := $top.Values.global | default (dict) -}}
{{- $annotations := dict -}}
{{- range $values := prepend $args $global -}}
{{- with $values.annotations -}}
{{- $annotations = $annotations | merge . -}}
{{- end -}}
{{- range $file := $values.checksums -}}
{{- $path := printf "%s/%s" $top.Template.BasePath $file -}}
{{- $checksum := include $path $top | sha256sum -}}
{{- $annotations = set $annotations (printf "checksum/%s" $file) $checksum -}}
{{- end -}}
{{- end -}}
{{- with $annotations -}}
{{- toYaml . }}
{{- end }}
{{- end -}}
