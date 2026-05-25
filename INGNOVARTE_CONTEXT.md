# Ingnovarte — Contexto de dominio

## Quiénes somos

Ingnovarte diseña y desarrolla programas de entrenamiento técnico corporativo. Diseñamos, desarrollamos y evaluamos programas de entrenamiento para organizaciones industriales (minería, mantenimiento, operación).

## Clientes

- Drummond LTD (minería a cielo abierto — Mina Pribbenow, equipos PC8000, Bucyrus, dragalina)

## El proceso LDD

El LDD (Learning Design Document) es el workflow completo de diseño y desarrollo de un curso. Tiene 6 fases principales.

### Fases principales

| Fase | Descripción | Entregables del stack |
|---|---|---|
| **Kickoff** | Reunión inicial. Se presenta el proceso y se levanta la necesidad. | Brief del curso |
| **Contextualización** | Entrevistas a expertos, visitas de inmersión, revisión documental. Usa Case\*Method (Tasks & Deliverables) y Mayéutica. | Ficha Técnica |
| **Esquema** | Borrador del contenido y estructura. Marco predictivo. | BBOK + Lluvia de Ideas + Esquema |
| **Creación** | Desarrollo de todos los entregables finales. Marco Scrum. | BOK final + Borrador Presentación + Guías + Evaluaciones |
| **Actualización** | Ajustes post-entrenamiento desde retroalimentación. | Informe de retroalimentación |
| **Evaluación** | Cierre del ciclo de eficacia. | Informe de eficacia |

> **Fuera del alcance del stack:** Entrenamiento (ejecución), Planeación, Monitoreo y Control, Transferencia.

---

## Modelo de dominio

### Course (Curso)

Entidad central, identificada por su **código** (ej. `M051`, `OP14M11`).

| Atributo | Descripción |
|---|---|
| `código` | Identificador único |
| `nombre` | Nombre completo en español |
| `nombre_eng` | Nombre en inglés |
| `cliente` | Organización contratante |
| `programa` | Categoría (ej. DTech Maintenance) |
| `clasificación` | Tipo (ej. Entrenamiento Especial) |
| `duración_total_hr` | Horas totales |
| `horas_teóricas` | Máximo 50% del total |
| `horas_prácticas` | |
| `horas_trabajo_independiente` | 20% del tiempo teórico |
| `modalidad` | Salón / Virtual / Blended |
| `sedes` | Dónde se imparte |
| `prerrequisitos` | Cursos previos requeridos |

---

### FichaTecnica

Documento de alcance validado por el cliente. Tres secciones:

**1. Información General**
Código, nombres (ESP/ENG), clasificación, categoría, nombre corto, proveedor (Ingnovarte), cargos objetivo, tipo de cierre, duración total, distribución de horas (teóricas / prácticas / independiente), modalidad, sedes, recursos, programa, prerrequisitos.

**2. Perfil del Curso**
- Grupo objetivo
- Meta
- Competencia (título de norma SENA, ej. `280501167 intervenir equipos...`)
- Actividad Clave
- Enfoque metodológico (máximo 50% teórico; 80% con docente, 20% autónomo)
- Objetivo general
- Objetivos específicos de aprendizaje
- Conocimientos Esenciales
- Criterios de desempeño
- Actitudes (Ser)
- Competencias del Entrenador (pedagógicas + técnicas)
- Frecuencia

**3. Tópicos**

Tabla: `Tópico | Contenido específico | Duración (minutos)`

La suma de minutos debe ser consistente con las horas teóricas del curso.

---

### BBOK / BOK

- **BBOK**: Borrador del BOK — generado en fase Esquema
- **BOK**: Versión final — generado en fase Creación
- Organizado por tópicos, alineado a los tópicos de la Ficha Técnica
- Incluye: conceptos clave, procedimientos, normativas, criterios técnicos

---

### LluviaDeIdeas

Tabla de propuestas de actividades pedagógicas. Columnas:

| Columna | Descripción |
|---|---|
| ¿Qué? | Nombre de la actividad |
| ¿Cómo? | Descripción del desarrollo |
| ¿Con qué? | Materiales y recursos necesarios |
| ¿Dónde? | Espacio / ambiente de aprendizaje |
| ¿Cuánto tiempo? | Duración estimada |
| Validación Interna | Aprobación del equipo Ingnovarte |
| Validación final | Aprobación del cliente |
| Tópico | Tópico al que pertenece |
| % | Porcentaje del tiempo del tópico |
| M | Minutos asignados |
| P | Momento práctico (sí/no) |
| TOTAL | Minutos totales del tópico |

---

### Esquema

Minuto a minuto del curso. Define la secuencia completa de momentos pedagógicos:
- Tópico y subtema
- Actividad asociada (de la Lluvia de Ideas)
- Tiempo en minutos y porcentaje
- Tipo de momento (teórico / práctico)
- La suma de todos los minutos = duración total del curso

