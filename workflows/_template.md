# Workflow Template

## Objetivo
Definir secuencia mínima, entradas, decisiones y salidas verificables.

## Activación orgánica
- El `learning-orchestrator` puede activar este workflow cuando la solicitud lo amerite.
- El usuario no necesita invocarlo manualmente ni conocer la fase LDD.

## Inputs
- Contexto del proyecto y fase LDD.
- Objetivo instruccional o técnico de la iteración.
- Restricciones operativas y non-goals.
- Último entregable aprobado para asegurar continuidad.

## Supuestos controlados
- Cuando falten datos, declarar `[SUPUESTO]` con impacto y responsable de validación.
- Separar explícitamente lo implementado vs lo pendiente por validar.

## Pasos
1. Entrada, contexto y continuidad desde entregable aprobado previo.
2. Diseño/ejecución con supuestos controlados cuando aplique.
3. Verificación, pendientes de validación y cierre.

## Límites
Sin ejecución runtime ni automatización externa.

## Quality Gates
- [ ] Entradas completas.
- [ ] Decisiones trazables.
- [ ] Salida reusable.

## Exit Criteria
- [ ] Artefacto final aprobado.
- [ ] Riesgos remanentes documentados.
