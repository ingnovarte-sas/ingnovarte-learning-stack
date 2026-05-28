# Microsoft 365 MCP — Configuración

El skill `ldd-presentation` accede a la carpeta multimedia de Ingnovarte en SharePoint para obtener
imágenes que ilustran las slides. Para eso usa el servidor MCP `ms365-work` de
[@softeria/ms-365-mcp-server](https://github.com/Softeria/ms-365-mcp-server).

---

## Requisitos previos

- **Node.js 18+** instalado — verifica con `node --version`
- **Cuenta Microsoft 365 de trabajo** (cuenta org de Ingnovarte)

---

## Instalación automática

El installer (`install.ps1` / `install.sh`) detecta Node.js y agrega `ms365-work` a la
configuración MCP de Claude Code y/o OpenCode automáticamente.

Después de instalar, autentica la cuenta una sola vez (ver sección **Autenticación** más abajo).

---

## Instalación manual

Si el installer no pudo configurarlo, agrégalo a mano.

### Claude Code — `.mcp.json`

Agrega la entrada `ms365-work` al bloque `mcpServers` del `.mcp.json` en la raíz del repositorio:

```json
{
  "mcpServers": {
    "ms365-work": {
      "command": "npx",
      "args": ["-y", "@softeria/ms-365-mcp-server", "--org-mode"]
    }
  }
}
```

### OpenCode — `opencode.json`

Agrega la entrada `ms365-work` al bloque `mcp` de tu `opencode.json`
(`~/.config/opencode/opencode.json`):

```json
{
  "mcp": {
    "ms365-work": {
      "type": "local",
      "command": ["npx", "-y", "@softeria/ms-365-mcp-server", "--org-mode"]
    }
  }
}
```

---

## Autenticación (una sola vez por equipo)

El servidor usa el flujo **Device Code** de Microsoft. No requiere configurar secretos ni
variables de entorno.

**Pasos:**

1. La primera vez que el agente llama a `ms365-work`, el servidor muestra:
   > "Para autenticarte, ve a `https://microsoft.com/devicelogin` e ingresa el código: `XXXX-XXXX`"

2. Abre `https://microsoft.com/devicelogin` en tu navegador.

3. Ingresa el código de verificación que te dio el agente.

4. Inicia sesión con tu **cuenta org de Ingnovarte** (correo `@ingnovarte.com`).

5. Autoriza el acceso — la sesión queda guardada localmente en tu perfil de usuario.

La autenticación persiste entre sesiones (aprox. 90 días). Si expira, el agente lo notificará y
repetirás el proceso desde el paso 1.

---

## Verificación

Después de autenticarte, pídele al agente:

> "lista los archivos de la carpeta multimedia de Ingnovarte en SharePoint"

Si responde con una lista de archivos o subcarpetas, la conexión está funcionando.

---

## Herramientas que usa el agente

| Tarea | Claude Code | OpenCode |
|---|---|---|
| Listar archivos | `mcp__ms365-work__list-folder-files` | `ms365-work/list-folder-files` |
| Descargar imagen | `mcp__ms365-work__download-bytes` | `ms365-work/download-bytes` |

Solo `ldd-presentation` usa estas herramientas. El resto del pipeline LDD no requiere ms365-work.

---

## Si la carpeta multimedia no es accesible

`ldd-presentation` tiene un fallback: si la conexión a SharePoint falla o el índice está vacío,
continúa generando el .pptx con **rectángulos de color sólido** como placeholder para las imágenes
y reporta al final cuáles slides quedaron sin imagen.

Esto permite avanzar con la estructura del deck aunque ms365-work no esté configurado.
