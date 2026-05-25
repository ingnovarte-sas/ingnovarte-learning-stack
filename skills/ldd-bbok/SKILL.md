---
name: ldd-bbok
description: Genera el BBOK (Borrador Body of Knowledge) organizado por tópico a partir de la Ficha Técnica aprobada y la documentación técnica del curso.
triggers:
  - BBOK
  - borrador BOK
  - borrador del contenido
  - contenido del curso
  - body of knowledge borrador
  - redactar contenido por tópico
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- La Ficha Técnica está aprobada por el cliente
- Tienes documentación técnica de soporte (manuales, procedimientos, instructivos)
- Estás en la fase de Esquema y necesitas el borrador de contenido para diseñar actividades

No uses esta skill para:
- Generar el BOK final (usa `ldd-bok` — requiere esquema aprobado y revisión técnica)
- Generar la Ficha Técnica (usa `ldd-ficha`)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/ficha`. Si no existe o no está aprobada, detener y notificar
2. **Revisar la tabla de Tópicos** de la Ficha Técnica — estos son los tópicos que el BBOK debe cubrir, exactamente con los mismos nombres
3. **Por cada tópico**, generar:
   - Introducción conceptual del tema
   - Conceptos clave con definiciones
   - Contenido técnico organizado (procedimientos, clasificaciones, criterios)
   - Conexión con las actividades clave del puesto de trabajo
4. **Respetar las restricciones** de la Ficha: no profundizar más allá de lo que los criterios de desempeño exigen
5. **Marcar supuestos técnicos** que requieran validación con el SME
6. **Guardar en Engram**: `topic_key: ldd/{código}/bbok`

## Outputs

```markdown
# BBOK — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:** | **Estado:** Borrador (requiere validación técnica)

> Este documento es el Borrador del Body of Knowledge.
> Los datos técnicos específicos (valores, normas, especificaciones) deben ser validados por el SME antes de usar en producción.

---

## [Tópico 1 — exactamente como aparece en la Ficha Técnica]

### Introducción
[párrafo introductorio del tema, contexto de por qué es relevante para el rol]

### Conceptos clave
**[Concepto 1]:** [definición técnica clara]
**[Concepto 2]:** [definición técnica clara]

### Contenido técnico
[desarrollo del contenido organizado en subtemas]

#### [Subtema 1]
[contenido]

#### [Subtema 2]
[contenido]

### Aplicación en el puesto de trabajo
[cómo se aplica este tópico en las actividades clave del rol]

---

## [Tópico 2]
[misma estructura]
```

## Limits

- Los tópicos del BBOK deben coincidir exactamente con los tópicos de la Ficha Técnica
- No inventar valores técnicos específicos (torques, presiones, voltajes, procedimientos precisos) — marcarlos como supuestos
- El BBOK es un borrador: no es el documento final que el estudiante recibe
- La profundidad del contenido debe alinearse con la duración del tópico en la ficha (un tópico de 15 min no necesita el mismo detalle que uno de 120 min)
- No incluir actividades pedagógicas en el BBOK — esas van en la Lluvia de Ideas

## Plan Update

Al finalizar la generación del BBOK, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 21 — Borrador del contenido del curso BBOK
2. Recalcula SPI de la tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tarea 21 marcada ✅ en el plan. SPI Global: {valor}"
