# Engram Setup — Ingnovarte Learning Stack

> Para el contrato completo de convenciones de guardado, consulta `skills/_shared/engram-convention.md`.

---

## Qué es Engram en este stack

Engram es la capa de memoria persistente del Ingnovarte Learning Stack. Permite que el agente recuerde el estado de cada curso entre sesiones: la Ficha Técnica, el BBOK, el Esquema, y todos los artefactos LDD generados. Sin Engram, el agente comienza cada sesión desde cero y no puede recuperar trabajo previo ni verificar prerequisitos de fase. Engram se instala una sola vez como herramienta MCP y funciona de forma transparente desde Claude Code u OpenCode.

---

## Topic-key convention

Todos los artefactos del stack usan el esquema:

```
ldd/{código-curso}/{artefacto}
```

| Campo | Valor |
|---|---|
| **Prefijo** | `ldd/` (fijo para todos los artefactos LDD) |
| **scope** | `project` |
| **project** | `ingnovarte-learning-stack` |

### Artefactos comunes

| Topic key | Contenido |
|---|---|
| `ldd/{code}/init` | Datos iniciales del curso (nombre, cliente, duración) |
| `ldd/{code}/kickoff` | Brief del kickoff: parámetros, audiencia, contexto |
| `ldd/{code}/context` | Notas de contextualización, docs revisados, entrevistas |
| `ldd/{code}/ficha` | Ficha Técnica completa |
| `ldd/{code}/bbok` | Borrador BOK por tópico |
| `ldd/{code}/lluvia` | Lluvia de Ideas (tabla de actividades) |
| `ldd/{code}/esquema` | Esquema minuto a minuto |
| `ldd/{code}/bok` | BOK final por tópico |
| `ldd/{code}/presentacion` | Borrador de presentación por diapositiva |
| `ldd/{code}/guias` | Guías de Actividades completas |
| `ldd/{code}/evaluaciones` | Evaluaciones, rúbricas y encuestas |
| `ldd/{code}/informe-retro` | Informe de retroalimentación post-entrenamiento |
| `ldd/{code}/informe-eficacia` | Informe de eficacia del ciclo de evaluación |

**Ejemplos reales:**
- `ldd/M051/ficha` — Ficha Técnica del curso M051
- `ldd/OP14M11/lluvia` — Lluvia de Ideas del curso OP14M11
- `ldd/E20262/bbok` — BBOK del curso E20262

---

## Comandos básicos con ejemplos LDD

### Guardar un artefacto (`mem_save`)

```python
mem_save(
  title="Ficha Técnica — M051 Torqueo de Pernos",
  topic_key="ldd/M051/ficha",
  type="architecture",
  scope="project",
  project="ingnovarte-learning-stack",
  content="""
## Curso
Código: M051 | Nombre: Torqueo de Pernos | Cliente: Drummond LTD

## Artefacto generado
Ficha Técnica completa con objetivos, audiencia, estructura modular y restricciones operacionales.

## Tópicos cubiertos
- Torque y unidades de medida
- Secuencias de apriete según norma
- Uso de llaves dinamométricas

## Supuestos
- Norma aplicada es ASME B18.2.2 — requiere validación con cliente

## Pendientes
- Confirmar número de participantes por sesión
  """
)
```

**Regla:** usar siempre el mismo `topic_key` para actualizar un artefacto existente (upsert, no crea duplicados).

### Buscar artefactos de un curso (`mem_search`)

```python
mem_search(
  query="ldd/M051",
  project="ingnovarte-learning-stack"
)
```

Retorna una lista de resultados con previews de 300 caracteres. El ID de cada resultado se usa para recuperar el contenido completo.

### Recuperar contenido completo (`mem_get_observation`)

```python
# Nunca usar el preview truncado de mem_search — siempre recuperar con este llamado
mem_get_observation(id=<ID del resultado>)
```

**Flujo completo para recuperar la Ficha de M051:**

1. `mem_search(query="ldd/M051/ficha", project="ingnovarte-learning-stack")` → obtiene el ID
2. `mem_get_observation(id=<ID>)` → contenido completo sin truncar

---

## Si Engram no responde

Si el agente reporta un error de transporte al llamar `mem_search` o `mem_save`, Engram no está configurado como servidor MCP. Sigue los pasos según tu runtime:

### Claude Code

Agrega la entrada `engram` a tu archivo `.mcp.json` en la raíz del repositorio. Si el archivo no existe, créalo con este contenido:

```json
{
  "mcpServers": {
    "engram": {
      "type": "stdio",
      "command": "engram",
      "args": ["mcp"],
      "env": {
        "ENGRAM_PROJECT": "ingnovarte-learning-stack"
      }
    }
  }
}
```

Si el archivo ya existe con otros servidores, agrega solo el bloque `"engram": { ... }` dentro de `mcpServers`.

Después de editar el archivo, reinicia Claude Code para que detecte el nuevo servidor.

### OpenCode

Agrega la entrada `engram` al bloque `mcp` de tu archivo `opencode.json` en la raíz del repositorio:

```json
{
  "mcp": {
    "engram": {
      "type": "local",
      "command": ["engram", "mcp"],
      "environment": {
        "ENGRAM_PROJECT": "ingnovarte-learning-stack"
      }
    }
  }
}
```

Si el archivo ya tiene otras entradas MCP, agrega solo el bloque `"engram": { ... }` dentro de `mcp`.

### Verificar que Engram está instalado

Antes de configurar el archivo MCP, verifica que el binario `engram` esté disponible:

```bash
# macOS / Linux
command -v engram

# Windows (PowerShell)
Get-Command engram
```

Si el comando no se encuentra, instala Engram desde [engram.fyi](https://engram.fyi) siguiendo las instrucciones para tu sistema operativo.

> **Nota:** El installer del stack (`install.sh` / `install.ps1`) detecta si Engram está instalado y configura automáticamente el archivo MCP correspondiente. Si ya corriste el installer, este paso puede ser innecesario.

---

## Coexistencia con otras configs MCP

Si ya tienes otros servidores MCP configurados (por ejemplo, Gentle AI u otras herramientas), el installer hace **merge**, no sobrescribe. Agrega únicamente la entrada `engram` dentro del bloque existente de `mcpServers` (Claude Code) o `mcp` (OpenCode), preservando todas las entradas previas.

Si configuras manualmente, sigue el mismo principio: agrega el bloque `engram` junto a los demás — no reemplaces el archivo completo.
