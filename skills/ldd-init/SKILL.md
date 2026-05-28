---
name: ldd-init
description: Inicializa la estructura estándar de 10 carpetas LDD dentro de la carpeta del curso ya creada por el usuario. Genera la estructura de carpetas y el plan de gestión completo con fechas calculadas. Punto de entrada obligatorio antes de cualquier fase LDD.
triggers:
  - ldd-init
  - iniciar curso
  - init curso
  - crear estructura del curso
  - inicializar carpetas
  - nuevo curso
metadata:
  version: "1.1"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El usuario acaba de crear la carpeta del curso en su OneDrive y está listo para iniciar el LDD
- Se necesita crear la estructura estándar de Ingnovarte con el plan de gestión

No uses esta skill para:
- Crear la carpeta raíz del curso — eso lo hace el usuario manualmente
- Generar contenido del curso — usa las skills LDD específicas para cada fase

## Steps

1. Infiere código y nombre del curso:
   - Si el nombre de la carpeta actual (`cwd`) sigue el patrón `{CÓDIGO} {Nombre del curso}` (ej: `OP17 Finanzas personales`), extrae el código y nombre de ahí y confírmalos con el usuario antes de continuar
   - Si no se puede inferir: solicita al usuario **código** y **nombre** explícitamente
   - **Fecha de inicio del plan** — primer día de trabajo del proyecto (formato: DD-MMM-AA, ej: 29-ene-26)

2. Confirma el directorio de trabajo actual (`cwd`) — ahí se crean las carpetas.

3. Crea las 10 subcarpetas estándar en el `cwd`:
   ```
   01_Contextualización/
   02_Esquema/
   03_Creación/
   04_Entrenamiento/
   05_Evaluación/
   06_Actualización/
   07_Planeación/
   08_Monitoreo_y_Control/
   09_Transferencia/
   10_Control_de_Cambios/
   ```

4. Crea un archivo `_contenido.md` dentro de cada subcarpeta (ver sección Outputs — Contenido de carpetas).

5. Genera `07_Planeación/plan-gestion.md` con las 39 tareas estándar y fechas calculadas (ver sección Plan de Gestión).

6. Crea `README.md` en el `cwd` (ver sección Outputs — README).

7. Guarda en Engram:
   ```
   topic_key: ldd/{código}/init
   type: architecture
   project: ingnovarte-learning-stack
   ```

---

## Plan de Gestión

### Cálculo de fechas

Dado el `INICIO_OFFSET` de cada tarea (días calendario desde el día 0 = fecha de inicio del plan):
- `INICIO` = fecha_inicio_plan + INICIO_OFFSET días calendario
- `FIN` = INICIO + DIAS - 1 días calendario (si DIAS=1, FIN = INICIO)

Calcula las fechas reales de cada tarea aplicando esta fórmula. Usa el formato `DD-MMM-AA` (ej: 29-ene-26).

### Columnas del plan

| Columna | Descripción |
|---|---|
| ITEM | Número secuencial |
| TAREA | Descripción de la actividad |
| GRUPO | Paquete de trabajo al que pertenece |
| FASE | Fase del proceso LDD |
| % | Avance de la tarea (inicia en 0%) |
| DIAS | Duración estándar en días calendario |
| INICIO | Fecha calculada de inicio |
| FIN | Fecha calculada de fin |
| META | Cantidad de entregables objetivo para esa tarea |
| PV | Valor planeado (1,0 por defecto = peso igual para todas las tareas) |
| SPI | Índice de desempeño del cronograma = EV/PV (inicia en `-`) |

### EVM — Cómo calcular SPI

- **PV acumulado a la fecha**: suma de PV de todas las tareas cuyo FIN ya pasó
- **EV acumulado a la fecha**: suma de PV de tareas al 100% completadas
- **SPI = EV / PV** — si SPI < 1,0: atrasado; SPI = 1,0: en tiempo; SPI > 1,0: adelantado

El SPI por tarea individual:
- Tarea al 100% y dentro del plazo: `1,0`
- Tarea al 100% y fuera del plazo: `>1,0` (se completó aunque tardó más)
- Tarea en progreso o no iniciada con FIN pasado: `<1,0`
- Tarea no iniciada y FIN futuro: `-`

### Referencia de tareas estándar

> Tabla de tareas con INICIO_OFFSET (días calendario desde el primer día del plan).
> Las tareas en la misma fase con el mismo offset son paralelas.

