---
name: ldd-informe
description: Genera informes de retroalimentación post-entrenamiento o informes de eficacia del ciclo de evaluación, a partir de datos de retroalimentación y resultados de evaluación.
triggers:
  - informe de retroalimentación
  - informe de eficacia
  - informe del entrenamiento
  - análisis de resultados
  - resultados de evaluación
  - encuestas de satisfacción resultados
  - verificación de eficacia
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- Tienes datos de retroalimentación del entrenamiento (notas del instructor, comentarios de participantes, dudas frecuentes) → genera **Informe de Retroalimentación**
- Tienes resultados de evaluaciones pre/post y encuestas de satisfacción → genera **Informe de Eficacia**

No uses esta skill para:
- Diseñar los instrumentos de evaluación (usa `ldd-evaluaciones`)
- Generar el resumen ejecutivo del proyecto completo (eso es una comunicación al cliente diferente)

## Steps

### Modo A — Informe de Retroalimentación (fase Actualización)

1. **Verificar prerequisitos**: confirmar que el entrenamiento fue ejecutado
2. **Recibir**: notas del instructor, comentarios de participantes, registro de dudas frecuentes, solicitudes de cambio
3. **Analizar y agrupar** por: contenido, metodología, materiales, logística
4. **Priorizar** por impacto en el aprendizaje: crítico / importante / sugerencia
5. **Generar recomendaciones** de ajuste para cada hallazgo prioritario
6. **Guardar en Engram**: `topic_key: ldd/{código}/informe-retro`

### Modo B — Informe de Eficacia (fase Evaluación)

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/evaluaciones` (resultados pre/post)
2. **Calcular indicadores**:
   - Ganancia de aprendizaje: (Post - Pre) / (100 - Pre) × 100
   - Puntaje promedio pre/post por tópico
   - Tasa de aprobación (si hay criterio de aprobación)
   - Promedio encuesta de satisfacción por dimensión
3. **Identificar brechas persistentes**: ítems o tópicos donde el post-test sigue bajo
4. **Generar conclusión** sobre pertinencia, eficacia y apropiación
5. **Guardar en Engram**: `topic_key: ldd/{código}/informe-eficacia`

## Outputs

### Informe de Retroalimentación

```markdown
# Informe de Retroalimentación — [Código] [Nombre del curso]
**Sesión:** [fechas] | **Participantes:** [N] | **Instructor:** [nombre]

## Resumen ejecutivo
[2-3 frases: qué salió bien, principales hallazgos, próxima acción]

## Hallazgos por dimensión

### Contenido
| Hallazgo | Prioridad | Recomendación |
|---|---|---|
| [hallazgo] | Crítico / Importante / Sugerencia | [acción específica] |

### Metodología / Actividades
| Hallazgo | Prioridad | Recomendación |
|---|---|---|

### Materiales (presentación, guías)
| Hallazgo | Prioridad | Recomendación |
|---|---|---|

### Logística
| Hallazgo | Prioridad | Recomendación |
|---|---|---|

## Dudas frecuentes identificadas
- [duda 1] — Tópico: [tópico]
- [duda 2]

## Solicitudes de cambio
| Cambio solicitado | Justificación | Impacto estimado |
|---|---|---|

## Próximos pasos
- [ ] [acción 1] — Responsable: | Fecha:
- [ ] [acción 2]
```

### Informe de Eficacia

```markdown
# Informe de Eficacia — [Código] [Nombre del curso]
**Período:** | **Participantes evaluados:** [N]

## Conclusión ejecutiva
[El entrenamiento fue / no fue pertinente / eficaz / apropiado porque...]

## Resultados de evaluación de aprendizaje

### Indicadores generales
| Indicador | Resultado |
|---|---|
| Promedio Pre-test | [X]% |
| Promedio Post-test | [X]% |
| Ganancia de aprendizaje | [X]% |
| Tasa de aprobación | [X]% |

### Resultados por tópico
| Tópico | Pre (%) | Post (%) | Ganancia | Observación |
|---|---|---|---|---|
| [Tópico 1] | | | | |
| [Tópico 2] | | | | |

### Brechas persistentes
| Ítem / Tópico | Resultado Post | Posible causa | Acción recomendada |
|---|---|---|---|

## Resultados de satisfacción
| Dimensión | Promedio (1-5) | Observación |
|---|---|---|
| Contenido | | |
| Metodología | | |
| Instructor | | |
| Aplicabilidad | | |
| **General** | | |

## Conclusión por criterio de Kirkpatrick
| Nivel | Evidencia | Resultado |
|---|---|---|
| Nivel 1 — Reacción | Encuesta de satisfacción | [resultado] |
| Nivel 2 — Aprendizaje | Pre/post test | [resultado] |
| Nivel 3 — Aplicación | [observación en campo si disponible] | [resultado / pendiente] |

## Insumos para el siguiente ciclo
- [recomendación para futura actualización del curso]
```

## Limits

- No inventar datos de evaluación — trabajar solo con lo que el usuario provee
- Marcar como `[Sin datos]` cualquier indicador que no se pueda calcular con la información disponible
- La ganancia de aprendizaje requiere resultados pre Y post del mismo grupo — no calcular con grupos diferentes
- El nivel 3 de Kirkpatrick (aplicación en campo) generalmente requiere observación posterior al curso — marcarlo como pendiente si no hay evidencia

## Plan Update

El informe no tiene una tarea propia en el plan de gestión estándar.
El orquestador activa el protocolo de seguimiento proactivo para verificar con el usuario si la generación del informe implica cerrar la tarea ITEM 39 (Ejecución de sesiones) u otras tareas de evaluación relacionadas.
