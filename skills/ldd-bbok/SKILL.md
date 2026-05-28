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
  version: "2.2"
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

## Modo de trabajo

Antes de generar contenido, preguntar al usuario:

> "Este BBOK tiene **[N] tópicos** según la Ficha Técnica.
> ¿Cómo quieres que trabaje?
>
> **A) Por tópico** *(recomendado)* — genero un tópico a la vez con su segmentación completa y te pido validación antes de continuar.
> **B) Por subtema** — genero subtema a subtema dentro de cada tópico (más granular, ideal si los tópicos son extensos).
> **C) Una pasada** — genero todo el BBOK de una vez y te presento el resultado completo al final.
> **D) Otro** — especifica (ej: 'tópicos 1 y 2 juntos, luego uno a uno')."

**Default si no responde:** opción A (por tópico).

### Validación por unidad de trabajo

Al terminar cada tópico (o subtema, según el modo elegido), presentar este reporte **antes de continuar con el siguiente**:

```
─── Validación — Tópico [N]: [Nombre] ──────────────────────
IDs generados     : [total] ([X] Críticos · [Y] Altos · [Z] Medios)
Imágenes BBOK     : [N] imágenes asociadas a IDs de este tópico
Supuestos técnicos: [N] marcados — [lista breve o "ninguno"]
Funciones cubiertas: [definir · explicar mecanismo · aplicar criterio · comparar · advertir riesgo · procedimiento]
Funciones ausentes : [lista o "ninguna"]

¿Apruebas este tópico o hay ajustes antes de continuar?
────────────────────────────────────────────────────────────
```

**Criterios de bloqueo** — no continuar al siguiente tópico si:
- Hay 0 IDs con prioridad Crítica en un tópico con duración > 15 min
- Hay supuestos técnicos que el usuario quiere confirmar primero
- El usuario pide correcciones

**En modo "Una pasada":** no hay pausas intermedias. Presentar el reporte global al final con el resumen por tópico.

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
2. **Extraer imágenes del BBOK fuente** — si el BBOK fuente es un archivo `.docx`, extraer las imágenes embebidas antes de leer el contenido:
   ```bash
   pandoc --extract-media="{carpeta}/02_Esquema/bbok-images" "{bbok.docx}" -o /tmp/bbok-md.md
   ```
   Esto produce:
   - `/tmp/bbok-md.md` — texto del BBOK en markdown con referencias `![](bbok-images/media/imageN.png)` en el lugar exacto donde aparecían en el docx
   - `{carpeta}/02_Esquema/bbok-images/media/` — carpeta con todas las imágenes extraídas
   Si el BBOK fuente no es .docx (ya es markdown u otro formato sin imágenes embebidas), omitir este paso.
   Guardar el manifiesto de imágenes en Engram: `ldd/{código}/bbok-images` (ver formato en Outputs)
3. **Revisar la tabla de Tópicos** de la Ficha Técnica — estos son los tópicos que el BBOK debe cubrir, exactamente con los mismos nombres
4. **Por cada tópico**, generar:
   - Introducción conceptual del tema
   - Conceptos clave con definiciones
   - Contenido técnico organizado (procedimientos, clasificaciones, criterios)
   - Conexión con las actividades clave del puesto de trabajo
5. **Segmentar el BBOK en unidades atómicas** — por cada tópico, descomponer el contenido generado en unidades mínimas de conocimiento y asignar un ID único a cada una:
   - Formato de ID: `T{N}-{num}` donde N = número de tópico (1, 2, 3…), num = secuencial de 3 dígitos (001, 002…)
   - Una unidad = una idea técnica atómica: un principio, una regla, una relación causa-efecto, un dato operacional
   - Prioridad: `Crítica` (sin esto el participante no puede desempeñarse) · `Alta` (enriquece la comprensión) · `Media` (contexto o complemento)
   - Función instruccional: `definir` · `explicar mecanismo` · `aplicar criterio` · `comparar` · `advertir riesgo` · `procedimiento`
   - El resultado es la tabla `BBOK_segmentado` (ver formato en Outputs)
   - **Detectar imágenes por sección**: al segmentar, buscar referencias `![](...)` en el markdown generado por pandoc. Asociar cada imagen al ID más cercano que la precede. Registrar la ruta relativa en la columna `Imagen BBOK` de la tabla.