| ITEM | TAREA | GRUPO | FASE | DIAS | INICIO_OFFSET | META | PV |
|---|---|---|---|---|---|---|---|
| 1 | Estimación de las actividades | Plan de Gestión | Planeación | 1 | 0 | 1 | 1,0 |
| 2 | Asignación de responsables | Plan de Gestión | Planeación | 1 | 2 | 1 | 1,0 |
| 3 | Estimación de la duración de las fases y actividades | Plan de Gestión | Planeación | 1 | 3 | 1 | 1,0 |
| 4 | Identificación y base de datos de expertos en la materia | Plan de Gestión | Planeación | 2 | 4 | 1 | 1,0 |
| 5 | Generación de cronograma con metas semanales de contextualización e inmersión | Plan de Contextualización | Planeación | 1 | 5 | 1 | 1,0 |
| 6 | Sesiones de contextualización utilizando Case*Method: Tasks and Deliverables | 01. Entrevista a expertos e inmersión | Contextualización | 10 | 4 | 1 | 1,0 |
| 7 | Identificación de necesidades de elementos audiovisuales | Plan de Contextualización | Planeación | 8 | 14 | 1 | 1,0 |
| 8 | Inmersión a las áreas relacionadas al levantamiento de las necesidades de capacitación | 01. Entrevista a expertos e inmersión | Contextualización | 5 | 14 | 1 | 1,0 |
| 9 | Informes de las entrevistas y las visitas de inmersión | 01. Entrevista a expertos e inmersión | Contextualización | 1 | 19 | 1 | 1,0 |
| 10 | Ubicación y organización estructurada de la información en la carpeta asignada | 02. Documentación soporte | Contextualización | 1 | 19 | 1 | 1,0 |
| 11 | Ubicación y organización estructurada del material audiovisual en plataforma | 02. Documentación soporte | Contextualización | 2 | 20 | 1 | 1,0 |
| 12 | Revisión de documentación: manuales, procedimientos, instructivos, material audiovisual | 02. Documentación soporte | Contextualización | 1 | 20 | 1 | 1,0 |
| 13 | Redacción del Perfil del curso | 03. Ficha Técnica | Contextualización | 1 | 20 | 1 | 1,0 |
| 14 | Redacción de la Información General | 03. Ficha Técnica | Contextualización | 1 | 20 | 1 | 1,0 |
| 15 | Redacción de Estructura de entrenamiento, evidencias y contexto | 03. Ficha Técnica | Contextualización | 1 | 21 | 1 | 1,0 |
| 16 | Generación de propuestas de enfoque pedagógico y actividades para la implementación en curso | 01. Lluvia de ideas | Esquema | 3 | 21 | 1 | 1,0 |
| 17 | Análisis, evaluación y selección de propuestas, secuencias y tiempos | 01. Lluvia de ideas | Esquema | 1 | 24 | 1 | 1,0 |
| 18 | Borrador del tema gráfico del curso | 04. Borrador | Esquema | 3 | 24 | 1 | 1,0 |
| 19 | Reuniones de validación de la Ficha Técnica que incluye contenido y prácticas relevantes | 01. Entregables | Transferencia | 1 | 22 | 1 | 1,0 |
| 20 | Borrador de las actividades con su objetivo general, propuesta y materiales | 04. Borrador | Esquema | 4 | 23 | 1 | 1,0 |
| 21 | Borrador del contenido del curso BBOK | 04. Borrador | Esquema | 15 | 27 | 1 | 1,0 |
| 22 | Preparación de material de entrenamiento, presentación, guías y plataformas por el instructor | 05. Alistamiento | Creación | 15 | 42 | 3 | 1,0 |
| 23 | Elaboración contenido de la Presentación indicando estilo, tipos de animación, gráficos deseados | 01. Contenido | Creación | 15 | 29 | 1 | 1,0 |
| 24 | Revisión y ajustes del contenido de la presentación por Tópico | 01. Contenido | Creación | 10 | 31 | 1 | 1,0 |
| 25 | Refinamiento del borrador de la guía, diseño y pruebas piloto simuladas o reales | 02. Guía de Actividades | Creación | 15 | 26 | 1 | 1,0 |
| 26 | Solicitud, aseguramiento de los materiales, montaje de la actividad | 02. Guía de Actividades | Creación | 15 | 26 | 1 | 1,0 |
| 27 | Pruebas de usuario (PU) para identificar Usabilidad, Accesibilidad, Tiempos y coherencia con los objetivos | 02. Guía de Actividades | Creación | 15 | 27 | 1 | 1,0 |
| 28 | Desarrollo de Guía completa basado en el informe de PU | 02. Guía de Actividades | Creación | 10 | 42 | 1 | 1,0 |
| 29 | Implementación de la guía al LMS (Gforms, Plataforma, Interfaz, APP) | 02. Guía de Actividades | Creación | 6 | 52 | 1 | 1,0 |
| 30 | Desarrollo gráfico por tópicos | 03. Diseño gráfico | Creación | 10 | 30 | 1 | 1,0 |
| 31 | PU - Revisión de la estructura gráfica, navegabilidad, animaciones, exactitud técnica | 03. Diseño gráfico | Creación | 10 | 32 | 1 | 1,0 |
| 32 | Creación de Evaluaciones, Rúbricas y Encuestas | 04. Evaluaciones | Creación | 7 | 41 | 1 | 1,0 |
| 33 | Montaje de evaluación en LMS (Gforms, Plataforma, Interfaz, APP) | 04. Evaluaciones | Creación | 3 | 47 | 1 | 1,0 |
| 34 | Reuniones de validación de las presentaciones, guías de actividades y material soporte | 01. Entregables | Transferencia | 2 | 52 | 1 | 1,0 |
| 35 | Diseño gráfico de ambientes de aprendizaje | 05. Alistamiento | Creación | 2 | 42 | 1 | 1,0 |
| 36 | Montaje y adecuación de Ambientes de aprendizaje (Laboratorios, salones, talleres) | 05. Alistamiento | Creación | 3 | 43 | 1 | 1,0 |
| 37 | Aseguramiento de material de entrenamiento, plataformas LMS y accesos virtuales | 05. Alistamiento | Creación | 4 | 46 | 1 | 1,0 |
| 38 | Generación del cronograma de capacitación | Plan de Gestión | Planeación | 2 | 50 | 1 | 1,0 |
| 39 | Ejecución de las sesiones según cronograma | 01. Clases programadas | Entrenamiento | 1 | 68 | 42 | 1,0 |

