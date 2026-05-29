---
name: ldd-storyboard
description: Genera el storyboard slide por slide — brief formal por slide con historia visual, Huella BBOK, texto en pantalla, especificaciones de diseño y notas de facilitador.
triggers:
  - storyboard
  - generar storyboard
  - brief de presentación
  - brief por slide
  - borrador presentación
  - presentación del curso
  - diapositivas
  - slides
  - brief para diseño
  - brief diseño gráfico
metadata:
  version: "3.7"
  author: "ingnovarte"
  updated_at: "2026-05-29"
license: "proprietary"
---

## Modo de trabajo

Antes de generar ningún brief, preguntar al usuario:

> "Este storyboard tiene **[N] tópicos** y aproximadamente **[M] slides** según la arquitectura.
> ¿Cómo quieres que trabaje?
>
> **A) Por tópico** *(recomendado)* — genero la tabla de arquitectura + todos los briefs de un tópico, valido cobertura BBOK y te pido aprobación antes de continuar.
> **B) Arquitectura primero, briefs después** — genero la tabla completa de todos los tópicos, espero tu aprobación, y luego genero los briefs tópico a tópico.
> **C) Una pasada** — genero arquitectura y todos los briefs de una vez.
> **D) Otro** — especifica (ej: 'solo el tópico 3', 'los divisores y portada primero')."

**Default si no responde:** opción B (arquitectura primero — permite corregir estructura antes de escribir 30+ briefs).

### Validación por unidad de trabajo

Al terminar cada tópico, presentar este reporte **antes de continuar con el siguiente**:

```
─── Validación — Tópico [N]: [Nombre] ──────────────────────────────
Slides generadas  : [total] (CONCEPTO: X · TÉCNICO: Y · EJEMPLO: Z · ACTIVIDAD: W)
Cobertura BBOK    : [X]/[total] IDs críticos cubiertos
IDs sin slide     : [lista o "Cobertura completa ✓"]
Variedad visual   : [OK / ⚠️ recurso '{código}' aparece N veces consecutivas]
Dual-coding       : [✓ todos completos / ⚠️ N slides con checklist incompleto]
Huella BBOK       : [✓ todas declaradas / ⚠️ N slides sin huella]

¿Apruebas este tópico o hay ajustes antes de continuar?
────────────────────────────────────────────────────────────────────
```

**Criterios de bloqueo** — no continuar al siguiente tópico si:
- Hay IDs críticos sin slide asignada (cobertura < 100% en críticos)
- Hay slides CONCEPTO con checklist dual-coding incompleto
- El usuario detecta un título que no coincide con el BBOK exacto
- El usuario pide correcciones de estructura o contenido

**En modo "Una pasada":** presentar el reporte global al final con cobertura total y lista consolidada de observaciones.

---

## When to Use

Usa esta skill cuando:
- El BBOK y el Esquema minuto a minuto están disponibles en Engram
- Necesitas el brief formal de presentación listo para que el equipo de diseño gráfico trabaje sin reuniones adicionales
- Estás en la fase de Creación produciendo los entregables del curso

No uses esta skill para:
- Generar el contenido técnico del curso (usa `ldd-bok`)
- Generar guías de actividades (usa `ldd-guias`)
- Definir la estructura del curso (usa `ldd-esquema`)

---

## Modo de ejecución

Esta skill genera 80–150+ slides (Nivel 4 — 1 slide por párrafo-título del BBOK, máximo 3 bullets × 7 palabras, split automático si el párrafo excede densidad) con múltiples lecturas de Engram y escritura de archivo extenso. Para proteger la ventana de contexto del orquestador:

**Esta skill DEBE ejecutarse como sub-agente. No ejecutar inline.**

El orquestador detecta la invocación de esta skill y lanza un sub-agente (herramienta `Agent` / Task tool) con el siguiente prompt mínimo:

> Ejecuta la skill `ldd-storyboard` para el curso [código].
> Lee el SKILL.md completo antes de comenzar: `skills/ldd-storyboard/SKILL.md`
> Lee BBOK desde Engram: `ldd/{código}/bbok`
> Lee Esquema desde Engram: `ldd/{código}/esquema`
> Genera por tópico. Guarda el archivo en: `cursos/{carpeta}/03_Creación/borrador-presentacion.md`
> Confirma con el usuario antes de avanzar al siguiente tópico.
> Si hay datos de BBOK que no encuentres en Engram, léelos directamente desde `cursos/{carpeta}/02_Esquema/`.

El sub-agente ejecuta todos los pasos de esta skill. El orquestador espera el resultado del sub-agente y lo reporta al usuario sin generar contenido inline.

---

## Inputs requeridos

| Input | Fuente | Obligatorio |
|---|---|---|
| BBOK | Engram `ldd/{código}/bbok` | ✅ Sí |
| Esquema minuto a minuto | Engram `ldd/{código}/esquema` | ✅ Sí |
| Tema visual del curso | Engram `ldd/{código}/tema-visual` | ⚠️ Si no existe, se propone en el paso 2 |

---

## Reglas mandatorias de trazabilidad BBOK

