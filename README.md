<h1 align="center"> Sistema de Gestión y Análisis para una Fábrica de Sillones </h1>
<p align="center"</p>
<h2 align="center"> Trabajo Practico - Gestion de Datos - UTN FRBA 2025 1C  </h2>


## Objetivo del Proyecto 🎯

El objetivo del proyecto es diseñar e implementar un sistema de gestión para una fábrica de sillones, migrando y reorganizando los datos existentes en un modelo de base de datos eficiente, y desarrollando un modelo de inteligencia de negocios que permita analizar la información y apoyar la toma de decisiones.

### A través del desarrollo del proyecto se busca:
- Investigar y aplicar técnicas avanzadas de diseño de bases de datos.
- Transformar un conjunto de datos desorganizados en un modelo transaccional normalizado, consistente y eficiente.
- Implementar procesos reales de migración de datos, respetando la información original y sus posibles inconsistencias.
- Construir un modelo de Inteligencia de Negocios (BI) que permita generar indicadores de gestión para el análisis y la toma de decisiones.
- Fomentar el trabajo en equipo, la delegación de tareas y la toma de decisiones técnicas fundamentadas.

## Descripción General

Mediante este trabajo práctico se intenta simular la implementación de un nuevo sistema de gestión para una fábrica de sillones, encargada de administrar pedidos, ventas, compras, facturación y envíos a través de múltiples sucursales. La implementación de dicho sistema, requiere previamente realizar la migración de los datos que se tenían registrados hasta el momento. Para ello es necesario que se reformule el diseño de la base de datos y los procesos, de manera tal que cumplan con los nuevos requerimientos. Además, se solicita la implementación de un segundo modelo, con sus correspondientes procedimientos y vistas, que pueda ser utilizado para la obtención de indicadores de
gestión, análisis de escenarios y proyección para la toma de decisiones.

La organización cuenta con información histórica almacenada en un sistema heredado, representado por una única tabla maestra que concentra todos los datos del negocio. La tabla maestra presenta inconsistencias como:

- Datos desnormalizados y redundantes
- Falta de relaciones explícitas
- Inconsistencias en fechas, identificadores y registros
- Ausencia de reglas de integridad

El trabajo consiste en rediseñar completamente la base de datos, partiendo de esta tabla original, para construir un nuevo modelo normalizado, escalable.


> _Ver enunciado completo [acá](TP-Gestion-de-Datos/Documentos/Enunciado.pdf)_


## Pasos para ejecutar el Trabajo
## Requisitos Previos
Antes de comenzar, es necesario contar con:
- Microsoft SQL Server 2022 (Express o Full)
- SQL Server Management Studio (SSMS)
- Acceso a un usuario con permisos suficientes (por ejemplo, sa)
- Sistema operativo con soporte para ejecución de scripts por consola

## Carga de Datos Iniciales (Tabla Maestra)
El trabajo parte de una base de datos inicial provista por la cátedra, compuesta por una tabla maestra desnormalizada.

1. Crear una nueva base de datos en SQL Server con los parámetros por defecto y un nombre: Ejemplo: ```GDD1C2025```
2. Descomprimir el archivo: [gd_esquema.Maestra.Table.rar](TP-Gestion-de-Datos/Data/gd_esquema.Maestra.Table.rar)
3. Ejecutar el comando de consola de SQL Server llamada ["sqlcmd"](TP-Gestion-de-Datos/Scripts/cmd.txt)

Aclaración: Al ejecutar sqlcmd, se deben especificar los parámetros:
-S nombre del servidor
-U nombre de usuario
-P contraseña
de acuerdo a las credenciales configuradas en el entorno local de cada usuario.

En caso de haber configurado SQL Server con Autenticación de Windows, 
no debe incluirse en el comando sqlcmd los parámetros -U y -P, ya que estos solo se utilizan cuando la base de datos está configurada con autenticación mixta.
Cuando se utiliza autenticación mixta, el usuario y la contraseña deben especificarse explícitamente.

## Ejecucion de Scripts

Primer se debe crear el Modelo Operativo corriendo el script

	script_creacion_inicial.sql

Luego podemos crear el Modelo BI corriendo

	script_creacion_BI.sql

Listo ya podemos hacer consultas libremente sobre el modelo OLPT y el OLAP

## Integrantes 
- [Roger Ramos](https://github.com/RogerRamosAW)
- [Nahuel Lazarte](https://github.com/NahuelLazarte)
- [Matías Escordamaglia](https://github.com/matias-escordamaglia)
- [Matías Tiscornia](https://github.com/Matitisco)
