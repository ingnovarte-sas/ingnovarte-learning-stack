---
name: ldd-esquema
description: Genera el Esquema del curso — el minuto a minuto completo con secuencia de tópicos, actividades, tiempos y tipos de momento pedagógico.
triggers:
  - esquema
  - minuto a minuto
  - cronograma del curso
  - secuencia del curso
  - estructura del curso
  - esquema de sesión
metadata:
  version: "1.0"
  author: "ingnovarte"
  updated_at: "2026-05-25"
license: "proprietary"
---

## When to Use

Usa esta skill cuando:
- El BBOK y la Lluvia de Ideas están generados y al menos revisados internamente
- Necesitas construir la secuencia completa de un curso con tiempos por actividad
- Estás cerrando la fase de Esquema antes de pasar a Creación

No uses esta skill para:
- Generar actividades (usa `ldd-lluvia`)
- Generar el borrador de presentación (usa `ldd-storyboard`)

## Steps

1. **Verificar prerequisitos**: buscar en Engram `ldd/{código}/lluvia` y `ldd/{código}/ficha`
2. **Calcular tiempos base**:
   - Total de horas teóricas × 60 = minutos totales disponibles para contenido
   - Reservar tiempo para apertura, cierre y breaks si aplica
3. **Secuenciar tópicos**: ordenarlos de menor a mayor complejidad, garantizando que prerequisitos conceptuales precedan a los que los requieren
4. **Para cada tópico**, distribuir los minutos entre:
   - Momento teórico (exposición / presentación)
   - Momento práctico (actividad de la Lluvia de Ideas)
5. **Calcular porcentajes**: M (minutos de actividad) / duración total del tópico × 100
6. **Verificar la suma total**: la suma de todos los TOTAL debe igualar la duración total del curso en minutos
7. **Guardar en Engram**: `topic_key: ldd/{código}/esquema`

## Outputs

```markdown
# Esquema — [Código] [Nombre del curso]
**Versión:** v1 | **Fecha:**
**Duración total:** [X] horas = [Y] minutos

| Tópico | Contenido específico | Actividad | Tipo | M | % | TOTAL |
|---|---|---|---|---|---|---|
| Apertura | Presentación, encuadre del curso, introducción | Dinámica de apertura | P | 15 | 2.5% | 15 |
| [Tópico 1] | [contenido] | Exposición + [Nombre actividad] | T+P | [min] | [%] | [total] |
| [Tópico 1] | [subtema] | [actividad práctica] | P | [min] | [%] | [total] |
| [Tópico 2] | [contenido] | Exposición | T | [min] | [%] | [total] |
| Break | | | | 15 | | 15 |
| [Tópico 2] | [práctica] | [actividad] | P | [min] | [%] | [total] |
| Cierre | Síntesis, preguntas, evaluación | Evaluación post | P | 30 | | 30 |
| **TOTAL** | | | | | | **[suma]** |

**Leyenda:** T = Teórico | P = Práctico | T+P = Mixto

---

## Verificación de tiempos

| Indicador | Valor esperado | Valor real |
|---|---|---|
| Total minutos | [X min] | [suma esquema] |
| % Teórico | ≤ 50% | [calcular] |
| % Práctico | ≥ 50% | [calcular] |
```

## Limits

- La suma de minutos del Esquema debe ser igual a la duración total del curso en la Ficha Técnica
- El porcentaje teórico no debe superar el 50% del total
- Cada tópico de la Ficha Técnica debe aparecer en el Esquema
- Las actividades usadas en el Esquema deben existir en la Lluvia de Ideas
- No incluir contenido detallado en el Esquema — solo los títulos y referencias a actividades

## Plan Update

El Esquema no tiene una tarea propia en el plan de gestión estándar — su generación es el resultado de cerrar las tareas 16–21 (Lluvia de Ideas y Borradores).
El orquestador activa el protocolo de seguimiento proactivo para verificar con el usuario si las tareas de borrador pendientes (ITEM 18, 20) pueden cerrarse junto con la entrega del Esquema.