- Los títulos usados en la arquitectura y en los briefs de slides deben ser **copias exactas del BBOK**.
- Excepciones permitidas: slides estructurales sin fuente BBOK directa (`PORTADA`, `AGENDA`, `CIERRE`) pueden usar nombres funcionales institucionales; actividades prácticas del Esquema pueden usar el título exacto del Esquema. Todos los `DIVISOR`, `CONCEPTO`, `TÉCNICO` y slides `EJEMPLO` derivados del contenido técnico deben conservar el título BBOK exacto.
- Prohibido reescribir, resumir, pedagogizar, embellecer, traducir, acortar o crear títulos alternativos.
- Prohibido incluir una columna de "título sugerido", "título visual", "microtema" o equivalente.
- La taxonomía `CONCEPTO`, `TÉCNICO`, `EJEMPLO`, `DIVISOR`, etc. clasifica el **tipo didáctico de la slide**; no autoriza a renombrar el contenido fuente.
- Si un bloque del BBOK requiere varias slides, repetir el mismo `Título BBOK exacto` y diferenciar las slides con `Parte 1`, `Parte 2`, etc. en la columna `Observación de trazabilidad`, no en el título.
- Las actividades prácticas del Esquema minuto a minuto son obligatorias en la arquitectura. Si no existen en el BBOK, usar exactamente el título del Esquema y marcarlas como fuente `Esquema` en la observación de trazabilidad.
- No omitir actividades prácticas (`P`) del Esquema bajo el argumento de que no son contenido BBOK. Deben aparecer como slides tipo `EJEMPLO` o `ACTIVIDAD` según corresponda.
- Si una slide no tiene fuente directa en el BBOK ni corresponde a una actividad práctica explícita del Esquema, detenerse y pedir confirmación al usuario antes de incluirla. No inventar slides no trazadas.
- **TEXTO EN PANTALLA = términos técnicos exactos del BBOK, fraseados de forma directa y natural.** Los términos técnicos, nombres de normas (IEEE, RETIE, ANSI), valores numéricos y fórmulas se toman exactamente del BBOK. La estructura de la frase puede adaptarse para que sea directa y natural — no un fragmento de párrafo arrancado de contexto. **Test de validez:** ¿Suena como algo que diría un técnico experto hablando con su par? Sí → válido. ¿Suena como una línea de manual copiada? → reformular la estructura manteniendo los términos técnicos exactos. Prohibido: inventar términos que no aparecen en el BBOK, sinónimos no técnicos, metáforas o interpretaciones. La HISTORIA VISUAL y la NOTA FACILITADOR sí pueden tener narrativa libre — el **TEXTO EN PANTALLA**, no.

---

## Modelo de profundidad

Las presentaciones técnicas de Ingnovarte siguen este modelo de profundidad:

| Nivel | Descripción | Estado |
|---|---|---|
| 1 | Slides del Tópico (solo nombre del tópico) | — Insuficiente |
| 2 | Slides del Título del tema (encabezado de sección) | — Insuficiente |
| 3 | Slides con palabras clave de los Subtítulos del tema | ❌ No es el estándar |
| **4** | **Slides con palabras clave, infografías o frases que explican el concepto decada subtítulo** | **✅ OBJETIVO** |
| 5 | Slides con textos largos extraídos directamente del tema | — Excede estándar |
| 6 | Slides con textos idénticos a los del tema | — Excede estándar |

**El estándar de Ingnovarte es Nivel 4.** Esto significa:

- Cada párrafo-título del BBOK (los encabezados en negrita dentro de cada sección `###`) genera una slide propia.
- El TEXTO EN PANTALLA de cada slide contiene las frases explicativas del párrafo fuente — tomadas verbatim del BBOK — no solo el nombre del subtítulo.
- Las tablas del BBOK generan slides TÉCNICO independientes.
- El número de slides se **deriva de la estructura del BBOK**, no de una proporción de tiempo. El tiempo se asigna después.
- Resultado esperado: más slides por tópico que en Nivel 3, mayor fidelidad técnica, menor inferencia del diseñador.

---

## Catálogo de recursos visuales

El brief de cada slide **debe especificar un recurso visual del catálogo**. El agente elige el más apropiado para el concepto — nunca por defecto ni por comodidad. La **variedad es obligatoria**: dentro de un mismo tópico, no se permite el mismo recurso más de 2 veces consecutivas; un tópico con 8+ slides CONCEPTO debe usar al menos 4 recursos distintos.

| Código | Recurso | Cuándo usar |
|---|---|---|
| `foto-contextual` | Fotografía o ilustración que muestra el concepto en el contexto operativo real del curso — equipo, instalación, proceso, entorno de trabajo típico del participante | Cuando el concepto tiene representación física clara y el participante puede reconocerse en esa situación |
| `video-en-monitor` | Video corto reproducido dentro de la composición como si fuera la pantalla de un equipo o dispositivo real (bezel visible, interfaz de operación reconocible) | Cuando el concepto involucra un proceso dinámico: un sistema respondiendo, un procedimiento ejecutándose, un evento desarrollándose en el tiempo |
| `galería-netflix` | Conjunto de 3–6 imágenes o ilustraciones presentadas como tarjetas de contenido tipo streaming — fondo oscuro, título corto en cada tarjeta, disposición en grilla | Cuando hay varios casos, tipos, variantes o ejemplos del mismo concepto que deben mostrarse en paralelo |
| `sección-transversal` | Corte transversal o vista explosionada del equipo, instalación o sistema que revela lo que no se ve a simple vista | Cuando el concepto es un componente interno, una capa oculta o una estructura que requiere ver su interior para entenderse |
| `animación-de-trayecto` | Composición donde un flujo (energía, señal, material, datos, proceso, decisión) recorre un camino animado sobre el escenario — la ruta se dibuja en tiempo real | Cuando el concepto trata sobre movimiento, propagación, secuencia o transferencia: cómo algo viaja, se transmite o se propaga de A a B |
| `mapa-de-zona` | Vista isométrica, planimétrica o esquemática del espacio físico o lógico con zonas, sectores o áreas marcadas, coloreadas y etiquetadas | Cuando el concepto define áreas, alcances, límites o distribuciones dentro de un espacio — planta, red, sistema, proceso o estructura organizacional |
| `dato-prominente` | Un valor numérico, porcentaje, cifra técnica o indicador en tipografía gigante como protagonista visual, con mínimo contexto adicional | Cuando el concepto central es una cifra clave: un valor normativo, un umbral crítico, un indicador de desempeño o una estadística de impacto |
| `panel-de-instrumento` | Simulación gráfica de un instrumento, interfaz, dashboard, panel de control o pantalla de sistema mostrando un valor, estado o condición específica | Para slides de medición, lectura de indicadores, criterios de aceptación, estados del sistema o interpretación de resultados |
| `diagrama-esquemático` | Diagrama lógico, diagrama de bloques, esquema de relaciones, arquitectura del sistema o mapa de proceso, dibujado en el estilo visual del tema del curso | Para mostrar relaciones, jerarquías, arquitecturas, flujos de proceso o la disposición de los componentes de un sistema |
| `antes-después` | Dos estados contrastados en pantalla dividida: situación incorrecta vs correcta, estado sin intervención vs con intervención, antes de la práctica vs después | Cuando el concepto define qué cambia con o sin la aplicación de la técnica, el componente, el procedimiento o el cumplimiento normativo |

