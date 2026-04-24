# Contrato de Agentes

## Propósito
Establecer comportamiento común para agentes del stack instruccional de Ingnovarte.

## Secuencia obligatoria antes de ejecutar
1. Leer `README.md`.
2. Leer `INGNOVARTE_CONTEXT.md`.
3. Validar límites en `MEMORY_PROTOCOL.md`.

Si no se cumple esta secuencia, la ejecución se considera inválida.

## Reglas transversales
- Priorizar precisión técnica industrial sobre redacción extensa.
- Diseñar para cursos de 12h con evidencia aplicable al trabajo real.
- Declarar límites y non-goals en cada salida.
- No prometer conectividad alta ni licencias avanzadas por defecto.
- El `learning-orchestrator` es la interfaz principal del usuario: el usuario habla en lenguaje natural y los agentes, workflows y skills operan como mecanismos internos del stack.
- Partir del último entregable aprobado y extenderlo; no rehacer desde cero sin motivo explícito.
- Usar supuestos controlados cuando falte contexto y marcar claramente lo pendiente por validar.

## Precedencia Agente vs Skill
- Los agentes coordinan, deciden y revisan el flujo de trabajo.
- Las skills ejecutan capacidades puntuales y reutilizables.
- Si un agente y una skill cubren dominios similares, el agente decide cuándo invocar la skill.
- Una skill no reemplaza al agente; funciona como herramienta especializada.

## Catálogo de agentes
- `agents/learning-orchestrator.md`
- `agents/course-architect.md`
- `agents/technical-sme-translator.md`
- `agents/assessment-designer.md`
- `agents/ppt-storyteller.md`
- `agents/activity-guide-builder.md`
- `agents/scorm-moodle-engineer.md`
- `agents/quality-reviewer.md`

## Quality Checks
- [x] Orden de lectura inicial obligatorio declarado.
- [x] Reglas comunes de dominio y límites documentadas.
- [x] Catálogo de agentes enlazado.

## Verification Checklist
- [x] `README.md` y `INGNOVARTE_CONTEXT.md` exigidos como entrada.
- [x] Non-goals operativos definidos.