---

### BorradorPresentacion

Borrador completo de la presentación por diapositiva. El equipo de diseño gráfico aplica la capa visual final.

Por diapositiva incluye:
- Título
- Contenido (texto, bullets, ejemplos, datos técnicos)
- Notas al facilitador
- Indicaciones para diseño gráfico (qué imagen / gráfico / diagrama va aquí)

---

### GuiaActividades

Documento completo por actividad. Incluye:
- Objetivo de la actividad (alineado a objetivos del curso)
- Descripción detallada del desarrollo
- Materiales y recursos
- Procedimiento paso a paso
- Criterios de evaluación de la actividad
- Configuración LMS si aplica (Gforms, plataforma, app)

---

### Evaluacion

- **Pre/post**: instrumento de medición antes y después del curso
- **Rúbrica**: criterios de desempeño por competencia
- **Encuesta de satisfacción**: percepción del participante
- Todos los ítems trazables a los objetivos de la Ficha Técnica

---

### ExperienciaDigital

Plan estructurado para experiencias interactivas:
- **SCORM**: e-learning interactivo empaquetado
- **Chatbot**: práctica conversacional
- **Simulador**: práctica en entorno virtual

**Alcance del stack LDD respecto a ExperienciaDigital:**

1. El stack LDD genera el **PLAN y/o GUIÓN** de la experiencia digital: mapa de navegación, guión del chatbot, estructura del simulador, secuencia de pantallas.
2. El **artefacto técnico ejecutable** (archivo SCORM, chatbot funcional, simulador interactivo) lo desarrolla el equipo técnico — **NO es responsabilidad del stack LDD**.
3. La skill `ldd-digital` está **diferida** como decisión arquitectónica futura. Hasta que se implemente, el stack genera el guión/plan como documento de trabajo para el equipo técnico.

---

### InformeRetroalimentacion

Generado en fase Actualización. Incluye:
- Retroalimentación de participantes e instructores
- Dudas y falencias identificadas en clase
- Solicitudes de cambio
- Recomendaciones de mejora priorizadas

---

### InformeEficacia

Generado en fase Evaluación. Incluye:
- Resultados comparados pre/post (por ítem y por competencia)
- Resultados de encuestas de satisfacción
- Conclusión: ¿el entrenamiento fue pertinente, eficaz, apropiado?
- Insumos para futuros entrenamientos

---

## Topic Keys de Engram

Todo el trabajo por curso usa el prefijo `ldd/{código-curso}/`:

```
ldd/{code}/kickoff        → Brief del kickoff
ldd/{code}/context        → Notas de contextualización, docs revisados
ldd/{code}/ficha          → Ficha Técnica
ldd/{code}/bbok           → Borrador BOK
ldd/{code}/lluvia         → Lluvia de Ideas
ldd/{code}/esquema        → Esquema minuto a minuto
ldd/{code}/presentacion   → Borrador de presentación
ldd/{code}/bok            → BOK final
ldd/{code}/guias          → Guías de Actividades
ldd/{code}/evaluaciones   → Evaluaciones + rúbricas + encuestas
ldd/{code}/informe-retro  → Informe de retroalimentación post-entrenamiento
ldd/{code}/informe-eficacia → Informe de eficacia del ciclo de evaluación
```

---

## Marco metodológico

| Fase | Marco |
|---|---|
| Contextualización, Esquema | Predictivo (waterfall) |
| Creación | Scrum (sprints por entregable) |

**Técnicas de contextualización:**
- Case\*Method: Tasks and Deliverables
- Mayéutica (preguntas socráticas para extraer conocimiento tácito)

**Distribución horaria estándar:**
- Máximo 50% horas teóricas del total
- Del tiempo teórico: 80% con docente, 20% trabajo autónomo

## Restricciones operacionales

- Tiempo limitado de personal fuera de operación
- Conectividad variable en campo
- Licencias y herramientas no siempre homogéneas entre sedes
- Nivel digital mixto entre participantes

## Criterio de eficacia

Todo diseño debe poder verificarse con evidencia observable en desempeño en campo (antes/después, aplicación, calidad y seguridad).

---

## Glosario

| Término | Definición |
|---|---|
| LDD | Learning Design Document — el workflow completo de Ingnovarte |
| BBOK | Borrador Body of Knowledge |
| BOK | Body of Knowledge (versión final) |
| Esquema | Minuto a minuto del curso con tópicos, actividades y tiempos |
| Lluvia de Ideas | Tabla de propuestas de actividades pedagógicas |
| Ficha Técnica | Documento de alcance del curso validado por el cliente |
| PU | Prueba de Usuario |
| LMS | Learning Management System (Gforms, plataforma, app) |
| SCORM | Formato de e-learning empaquetado para LMS |
| SME | Subject Matter Expert (experto en el tema del curso) |
| Case\*Method | Metodología de contextualización: Tasks and Deliverables |