**Regla de variedad (obligatoria):** El agente debe planificar la distribución de recursos al diseñar la arquitectura (Paso D). Reportar el recurso asignado a cada CONCEPTO en la tabla de arquitectura como columna adicional . Si detecta 3 slides consecutivas con el mismo recurso, cambiar el tercero antes de continuar.


---

## Principios de dual-coding (obligatorios en CONCEPTO)

Cada slide CONCEPTO debe satisfacer los 5 principios antes de finalizar el BRIEF DISEÑO. El agente valida esta lista al redactar cada slide:

| # | Principio | Regla operativa |
|---|---|---|
| 1 | **Multimedia** | El visual debe expresar algo que las palabras solas no pueden — si solo repite el texto, rediseñar |
| 2 | **Estructura cognitiva** | El tipo de diagrama debe reflejar la organización del concepto: causal → causa-efecto · secuencial → flujo/línea de tiempo · jerárquico → árbol · espacial → posicional · comparativo → lado a lado |
| 3 | **Contigüidad** | Los labels van directamente sobre el diagrama — nunca en leyenda separada ni en cuadro de texto aparte |
| 4 | **Coherencia** | Eliminar todo elemento sin función informativa: fondos decorativos, iconos de adorno, gradientes sin significado |
| 5 | **Señalización** | Cada color codifica un significado específico — si un color no comunica algo concreto, no debe usarse |


---

## Steps

### 1. Verificar prerequisitos

Buscar en Engram:
- `ldd/{código}/bbok` — si no existe, detener y pedir al usuario ejecutar `ldd-bbok` primero
- `ldd/{código}/esquema` — si no existe, detener y pedir al usuario ejecutar `ldd-esquema` primero
- `ldd/{código}/bbok-images` — opcional; si existe, cargar el manifiesto para referenciar imágenes técnicas del BBOK en los briefs de diseño

**Cargar índice multimedia (opcional):**

Si `ms365-work` está disponible, descargar el índice pre-generado de imágenes:

```
index_path = "/drives/b!_4s4r1EyNE-qv91Z8XTqUv51NwO5vgxIh4KXaqdQ2TkCI2ZatiG6R4eTl7SCbpzr/items/017L4IGJP54PUFCV2WOVAIZECMDSL22J3Y:/_index.md:/content"
```

Parsear la tabla markdown → construir `media_index = { rel_path: { description, tags, category } }` (~3,252 entradas). Guardar en memoria para usarlo en Step 5 al elegir imágenes `foto-contextual`.

> Si la descarga falla (sin autenticación): continuar sin índice. Los campos `Imagen multimedia` quedarán `N/A` y `ldd-presentation` hará matching semántico.

### 2. Verificar o proponer el tema visual

Buscar en Engram `ldd/{código}/tema-visual`.

**Si existe:** leerlo y usarlo como referencia para todos los briefs de diseño.

**Si NO existe:** generar 3 propuestas de tema visual basadas en el dominio del curso, el perfil del participante y el contexto industrial. Formato de cada propuesta:

```
### Propuesta A — [Nombre del tema]
**Concepto:** [1 frase — la metáfora visual central]
**Paleta:** [colores principales]
**Tipografía:** [estilo — industrial, técnico, académico, etc.]
**Elementos recurrentes:** [objetos, texturas, iconografía que aparecen en todas las slides]
**Referencia de ambiente:** [descripción del "mundo" visual del curso]
```

Presentar las 3 propuestas al usuario y esperar su selección antes de continuar. Guardar el tema elegido en Engram: `topic_key: ldd/{código}/tema-visual`.

### 3. Diseñar la arquitectura de slides

Basarse en el BBOK y en el Esquema minuto a minuto. El conteo de slides se **deriva de la estructura del BBOK** (Nivel 4), no de minutos.

