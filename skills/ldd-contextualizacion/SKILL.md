---
name: ldd-contextualizacion
description: Prepara y procesa la fase de Contextualización del curso — entrevistas SME, visitas de inmersión y análisis documental — para generar el artefacto de contexto que alimenta la Ficha Técnica.
triggers:
  - contextualización
  - entrevistas SME
  - visitas de inmersión
  - análisis documental
  - Case*Method
  - Mayéutica
  - levantamiento de información
  - procesar notas del experto
  - extraer información del manual
  - preparar sesión con el experto
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- Necesitas preparar una sesión de entrevista con el SME (Modo A)
- Tienes notas crudas de una entrevista o visita de inmersión y necesitas estructurarlas (Modo B)
- Tienes documentación técnica (manuales, procedimientos, normas) y necesitas extraer la información relevante para el curso (Modo C)

Esta skill NO reemplaza la Ficha Técnica. El artefacto `ldd/{code}/context` que genera es el insumo para `ldd-ficha`.

No uses esta skill para:
- Generar la Ficha Técnica (usa `ldd-ficha`)
- Proponer actividades pedagógicas (usa `ldd-lluvia`)

## Prerequisites

Antes de ejecutar cualquier modo:
1. Buscar en Engram: `ldd/{code}/kickoff`
2. Si no existe → DETENER y responder: "Necesito el brief del kickoff del curso antes de contextualizar. ¿Deseas generarlo primero con `ldd-kickoff`?"

## Steps

### Modo A — Preparar sesión de contextualización

Usar cuando el SME aún no ha sido entrevistado y necesitas una guía estructurada.

1. Revisar el kickoff (`ldd/{code}/kickoff`) para identificar tópicos y objetivos preliminares
2. Generar **Guía de Entrevista SME** con dos secciones:

**Sección 1 — Preguntas Case\*Method (Tasks & Deliverables)**

Protocolo: mapear las tareas reales del rol del participante.

| Tarea / Actividad | Subtareas | Entregable esperado | Pregunta socrática asociada |
|---|---|---|---|
| [tarea del rol] | [subtareas] | [qué produce el trabajador] | [pregunta de investigación] |

Preguntas guía para el SME:
- ¿Cuáles son las 3-5 tareas más críticas que realiza alguien en este rol?
- Para cada tarea: ¿qué pasos sigue? ¿qué entrega al final?
- ¿Dónde ocurren los errores más frecuentes?
- ¿Qué diferencia a alguien experto de uno novato en esta tarea?

**Sección 2 — Preguntas Mayéutica (socrática)**

Banco de preguntas para extraer conocimiento tácito:
- ¿Qué pasa si [condición X] ocurre durante [tarea]?
- ¿Cómo sabes que [el resultado] está bien hecho?
- ¿Cuándo es válido saltarse [paso Y]?
- Dame un contraejemplo: ¿cuándo NO aplicarías [procedimiento Z]?
- Descompón [concepto complejo] en sus partes más simples.
- ¿Qué es lo que más le cuesta aprender a alguien nuevo en esto?

3. Guardar la guía de entrevista localmente — no genera artefacto en Engram (aún no hay datos)

---

### Modo B — Procesar notas de entrevista o visita de inmersión

Usar cuando tienes notas crudas del trabajo de campo.

1. Recibir: notas de entrevista, grabación transcrita, o registro de visita
2. Clasificar hallazgos por dimensión (Case\*Method):
   - Tareas y subtareas identificadas
   - Entregables del rol
   - Errores frecuentes
   - Conocimientos esenciales
   - Supuestos (afirmaciones sin evidencia documental)
3. Identificar gaps de información (lo que aún no se sabe)
4. Construir el artefacto `ldd/{code}/context` y guardarlo en Engram

---

### Modo C — Procesar documentación técnica

Usar cuando tienes manuales, procedimientos, normas o documentos técnicos.

1. Recibir: documento(s) técnico(s)
2. Extraer: definiciones clave, procedimientos, requisitos de seguridad, normas aplicables
3. Clasificar por tópico preliminar (basado en kickoff)
4. Identificar gaps (información importante que los documentos no cubren)
5. Construir el artefacto `ldd/{code}/context` y guardarlo en Engram

---

## Outputs

### Artefacto `ldd/{code}/context` (Engram — Modos B y C)

Campos obligatorios del artefacto:
- `documentos_revisados`: lista de fuentes consultadas (≥1)
- `hallazgos_por_topico`: mapa de tópico → hallazgos (al menos un tópico)
- `supuestos_identificados`: lista de supuestos pendientes de validar
- `gaps_de_informacion`: lista de información faltante (puede ser vacía)

```markdown
## Curso
Código: {code} | Cliente: {cliente} | Fecha de contextualización: {fecha}

## documentos_revisados

| Fuente | Tipo | Fecha | Responsable |
|---|---|---|---|
| [nombre del SME / documento] | entrevista SME / visita / documento | | |

## hallazgos_por_topico (Case*Method)

| Tópico | Tarea / Actividad clave | Subtarea | Entregable | Riesgo o gap detectado |
|---|---|---|---|---|
| [tópico del kickoff] | [tarea real del rol] | | | |

## Conocimientos esenciales identificados
- (lista bruta, sin priorizar — ldd-ficha priorizará)

## supuestos_identificados
> **Supuesto:** [afirmación sin evidencia] — Responsable de validar: [nombre/rol]

## Citas textuales relevantes (SME o manuales)
> "[cita exacta]" — Fuente: [nombre]

## gaps_de_informacion
- [información que aún falta antes de avanzar a ldd-ficha]
```

Guardar en Engram: `topic_key: ldd/{code}/context`, `project: ingnovarte-learning-stack`

### Guía de entrevista (Modo A — no persiste en Engram)

Documento de trabajo para el equipo antes de la visita al cliente.

---

## Limits

- Esta skill NO genera la Ficha Técnica — solo genera `ldd/{code}/context`
- NO valida si la información técnica es correcta — solo la estructura y clasifica
- NO inventa datos técnicos — si el insumo no lo dice, va a "Pendientes de contextualización"
- Un solo skill, tres modos: si el usuario provee notas → Modo B; si provee documentos → Modo C; si no tiene nada aún → Modo A

## Plan Update

Al finalizar la generación del artefacto de contextualización, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 9 — Informes de las entrevistas y las visitas de inmersión
   - ITEM 10 — Ubicación y organización estructurada de la información en la carpeta asignada
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 9 y 10 marcadas ✅ en el plan. SPI Global: {valor}"
