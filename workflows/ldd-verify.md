# Workflow: LDD Verify

## Objetivo
Verificar calidad instruccional, consistencia técnica y factibilidad operativa.

## Activación orgánica
- Este workflow puede ser activado por el `learning-orchestrator` cuando la solicitud lo amerite.
- El usuario no necesita invocarlo manualmente ni conocer la fase.

## Inputs
- Entregables construidos en `ldd-build`.
- Checklists de calidad por artefacto.
- Criterios de aceptación y límites definidos.

## Pasos
1. Ejecutar checklists por artefacto.
2. Detectar gaps y severidad.
3. Emitir estado: aprobado/parcial/bloqueado.

## Quality Gates
- [ ] Hallazgos con evidencia concreta.
- [ ] Recomendaciones accionables priorizadas.

## Exit Criteria
- [ ] Informe de verificación publicado.
