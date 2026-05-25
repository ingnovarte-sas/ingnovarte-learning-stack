---
name: ldd-review
description: Revisa cualquier entregable LDD para verificar calidad, alineación a la Ficha Técnica y coherencia pedagógica. Genera un reporte de revisión con hallazgos críticos, advertencias y sugerencias.
triggers:
  - revisar entregable
  - review
  - auditoría LDD
  - verificar calidad
  - revisar ficha
  - revisar BBOK
  - revisar esquema
  - revisar presentación
  - revisar evaluaciones
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- Terminas de generar cualquier artefacto LDD y quieres verificar su calidad antes de compartirlo
- Un miembro del equipo pide revisión de un entregable antes de enviarlo al cliente
- Hay dudas sobre si un entregable cumple con los estándares de Ingnovarte

Aplica a cualquier artefacto: Brief, Ficha Técnica, BBOK, BOK, Lluvia de Ideas, Esquema, Borrador Presentación, Guías, Evaluaciones, Informes.

## Steps

1. **Identificar el artefacto y el curso**: buscar en Engram el artefacto y la Ficha Técnica del curso
2. **Verificar campos mínimos** según la tabla de `ldd-phase-common.md`
3. **Verificar alineación**:
   - ¿Los tópicos del artefacto corresponden exactamente a los de la Ficha Técnica?
   - ¿Los objetivos referenciados corresponden a los objetivos específicos de la Ficha?
4. **Verificar coherencia pedagógica**:
   - ¿Las actividades son proporcionales al tiempo asignado?
   - ¿El nivel de profundidad es apropiado para la audiencia definida?
   - ¿La distribución teórico/práctico respeta la regla del 50%?
5. **Verificar restricciones operacionales**: ¿el artefacto respeta las restricciones de conectividad, nivel digital y tiempo?
6. **Clasificar hallazgos**: CRÍTICO / ADVERTENCIA / SUGERENCIA
7. **Generar el reporte de revisión**

## Outputs

```markdown
# Reporte de Revisión — [Artefacto] | [Código] [Nombre del curso]
**Revisado por:** stack Ingnovarte | **Fecha:**
**Veredicto:** ✅ Aprobado | ⚠️ Aprobado con advertencias | ❌ Requiere corrección

---

## Resumen
[1-2 frases con el resultado global y la acción recomendada]

---

## Hallazgos

### ❌ CRÍTICO — Requiere corrección antes de avanzar

| # | Hallazgo | Ubicación | Acción requerida |
|---|---|---|---|
| C1 | [descripción del problema crítico] | [sección / slide / ítem] | [qué hacer exactamente] |

### ⚠️ ADVERTENCIA — Revisar antes de entregar al cliente

| # | Hallazgo | Ubicación | Acción recomendada |
|---|---|---|---|
| W1 | | | |

### 💡 SUGERENCIA — Mejora de calidad (no bloqueante)

| # | Sugerencia | Ubicación | Beneficio |
|---|---|---|---|
| S1 | | | |

---

## Checklist de campos mínimos

| Campo mínimo | Presente | Observación |
|---|---|---|
| [campo 1] | ✅ / ❌ | |
| [campo 2] | ✅ / ❌ | |

---

## Próxima acción recomendada

- [ ] Corregir hallazgos críticos
- [ ] Revisar advertencias con el equipo
- [ ] [siguiente fase LDD]
```

## Clasificación de hallazgos

| Nivel | Descripción | Ejemplos |
|---|---|---|
| **CRÍTICO** | Bloquea avanzar a la siguiente fase o entregar al cliente | Tópicos que no coinciden con la ficha, objetivos sin ítems de evaluación, suma de minutos incorrecta |
| **ADVERTENCIA** | Reduce la calidad pero no bloquea | Supuestos sin marcar, contenido más profundo de lo que el tiempo permite, actividades sin materiales confirmados |
| **SUGERENCIA** | Mejora de calidad sin impacto en completitud | Redacción mejorable, ejemplos adicionales recomendados, variantes pedagógicas posibles |

## Limits

- Esta skill revisa estructura, alineación y coherencia — no valida la precisión técnica del contenido (eso requiere un SME humano)
- No modificar el artefacto revisado — solo generar el reporte; los cambios los hace el equipo
- Si no hay Ficha Técnica disponible, la revisión de alineación es limitada — indicarlo explícitamente