**Paso A — Derivar slides desde el BBOK (por cada tópico):**
1. Identificar las secciones `###` del tópico en el BBOK.
2. Por cada sección `###`, listar los párrafo-títulos (encabezados en negrita dentro del texto).
3. Cada párrafo-título = **1 slide CONCEPTO o TÉCNICO**.
4. Cada tabla del BBOK = **1 slide TÉCNICO adicional** (independiente del párrafo que la introduce).
5. Si un párrafo-título no tiene contenido explicativo sustantivo propio, agrupar con el anterior o con la sección.
6. Si el párrafo genera más de 6 elementos de texto, dividir en Parte 1 / Parte 2 con el mismo título.

**Paso B — Agregar estructura fija:**
1. 1 slide PORTADA
2. 1 slide AGENDA
3. 1 slide DIVISOR por cada tópico principal
4. Las actividades prácticas del Esquema (`P`) se incluyen como slides ACTIVIDAD — conservar exactamente el título del Esquema y la duración.
5. 1 slide CIERRE/SÍNTESIS

**Paso C — Asignar duración estimada:**
Una vez definido el total de slides de contenido, distribuir el tiempo del Esquema entre ellas. El tiempo por slide resultante es orientativo para el instructor, no un límite de diseño.

**Paso D — Producir tabla de arquitectura antes de generar los briefs:**

```markdown
| # | Tipo | Título BBOK exacto | Tópico fuente | Resumen del slide | Min. aprox. | Observación de trazabilidad |
|---|---|---|---|---|---|---|
| 1 | PORTADA | [nombre exacto del curso] | — | Portada institucional del curso | — | Portada institucional |
| 2 | AGENDA | [títulos exactos de tópicos BBOK] | — | [Tópico 1] · [Tópico 2] · [Tópico N] | — | Agenda construida solo con tópicos BBOK |
| 3 | DIVISOR | [título exacto del Tópico 1 en BBOK] | Tópico 1 | Separador de tópico | — | Divisor del tópico fuente |
| 4 | CONCEPTO | [título exacto del bloque BBOK] | Tópico 1 | [concepto 1] · [concepto 2] · [concepto 3] | 3 | Slide trazada al BBOK |
...
```

El campo **Resumen del slide** contiene 3–5 conceptos clave del BBOK separados por ` · `, que describen de qué trata específicamente esa slide. Para slides estructurales (PORTADA, DIVISOR, ACTIVIDAD) puede ser una frase funcional corta.

Mostrar la arquitectura al usuario y pedir confirmación antes de generar todos los briefs.

**Paso E — Verificar cobertura BBOK crítica (si existe bbok-segmentado):**

Si `ldd/{código}/bbok-segmentado` existe en Engram, verificar que todos los IDs con prioridad `Crítica` estén asignados como HUELLA BBOK en al menos una slide CONCEPTO o TÉCNICO de la arquitectura. Reportar en el resumen de arquitectura:

```
Cobertura BBOK crítica: {N}/{total} IDs críticos cubiertos
IDs críticos sin slide asignada: [lista — si ninguno, escribir "Cobertura completa ✓"]
```

Si hay IDs críticos sin cobertura, proponer slides adicionales antes de solicitar confirmación al usuario.

### 4. Clasificar cada slide por tipo

Usar la siguiente taxonomía:

| Tipo | Cuándo usar |
|---|---|
| **PORTADA** | Slide de apertura — solo nombre del curso, cliente, logo |
| **AGENDA** | Tabla de contenido con los tópicos del curso |
| **DIVISOR** | Separador entre tópicos — visual completo, solo título del tópico |
| **CONCEPTO** | Idea, principio o definición del BBOK expresada mediante imagen o composición visual |
| **TÉCNICO** | Diagrama, tabla, animación de componente o proceso — requiere datos exactos del BBOK |
| **EJEMPLO** | Caso real, escenario operativo, ejercicio o situación de aplicación |
| **ACTIVIDAD** | Momento práctico definido en el Esquema — conservar exactamente el título del Esquema |
| **CIERRE** | Síntesis del tópico o del curso — puntos clave visualizados |

> La clasificación de tipo didáctico no cambia el título. El título visible y el encabezado del brief siguen siendo el `Título BBOK exacto`.
> Para actividades prácticas que no existen en BBOK, el título visible y el encabezado del brief deben ser el título exacto del Esquema.

### 5. Generar el brief por slide

Para cada slide, producir el bloque completo según el formato de output. Ver sección **Outputs**.

**Reglas por tipo de slide:**

**PORTADA / AGENDA / DIVISOR:**
- Mínimo texto — solo títulos y etiquetas de navegación
- El visual define el "mundo" del curso
- El DIVISOR debe sentirse como "entrar a un nuevo capítulo"

**CONCEPTO:**
- La slide MUESTRA la idea visualmente antes de que el instructor la explique
- La fuente de cada slide CONCEPTO es el **párrafo-título** del BBOK (encabezado en negrita dentro de la sección)
- **Proceso de extracción Nivel 4:**
  1. Leer el párrafo completo cuyo título es la fuente de esta slide
  2. **Identificar la pregunta del aprendiz:** ¿qué pregunta implícita tiene el participante en este punto del curso que esta slide responde? (ej: "¿Cuándo exactamente aplica esta restricción?") — esa pregunta define qué frases del BBOK priorizar
  3. Identificar las 3–5 frases que **explican** ese título: las que definen el concepto, establecen la causa/consecuencia, fijan un requisito, dan valores o clasifican
  4. Condensar cada frase a ≤ 7 palabras si es label; conservar completa (≤ 15 palabras) si es definición o requisito directo del BBOK
  5. Todo texto proviene del BBOK — prohibido sintetizar, parafrasear o completar ideas
  - **Densidad máxima:** Máximo **3 bullets × 7 palabras** en TEXTO EN PANTALLA por slide CONCEPTO. Si el párrafo fuente genera más de 3 ideas sustantivas → crear slides adicionales (Parte 1, Parte 2) en lugar de comprimir. La compresión destruye Nivel 4.
