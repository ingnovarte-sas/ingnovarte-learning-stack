# Engram Convention — Ingnovarte Stack

## Topic Key Format

Todo el trabajo por curso usa el prefijo `ldd/{course-code}/{artifact}`.

```
ldd/{code}/kickoff        → Brief del kickoff (parámetros, audiencia, contexto)
ldd/{code}/context        → Notas de contextualización, docs revisados, entrevistas
ldd/{code}/ficha          → Ficha Técnica completa
ldd/{code}/bbok           → Borrador BOK por tópico
ldd/{code}/lluvia         → Lluvia de Ideas (tabla de actividades)
ldd/{code}/esquema        → Esquema minuto a minuto
ldd/{code}/presentacion   → Borrador de presentación por diapositiva
ldd/{code}/bok            → BOK final por tópico
ldd/{code}/guias          → Guías de Actividades completas
ldd/{code}/evaluaciones   → Evaluaciones + rúbricas + encuestas
ldd/{code}/informe-retro  → Informe de retroalimentación post-entrenamiento
ldd/{code}/informe-eficacia → Informe de eficacia del ciclo de evaluación
```

## Reglas de guardado

1. **Siempre incluye el código del curso** en el topic_key (ej. `ldd/M051/ficha`)
2. **Usa upsert** (mismo topic_key) cuando actualices un artefacto del mismo curso
3. **Guarda ANTES de retornar** — si generaste un entregable, guárdalo en Engram antes de responder
4. El campo `content` debe incluir: Qué generaste, Tópicos cubiertos, Supuestos, Pendientes

## Búsqueda por curso

Para recuperar artefactos de un curso:
1. `mem_search(query: "ldd/{code}", project: "ingnovarte-learning-stack")`
2. Para el contenido completo (nunca usar el preview truncado): `mem_get_observation(id: {id})`

## Self-check obligatorio antes de cada fase

Antes de iniciar cualquier entregable LDD, busca en Engram:
- ¿Existe ya un artefacto de la fase anterior para este curso?
- ¿Existe ya trabajo previo sobre este curso que deba considerar?

Si existe → úsalo como base. Si no existe → pide la información necesaria al usuario antes de generar.

## Formato del content en mem_save

```
## Curso
Código: {code} | Nombre: {nombre} | Cliente: {cliente}

## Artefacto generado
{descripción breve de lo que se generó}

## Tópicos cubiertos
- {tópico 1}
- {tópico 2}

## Supuestos
- {supuesto 1} — requiere validación

## Pendientes
- {pendiente 1}
```
