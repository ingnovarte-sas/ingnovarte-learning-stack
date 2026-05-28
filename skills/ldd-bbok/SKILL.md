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
  version: "2.0"
  author: "ingnovarte"
  updated_at: "2026-05-28"
license: "proprietary"
---

## Modo de ejecución

Esta skill genera el BBOK completo más la tabla de segmentación con IDs únicos. Para proteger el contexto del orquestador:

**Esta skill DEBE ejecutarse como sub-agente. No ejecutar inline.**

Prompt mínimo para el sub-agente:
> Ejecuta la skill `ldd-bbok` para el curso [código].
> Lee el SKILL.md completo antes de comenzar: `skills/ldd-bbok/SKILL.md`
> Lee la Ficha Técnica desde Engram: `ldd/{código}/ficha`
> Lee documentación técnica disponible en la carpeta del curso.
> Genera el BBOK completo Y la tabla BBOK_segmentado con IDs T{N}-{num}.
> Guarda: `ldd/{código}/bbok` (texto completo) y `ldd/{código}/bbok-segmentado` (tabla de IDs).
> Actualiza el plan en: `07_Planeación/plan-gestion.md`

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
4. **Segmentar el BBOK en unidades atómicas** — por cada tópico, descomponer el contenido generado en unidades mínimas de conocimiento y asignar un ID único a cada una:
   - Formato de ID: `T{N}-{num}` donde N = número de tópico (1, 2, 3…), num = secuencial de 3 dígitos (001, 002…)
   - Una unidad = una idea técnica atómica: un principio, una regla, una relación causa-efecto, un dato operacional
   - Prioridad: `Crítica` (sin esto el participante no puede desempeñarse) · `Alta` (enriquece la comprensión) · `Media` (contexto o complemento)
   - Función instruccional: `definir` · `explicar mecanismo` · `aplicar criterio` · `comparar` · `advertir riesgo` · `procedimiento`
   - El resultado es la tabla `BBOK_segmentado` (ver formato en Outputs)
5. **Respetar las restricciones** de la Ficha: no profundizar más allá de lo que los criterios de desempeño exigen
6. **Marcar supuestos técnicos** que requieran validación con el SME
7. **Guardar en Engram**: topic_keys `ldd/{código}/bbok` (texto completo del borrador) y `ldd/{código}/bbok-segmentado` (tabla de IDs)

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

### BBOK Segmentado — tabla de trazabilidad

```markdown
# BBOK Segmentado — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:** | **Total IDs:** [N] ([X] Críticos · [Y] Altos · [Z] Medios)

| ID | Subtema | Unidad BBOK | Idea técnica | Prioridad | Función instruccional |
|---|---|---|---|---|---|
| T1-001 | 1.1 | [nombre de la sección ### del BBOK] | [una frase: la idea atómica] | Crítica | definir |
| T1-002 | 1.1 | [mismo subtema si el bloque tiene más ideas] | [siguiente idea atómica] | Alta | explicar mecanismo |
| T2-001 | 2.1 | [sección del tópico 2] | [idea atómica] | Crítica | aplicar criterio |
...
```

**Reglas de la tabla:**
- Una fila = una idea técnica que puede enseñarse de forma independiente
- Los IDs son correlativos y sin saltos dentro de cada tópico
- La columna «Subtema» usa el código del subtema de la Ficha Técnica (ej: 3.1, 3.2)
- «Unidad BBOK» es el nombre de la sección `###` del BBOK que contiene la idea
- «Idea técnica» es una sola frase activa en presente: «La malla de subestación cumple una función distinta»

## Limits

- Los tópicos del BBOK deben coincidir exactamente con los tópicos de la Ficha Técnica
- No inventar valores técnicos específicos (torques, presiones, voltajes, procedimientos precisos) — marcarlos como supuestos
- El BBOK es un borrador: no es el documento final que el estudiante recibe
- La profundidad del contenido debe alinearse con la duración del tópico en la ficha (un tópico de 15 min no necesita el mismo detalle que uno de 120 min)
- No incluir actividades pedagógicas en el BBOK — esas van en la Lluvia de Ideas
- **IDs correlativos y sin saltos**: los IDs se asignan en orden de aparición en el BBOK; ningún ID puede omitirse ni reutilizarse
- **Prioridad «Crítica» sin excepción**: todo concepto del que depende directamente el desempeño en el puesto debe marcarse Crítica — si hay duda entre Crítica y Alta, elegir Crítica
- **Una idea por ID**: si un párrafo contiene más de una idea atómica, segmentar en múltiples IDs consecutivos; no agrupar ideas distintas en un solo ID

## Plan Update

Al finalizar la generación del BBOK, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 21 — Borrador del contenido del curso BBOK
2. Recalcula SPI de la tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tarea 21 marcada ✅ en el plan. SPI Global: {valor}"
