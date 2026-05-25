---
name: ldd-presentacion
description: Genera el borrador completo de la presentación del curso — slide por slide — como documento formal de brief para el equipo de diseño gráfico, con historia visual, texto en pantalla, especificaciones técnicas y secuencia de animación por slide.
triggers:
  - borrador presentación
  - presentación del curso
  - diapositivas
  - slides
  - generar presentación
  - storyboard presentación
  - brief para diseño
  - brief diseño gráfico
  - contenido para diseño gráfico
metadata:
  version: "2.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
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

## Inputs requeridos

| Input | Fuente | Obligatorio |
|---|---|---|
| BBOK | Engram `ldd/{código}/bbok` | ✅ Sí |
| Esquema minuto a minuto | Engram `ldd/{código}/esquema` | ✅ Sí |
| Tema visual del curso | Engram `ldd/{código}/tema-visual` | ⚠️ Si no existe, se propone en el paso 2 |

---

## Steps

### 1. Verificar prerequisitos

Buscar en Engram:
- `ldd/{código}/bbok` — si no existe, detener y pedir al usuario ejecutar `ldd-bbok` primero
- `ldd/{código}/esquema` — si no existe, detener y pedir al usuario ejecutar `ldd-esquema` primero

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

Basarse en el Esquema minuto a minuto:

1. Contar los tópicos principales y sus duraciones
2. Calcular slides de contenido: **1 slide cada 3–4 minutos de contenido activo** (no contar actividades ni evaluaciones)
3. Sumar estructura fija:
   - 1 slide PORTADA
   - 1 slide AGENDA
   - 1 slide DIVISOR por cada tópico principal
   - 1 slide CIERRE/SÍNTESIS
4. Producir tabla de arquitectura antes de generar los briefs:

```markdown
| # | Tipo | Concepto | Tópico | Min. aprox. |
|---|---|---|---|---|
| 1 | PORTADA | Nombre del curso | — | — |
| 2 | AGENDA | Tabla de contenido | — | — |
| 3 | DIVISOR | Nombre Tópico 1 | Tópico 1 | — |
| 4 | CONCEPTO | [concepto] | Tópico 1 | 3 |
...
```

Mostrar la arquitectura al usuario y pedir confirmación antes de generar todos los briefs.

### 4. Clasificar cada slide por tipo

Usar la siguiente taxonomía:

| Tipo | Cuándo usar |
|---|---|
| **PORTADA** | Slide de apertura — solo nombre del curso, cliente, logo |
| **AGENDA** | Tabla de contenido con los tópicos del curso |
| **DIVISOR** | Separador entre tópicos — visual completo, solo título del tópico |
| **CONCEPTO** | Idea, principio o definición expresada mediante metáfora visual |
| **TÉCNICO** | Diagrama, tabla, animación de componente o proceso — requiere datos exactos del BBOK |
| **EJEMPLO** | Caso real, escenario operativo, ejercicio o situación de aplicación |
| **CIERRE** | Síntesis del tópico o del curso — puntos clave visualizados |

### 5. Generar el brief por slide

Para cada slide, producir el bloque completo según el formato de output. Ver sección **Outputs**.

**Reglas por tipo de slide:**

**PORTADA / AGENDA / DIVISOR:**
- Mínimo texto — solo títulos y etiquetas de navegación
- El visual define el "mundo" del curso
- El DIVISOR debe sentirse como "entrar a un nuevo capítulo"

**CONCEPTO:**
- La slide MUESTRA la idea visualmente antes de que el instructor la explique
- El texto en pantalla son etiquetas que anclan el visual, no la explicación
- Identificar la metáfora que mejor comunica el concepto en el contexto industrial del participante

**TÉCNICO:**
- Copiar verbatim del BBOK todos los valores, tolerancias, normas ISO/ANSI, fórmulas y nombres de componentes que deben aparecer en el visual
- Nunca parafrasear datos técnicos — el diseñador no conoce el dominio
- Especificar la secuencia de animación como si fuera un guión de cine: qué se mueve, en qué orden, qué revela la animación

**EJEMPLO:**
- Incluir el contexto real del caso: equipo específico, operación concreta, consecuencia real
- El visual debe ser reconocible para el participante — su industria, sus máquinas, su entorno

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

| # | Tipo | Concepto | Tópico | Min. aprox. |
|---|---|---|---|---|
| 1 | PORTADA | [nombre del curso] | — | — |
...
| N | CIERRE | Síntesis | — | — |
**Total: N slides**

---

## Briefs por Slide

---

### Slide 1 — PORTADA — [Nombre del curso]

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
| Tópico 1 | [nombre tópico 1] | [contenedor visual 1] |
| Tópico 2 | [nombre tópico 2] | [contenedor visual 2] |
| Tópico N | [nombre tópico N] | [contenedor visual N] |

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

### Slide [N] — DIVISOR — [Nombre del Tópico]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Número de tópico | [N] | Esquina o área secundaria |
| Título del tópico | [NOMBRE DEL TÓPICO] | Centro o posición dominante |

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

### Slide [N] — CONCEPTO — [Nombre del concepto]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| [Etiqueta 1] | [texto ≤ 6 palabras] | [posición] |
| [Etiqueta 2] | [texto ≤ 6 palabras] | [posición] |
| [Concepto clave] | [frase central — puede ser 1 oración] | [posición dominante] |

