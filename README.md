# Ruby Notes App

> Gestor de notas

## Uso de `rn`

Para ejecutar el comando principal de la herramienta se utiliza el script `bin/rn`, el cual
puede correrse de las siguientes maneras:

```bash
$ ruby bin/rn [args]
```
>Para la ejecución de la herramienta, es necesario tener una versión reciente de
> Ruby (2.5 o posterior) y tener instaladas sus dependencias, las cuales se manejan con
> Bundle. 

### Comandos
* Books: lista las posibles acciones a realizar para con los cuadernos.
  - Books create NAME --> crea un cuaderno llamado NAME
  - Books delete NAME --> borra un cuaderno llamado NAME
  - Books list --> lista todos los cuadernos existentes
  - Books rename OLD_NAME NEW_NAME --> renombra al cuaderno OLD_NAME con NEW_NAME
* Notes: lista las posibles acciones a realizar para con las notas.
  - Notes create TITLE --> crea una nota en la carpeta especificada con --books o la guarda en una carpeta global por defecto, la nota tiene título y contenido
  - Notes delete TITLE --> elimina una nota, de una carpeta especificada o de la carpeta global en caso contrario 
  - Notes edit TITLE --> edita el contenido de una nota
  - Notes list --> lista todas las notas, o la de una carpeta específica
  - Notes retitle OLD_TITLE NEW_TITLE--> renombra una nota
  - Notes show TITLE --> Muestra una nota, título y contenido
  - Notes export [TITLE] --> Exporta una o más notas en texto plano a HTML con formato(Markdown), en el mismo directorio, con el mismo nombre. 
