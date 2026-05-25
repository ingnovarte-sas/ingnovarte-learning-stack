# LDD Phase Common — Convenciones compartidas

## Principios de calidad

1. **Alineación**: cada entregable referencia explícitamente los tópicos de la Ficha Técnica
2. **Trazabilidad**: los tópicos del Esquema = los tópicos del BBOK = los tópicos de la Presentación
3. **Verificabilidad**: cada entregable tiene campos mínimos que permiten confirmar que está completo
4. **Continuidad**: no iniciar una fase sin el artefacto aprobado de la fase anterior

## Dependencias entre fases

```
Kickoff → ldd-contextualizacion → ldd-ficha → BBOK → Lluvia → Esquema → Creación → Actualización → Evaluación
                                                                    ↓           ↓
                                                             BBOK + Lluvia   BOK + Presentación
                                                             + Esquema       + Guías + Evaluaciones
```

Para generar cualquier artefacto, el artefacto de la fase anterior debe existir y estar aprobado.

## Campos mínimos verificables

| Entregable | Campos mínimos para considerarlo completo |
|---|---|
| Brief (Kickoff) | cliente, audiencia, competencias esperadas, duración estimada |
| Notas de Contextualización | `documentos_revisados` ≥1 fuente listada; `hallazgos_por_topico` al menos un tópico con hallazgos; `supuestos_identificados` presente (puede ser lista vacía con nota justificatoria) |
| Ficha Técnica | código, nombre, duración, grupo objetivo, objetivo general, ≥1 tópico con duración |
| BBOK | ≥1 sección por tópico de la ficha, contenido por sección |
| Lluvia de Ideas | ≥1 actividad por tópico con ¿Qué?, ¿Cómo?, ¿Con qué?, tiempo estimado |
| Esquema | secuencia completa (suma de minutos = duración total del curso) |
| Borrador Presentación | ≥1 slide por tópico con título, contenido e indicaciones para diseño |
| BOK | ≥1 sección por tópico, contenido expandido y revisado |
| Guías | objetivo + descripción + materiales + procedimiento por actividad |
| Evaluaciones | ≥5 ítems pre/post alineados a objetivos + rúbrica |
| Informe | conclusión explícita sobre eficacia o retroalimentación |

## Convenciones de formato

- Usar **Markdown** para todos los entregables
- Usar **tablas Markdown** para Esquema y Lluvia de Ideas
- Usar `## Tópico` (H2) para tópicos, `### Subtema` (H3) para subtemas
- NO generar formato Word, HTML ni presentaciones ejecutables directamente
- Las presentaciones se generan como borrador markdown — el equipo gráfico aplica la capa final

## Convenciones de nomenclatura

- Tópicos: usar exactamente los nombres de la Ficha Técnica, sin variaciones
- Versiones: `v1` (borrador), `v2` (revisado), `vF` (final)

## Supuestos controlados

Si falta información para completar un artefacto, indicar explícitamente:

```
> **Supuesto**: [qué se asumió] — requiere validación del cliente / SME
```

**Nunca inventar:**
- Datos técnicos específicos (torques, procedimientos, normativas, especificaciones de equipos)
- Nombres de personal, cargos o estructuras organizacionales del cliente
- Tiempos de duración sin base en la Ficha Técnica

## Restricciones operacionales a respetar

- Tiempo limitado de personal fuera de operación → actividades compactas y de alto impacto
- Conectividad variable en campo → no asumir acceso permanente a internet
- Nivel digital mixto → instrucciones claras, sin suponer experticia tecnológica
- No prometer infraestructura avanzada por defecto
