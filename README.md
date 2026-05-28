# Ingnovarte Learning Stack

El Ingnovarte Learning Stack es un conjunto de instrucciones y herramientas para Claude Code y OpenCode que guía al agente de IA a través del proceso LDD (Learning Design Document) de Ingnovarte. Está diseñado para instructores y diseñadores instruccionales que desarrollan programas de entrenamiento técnico corporativo: el agente entiende las fases del proceso, verifica prerequisitos, genera artefactos de diseño y recuerda el estado de cada curso entre sesiones.

---

## Requisitos

- **Claude Code** o **[OpenCode](https://opencode.ai)** instalado en tu equipo
- **[Engram](https://engram.fyi)** — recomendado para memoria persistente entre sesiones; el stack funciona sin él pero el agente no recuerda el estado de los cursos al cerrar y reabrir
- **Git**
- **bash** (macOS / Linux) o **PowerShell 5+** (Windows)

---

## Instalación

```bash
# 1. Clona el repositorio
git clone https://github.com/ingnovarte-sas/ingnovarte-learning-stack.git ingnovarte-learning-stack
cd ingnovarte-learning-stack

# 2. Ejecuta el installer
# macOS / Linux:
./install.sh

# Windows (PowerShell):
.\install.ps1

# 3. Abre Claude Code u OpenCode en esta carpeta y escribe:
#    ejecuta ldd-onboard
```

El installer detecta tu entorno automáticamente (Claude Code, OpenCode, o ambos), configura Engram como servidor MCP y genera el índice de skills. Es idempotente — ejecutarlo más de una vez es seguro.

---

## Verificación

Después de instalar, abre Claude Code u OpenCode en la carpeta del stack y escribe:

> ejecuta ldd-onboard

El agente ejecutará cinco verificaciones y reportará si todo está correcto. Si algún check falla, recibirás instrucciones específicas para resolverlo.

---

## Tu primer curso

1. Crea la carpeta del curso localmente (no está incluida en el repositorio):
   ```
   mkdir cursos/M051
   ```

2. Dile al agente: **"iniciar curso M051"** — ejecutará `ldd-init` y guardará el contexto base.

3. Avanza con **`ldd-kickoff`** para registrar los parámetros de la reunión inicial.

4. Continúa con **`ldd-ficha`** para generar la Ficha Técnica del curso.

5. El agente guía el resto del proceso fase a fase. Escribe en lenguaje natural — por ejemplo: *"necesito el BBOK del curso M051"* o *"generemos el esquema"*.

Para el proceso LDD completo, lee `INGNOVARTE_CONTEXT.md`.

---

## Troubleshooting

### Engram no responde

El agente reporta un error al llamar `mem_search` o `mem_save`. Esto significa que Engram no está configurado como servidor MCP.

Ver las instrucciones detalladas en `skills/_shared/engram-setup.md`, que incluye los snippets exactos de configuración para Claude Code (`.mcp.json`) y OpenCode (`opencode.json`).

Si Engram no está instalado, descárgalo desde [engram.fyi](https://engram.fyi) y vuelve a correr el installer.

### Skill registry roto o vacío

El agente dice que no encuentra skills LDD o el archivo `.atl/skill-registry.md` está vacío.

Solución: vuelve a ejecutar el installer, que regenera el registry escaneando las skills del repositorio:

```bash
# macOS / Linux
./install.sh

# Windows
.\install.ps1
```

### Coexistencia con Gentle AI

Si tienes Gentle AI instalado, no hay conflicto. El installer detecta Gentle AI al revisar los archivos de configuración MCP y hace **merge** — agrega la entrada de Engram sin tocar las entradas existentes de Gentle AI ni de otras herramientas.

Las skills LDD usan el prefijo `ldd-` en todos sus nombres y topic keys (`ldd/{código}/{artefacto}`), lo que evita colisiones con cualquier otro sistema.

### "Falta el prerequisito X" — Phase Guard

Si el agente responde algo como *"Falta la Ficha Técnica aprobada. ¿Deseas generarla primero?"*, esto es el comportamiento esperado. El Phase Guard verifica que los artefactos de cada fase existan antes de avanzar a la siguiente.

El mensaje indica exactamente qué fase ejecutar antes. Sigue la indicación del agente — el proceso LDD tiene dependencias intencionales entre fases.

### La carpeta `cursos/` no aparece en el repositorio

Correcto: `cursos/` está en `.gitignore` y no se distribuye con el repositorio. Debes crearla localmente. El agente espera encontrar las carpetas de los cursos en `cursos/{código-del-curso}/` relativo a la raíz del repositorio.

---

## Estructura del repositorio

```
ingnovarte-learning-stack/
├── skills/                    # Skills LDD del agente
│   ├── ldd-init/              # Inicializar un curso nuevo
│   ├── ldd-kickoff/           # Brief del kickoff
│   ├── ldd-contextualizacion/ # Contextualización del curso
│   ├── ldd-ficha/             # Ficha Técnica
│   ├── ldd-bbok/              # Borrador BOK
│   ├── ldd-lluvia/            # Lluvia de Ideas
│   ├── ldd-esquema/           # Esquema minuto a minuto
│   ├── ldd-bok/               # BOK final
│   ├── ldd-storyboard/        # Storyboard slide por slide
│   ├── ldd-presentation/      # Genera el .pptx desde el storyboard
│   ├── ldd-guias/             # Guías de Actividades
│   ├── ldd-evaluaciones/      # Evaluaciones y rúbricas
│   ├── ldd-informe/           # Informes de retroalimentación y eficacia
│   ├── ldd-review/            # Revisión de artefactos
│   ├── ldd-status/            # Estado del proceso LDD de un curso
│   ├── ldd-onboard/           # Verificación del entorno (este stack)
│   └── _shared/               # Archivos compartidos entre skills
│       ├── orchestrator-rules.md    # Reglas de orquestación (fuente única)
│       ├── engram-convention.md     # Convenciones de Engram para LDD
│       ├── engram-setup.md          # Instrucciones de instalación de Engram
│       ├── skill-resolver.md        # Protocolo de resolución de skills
│       └── skill-registry.header.md # Plantilla del encabezado del registry
├── scripts/                   # Scripts del installer
│   ├── lib.sh                 # Helpers bash comunes
│   ├── lib.ps1                # Helpers PowerShell comunes
│   ├── build-registry.sh      # Generador del skill registry (bash)
│   └── build-registry.ps1     # Generador del skill registry (PowerShell)
├── .atl/                      # Archivos generados en tiempo de instalación
│   └── skill-registry.md      # Índice de skills (generado, no versionar)
├── cursos/                    # NO incluido — crear localmente por curso
├── CLAUDE.md                  # Entry file para Claude Code
├── AGENTS.md                  # Entry file para OpenCode
├── INGNOVARTE_CONTEXT.md      # Dominio, proceso LDD y modelo de datos
├── install.sh                 # Installer (macOS / Linux)
└── install.ps1                # Installer (Windows)
```

---

## Actualización del stack

```bash
git pull
./install.sh          # macOS / Linux
.\install.ps1         # Windows
```

El installer es idempotente: detecta qué está actualizado y omite lo que no necesita cambios. Regenera el skill registry para incluir cualquier skill nueva.

---

## Compatibilidad

- Funciona con Gentle AI instalado — el installer convive con su configuración.
- Funciona sin Gentle AI — no hay dependencia.
- Compatible con Claude Code y OpenCode en el mismo entorno simultáneamente.
