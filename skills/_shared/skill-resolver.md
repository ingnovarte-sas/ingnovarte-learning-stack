# Skill Resolver — Ingnovarte Stack

## Propósito

El orquestador inyecta los paths de skills relevantes en el prompt de cada sub-agente antes de delegarle trabajo. Sin esto, el sub-agente no sabe qué skills cargar y opera sin contexto de dominio.

## Protocolo (ejecutar una vez por sesión)

### Paso 1 — Leer el skill registry
```
Buscar: mem_search(query: "skill-registry ingnovarte", project: "ingnovarte-learning-stack")
Fallback: leer .atl/skill-registry.md directamente
```

### Paso 2 — Identificar skills relevantes para la tarea

Matchear por dos dimensiones:
- **Contexto de tarea**: qué fase LDD ejecutará el sub-agente (kickoff, ficha, bbok, etc.)
- **Contexto de código**: qué archivos o formatos tocará

### Paso 3 — Incluir en el prompt del sub-agente

```markdown
## Skills a cargar antes de trabajar

Lee estos archivos COMPLETAMENTE antes de iniciar el trabajo:
- skills/ldd-{fase}/SKILL.md
- skills/_shared/ldd-phase-common.md
- skills/_shared/engram-convention.md
- INGNOVARTE_CONTEXT.md
```

## Regla crítica

Pasa **paths exactos**, no resúmenes generados. El sub-agente lee el SKILL.md completo para preservar la intención del autor. Nunca parafrasees el contenido de un skill en el prompt.

## Fallback si el registry no existe

Si `.atl/skill-registry.md` no existe en disco Y la búsqueda en Engram no retorna resultados para `skill-registry`:

1. **Notificar al usuario**: informar que no se encontró el skill-registry y que se continuará con el conocimiento de dominio disponible.
2. **Continuar con fallback**: usar el conocimiento de dominio disponible en `INGNOVARTE_CONTEXT.md` como base para ejecutar la tarea.
3. **Reportar en el return envelope**: `skill_resolution: fallback-knowledge`

Este fallback NO reemplaza al registry a largo plazo. Si se activa, recomendar al usuario que verifique que `.atl/skill-registry.md` existe y está accesible.

## Feedback de resolución

Después de cada delegación, verifica el campo `skill_resolution` del resultado:
- `paths-injected` → correcto, continúa normal
- `fallback-*` o `none` → volver a leer el registry y re-inyectar paths en siguientes delegaciones

## Skills disponibles (referencia rápida)

| Skill | Path |
|---|---|
| ldd-kickoff | skills/ldd-kickoff/SKILL.md |
| ldd-contextualizacion | skills/ldd-contextualizacion/SKILL.md |
| ldd-ficha | skills/ldd-ficha/SKILL.md |
| ldd-bbok | skills/ldd-bbok/SKILL.md |
| ldd-lluvia | skills/ldd-lluvia/SKILL.md |
| ldd-esquema | skills/ldd-esquema/SKILL.md |
| ldd-bok | skills/ldd-bok/SKILL.md |
| ldd-storyboard | skills/ldd-storyboard/SKILL.md |
| ldd-guias | skills/ldd-guias/SKILL.md |
| ldd-evaluaciones | skills/ldd-evaluaciones/SKILL.md |
| ldd-informe | skills/ldd-informe/SKILL.md |
| ldd-review | skills/ldd-review/SKILL.md |
