---
name: ldd-bok
description: Genera el BOK (Body of Knowledge) final a partir del BBOK aprobado, expandiendo y refinando el contenido técnico para producción.
triggers:
  - BOK
  - BOK final
  - body of knowledge
  - contenido final
  - finalizar contenido
  - expandir BBOK
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El BBOK fue revisado y validado técnicamente (por el SME o el cliente)
- El Esquema está aprobado y define exactamente qué contenido entra en el curso
- Estás en la fase de Creación y necesitas el contenido definitivo

No uses esta skill para:
- Generar el borrador de contenido (usa `ldd-bbok`)
- Generar la presentación (usa `ldd-storyboard` — toma el BOK como insumo)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/bbok` y `ldd/{código}/esquema`
2. **Revisar el BBOK**: identificar las secciones marcadas como supuestos o pendientes de validación
3. **Incorporar retroalimentación técnica**: ajustar el contenido según revisiones del SME o del cliente
4. **Expandir el contenido**: desarrollar cada tópico a la profundidad que el Esquema exige (proporcional a los minutos asignados)
5. **Verificar alineación**: cada sección del BOK debe mapear a un tópico del Esquema
6. **Eliminar supuestos resueltos**: reemplazar los `[SUPUESTO]` con el dato confirmado; mantener los no resueltos marcados
7. **Guardar en Engram**: `topic_key: ldd/{código}/bok`

## Outputs

```markdown
# BOK — [Código] [Nombre del curso]
**Versión:** vF | **Fecha:** | **Estado:** Final / Listo para producción

> Validado técnicamente por: [nombre del SME / cliente] el [fecha]

---

## [Tópico 1 — exactamente como aparece en la Ficha Técnica]
*Duración en Esquema: [X] minutos*

### [Subtema 1]
[contenido técnico desarrollado y validado]

### [Subtema 2]
[contenido técnico]

#### Puntos clave
- [punto clave 1]
- [punto clave 2]

#### Errores frecuentes a evitar
- [error frecuente 1]

---

## [Tópico 2]
[misma estructura]
```

## Limits

- No generar el BOK sin validación técnica del BBOK — los datos técnicos específicos deben venir del SME
- La estructura de tópicos debe ser idéntica a la de la Ficha Técnica
- El nivel de profundidad de cada tópico debe ser proporcional a su duración en el Esquema
- Mantener marcados los supuestos no resueltos con `> **Pendiente de validación:**`

## Plan Update

El BOK final no tiene una tarea propia en el plan de gestión estándar (el plan registra el BBOK en ITEM 21).
El orquestador activa el protocolo de seguimiento proactivo para verificar con el usuario si la validación técnica del BBOK (previa al BOK) puede asociarse al cierre de alguna tarea pendiente.