### Formato del archivo generado: `07_Planeación/plan-gestion.md`

```markdown
# Plan de Gestión — {CÓDIGO} {NOMBRE DEL CURSO}

**Fecha de inicio:** {FECHA_INICIO}
**PV Total:** 39,0

## Resumen EVM

| Indicador | Valor |
|---|---|
| PV Total | 39,0 |
| EV Acumulado | 0,0 |
| SPI Global | - |

> **Cómo actualizar el SPI:** marca el % de avance de cada tarea. Suma el PV de las tareas al 100% (EV) y divídelo entre la suma del PV de las tareas cuyo FIN ya pasó (PV due). SPI = EV / PV due.

## Tareas

| ITEM | TAREA | GRUPO | FASE | % | DIAS | INICIO | FIN | META | PV | SPI |
|---|---|---|---|---|---|---|---|---|---|---|
[insertar las 39 filas con fechas calculadas, % = 0%, SPI = -]
```

---

## Outputs — Contenido de carpetas

**01_Contextualización/_contenido.md**
```markdown
# 01 — Contextualización

## Archivos en esta carpeta
- `brief.md` — Brief del curso (output: ldd-kickoff)
- `informe-contextualizacion.md` — Informe de contextualización (output: ldd-contextualizacion)
- `ficha-tecnica.md` — Ficha Técnica aprobada (output: ldd-ficha)
- `documentacion-soporte/` — PDFs, manuales, instructivos del cliente
- `normas-competencia/` — Normas de competencia laboral relacionadas
```

**02_Esquema/_contenido.md**
```markdown
# 02 — Esquema

## Archivos en esta carpeta
- `bbok.md` — Borrador Body of Knowledge (output: ldd-bbok)
- `lluvia-de-ideas.md` — Lluvia de Ideas de actividades (output: ldd-lluvia)
- `esquema.md` — Esquema minuto a minuto (output: ldd-esquema)
- `listado-materiales.md` — Listado de materiales requeridos
- `temas-graficos/` — Borradores de tema gráfico
- `actividades/` — Borradores de actividades (pre-producción)
```

**03_Creación/_contenido.md**
```markdown
# 03 — Creación

## Archivos en esta carpeta
- `storyboard/` — Presentación final del curso (output: ldd-storyboard)
- `guia-actividades.md` — Guía de actividades completa (output: ldd-guias)
- `desarrollo/` — SCORM, aplicaciones, simuladores (si aplica)
```

