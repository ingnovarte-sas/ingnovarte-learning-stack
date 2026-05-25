---
name: ldd-lluvia
description: Genera la Lluvia de Ideas de dinámicas y actividades pedagógicas alineadas al BBOK, con el formato estándar de Ingnovarte (¿Qué? ¿Cómo? ¿Con qué? ¿Dónde? ¿Cuánto tiempo?).
triggers:
  - lluvia de ideas
  - actividades del curso
  - dinámicas
  - propuestas de actividades
  - enfoque pedagógico
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El BBOK (borrador del BOK) está generado
- Necesitas proponer actividades pedagógicas para cada tópico del curso
- Estás diseñando el Esquema y necesitas las actividades antes de construir el minuto a minuto

No uses esta skill para:
- Generar el Esquema (usa `ldd-esquema` — el esquema usa la Lluvia de Ideas como insumo)
- Generar guías completas de actividades (usa `ldd-guias` — eso viene en Creación)

> **Demarcación:** Si el usuario pregunta QUÉ actividades hacer → lluvia. Si pregunta CÓMO ejecutar una actividad ya elegida → guias.

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/bbok`. Si no existe, detenerse con el mensaje: "Necesito el BBOK del curso antes de generar la Lluvia de Ideas. ¿Deseas generarlo primero?"
2. **Revisar la Ficha Técnica**: objetivos, tópicos, duración, grupo objetivo, enfoque metodológico
3. **Por cada tópico**, generar al menos 2 propuestas de actividades:
   - Una actividad teórica (exposición, análisis de caso, demostración)
   - Una actividad práctica (ejercicio, simulación, práctica directa)
4. **Para cada propuesta**, completar todas las columnas del formato estándar
5. **Considerar restricciones operacionales**: conectividad, nivel digital, tiempo disponible
6. **Guardar en Engram**: `topic_key: ldd/{código}/lluvia`

## Outputs

```markdown
# Lluvia de Ideas — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:** | **Estado:** Borrador

> Las actividades marcadas con ✓ en Validación Interna están aprobadas para incluir en el Esquema.
> Las actividades marcadas con [SUPUESTO] requieren confirmación de materiales con el cliente.

---

## [Tópico 1]

| ¿Qué? | ¿Cómo? | ¿Con qué? | ¿Dónde? | ¿Cuánto tiempo? | Val. Interna | Val. Final |
|---|---|---|---|---|---|---|
| [Nombre actividad] | [descripción del desarrollo de la actividad] | [materiales y recursos necesarios] | [salón / taller / campo / virtual] | [X min] | | |
| [Nombre actividad 2] | [descripción] | [materiales] | [espacio] | [X min] | | |

---

## [Tópico 2]

| ¿Qué? | ¿Cómo? | ¿Con qué? | ¿Dónde? | ¿Cuánto tiempo? | Val. Interna | Val. Final |
|---|---|---|---|---|---|---|
| | | | | | | |
```

### Resumen de materiales por solicitar al cliente

```markdown
## Lista de materiales — [Código]

| Material | Cantidad | Tópico | Responsable de conseguir |
|---|---|---|---|
| [material 1] | | | Cliente / Ingnovarte |
```

## Limits

- Cada actividad debe ser realizable dentro de las restricciones operacionales del cliente (conectividad, tiempo, nivel digital)
- No diseñar actividades que requieran infraestructura que el cliente no confirmó tener
- Las actividades son propuestas, no guías completas — los detalles de ejecución van en `ldd-guias`
- El tiempo total de actividades por tópico debe ser proporcional a la duración del tópico en la Ficha Técnica
- Marcar con `[SUPUESTO]` cualquier material cuya disponibilidad no fue confirmada

## Plan Update

Al finalizar la generación de la Lluvia de Ideas, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 16 — Generación de propuestas de enfoque pedagógico y actividades para la implementación en curso
   - ITEM 17 — Análisis, evaluación y selección de propuestas, secuencias y tiempos
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 16 y 17 marcadas ✅ en el plan. SPI Global: {valor}"
