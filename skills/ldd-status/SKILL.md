---
name: ldd-status
description: Recibe del usuario el avance de una o más tareas del plan de gestión, actualiza el porcentaje de completitud y recalcula el SPI global del curso.
triggers:
  - ldd-status
  - actualizar plan
  - marcar tarea
  - reportar avance
  - cerrar tarea
  - actualizar progreso
  - registrar avance
  - ¿cómo vamos en el plan?
  - estado del plan
  - SPI del curso
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El usuario reporta avance en actividades del plan de gestión (ej: "las entrevistas están listas", "terminamos el diseño gráfico")
- El usuario quiere ver el estado actual del plan y el SPI global
- El usuario quiere marcar tareas manualmente sin generar ningún artefacto LDD

No uses esta skill para:
- Generar artefactos LDD — eso lo hacen las skills específicas de cada fase
- Crear o reinicializar el plan — eso lo hace `ldd-init`

---

## Steps

### Modo A — Reportar avance (el usuario indica qué avanzó)

1. Recibe del usuario:
   - Qué actividad o tarea avanzó (en lenguaje natural o número de ITEM)
   - Porcentaje de avance (ej: 100%, 50%, parcial)
   - Si no especifica el porcentaje: preguntar si está completa o parcialmente lista

2. Lee `07_Planeación/plan-gestion.md` del curso activo

3. Mapea la descripción del usuario contra las tareas del plan (por nombre o ITEM#)

4. Confirma con el usuario antes de escribir:
   > "Voy a marcar las siguientes tareas:
   > - ITEM X — {nombre}: {%} → {nuevo %}
   > ¿Confirmas?"

5. Actualiza el archivo con los nuevos valores de %

6. Recalcula SPI por tarea (ver fórmula abajo)

7. Recalcula SPI Global (ver fórmula abajo)

8. Actualiza el Resumen EVM en el encabezado del plan

9. Responde con el resumen del estado actualizado

### Modo B — Consultar estado (el usuario pregunta cómo va el plan)

1. Lee `07_Planeación/plan-gestion.md` del curso activo

2. Calcula:
   - Total de tareas completadas (% = 100%)
   - Total de tareas en progreso (0% < % < 100%)
   - Total de tareas no iniciadas (% = 0%)
   - SPI Global actual

3. Responde con el resumen del estado, destacando:
   - Tareas vencidas (FIN ya pasó y % < 100%)
   - Tareas en riesgo (FIN próximo y % < 50%)
   - SPI Global y su interpretación

---

## Fórmulas EVM

### SPI por tarea
```
Si tarea al 100% → SPI = 1,0
Si tarea en progreso o no iniciada y FIN ya pasó → SPI = % completado / 100
Si tarea no iniciada y FIN es futuro → SPI = "-"
```

### SPI Global
```
EV = suma de PV de todas las tareas × (% / 100)
PV_due = suma de PV de tareas cuyo FIN ya pasó (o es hoy)
SPI Global = EV / PV_due

Si PV_due = 0 → SPI Global = "-" (ninguna tarea ha vencido aún)
```

### Interpretación del SPI Global
| Rango | Interpretación |
|---|---|
| SPI ≥ 1,0 | En tiempo o adelantado |
| 0,8 ≤ SPI < 1,0 | Leve retraso — vigilar |
| 0,6 ≤ SPI < 0,8 | Retraso significativo — tomar acción |
| SPI < 0,6 | Retraso crítico — revisar plan con el equipo |

---

## Output — Resumen de actualización

```
## Estado del plan — {CÓDIGO} {NOMBRE}
Fecha de corte: {fecha actual}

### Cambios aplicados
| ITEM | Tarea | % Anterior | % Nuevo | SPI |
|---|---|---|---|---|
| X | {nombre} | 0% | 100% | 1,0 |

### Resumen EVM actualizado
| Indicador | Valor |
|---|---|
| PV Total | 39,0 |
| EV Acumulado | {valor} |
| PV Due (vencido a hoy) | {valor} |
| **SPI Global** | **{valor}** |

### Tareas en riesgo
- ITEM X — {nombre}: FIN {fecha}, avance actual {%}%
```

---

## Limits

- Nunca actualizar el plan sin confirmación explícita del usuario
- Si el usuario dice que una tarea está "casi lista" o "en proceso": preguntar el % exacto antes de escribir
- Si el ITEM referenciado no existe en el plan: informar al usuario y no modificar el archivo
- Si no hay `07_Planeación/plan-gestion.md`: informar que el curso necesita inicializarse con `ldd-init`
- No recalcular SPI si no hay tareas vencidas aún (PV_due = 0) — reportar como "-" con nota explicativa
