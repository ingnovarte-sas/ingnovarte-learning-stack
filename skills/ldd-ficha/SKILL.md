---
name: ldd-ficha
description: Genera la Ficha Técnica completa del curso (Información General + Perfil del Curso + Tópicos) a partir de los resultados de la fase de Contextualización.
triggers:
  - ficha técnica
  - ficha del curso
  - generar ficha
  - perfil del curso
  - información general del curso
  - tópicos del curso
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- Tienes el brief del curso y los resultados de las entrevistas/visitas de contextualización
- Necesitas formalizar el alcance del curso en un documento para validar con el cliente
- Estás en la fase de Contextualización y tienes suficiente información técnica del dominio

No uses esta skill para:
- Generar el BBOK (usa `ldd-bbok` — requiere ficha aprobada)
- Procesar las notas del kickoff (usa `ldd-kickoff`)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/kickoff`. Si no existe, pedir el brief antes de continuar
2. **Recopilar información**: solicitar o revisar la documentación de contextualización disponible (manuales, procedimientos, entrevistas, notas de visitas)
3. **Generar Información General**: completar todos los campos de la primera sección
4. **Generar Perfil del Curso**:
   - Redactar la meta en términos de capacidad observable (`"El estudiante estará en capacidad de..."`)
   - Identificar las competencias SENA o corporativas aplicables
   - Redactar objetivos específicos usando verbos de desempeño (Bloom)
   - Definir conocimientos esenciales organizados por tópico
   - Redactar criterios de desempeño observables y medibles
   - Definir actitudes (Ser) relevantes al rol
5. **Generar Tópicos**: tabla con nombre del tópico, contenido específico y duración en minutos (verificar que sumen las horas teóricas del curso)
6. **Marcar supuestos**: cualquier dato asumido sin confirmación del cliente o SME
7. **Guardar en Engram**: `topic_key: ldd/{código}/ficha`

## Outputs

```markdown
# Ficha Técnica — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:** | **Estado:** Borrador / Validado por cliente

---

## INFORMACIÓN GENERAL

| Campo | Valor |
|---|---|
| Código | |
| Nombre del curso (ESP) | |
| Nombre del curso (ENG) | |
| Clasificación | |
| Categoría | |
| Nombre corto | |
| Suministrado por | Ingnovarte |
| Cargos objetivo | |
| Tipo de cierre | Interno / Externo |
| Área de conocimiento | |
| Duración Total (Hr) | |
| Tipo de equipo | |
| Horas Teóricas | |
| Horas Prácticas | |
| Hrs. Trabajo Independiente | |
| Modalidad | |
| Sedes | |
| Recursos | |
| Programa | |
| Prerrequisitos | |

---

## PERFIL DEL CURSO

**Grupo objetivo:**
[descripción del perfil del participante]

**Meta:**
El estudiante estará en capacidad de [descripción de la capacidad esperada].

**Competencia (Título de la norma):**
[código y título de la norma SENA o corporativa]

**Actividad Clave:**
[descripción de la actividad laboral central que el curso habilita]

**Enfoque metodológico:**
[descripción del enfoque — incluir distribución: % teórico / % práctico / % autónomo]

**Objetivo general:**
[objetivo del curso en términos de competencia]

**Objetivos específicos de aprendizaje:**
El estudiante estará en capacidad de:
- [objetivo 1 — verbo de desempeño + condición + criterio]
- [objetivo 2]

**Conocimientos Esenciales:**
- [conocimiento 1]
- [conocimiento 2]

**Criterios de desempeño:**
- [criterio 1 — observable y medible]
- [criterio 2]

**Actitudes (Ser):**
- [actitud 1]
- [actitud 2]

**Competencias del Entrenador:**
*Pedagógicas:*
- [competencia pedagógica 1]

*Técnicas:*
- [competencia técnica 1]

**Frecuencia:** [semestral / anual / según plan de entrenamiento]

---

## TÓPICOS

| Tópico | Contenido específico | Duración (min) |
|---|---|---|
| [Tópico 1] | [descripción del contenido] | |
| [Tópico 2] | [descripción del contenido] | |
| **TOTAL** | | **[suma]** |

> Verificar: Total minutos / 60 = Horas Teóricas declaradas en Información General
```

## Limits

- No inventar especificaciones técnicas, normas SENA o datos del cliente sin confirmación
- Marcar explícitamente con `> **Supuesto**:` cualquier dato asumido
- Los criterios de desempeño deben ser observables — no usar frases vagas como "comprenderá" o "entenderá"
- La suma de minutos en la tabla de Tópicos debe ser consistente con las Horas Teóricas
- Esta skill no valida el contenido técnico del curso — solo estructura el alcance

## Plan Update

Al finalizar la generación de la Ficha Técnica, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 13 — Redacción del Perfil del curso
   - ITEM 14 — Redacción de la Información General
   - ITEM 15 — Redacción de Estructura de entrenamiento, evidencias y contexto
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 13, 14 y 15 marcadas ✅ en el plan. SPI Global: {valor}"
