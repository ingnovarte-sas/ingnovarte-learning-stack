---
name: ldd-guias
description: Genera las Guías de Actividades completas del curso a partir de las actividades aprobadas en la Lluvia de Ideas y el Esquema.
triggers:
  - guía de actividades
  - guías del curso
  - guía de la dinámica
  - guía de práctica
  - instrucciones de actividad
  - guía del facilitador para actividades
  - desarrollar la actividad
  - cómo ejecutar la actividad
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El Esquema está aprobado y las actividades de la Lluvia de Ideas están seleccionadas (Validación Interna ✓)
- Estás en la fase de Creación desarrollando los entregables del curso
- Necesitas el documento completo que el facilitador y/o el participante usan durante la actividad

No uses esta skill para:
- Proponer nuevas actividades (usa `ldd-lluvia`)
- Generar evaluaciones (usa `ldd-evaluaciones`)

> **Demarcación:** Si el usuario pregunta CÓMO ejecutar una actividad ya elegida → aquí. Para proponer nuevas actividades → usa ldd-lluvia.

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/lluvia` y `ldd/{código}/esquema`
2. **Identificar las actividades aprobadas** en la Lluvia de Ideas (Validación Interna ✓)
3. **Por cada actividad**, desarrollar la guía completa siguiendo la estructura de Outputs
4. **Verificar alineación**: cada guía debe referenciar el objetivo específico de la Ficha Técnica al que contribuye
5. **Definir configuración LMS** si la actividad requiere montaje en plataforma (Gforms, app, etc.)
6. **Guardar en Engram**: `topic_key: ldd/{código}/guias`

## Outputs

```markdown
# Guías de Actividades — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:**

---

## Guía [#] — [Nombre de la actividad]

**Tópico:** [tópico al que pertenece]
**Tipo:** Práctica / Demostración / Análisis de caso / Simulación / Juego de roles
**Duración:** [X minutos]
**Modalidad:** Presencial / Virtual / Mixta

**Objetivo de la actividad:**
Al finalizar esta actividad, el participante podrá [verbo de desempeño + condición + criterio].

**Alineación con objetivos del curso:**
Contribuye al objetivo específico: "[citar el objetivo específico de la Ficha Técnica]"

---

### Materiales y recursos

| Material | Cantidad | Responsable de conseguir |
|---|---|---|
| [material 1] | [cantidad] | Ingnovarte / Cliente |
| [material 2] | | |

---

### Preparación previa

*El facilitador debe:*
- [acción de preparación 1]
- [acción de preparación 2]

*El espacio debe:*
- [configuración del ambiente de aprendizaje]

---

### Instrucciones de desarrollo

**Paso 1 — [nombre del paso] ([X] min)**
[descripción detallada de lo que ocurre en este paso]

**Paso 2 — [nombre del paso] ([X] min)**
[descripción]

**Paso 3 — [nombre del paso] ([X] min)**
[descripción]

---

### Instrucciones para el participante

> *Estas instrucciones se entregan al participante al inicio de la actividad.*

[texto en segunda persona, claro y directo]

---

### Criterios de evaluación de la actividad

| Criterio | Indicador | ¿Cómo se verifica? |
|---|---|---|
| [criterio 1] | [indicador observable] | [observación / producto / respuesta] |
| [criterio 2] | | |

---

### Configuración LMS (si aplica)

**Plataforma:** [Gforms / Moodle / App / N/A]
**Tipo de configuración:** [formulario / quiz / foro / tarea]
[instrucciones de montaje]

---

### Notas al facilitador

[observaciones, preguntas sugeridas para el cierre de la actividad, variantes si no hay materiales disponibles]
```

## Limits

- Las guías son para actividades que ya fueron aprobadas en la Lluvia de Ideas — no proponer actividades nuevas
- Los materiales deben coincidir con los listados en la Lluvia de Ideas
- Si una actividad requiere materiales que el cliente no confirmó tener, marcarlo como `[PENDIENTE CONFIRMACIÓN]`
- No incluir contenido técnico del curso en la guía — el contenido va en el BOK y la presentación

## Plan Update

Al finalizar la generación de las Guías de Actividades, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 25 — Refinamiento del borrador de la guía, diseño y pruebas piloto simuladas o reales
   - ITEM 26 — Solicitud, aseguramiento de los materiales, montaje de la actividad
   - ITEM 27 — Pruebas de usuario (PU) para identificar Usabilidad, Accesibilidad, Tiempos y coherencia
   - ITEM 28 — Desarrollo de Guía completa basado en el informe de PU
   - ITEM 29 — Implementación de la guía al LMS
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 25–29 marcadas ✅ en el plan. SPI Global: {valor}"