**04_Entrenamiento/_contenido.md**
```markdown
# 04 — Entrenamiento

## Archivos en esta carpeta
- `registros/` — Actas, listas de asistencia, fotografías
  - Formato de nombre: `{fecha}-{sede}-registro.pdf`
```

**05_Evaluación/_contenido.md**
```markdown
# 05 — Evaluación

## Archivos en esta carpeta
- `instrumentos/`
  - `evaluacion-pre-post.md` — Evaluación pre y post (output: ldd-evaluaciones)
  - `rubrica-desempeno.md` — Rúbrica de desempeño (output: ldd-evaluaciones)
  - `encuesta-satisfaccion.md` — Encuesta de satisfacción (output: ldd-evaluaciones)
- `plan-verificacion-eficacia.md` — Plan de verificación de eficacia
- `resultados/`
  - `informe-retro.md` — Informe de retroalimentación post-entrenamiento (output: ldd-informe)
  - `informe-eficacia.md` — Informe de eficacia del ciclo (output: ldd-informe)
```

**06_Actualización/_contenido.md**
```markdown
# 06 — Actualización

## Archivos en esta carpeta
Material producido en una actualización del curso.
Misma estructura interna que 03_Creación, versionado por fecha.
```

**07_Planeación/_contenido.md**
```markdown
# 07 — Planeación

## Archivos en esta carpeta
- `plan-gestion.md` — Plan de gestión del curso con seguimiento EVM (% avance, PV, SPI)
```

**08_Monitoreo_y_Control/_contenido.md**
```markdown
# 08 — Monitoreo y Control

## Archivos en esta carpeta
- `inventario-materiales.md` — Inventario de materiales del curso
```

**09_Transferencia/_contenido.md**
```markdown
# 09 — Transferencia

## Archivos en esta carpeta
- `entregables/` — Versiones finales aprobadas de todos los materiales
- `actas-validacion/` — Actas de validación firmadas por el cliente
  - Formato: `{fecha}-acta-validacion-{entregable}.pdf`
```

**10_Control_de_Cambios/_contenido.md**
```markdown
# 10 — Control de Cambios

## Archivos en esta carpeta
Registro de cambios al curso de acuerdo con el procedimiento de solicitud de cambio.
Estructura por definir en versión futura del stack.
```

---

## Outputs — README

```markdown
# {CÓDIGO} — {Nombre del curso}

| Campo | Valor |
|---|---|
| **Código** | {código} |
| **Fecha de inicio** | {fecha} |
| **Estado** | En diseño |

## Estado por fases

| # | Fase | Carpeta | Estado |
|---|---|---|---|
| 0 | Init | — | ✅ Completado |
| 1 | Kickoff | — | ⏳ Pendiente |
| 2 | Contextualización | 01_Contextualización | ⏳ Pendiente |
| 3 | Ficha Técnica | 01_Contextualización | ⏳ Pendiente |
| 4 | BBOK + Lluvia + Esquema | 02_Esquema | ⏳ Pendiente |
| 5 | Creación de materiales | 03_Creación | ⏳ Pendiente |
| 6 | Entrenamiento | 04_Entrenamiento | ⏳ Pendiente |
| 7 | Evaluación | 05_Evaluación | ⏳ Pendiente |

## Plan de gestión

Ver `07_Planeación/plan-gestion.md`

## Contexto en Engram

Busca: `mem_search(query: "ldd/{código}", project: "ingnovarte-learning-stack")`
```

---

## Outputs — Engram

```
topic_key: ldd/{código}/init
type: architecture
content:
  código: {código}
  nombre: {nombre del curso}
  fecha_inicio: {fecha de inicio del plan}
  path: {cwd}
  estado: iniciado
  carpetas_creadas:
    - 01_Contextualización
    - 02_Esquema
    - 03_Creación
    - 04_Entrenamiento
    - 05_Evaluación
    - 06_Actualización
    - 07_Planeación
    - 08_Monitoreo_y_Control
    - 09_Transferencia
    - 10_Control_de_Cambios
```

## Limits

- No crear la carpeta raíz del curso — ya existe, el usuario la creó
- Si una carpeta ya existe, no sobreescribirla — informar cuáles ya existían
- No generar contenido de curso — solo estructura, plan y orientación
- Si faltan código, nombre o fecha de inicio: preguntar antes de crear cualquier archivo
- Las fechas del plan son estimaciones estándar — el director de proyecto las ajusta según la realidad del curso