- **Recurso visual + disposición del texto:** Elegir del Catálogo de recursos visuales. Especificar en BRIEF DISEÑO:
  -  — código del catálogo (foto-contextual, video-en-monitor, galería-netflix, sección-transversal, animación-de-trayecto, mapa-de-zona, dato-prominente, panel-de-instrumento, diagrama-esquemático, antes-después)
  -  — cómo se organizan los elementos de texto sobre ese recurso: , , , , 
  - **Verificar variedad:** ¿es el mismo recurso que la slide anterior? Si es la tercera consecutiva igual → cambiar

**TÉCNICO:**
- Copiar verbatim del BBOK todos los valores, tolerancias, normas ISO/ANSI, fórmulas y nombres de componentes que deben aparecer en el visual
- Nunca parafrasear datos técnicos — el diseñador no conoce el dominio
- Especificar la secuencia de animación como si fuera un guión de cine: qué se mueve, en qué orden, qué revela la animación

**EJEMPLO:**
- Incluir el contexto real del caso: equipo específico, operación concreta, consecuencia real
- El visual debe ser reconocible para el participante — su industria, sus máquinas, su entorno
- Si el ejemplo corresponde a una actividad práctica del Esquema, copiar exactamente el título de la actividad y conservar la duración definida en el Esquema.

**ACTIVIDAD:**
- Usar cuando el Esquema define explícitamente un momento práctico (`P`) con nombre de actividad.
- Copiar el título exactamente como aparece en el Esquema, incluyendo prefijos como `Actividad:` si existen.
- No renombrar la actividad para hacerla más atractiva o visual.
- La observación de trazabilidad debe indicar: `Fuente Esquema; actividad práctica obligatoria`.

### 6. Guardar outputs

1. Guardar en Engram: `topic_key: ldd/{código}/presentacion`
2. Guardar archivo: `03_Creación/borrador-presentacion.md`

> Para cursos con más de 60 slides, generar por tópico. Confirmar con el usuario cuándo avanzar al siguiente tópico.

---

## Outputs

### Archivo: `03_Creación/borrador-presentacion.md`

