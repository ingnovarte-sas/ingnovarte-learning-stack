---
name: ldd-onboard
description: Verifica que el entorno del Ingnovarte Learning Stack esté correctamente instalado y configurado.
triggers:
  - ldd-onboard
  - ejecuta ldd-onboard
  - verifica setup
  - onboarding
  - primera vez
  - verificar instalación
metadata:
  version: "1.0"
  author: ingnovarte
  updated_at: 2026-05-25
model: sonnet
---

# Skill: ldd-onboard

Verifica end-to-end que el entorno del Ingnovarte Learning Stack está correctamente instalado y funcional. Ejecuta cinco checks en orden estricto y reporta el resultado al usuario.

Esta skill NO crea cursos, NO modifica artefactos LDD, NO toca datos de usuario.

---

## Instrucciones de ejecución

Ejecuta los checks en el orden indicado. No continúes al siguiente check si el anterior falla con error crítico — reporta el fallo inmediatamente con las instrucciones de remediación. Si un check produce un warning (no crítico), anótalo y continúa.

---

## Check 1 — INGNOVARTE_CONTEXT.md

**Acción:** Lee el archivo `INGNOVARTE_CONTEXT.md` en la raíz del repositorio.

**Resultado esperado:** El archivo existe y es legible.

**Si falla:**
```
[error] INGNOVARTE_CONTEXT.md no encontrado.

El repositorio parece estar incompleto. Verifica que clonaste el repositorio
correctamente y que todos los archivos están presentes:

  git status
  git pull

Si el problema persiste, vuelve a clonar el repositorio desde la fuente original.
```
**Detener ejecución si este check falla.**

---

## Check 2 — Skill registry

**Acción:** Lee el archivo `.atl/skill-registry.md`. Verifica que:
1. El archivo existe
2. Contiene al menos una entrada con el prefijo `ldd-`
3. Al menos 3 de los paths listados apuntan a archivos que existen en el repositorio (muestra verificable: `skills/ldd-init/SKILL.md`, `skills/ldd-ficha/SKILL.md`, `skills/ldd-kickoff/SKILL.md`)

**Resultado esperado:** Registry presente con entradas `ldd-` y paths válidos.

**Si falla:**
```
[error] Skill registry no encontrado o incompleto.

El archivo .atl/skill-registry.md no existe o no tiene entradas LDD.
Este archivo se genera automáticamente al correr el installer.

Solución:
  # macOS / Linux
  ./install.sh

  # Windows
  .\install.ps1

Después de correr el installer, vuelve a ejecutar ldd-onboard.
```
**Detener ejecución si este check falla.**

---

## Check 3 — Engram responde

**Acción:** Llama `mem_search(query: "ldd/", project: "ingnovarte-learning-stack")`.

**Resultado esperado:** La herramienta responde (con 0 o más resultados). Un resultado vacío es válido — lo importante es que no retorna un error de transporte o conexión.

**Si retorna error de transporte (Engram no responde):**
```
[error] Engram no responde.

El servidor MCP de Engram no está configurado o no está en ejecución.

Pasos para resolver:
1. Verifica que Engram está instalado: https://engram.fyi
2. Configura el servidor MCP según tu runtime — ver:
   skills/_shared/engram-setup.md

El installer del stack también puede configurarlo automáticamente:
  ./install.sh   (macOS / Linux)
  .\install.ps1  (Windows)

Nota: el stack puede funcionar parcialmente sin Engram, pero el agente no
podrá recordar el estado de los cursos entre sesiones.
```
**Detener ejecución si este check falla.**

---

## Check 4 — Roundtrip Engram (E2E)

**Acción:** Ejecuta la siguiente secuencia en orden:

1. Guarda un registro de prueba:
   ```
   mem_save(
     title="Onboard probe — verificación E2E",
     topic_key="onboard/probe",
     type="discovery",
     scope="project",
     project="ingnovarte-learning-stack",
     capture_prompt=false,
     content="Verificación E2E generada por ldd-onboard. Seguro ignorar."
   )
   ```

2. Recupera el registro guardado:
   ```
   mem_search(query: "onboard/probe", project: "ingnovarte-learning-stack")
   ```

**Resultado esperado:** `mem_search` retorna al menos un resultado con topic_key `onboard/probe`.

**Si falla:**
```
[error] Roundtrip Engram fallido.

Engram respondió al Check 3 pero no pudo completar el ciclo guardar/recuperar.
Esto puede indicar un problema de permisos o configuración del proyecto.

Verifica:
- Que ENGRAM_PROJECT="ingnovarte-learning-stack" está configurado en tu .mcp.json
- Que el servidor MCP de Engram tiene permisos de escritura

Ver skills/_shared/engram-setup.md para la configuración completa.
```
**Detener ejecución si este check falla.**

---

## Check 5 — Guardar resultado del onboarding

**Acción:** Detecta el runtime activo (Claude Code o OpenCode) y guarda el resultado del onboarding en Engram:

```
mem_save(
  title="ldd-onboard completado",
  topic_key="onboard/completed",
  type="discovery",
  scope="project",
  project="ingnovarte-learning-stack",
  capture_prompt=false,
  content="""
## Resultado del onboarding

Fecha: {fecha actual en formato YYYY-MM-DD}
Runtime detectado: {Claude Code | OpenCode | desconocido}

## Checks ejecutados

| Check | Resultado |
|---|---|
| 1 — INGNOVARTE_CONTEXT.md | {ok / error} |
| 2 — Skill registry (.atl/skill-registry.md) | {ok / error} |
| 3 — Engram responde | {ok / error} |
| 4 — Roundtrip Engram (E2E) | {ok / error} |
| 5 — Guardar resultado | ok |

## Notas
{cualquier warning o observación no crítica detectada durante la verificación}
  """
)
```

Este guardado usa upsert (mismo `topic_key: onboard/completed`) — no genera duplicados en runs sucesivos.

---

## Reporte al usuario

### Todo OK

Si todos los checks pasan, reporta:

```
Setup verificado. El Ingnovarte Learning Stack está correctamente instalado.

Checks:
  ✅ INGNOVARTE_CONTEXT.md — encontrado
  ✅ Skill registry — {N} skills LDD indexadas
  ✅ Engram responde
  ✅ Roundtrip Engram — guardar/recuperar OK
  ✅ Resultado guardado en Engram

Ya puedes comenzar a trabajar. Para tu primer curso:
1. Crea una carpeta en cursos/{código-del-curso}/
2. Dime "iniciar curso {código}"

El agente ejecutará ldd-init y guiará el proceso LDD desde ahí.
Para ver el proceso completo, lee INGNOVARTE_CONTEXT.md.
```

### Algún check falló

Reporta exactamente qué check falló con el mensaje de error correspondiente de la sección anterior. No reportes los checks que pasaron si un check crítico interrumpió la secuencia.

---

## Notas de implementación

- Esta skill no tiene prerequisitos en el Phase Guard — puede ejecutarse en cualquier momento.
- Los registros `onboard/probe` y `onboard/completed` en Engram son seguros de ignorar en flujos LDD normales.
- Si el usuario ejecuta ldd-onboard varias veces, el upsert en `onboard/completed` garantiza que no se acumulan entradas repetidas.
- La detección de runtime (Claude Code vs OpenCode) puede inferirse por el entorno en que se ejecuta la skill — si no es determinable, usa "desconocido".