6. **Respetar las restricciones** de la Ficha: no profundizar más allá de lo que los criterios de desempeño exigen
7. **Marcar supuestos técnicos** que requieran validación con el SME
8. **Guardar en Engram**: topic_keys `ldd/{código}/bbok` (texto completo del borrador), `ldd/{código}/bbok-segmentado` (tabla de IDs) y `ldd/{código}/bbok-images` (manifiesto de imágenes — solo si se extrajeron imágenes en el paso 2)

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

| ID | Subtema | Unidad BBOK | Idea técnica | Prioridad | Función instruccional | Imagen BBOK |
|---|---|---|---|---|---|---|
| T1-001 | 1.1 | [nombre de la sección ### del BBOK] | [una frase: la idea atómica] | Crítica | definir | bbok-images/media/image1.png |
| T1-002 | 1.1 | [mismo subtema si el bloque tiene más ideas] | [siguiente idea atómica] | Alta | explicar mecanismo | _(misma imagen que T1-001 si es del mismo bloque)_ |
| T2-001 | 2.1 | [sección del tópico 2] | [idea atómica] | Crítica | aplicar criterio | |
...
```

### Manifiesto de imágenes BBOK

```markdown
# BBOK Images — [Código] [Nombre del curso]

| Archivo | Sección BBOK | IDs asociados | Descripción inferida |
|---|---|---|---|
| bbok-images/media/image1.png | [título ### donde aparece] | T1-001, T1-002 | [qué muestra la imagen — diagrama, foto, tabla] |
| bbok-images/media/image2.png | [...] | T2-005 | [...] |
```

> Guardar en Engram con `topic_key: ldd/{código}/bbok-images`

**Reglas de la tabla:**
- Una fila = una idea técnica que puede enseñarse de forma independiente
- Los IDs son correlativos y sin saltos dentro de cada tópico
- La columna «Subtema» usa el código del subtema de la Ficha Técnica (ej: 3.1, 3.2)
- «Unidad BBOK» es el nombre de la sección `###` del BBOK que contiene la idea
- «Idea técnica» es una sola frase activa en presente: «La malla de subestación cumple una función distinta»
- «Imagen BBOK» contiene la ruta relativa desde la carpeta del curso (ej: `02_Esquema/bbok-images/media/image3.png`). Si la idea no tiene imagen asociada en el BBOK fuente, dejar vacío. Si varias ideas pertenecen al mismo bloque con una imagen, todas comparten la misma ruta.

## Limits

- Los tópicos del BBOK deben coincidir exactamente con los tópicos de la Ficha Técnica
- No inventar valores técnicos específicos (torques, presiones, voltajes, procedimientos precisos) — marcarlos como supuestos
- El BBOK es un borrador: no es el documento final que el estudiante recibe
- La profundidad del contenido debe alinearse con la duración del tópico en la ficha (un tópico de 15 min no necesita el mismo detalle que uno de 120 min)
- No incluir actividades pedagógicas en el BBOK — esas van en la Lluvia de Ideas
- **IDs correlativos y sin saltos**: los IDs se asignan en orden de aparición en el BBOK; ningún ID puede omitirse ni reutilizarse
- **Prioridad «Crítica» sin excepción**: todo concepto del que depende directamente el desempeño en el puesto debe marcarse Crítica — si hay duda entre Crítica y Alta, elegir Crítica
- **Una idea por ID**: si un párrafo contiene más de una idea atómica, segmentar en múltiples IDs consecutivos; no agrupar ideas distintas en un solo ID
- **Las imágenes del BBOK son contenido técnico validado**, no decoración — nunca descartarlas. Si una imagen aparece en el BBOK fuente, debe aparecer en la columna `Imagen BBOK` de al menos un ID de la sección correspondiente
- **Imágenes sin texto**: si una imagen aparece en el BBOK sin párrafo descriptivo alrededor, crear un ID específico para ella con función instruccional `ilustrar` y prioridad `Alta`

## Plan Update

Al finalizar la generación del BBOK, actualiza el plan de gestión (`07_Planeación/plan-gestion.md`):

1. Marca al 100% las siguientes tareas:
   - ITEM 21 — Borrador del contenido del curso BBOK
2. Recalcula SPI de la tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tarea 21 marcada ✅ en el plan. SPI Global: {valor}"
