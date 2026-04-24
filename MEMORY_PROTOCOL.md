# Memory Protocol

## Propósito
Definir cómo persistir memoria curada para decisiones instruccionales y técnicas sin duplicar artefactos versionados.

## Regla central
Si un artefacto ya existe como archivo versionado, **NO** se guarda completo en memoria.

En memoria solo se guarda:
- `summary`
- `rationale`
- `artifact_path`
- `linked_decision`
- `selection_criteria`
- `reusable_learning`

## Tipos permitidos
- `project_context`
- `client_constraint`
- `instructional_decision`
- `technical_decision`
- `style_rule`
- `assessment_pattern`
- `activity_pattern`
- `implementation_issue`
- `verification_finding`
- `reusable_asset`
- `lesson_learned`

## Criterio mínimo de registro
Registrar solo eventos reutilizables: decisiones, hallazgos, bloqueos o patrones que ahorren retrabajo en próximas iteraciones.

## Ejemplo breve
- `summary`: Se eligió curso 12h con 4 módulos.
- `rationale`: Disponibilidad operacional del cliente.
- `artifact_path`: `examples/curso-hidraulica-nivel-ii.md`
- `linked_decision`: `instructional_decision`
- `selection_criteria`: Transferencia a tareas críticas.
- `reusable_learning`: Limitar sesiones teóricas a bloques de 25-30 min.

## Ejemplos concretos (Hidráulica Nivel II)

### Qué SÍ guardar
- Decisión reusable: “Se priorizó verificación en campo por checklist de intervención segura al cierre del módulo 4”.
- Hallazgo reusable: “Los errores se concentran en diagnóstico inicial; agregar práctica guiada antes de intervención completa”.
- Patrón reusable: “Pre/post equivalente por dimensión (diagnóstico, seguridad, intervención, verificación) mejora trazabilidad”.

### Qué NO guardar
- El documento completo `examples/curso-hidraulica-nivel-ii.md` copiado en memoria.
- Listados extensos de slides, tablas o preguntas ya versionadas en archivos.
- Borradores intermedios sin decisión, hallazgo o patrón reutilizable.

## Verification Checklist
- [x] Regla anti-duplicación definida.
- [x] Taxonomía 11/11 documentada.
- [x] Campos mínimos de persistencia establecidos.