*Máximo 6 elementos de texto en pantalla.*

**HISTORIA VISUAL**
[Una frase: qué hace ver/sentir esta slide al participante. No qué explica — qué muestra.]

**BRIEF DISEÑO**
- Escena: [descripción específica del fondo/ambiente — dentro del tema visual del curso]
- Elemento principal: [objeto, fotografía o composición que vehicula el concepto — descripción precisa, no genérica. "Fotografía de un operador minero mirando hacia abajo desde una berma" es válido. "Imagen industrial" NO es válido.]
- Elemento secundario: [descripción + posición en pantalla]
- Conexiones visuales: [flechas, líneas, hilos, relaciones entre elementos si aplica]
- Paleta: [colores dominantes — referencia al tema visual]

**SECUENCIA DE ANIMACIÓN**
1. [Primer elemento — establece el contexto]
2. [Segundo elemento — introduce la tensión o el concepto]
3. [Elemento final — el punto de llegada, lo que el instructor va a explicar]

**NOTA FACILITADOR**
[Lo que dice el instructor en esta slide — frases clave, preguntas al grupo, conexión con experiencia del participante. 2–4 oraciones.]

---

### Slide [N] — TÉCNICO — [Nombre del componente o proceso]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | [nombre del componente/proceso] | Superior |
| Label técnico 1 | [dato exacto del BBOK] | [posición sobre el diagrama] |
| Label técnico 2 | [dato exacto del BBOK] | [posición sobre el diagrama] |
| Unidades / norma | [unidad o referencia ISO/ANSI] | [posición] |

**HISTORIA VISUAL**
[Qué entiende el participante al ver esta animación o diagrama — la función, el flujo, el principio físico.]

**BRIEF DISEÑO**
- Diagrama/animación: [descripción precisa del componente o proceso — geometría, partes, colores por función]
- Datos técnicos a incluir verbatim del BBOK:
  - [valor 1: nombre + cifra + unidad tal como aparece en el BBOK]
  - [valor 2: ...]
  - [norma o estándar si aplica: ISO XXXX, SAE XXX, etc.]
- Posición de cada dato sobre el diagrama: [especificar con referencia a la geometría del visual]
- Color coding: [qué colores representan qué función — ej: azul = fluido a presión, rojo = retorno, gris = estructura]

**SECUENCIA DE ANIMACIÓN**
1. [Estado inicial del sistema/componente]
2. [Primera acción — qué se activa, qué fluye, qué se mueve]
3. [Consecuencia visible — el efecto físico que el instructor está explicando]
4. [Labels y datos aparecen sobre los elementos ya en movimiento]

**NOTA FACILITADOR**
[Lo que dice el instructor mientras la animación corre — qué señalar, qué preguntar. Incluir las frases técnicas exactas que corresponden a los términos del BBOK.]

---

### Slide [N] — EJEMPLO — [Nombre del caso o ejercicio]

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

### Slide [N] — CIERRE — [Síntesis del tópico o del curso]

**TEXTO EN PANTALLA**
| Elemento | Texto | Posición |
|---|---|---|
| Header | ¿Qué aprendimos? | Superior |
| Punto 1 | [concepto clave — ≤ 6 palabras] | [posición en visual] |
| Punto 2 | [concepto clave — ≤ 6 palabras] | [posición en visual] |
| Punto 3 | [concepto clave — ≤ 6 palabras] | [posición en visual] |

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

| # | Tipo | Concepto | Tópico |
|---|---|---|---|
| 1 | PORTADA | [nombre del curso] | — |
| 2 | AGENDA | Contenido | — |
| 3 | DIVISOR | [Tópico 1] | Tópico 1 |
| ... | | | |
| N | CIERRE | Síntesis | — |

**Total: [N] slides**
**Distribución por tipo:** PORTADA: 1 | AGENDA: 1 | DIVISOR: X | CONCEPTO: X | TÉCNICO: X | EJEMPLO: X | CIERRE: X
```

---

## Limits

- **Sin bullets en pantalla.** El texto en pantalla son etiquetas posicionadas, no listas. Máximo 6 elementos de texto por slide. Cada elemento: ≤ 6 palabras, salvo paneles de definición (1–2 oraciones) y celdas de tabla técnica.
- **Sin datos técnicos parafraseados.** Los valores, tolerancias, normas, fórmulas y nombres de componentes se copian verbatim del BBOK. El diseñador no conoce el dominio.
- **Sin descripciones visuales genéricas.** "Imagen industrial", "foto de equipo", "gráfico representativo" no son briefs válidos. Cada elemento visual debe describirse con suficiente detalle para que el diseñador lo cree sin preguntar.
- **La animación es parte del contenido, no decoración.** Todo slide TÉCNICO y CONCEPTO debe tener secuencia de animación especificada. El orden en que aparecen los elementos es el orden en que el instructor construye la explicación.
- **Un concepto por slide.** Si hay dos ideas, son dos slides. Si una animación tiene más de 4 pasos, puede necesitar dos slides.
- **El instructor es el protagonista.** La slide no explica — muestra. La NOTA FACILITADOR contiene la explicación; el BRIEF DISEÑO contiene lo que se ve en pantalla.
- **Cursos > 60 slides:** generar por tópico, confirmando con el usuario antes de avanzar al siguiente.

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
implementada, `ldd-presentacion` maneja la propuesta del tema visual en su paso 2.