```markdown
# Brief de Presentación — [Código] [Nombre del curso]

**Versión:** v1 | **Fecha:** [fecha] | **Estado:** Borrador — pendiente aprobación
**Instruccional:** [nombre] | **Diseñador asignado:** [nombre o "por asignar"]

> **Instrucciones para el equipo de diseño:**
> Este documento es el brief formal de la presentación. Cada slide tiene
> historia visual, texto exacto en pantalla, especificaciones de diseño y
> secuencia de animación. No se requieren reuniones adicionales para comenzar —
> si hay dudas técnicas, referirse al BBOK del curso antes de consultar al instruccional.

---

## Tema Visual del Curso

**Nombre:** [nombre del tema]
**Concepto:** [metáfora central]
**Paleta:** [colores]
**Elementos recurrentes:** [objetos, texturas, iconografía]
**Referencia:** [descripción del ambiente visual]

---

## Arquitectura de Slides

| # | Tipo | Título BBOK exacto | Tópico fuente | Resumen del slide | Min. aprox. | Observación de trazabilidad |
|---|---|---|---|---|---|---|
| 1 | PORTADA | [nombre exacto del curso] | — | Portada institucional del curso | — | Portada institucional |
...
| N | CIERRE | Síntesis del curso | — | [concepto 1] · [concepto 2] · [concepto 3] | — | Cierre institucional |
**Total: N slides**

---

## Briefs por Slide

---

### Slide 1 — PORTADA — [Nombre exacto del curso]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Título principal | [NOMBRE DEL CURSO EN MAYÚSCULAS] | Centro |
| Subtítulo | [Cliente o programa] | Bajo el título |
| Logo Ingnovarte | — | Esquina inferior derecha |
| Identificador curso | [Código] | Esquina inferior izquierda |

**HISTORIA VISUAL**
El participante entra al "mundo" del curso — el ambiente visual les dice en qué contexto están antes de leer una sola palabra.

**BRIEF DISEÑO**
- Escena: [descripción completa del fondo según el tema visual del curso]
- Composición: Título centrado con jerarquía clara sobre el visual de fondo
- Sin elementos de contenido — esta slide es pura identidad visual del curso
- Paleta: [referencia al tema visual]

**SECUENCIA DE ANIMACIÓN**
1. Fondo/escena aparece (fade o build según el tema)
2. Título entra (efecto definido por el tema)
3. Subtítulo y logos aparecen

**NOTA FACILITADOR**
[Cómo abre el instructor la sesión — presentación personal, contexto del curso, duración]

---

### Slide 2 — AGENDA — Contenido del curso

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | CONTENIDO | Superior centrado |
| Tópico 1 | [título exacto del tópico 1 en BBOK] | [contenedor visual 1] |
| Tópico 2 | [título exacto del tópico 2 en BBOK] | [contenedor visual 2] |
| Tópico N | [título exacto del tópico N en BBOK] | [contenedor visual N] |

**HISTORIA VISUAL**
El participante ve el mapa completo del viaje que va a recorrer.

**BRIEF DISEÑO**
- Escena: Fondo del tema visual. Los tópicos aparecen como [contenedores visuales coherentes con el tema — ej: tarjetas, módulos tech, notas, capítulos de mapa]
- Cada tópico en su propio contenedor visual, sin duración — solo el nombre
- No usar viñetas ni lista plana — cada tópico es un elemento visual independiente

**SECUENCIA DE ANIMACIÓN**
1. Header "CONTENIDO" aparece
2. Tópicos aparecen secuencialmente (uno a uno, izquierda a derecha o arriba a abajo)

**NOTA FACILITADOR**
[Cómo presenta el instructor la agenda — qué destacar del recorrido del curso]

---

### Slide [N] — DIVISOR — [Título exacto del tópico BBOK]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Número de tópico | [N] | Esquina o área secundaria |
| Título del tópico | [TÍTULO EXACTO DEL TÓPICO BBOK] | Centro o posición dominante |

**HISTORIA VISUAL**
Una transición visual clara — el participante sabe que empieza una nueva sección.

**BRIEF DISEÑO**
- Escena: Versión "capitular" del tema visual — más impactante que las slides de contenido
- Solo el título del tópico y su número — sin contenido adicional
- Puede incluir una imagen icónica del tópico [descripción específica de la imagen]

**SECUENCIA DE ANIMACIÓN**
1. Escena de fondo construye
2. Número de tópico aparece
3. Título entra con efecto de impacto

**NOTA FACILITADOR**
[Transición verbal: cómo conecta el instructor el tópico anterior con este]

---

### Slide [N] — CONCEPTO — [Título BBOK exacto]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| [Etiqueta 1] | [término o frase verbatim del BBOK — ≤ 6 palabras] | [posición] |
| [Etiqueta 2] | [término o frase verbatim del BBOK — ≤ 6 palabras] | [posición] |
| [Concepto clave] | [definición o requisito tomado textualmente del BBOK] | [posición dominante] |

*Máximo 6 elementos de texto en pantalla. Todo texto proviene del BBOK — no parafrasear.*

**PREGUNTA DEL APRENDIZ**
[¿Qué pregunta implícita tiene el participante en este punto del curso que esta slide responde? Una frase. Ej: "¿Cuándo exactamente aplica esta restricción?". Si no puedes formularla, el contenido de la slide no está enfocado aún.]

**HISTORIA VISUAL**
[Una frase: qué hace ver/sentir esta slide al participante. No qué explica — qué muestra.]

**BRIEF DISEÑO**
- Imagen BBOK: [ruta relativa si el BBOK fuente tiene una imagen para esta sección — ej: `02_Esquema/bbok-images/media/image3.png`. Si no hay imagen BBOK, escribir `N/A`. Cuando existe, usarla como referencia visual base o como imagen del slide.]
- Recurso visual: [código del catálogo — foto-contextual | video-en-monitor | galería-netflix | sección-transversal | animación-de-trayecto | mapa-de-zona | dato-prominente | panel-de-instrumento | diagrama-esquemático | antes-después]
- Imagen multimedia: [**Solo cuando `Recurso visual = foto-contextual`**. Si el `media_index` está cargado: buscar la entrada más relevante usando keywords del contenido del slide contra `(description + tags).lower()` → escribir el `rel_path` de la mejor coincidencia. Si no hay índice o score = 0: escribir `N/A`. Ejemplo: `Fotografías/Operaciones mineras/General/Camión de acarreo de carbón en operaciones mineras (2).jpg`]
- Disposición del texto: [label-visual | lista-enumerada | comparativo | flujo-animado | libre]
- Descripción visual: [40–60 palabras. **Si `Imagen multimedia` tiene valor**: basar la descripción en la imagen real seleccionada — usar su campo `description` del índice como punto de partida y ampliar con composición, jerarquía visual y emoción. **Si `N/A`**: describir el visual ideal — qué elemento domina el espacio, qué color/forma/posición define el layout, qué jerarquía tiene el texto, qué emoción transmite. Ejemplo válido: "Primer plano de un panel de control con indicadores en rojo. Operador de espaldas en el tercio izquierdo, creando tensión. Etiquetas técnicas en tipografía blanca flotan sobre los indicadores en el tercio derecho, sobre fondo oscuro." — "imagen industrial técnica" NO es válido.]
- Punto de atención: [qué elemento debe capturar el ojo primero — el diseñador lo jerarquiza con tamaño, contraste o posición]
- Conexiones visuales: [flechas, líneas, hilos, relaciones entre elementos si aplica]
- Paleta: [colores dominantes — con valores HEX del tema visual]
- Checklist dual-coding:
  - [ ] Multimedia: ¿el visual expresa algo que las palabras solas no pueden?
  - [ ] Estructura cognitiva: ¿el tipo de diagrama refleja la organización del concepto? (causal → causa-efecto | secuencial → flujo/línea de tiempo | jerárquico → árbol | espacial → posicional | comparativo → lado a lado)
  - [ ] Contigüidad: ¿los labels están posicionados sobre el diagrama? Nunca en leyenda separada.
  - [ ] Coherencia: ¿cada elemento visual tiene función informativa? Eliminar decorativos.
  - [ ] Señalización: ¿cada color codifica un significado específico?

**HUELLA BBOK**
[IDs del BBOK cubiertos por esta slide — ej: T3-001, T3-002. Si no hay bbok-segmentado disponible, omitir este campo.]

**SECUENCIA DE ANIMACIÓN**
1. [Primer elemento — establece el contexto]
2. [Segundo elemento — introduce la tensión o el concepto]
3. [Elemento final — el punto de llegada, lo que el instructor va a explicar]

**NOTA FACILITADOR**
[Lo que dice el instructor en esta slide — frases clave, preguntas al grupo, conexión con experiencia del participante. 2–4 oraciones.]

---

### Slide [N] — TÉCNICO — [Título BBOK exacto]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | [título BBOK exacto] | Superior |
| Label técnico 1 | [dato exacto del BBOK] | [posición sobre el diagrama] |
| Label técnico 2 | [dato exacto del BBOK] | [posición sobre el diagrama] |
| Unidades / norma | [unidad o referencia ISO/ANSI] | [posición] |

**HISTORIA VISUAL**
[Qué entiende el participante al ver esta animación o diagrama — la función, el flujo, el principio físico.]

**BRIEF DISEÑO**
- Imagen BBOK: [ruta relativa si el BBOK fuente tiene un diagrama o imagen para esta sección — ej: `02_Esquema/bbok-images/media/image5.png`. Si existe, es el diagrama técnico validado por el SME y debe usarse como base o reemplazar la descripción del diagrama.]
- Diagrama/animación: [descripción precisa del componente o proceso — geometría, partes, colores por función. Si existe Imagen BBOK, describir cómo complementar o animar ESA imagen específica.]
- Datos técnicos a incluir verbatim del BBOK:
  - [valor 1: nombre + cifra + unidad tal como aparece en el BBOK]
  - [valor 2: ...]
  - [norma o estándar si aplica: ISO XXXX, SAE XXX, etc.]
- Posición de cada dato sobre el diagrama: [especificar con referencia a la geometría del visual]
- Color coding: [qué colores representan qué función — ej: azul = fluido a presión, rojo = retorno, gris = estructura]
- HUELLA BBOK: [IDs del BBOK cubiertos por esta slide — ej: T3-014, T3-015. Si no hay bbok-segmentado disponible, omitir.]

**SECUENCIA DE ANIMACIÓN**
1. [Estado inicial del sistema/componente]
2. [Primera acción — qué se activa, qué fluye, qué se mueve]
3. [Consecuencia visible — el efecto físico que el instructor está explicando]
4. [Labels y datos aparecen sobre los elementos ya en movimiento]

**NOTA FACILITADOR**
[Lo que dice el instructor mientras la animación corre — qué señalar, qué preguntar. Incluir las frases técnicas exactas que corresponden a los términos del BBOK.]

---

### Slide [N] — EJEMPLO — [Título BBOK exacto de la actividad, caso o ejercicio]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Contexto | [situación en ≤ 8 palabras] | Header o panel superior |
| Dato del caso | [valor o condición del ejemplo] | Área principal |
| Pregunta / consigna | [lo que se pide al participante] | Panel inferior o destacado |

**HISTORIA VISUAL**
[El participante reconoce la situación — es su trabajo, su máquina, su turno.]

**BRIEF DISEÑO**
- Escena: [contexto real del caso — equipo específico, operación concreta, ambiente reconocible para el participante]
- Datos del ejemplo: [copiar verbatim los valores del BBOK o del esquema que corresponden a este ejercicio]
- Si incluye cálculo o solución: tipografía matemática clara, pasos numerados sobre fondo de panel

**SECUENCIA DE ANIMACIÓN**
1. Escena / contexto aparece
2. Datos del caso se revelan
3. Pregunta o consigna aparece (el instructor pausa aquí para el trabajo del participante)

**NOTA FACILITADOR**
[Instrucción de facilitación: cuánto tiempo dar, cómo debrief, respuesta esperada.]

---

### Slide [N] — ACTIVIDAD — [Título exacto del Esquema]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | [título exacto del Esquema] | Superior |
| Consigna | [instrucción breve para participantes] | Área principal |
| Tiempo | [duración exacta del Esquema] | Esquina o panel secundario |

**HISTORIA VISUAL**
[Una frase: qué situación práctica reconoce el participante y qué decisión debe tomar.]

**BRIEF DISEÑO**
- Escena: [contexto real de la actividad según el Esquema y la Lluvia de Ideas]
- Materiales: [materiales indicados para la actividad, si existen]
- Trazabilidad: Fuente Esquema; actividad práctica obligatoria

**SECUENCIA DE ANIMACIÓN**
1. Escena / contexto aparece
2. Consigna de la actividad aparece
3. Tiempo y materiales aparecen antes de iniciar la práctica

**NOTA FACILITADOR**
[Cómo organiza la actividad, cuánto tiempo da, cómo recoge respuestas y cómo hace el debrief.]

---

### Slide [N] — CIERRE — [Título BBOK exacto o Síntesis del curso]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | ¿Qué aprendimos? | Superior |
| Punto 1 | [concepto clave verbatim del BBOK — ≤ 6 palabras] | [posición en visual] |
| Punto 2 | [concepto clave verbatim del BBOK — ≤ 6 palabras] | [posición en visual] |
| Punto 3 | [concepto clave verbatim del BBOK — ≤ 6 palabras] | [posición en visual] |

**HISTORIA VISUAL**
El participante ve los conceptos clave del tópico/curso conectados — el mapa mental de lo aprendido.

**BRIEF DISEÑO**
- Los puntos clave como elementos visuales independientes dentro del tema — no como lista plana
- Conexiones visuales entre conceptos si hay una relación importante que mostrar
- Paleta: versión de cierre del tema visual (puede ser más oscura o más "completa" que las slides de contenido)

**SECUENCIA DE ANIMACIÓN**
1. Header aparece
2. Puntos clave aparecen secuencialmente mientras el instructor los recorre verbalmente
3. Conexiones visuales se revelan al final

**NOTA FACILITADOR**
[Cómo facilita el instructor la síntesis — preguntas al grupo, conexión con los objetivos del curso, cierre emotivo si aplica.]

---

## Resumen de Slides

| # | Tipo | Título BBOK exacto | Tópico fuente | Resumen del slide | Observación de trazabilidad |
|---|---|---|---|---|---|
| 1 | PORTADA | [nombre exacto del curso] | — | Portada institucional del curso | Portada institucional |
| 2 | AGENDA | [títulos exactos de tópicos BBOK] | — | [Tópico 1] · [Tópico 2] · [Tópico N] | Agenda construida solo con tópicos BBOK |
| 3 | DIVISOR | [título exacto del Tópico 1 en BBOK] | Tópico 1 | Separador de tópico | Divisor del tópico fuente |
| ... | | | | | |
| N | CIERRE | Síntesis del curso | — | [concepto 1] · [concepto 2] · [concepto 3] | Cierre institucional |

**Total: [N] slides**
**Distribución por tipo:** PORTADA: 1 | AGENDA: 1 | DIVISOR: X | CONCEPTO: X | TÉCNICO: X | EJEMPLO: X | ACTIVIDAD: X | CIERRE: X
```

