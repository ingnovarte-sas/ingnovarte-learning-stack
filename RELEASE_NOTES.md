# Release Notes — v0.1.0

## Resumen ejecutivo
`v0.1.0` es la versión fundacional del **Ingnovarte Learning Stack**. Define una base markdown-first para trabajo instruccional técnico-industrial, orientada a uso conversacional con `learning-orchestrator` y apoyada por agentes, skills, workflows y memoria curada.

No es una herramienta ejecutable. Es una base documental reusable para diseñar, revisar y extender entregables de formación técnica industrial.

## Qué incluye
- `learning-orchestrator` como puerta principal de interacción en lenguaje natural.
- 8 agentes base.
- 12 skills base.
- 7 workflows LDD.
- `INGNOVARTE_CONTEXT.md` como contexto reusable.
- `MEMORY_PROTOCOL.md` como contrato de memoria curada.
- `skill-registry` para discovery interno de skills.
- Ejemplo vertical slice del caso **Hidráulica Nivel II**.

## Qué no incluye
- Código ejecutable.
- CLI.
- MCP propio.
- Integraciones reales con Moodle, SCORM, Captivate o PowerPoint.
- XML Moodle.
- Paquetes SCORM.
- Automatización runtime.

## Cómo se debe usar
1. El usuario conversa en lenguaje natural con `learning-orchestrator`.
2. El orquestador clasifica la solicitud y enruta internamente agentes, skills y workflows.
3. El trabajo se desarrolla por bloques revisables y partiendo del último entregable aprobado.
4. Cuando falta contexto, se usan supuestos controlados y placeholders explícitos.

## Validación realizada
La base del stack fue validada con el caso **Hidráulica Nivel II**, produciendo y refinando estos entregables:
- malla instruccional operacional,
- capa de decisiones del participante,
- storyboard PowerPoint,
- guía operativa de actividades,
- evaluación pre/post,
- matriz de corrección,
- verificación de eficacia en campo,
- ficha operativa de verificación.

## Riesgos conocidos
- La calidad del routing depende de que los outputs y límites de las skills se mantengan claros.
- El stack requiere disciplina documental para conservar continuidad entre entregables.
- La memoria debe mantenerse curada; no debe duplicar artefactos ya versionados.

## Próximos pasos sugeridos para v0.2
- Refinar consistencia terminológica del stack.
- Ampliar ejemplos verticales reutilizables.
- Profundizar plantillas y patrones de salida por skill.
- Consolidar backlog documental para futuras publicaciones y adopción.

## Nota metodológica
`gentle-ai` puede actuar como infraestructura o ecosistema de apoyo, pero la metodología, reglas de trabajo y foco de dominio de este stack son los de **Ingnovarte**.
