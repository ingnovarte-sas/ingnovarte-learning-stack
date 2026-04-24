# Ingnovarte Learning Stack (Markdown-First)

Base documental para diseñar, verificar y reutilizar soluciones de formación técnica industrial.

## Objetivo
- Centralizar contratos de trabajo para agentes, skills, workflows y ejemplos.
- Mantener un enfoque MVP: documentos cortos, operativos y versionables.
- Evitar runtime: sin CLI, sin MCP, sin integraciones ejecutables.

## Ruta de entrada obligatoria
1. `README.md` (este archivo)
2. `INGNOVARTE_CONTEXT.md`
3. `AGENTS.md`
4. `MEMORY_PROTOCOL.md`
5. `workflows/` según fase LDD

## Mapa de artefactos
- `agents/`: roles operativos de agentes.
- `skills/`: capacidades reutilizables con disparadores.
- `workflows/`: flujo LDD de extremo a extremo.
- `examples/`: semillas de entrega para casos reales.

## Cómo se usa
1. El usuario conversa en lenguaje natural con `learning-orchestrator`.
2. El trabajo se resuelve por bloques cortos y verificables.
3. Agentes, skills y workflows operan como mecanismos internos; no se exponen por defecto.

## Límites del MVP
- No crea código ejecutable.
- No promete integraciones reales con Moodle, Captivate o SCORM players.
- No modifica herramientas internas de orquestación.

## Fuera de alcance (v0.2)
- Automatizaciones runtime, integraciones reales y expansión de alcance más allá de markdown-first.

## Verification Checklist
- [x] Ruta de navegación inicial definida.
- [x] Referencias a contexto, agentes, memoria y workflows incluidas.
- [x] Límites y non-goals explícitos.