---

## Limits

- **Sin bullets en pantalla.** El texto en pantalla son etiquetas posicionadas, no listas. **Máximo 3 bullets × 7 palabras por slide CONCEPTO.** Si el contenido del párrafo BBOK supera esa densidad → crear slides adicionales (Parte 1, Parte 2) antes que comprimir. La compresión es el camino de regreso a Nivel 3. Paneles de definición o requisitos directos del BBOK: ≤ 15 palabras por elemento.
- **Pregunta del aprendiz en cada CONCEPTO.** Antes de redactar el texto de la slide, identificar en una frase la pregunta implícita del participante que esta slide responde. Si no puede formularse, el enfoque del contenido es incorrecto — revisar qué dice el párrafo BBOK fuente.
- **Sin datos técnicos parafraseados.** Los valores, tolerancias, normas, fórmulas y nombres de componentes se copian verbatim del BBOK. El diseñador no conoce el dominio.
- **Sin descripciones visuales genéricas.** "Imagen industrial", "foto de equipo", "gráfico representativo" no son briefs válidos. Cada elemento visual debe describirse con suficiente detalle para que el diseñador lo cree sin preguntar.
- **La animación es parte del contenido, no decoración.** Todo slide TÉCNICO y CONCEPTO debe tener secuencia de animación especificada. El orden en que aparecen los elementos es el orden en que el instructor construye la explicación.
- **Un párrafo-título por slide (Nivel 4).** Cada encabezado de párrafo del BBOK = 1 slide propia. Si el párrafo genera más de 6 elementos de texto, dividir en Parte 1 / Parte 2. Si dos párrafo-títulos consecutivos son muy cortos y relacionados, pueden agruparse — pero solo en ese caso.
- **El instructor es el protagonista.** La slide no explica — muestra. La NOTA FACILITADOR contiene la explicación; el BRIEF DISEÑO contiene lo que se ve en pantalla.
- **Cursos > 60 slides:** generar por tópico, confirmando con el usuario antes de avanzar al siguiente.
- **Variedad visual obligatoria.** No repetir el mismo recurso visual más de 2 veces consecutivas. Un tópico con 8+ slides CONCEPTO debe usar al menos 4 recursos distintos del catálogo. Uniformidad visual = falla de diseño.
- **Dual-coding obligatorio en CONCEPTO.** Antes de finalizar cada BRIEF DISEÑO, verificar los 5 principios: (1) el visual expresa algo que el texto solo no puede; (2) el tipo de diagrama refleja la organización cognitiva del concepto (causal/secuencial/jerárquico/espacial/comparativo); (3) los labels van sobre el diagrama, nunca en leyenda; (4) sin elementos decorativos — todo aporta información; (5) los colores codifican significado, no estética.
- **Huella BBOK obligatoria cuando existe bbok-segmentado.** Si el Engram del curso contiene `ldd/{código}/bbok-segmentado`, cada slide CONCEPTO y TÉCNICO debe declarar su HUELLA BBOK. Un slide sin Huella en ese contexto es un error de trazabilidad, no un campo opcional. Los slides estructurales (PORTADA, AGENDA, DIVISOR, ACTIVIDAD, CIERRE) están exentos.

---

## Plan Update

Al finalizar la generación del brief de presentación:

1. Marca al 100% las siguientes tareas en `07_Planeación/plan-gestion.md`:
   - ITEM 23 — Elaboración contenido de la Presentación indicando estilo, tipos de animación, gráficos deseados
   - ITEM 24 — Revisión y ajustes del contenido de la presentación por Tópico
2. Recalcula SPI de cada tarea marcada: SPI = 1,0
3. Recalcula SPI Global = EV acumulado ÷ PV de tareas cuyo FIN ya pasó
4. Actualiza el Resumen EVM en el encabezado del plan
5. Informa: "Tareas 23 y 24 marcadas ✅ en el plan. SPI Global: {valor}"

---

## Nota para versiones futuras

`ldd-esquema` debería generar el tema visual del curso como parte de su output
(topic_key: `ldd/{código}/tema-visual`), integrando al instruccional y al equipo de
diseño en esa decisión durante la fase de esquema. Mientras esa mejora no esté
implementada, `ldd-storyboard` maneja la propuesta del tema visual en su paso 2.
