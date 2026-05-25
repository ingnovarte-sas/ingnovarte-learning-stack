---
name: ldd-kickoff
description: Prepara la agenda de la reunión de kickoff con el cliente y procesa sus resultados para generar el brief del curso que da inicio al LDD.
triggers:
  - kickoff
  - reunión inicial
  - brief del curso
  - preparar reunión con cliente
  - procesar kickoff
  - levantar necesidad de entrenamiento
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- Necesitas preparar la agenda y los materiales para una reunión de kickoff con un cliente
- Tienes las notas de un kickoff realizado y necesitas estructurarlas en un brief formal
- Estás iniciando un nuevo curso desde cero y aún no existe ningún artefacto LDD

No uses esta skill para:
- Generar la Ficha Técnica (usa `ldd-ficha` — requiere contextualización completa)
- Analizar documentación técnica del curso (eso ocurre en Contextualización)

## Steps

### Modo A — Preparar el kickoff

1. Solicita: nombre del cliente, tipo de entrenamiento y cualquier contexto previo conocido
2. Genera la **Agenda de Kickoff** con las secciones definidas en Outputs
3. Genera un **Template de Captura** para usar durante la reunión

### Modo B — Procesar resultados del kickoff

1. Recibe las notas del kickoff (en cualquier formato — texto libre, bullet points, grabación transcrita)
2. Extrae y estructura en el **Brief del Curso**:
   - Necesidad de entrenamiento: qué brecha de desempeño resuelve
   - Audiencia objetivo: cargo, nivel técnico, experiencia previa
   - Parámetros: duración estimada, modalidad, sedes, prerrequisitos
   - Competencias esperadas: qué debe poder hacer el estudiante al finalizar
   - Recursos disponibles: documentación, SMEs, material audiovisual existente
   - Restricciones: fechas, presupuesto, idioma, normativas específicas
3. Guarda en Engram: `topic_key: ldd/{código}/kickoff`

## Outputs

### Agenda de Kickoff (Modo A)

```markdown
# Agenda Kickoff — [Nombre del curso]
**Cliente:** | **Fecha:** | **Duración:** 90 min

## 1. Bienvenida y presentación del proceso LDD (15 min)
- Las 6 fases: Kickoff → Contextualización → Esquema → Creación → Actualización → Evaluación
- Cómo participará el cliente en cada fase

## 2. Levantamiento de necesidad (30 min)
- ¿Qué brecha de desempeño o problema operacional resuelve este entrenamiento?
- ¿Quién es la audiencia? Cargo, nivel técnico, experiencia previa
- ¿Qué debe poder hacer el estudiante al finalizar?
- ¿Existen cursos anteriores sobre este tema?

## 3. Parámetros del curso (20 min)
- Duración estimada, modalidad, sedes
- Fechas objetivo, restricciones de disponibilidad del personal

## 4. Recursos disponibles (15 min)
- Documentación técnica existente (manuales, procedimientos, instructivos)
- SMEs disponibles para entrevistas de contextualización
- Material audiovisual existente

## 5. Próximos pasos (10 min)
- Inicio de fase de Contextualización
- Responsables y fechas acordadas
```

### Template de Captura (Modo A)

```markdown
# Captura Kickoff — [Nombre del curso]
**Fecha:** | **Asistentes:**

## Necesidad
[notas]

## Audiencia
[notas]

## Parámetros
Duración: | Modalidad: | Sedes: | Prerrequisitos:

## Competencias esperadas
[notas]

## Recursos disponibles
[notas]

## Restricciones
[notas]

## Compromisos y próximos pasos
[notas]
```

### Brief del Curso (Modo B)

```markdown
# Brief — [Código] [Nombre del curso]
**Cliente:** | **Programa:** | **Fecha kickoff:**

## Necesidad de entrenamiento
[descripción del problema / brecha de desempeño]

## Audiencia objetivo
[perfil, cargo, nivel técnico, experiencia previa]

## Parámetros del curso
| Duración estimada | Modalidad | Sedes | Prerrequisitos |
|---|---|---|---|
| | | | |

## Competencias esperadas
- [competencia 1]
- [competencia 2]

## Recursos disponibles
- Documentación: [lista]
- SMEs: [lista]
- Material audiovisual: [lista]

## Restricciones
- [restricción 1]

## Próximos pasos acordados
- [paso 1]
```

## Limits

- No tomar decisiones pedagógicas en esta fase — el kickoff es levantamiento, no diseño
- No inventar información del cliente no provista
- Si faltan datos críticos (audiencia, duración, competencias), pedir esa información antes de generar el brief
- No generar la Ficha Técnica en esta skill — eso requiere contextualización completa

## Plan Update

Este artefacto no tiene tareas directas asignadas en el plan de gestión estándar.
El orquestador activa el protocolo de seguimiento proactivo para verificar con el usuario si las tareas de Planeación (ITEM 1–5) pueden cerrarse tras completar el kickoff.
