# Skill Registry

Project: ingnovarte-learning-stack  
Generated: 2026-04-23  
Scope: runtime routing markdown-first para skills del proyecto

## Resolution Rules

1. Fuente principal del MVP: `skills/*.md` en este repositorio.
2. Ignorar skills internas de orquestación `sdd-*` para auto-resolución runtime.
3. Resolver por contexto de tarea + frases gatillo de `## When to Use`.
4. Si hay ambigüedad, el agente coordinador decide qué skill invocar.

## Skill Sources Scanned

- Project-level:
  - `skills/*.md` (12 skills encontradas)
- Convention files:
  - `AGENTS.md` (encontrado en raíz)

## Project Skills (12)

| Skill | Archivo | Contexto de ruteo (resumen) |
|---|---|---|
| course-12h-designer | `skills/course-12h-designer.md` | Estructurar curso técnico de 12h por módulos |
| pts-to-microlearning | `skills/pts-to-microlearning.md` | Convertir PTS/procedimientos a cápsulas breves |
| ppt-storytelling-builder | `skills/ppt-storytelling-builder.md` | Storyboard técnico para PowerPoint |
| instructor-guide-builder | `skills/instructor-guide-builder.md` | Guía de facilitación para instructores |
| activity-guide-builder | `skills/activity-guide-builder.md` | Actividades prácticas con evidencia en campo |
| pre-post-test-builder | `skills/pre-post-test-builder.md` | Diseño de medición pre/post |
| moodle-question-bank-builder | `skills/moodle-question-bank-builder.md` | Banco de preguntas para Moodle |
| rubric-builder | `skills/rubric-builder.md` | Rúbricas de desempeño práctico |
| scorm-flow-designer | `skills/scorm-flow-designer.md` | Flujo documental compatible SCORM 1.2 |
| field-verification-designer | `skills/field-verification-designer.md` | Verificación de transferencia al puesto |
| executive-report-builder | `skills/executive-report-builder.md` | Reporte ejecutivo corto y accionable |
| learning-analytics-interpreter | `skills/learning-analytics-interpreter.md` | Interpretación de datos y brechas |

## Routing Model (MVP markdown-first)

1. Identificar intención en la solicitud (objetivo + entregable).
2. Comparar con `## When to Use` de cada archivo en `skills/*.md`.
3. Seleccionar 1 skill principal (o secuencia mínima) sin crear workflows nuevos.
4. Ejecutar siguiendo `## Inputs`, `## Outputs` y `## Process` de la skill seleccionada.

## Notes

- Registry markdown-first y agnóstico del proveedor.
- Sin dependencia de APIs específicas para discovery/routing.
- Este registry se usa para discovery interno del stack, no como menú operativo para el usuario final.
- El usuario conversa con el `learning-orchestrator` en lenguaje natural; la selección de skills ocurre internamente.
- Routing recomendado por entregable típico (ej.: storyboard PPT → `ppt-storytelling-builder`, ficha de práctica → `activity-guide-builder`, medición comparativa → `pre-post-test-builder`, verificación en puesto → `field-verification-designer`).
