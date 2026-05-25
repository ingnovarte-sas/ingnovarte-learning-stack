---
name: ldd-evaluaciones
description: Genera los instrumentos de evaluación del curso — evaluación pre/post, rúbricas de desempeño y encuesta de satisfacción — alineados a los objetivos de la Ficha Técnica.
triggers:
  - evaluación del curso
  - evaluación pre-post
  - pre-test
  - post-test
  - rúbrica
  - encuesta de satisfacción
  - instrumentos de evaluación
  - banco de preguntas
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- La Ficha Técnica está aprobada (los objetivos específicos son la base de los ítems)
- El BOK o BBOK está disponible (los ítems se construyen sobre el contenido)
- Estás en la fase de Creación desarrollando los entregables del curso

No uses esta skill para:
- Analizar resultados de evaluaciones (usa `ldd-informe`)
- Diseñar actividades de práctica (usa `ldd-guias`)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/bbok` o `ldd/{código}/bok`. Si ninguno existe, detenerse con el mensaje: "Necesito el BBOK o el BOK del curso antes de generar los instrumentos de evaluación. ¿Deseas generarlo primero?"
2. **Revisar los objetivos específicos** de la Ficha Técnica — cada objetivo debe tener al menos 1 ítem en la evaluación. Los ítems deben referenciar secciones específicas del BBOK o BOK encontrado, no solo los objetivos de la Ficha.
3. **Construir la evaluación pre/post**:
   - Mínimo 10 ítems por versión (pre y post son equivalentes, no idénticas)
   - Distribución: 60% selección múltiple, 20% verdadero/falso o emparejamiento, 20% respuesta corta o caso
   - Dificultad progresiva dentro de cada versión
   - Distractores plausibles para las opciones incorrectas
4. **Construir la rúbrica** de desempeño para competencias prácticas
5. **Construir la encuesta de satisfacción** (8-12 ítems)
6. **Guardar en Engram**: `topic_key: ldd/{código}/evaluaciones`

## Outputs

### Evaluación Pre/Post

```markdown
# Evaluación — [Código] [Nombre del curso]
**Versión:** Pre / Post | **Fecha:**

> Instrucciones al evaluador: aplicar el instrumento PRE al inicio del curso y el instrumento POST al finalizar.
> Los ítems cubren los mismos objetivos con formulaciones equivalentes, no idénticas.

---

## Instrucciones para el participante

Responde de forma individual. No hay respuestas correctas o incorrectas en el PRE — queremos conocer tu punto de partida. En el POST, selecciona la mejor respuesta según lo aprendido.
Tiempo estimado: [X] minutos.

---

## Sección 1 — [Nombre del Tópico 1] ([X] ítems)

**Ítem 1**
[Enunciado de la pregunta]

a) [opción — distractor plausible]
b) [opción — respuesta correcta]
c) [opción — distractor plausible]
d) [opción — distractor plausible]

*Respuesta correcta: b) | Objetivo: [citar el objetivo específico] | Dificultad: Básica / Intermedia / Avanzada*

**Ítem 2**
[...]

---

## Tabla de especificaciones

| Tópico | # Ítems | Objetivos cubiertos | Nivel Bloom |
|---|---|---|---|
| [Tópico 1] | | | Recordar / Comprender / Aplicar |
| [Tópico 2] | | | |
| **Total** | **[N]** | | |
```

### Rúbrica de Desempeño

```markdown
# Rúbrica de Desempeño — [Código]
**Competencia evaluada:** [título de la norma]

| Criterio | Excelente (4) | Satisfactorio (3) | En desarrollo (2) | Insuficiente (1) |
|---|---|---|---|---|
| [criterio 1 de la ficha] | [descriptor] | [descriptor] | [descriptor] | [descriptor] |
| [criterio 2] | | | | |

**Puntaje mínimo de aprobación:** [X/Y puntos] ([%]%)
```

### Encuesta de Satisfacción

```markdown
# Encuesta de Satisfacción — [Código]
**Escala:** 1 (Muy en desacuerdo) → 5 (Muy de acuerdo)

## Contenido del curso
1. Los temas cubiertos son relevantes para mi trabajo diario. [1-2-3-4-5]
2. El nivel de profundidad del contenido fue adecuado. [1-2-3-4-5]
3. Los materiales del curso (presentación, guías) son claros y útiles. [1-2-3-4-5]

## Metodología
4. Las actividades prácticas me ayudaron a entender mejor el contenido. [1-2-3-4-5]
5. El ritmo del curso fue adecuado. [1-2-3-4-5]
6. El ambiente de aprendizaje fue propicio para participar. [1-2-3-4-5]

## Instructor
7. El instructor dominó los temas y respondió mis preguntas. [1-2-3-4-5]
8. El instructor facilitó la participación del grupo. [1-2-3-4-5]

## Aplicabilidad
9. Puedo aplicar lo aprendido en mi trabajo. [1-2-3-4-5]
10. Recomendaría este curso a un compañero. [1-2-3-4-5]

## Pregunta abierta
11. ¿Qué mejorarías del curso?
[respuesta abierta]
```

## Limits

- Los ítems deben construirse sobre el contenido del BOK/BBOK, no inventar conceptos que no están en el curso
- El instrumento PRE y el POST cubren los mismos objetivos pero con formulaciones distintas — no son idénticos
- Los distractores deben ser plausibles (errores técnicos reales), no absurdos
- Nunca incluir la respuesta correcta en el enunciado o en las instrucciones del participante
- La evaluación post no reemplaza la observación de desempeño en campo — es complementaria

## Plan Update

Al finalizar la generación de los instrumentos de evaluación, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 32 — Creación de Evaluaciones, Rúbricas y Encuestas
   - ITEM 33 — Montaje de evaluación en LMS
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 32 y 33 marcadas ✅ en el plan. SPI Global: {valor}"
