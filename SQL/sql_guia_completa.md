# Domina SQL desde Cero hasta Nivel Avanzado
### Guía completa para desarrolladores — Arquitectura, fundamentos y dominio real

---

## Tabla de Contenidos

1. [Historia y contexto](#1-historia-y-contexto)
2. [¿Qué es una base de datos relacional?](#2-qué-es-una-base-de-datos-relacional)
3. [Tipos de datos en MySQL](#3-tipos-de-datos-en-mysql)
4. [DDL — Lenguaje de Definición de Datos](#4-ddl--lenguaje-de-definición-de-datos)
5. [Constraints — Restricciones e Integridad](#5-constraints--restricciones-e-integridad)
6. [DML — Lenguaje de Manipulación de Datos](#6-dml--lenguaje-de-manipulación-de-datos)
7. [DQL — Consultas SELECT en profundidad](#7-dql--consultas-select-en-profundidad)
8. [JOINs — Relacionar tablas](#8-joins--relacionar-tablas)
9. [Funciones de agregación y GROUP BY](#9-funciones-de-agregación-y-group-by)
10. [Subconsultas](#10-subconsultas)
11. [Vistas](#11-vistas)
12. [Índices y rendimiento](#12-índices-y-rendimiento)
13. [Transacciones y control de concurrencia](#13-transacciones-y-control-de-concurrencia)
14. [Procedimientos almacenados](#14-procedimientos-almacenados)
15. [Funciones definidas por el usuario](#15-funciones-definidas-por-el-usuario)
16. [Triggers](#16-triggers)
17. [Normalización](#17-normalización)
18. [Optimización y buenas prácticas](#18-optimización-y-buenas-prácticas)
19. [Seguridad en bases de datos](#19-seguridad-en-bases-de-datos)
20. [Ejercicios prácticos finales](#20-ejercicios-prácticos-finales)

---

## 1. Historia y contexto

### El problema antes de SQL

Antes de los años 70, los datos se almacenaban en archivos planos o estructuras jerárquicas y de red. Cada aplicación tenía su propio formato de datos. Si querías compartir información entre sistemas, tenías que escribir código personalizado para cada caso. Era frágil, costoso y difícil de mantener.

El problema fundamental era que **los datos estaban atados a la forma en que los programas los accedían**, no a su significado real. Cambiar la estructura física de los datos significaba reescribir los programas.

### Edgar F. Codd y el modelo relacional (1970)

En 1970, Edgar F. Codd, matemático de IBM, publicó el paper **"A Relational Model of Data for Large Shared Data Banks"**. En él propuso algo revolucionario: organizar los datos en **tablas (relaciones)** con filas y columnas, y definir operaciones matemáticas (álgebra relacional) para manipularlos.

Los principios clave de Codd:

- Los datos se representan en tablas bidimensionales
- Cada fila es única (identificada por una clave primaria)
- Las relaciones entre tablas se expresan a través de valores compartidos, no punteros físicos
- Los datos son independientes de cómo se almacenan físicamente

Esto significaba que podías cambiar cómo el motor guardaba los datos sin afectar a los programas que los usaban.

### El nacimiento de SQL

En 1974, Donald Chamberlin y Raymond Boyce, también de IBM, crearon **SEQUEL** (Structured English Query Language) para implementar las ideas de Codd en el sistema experimental **System R**. SEQUEL se renombró a **SQL** por razones legales.

En 1979, **Oracle** (entonces llamada Relational Software Inc.) lanzó el primer RDBMS comercial basado en SQL. IBM respondió con DB2 en 1983.

En 1986, **ANSI** estandarizó SQL (SQL-86), seguido por SQL-89, SQL-92, SQL:1999, SQL:2003, SQL:2008, SQL:2011, SQL:2016 y SQL:2019. Cada versión añadió nuevas capacidades.

### El ecosistema actual

Hoy existen múltiples motores SQL, cada uno con sus fortalezas:

| Motor | Empresa | Uso típico |
|-------|---------|------------|
| MySQL | Oracle (open source) | Web, aplicaciones generales |
| PostgreSQL | Comunidad | Aplicaciones complejas, GIS, JSON |
| SQL Server | Microsoft | Entornos enterprise Windows |
| Oracle DB | Oracle | Sistemas financieros, enterprise |
| SQLite | Comunidad | Aplicaciones móviles, embebidas |
| MariaDB | MariaDB Foundation | Fork de MySQL, alto rendimiento |

Esta guía usa **MySQL** como motor de referencia, pero el 90% aplica a cualquier motor SQL.

---

## 2. ¿Qué es una base de datos relacional?

### Conceptos fundamentales

Una **base de datos relacional** es un sistema que organiza los datos en tablas con relaciones entre ellas, garantizando integridad y consistencia.

**Tabla (Relación):** Una estructura bidimensional compuesta por filas y columnas. Cada tabla representa una entidad del mundo real.

**Fila (Tupla / Registro):** Una instancia específica de la entidad. En una tabla `users`, cada fila es un usuario.

**Columna (Atributo / Campo):** Una característica de la entidad. En `users`, las columnas serían `id`, `nombre`, `email`, etc.

**Clave primaria (Primary Key):** Un valor único que identifica cada fila de forma inequívoca. Nunca puede repetirse ni ser nulo.

**Clave foránea (Foreign Key):** Un campo en una tabla que referencia la clave primaria de otra tabla, estableciendo la relación entre ellas.

### Propiedades ACID

Todo sistema de base de datos relacional debe garantizar las propiedades **ACID**:

**Atomicidad:** Una transacción es todo o nada. Si falla cualquier parte, se deshace todo.

**Consistencia:** La base de datos siempre pasa de un estado válido a otro estado válido. Las reglas de integridad nunca se violan.

**Aislamiento:** Las transacciones concurrentes no se interfieren entre sí. El resultado debe ser el mismo que si se ejecutaran en serie.

**Durabilidad:** Una vez que una transacción se confirma (COMMIT), los cambios persisten aunque el sistema falle.

### El álgebra relacional (conceptos base)

SQL se fundamenta en el álgebra relacional. Entender estas operaciones te ayuda a pensar en las consultas correctamente:

| Operación | SQL equivalente | Descripción |
|-----------|----------------|-------------|
| Selección (σ) | WHERE | Filtra filas según condición |
| Proyección (π) | SELECT columnas | Selecciona columnas específicas |
| Producto cartesiano (×) | FROM t1, t2 | Combina todas las filas de dos tablas |
| JOIN (⋈) | JOIN | Combina tablas por condición |
| Unión (∪) | UNION | Combina resultados de dos consultas |
| Diferencia (−) | EXCEPT / NOT IN | Filas en A que no están en B |
| Intersección (∩) | INTERSECT / IN | Filas que están en ambas consultas |

---

## 3. Tipos de datos en MySQL

Elegir el tipo de dato correcto es una decisión de arquitectura. Impacta el almacenamiento, el rendimiento y la integridad.

### Numéricos enteros

```sql
TINYINT    -- 1 byte  → -128 a 127 (o 0 a 255 con UNSIGNED)
SMALLINT   -- 2 bytes → -32,768 a 32,767
MEDIUMINT  -- 3 bytes → -8,388,608 a 8,388,607
INT        -- 4 bytes → -2,147,483,648 a 2,147,483,647
BIGINT     -- 8 bytes → ±9.2 × 10^18
```

> Usa `UNSIGNED` cuando el valor nunca será negativo (IDs, cantidades). Dobla el rango positivo disponible.

```sql
-- ID nunca negativo: usa UNSIGNED
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY

-- Edad: TINYINT UNSIGNED es suficiente (0-255)
edad TINYINT UNSIGNED

-- Precio en centavos para evitar decimales: BIGINT
precio_centavos BIGINT UNSIGNED
```

### Numéricos decimales

```sql
FLOAT(p)        -- Precisión simple, aproximado (4 bytes)
DOUBLE(p)       -- Precisión doble, aproximado (8 bytes)
DECIMAL(M, D)   -- Exacto. M dígitos totales, D decimales
```

> **Nunca uses FLOAT o DOUBLE para dinero.** Son aproximaciones en punto flotante. `0.1 + 0.2` puede dar `0.30000000000000004`. Usa `DECIMAL(15, 2)` para valores monetarios.

```sql
-- Correcto para dinero:
precio DECIMAL(15, 2)      -- hasta 999,999,999,999,999.99
tasa_impuesto DECIMAL(5, 4) -- hasta 9.9999 (ej: 0.1900 = 19%)

-- Para coordenadas GPS (alta precisión):
latitud DECIMAL(10, 8)
longitud DECIMAL(11, 8)
```

### Cadenas de texto

```sql
CHAR(n)       -- Longitud fija. Siempre ocupa n bytes
VARCHAR(n)    -- Longitud variable. Ocupa lo que necesita + 1-2 bytes overhead
TEXT          -- Hasta 65,535 bytes (~64KB)
MEDIUMTEXT    -- Hasta 16,777,215 bytes (~16MB)
LONGTEXT      -- Hasta 4,294,967,295 bytes (~4GB)
ENUM(...)     -- Valor de una lista predefinida
SET(...)      -- Uno o más valores de una lista predefinida
```

> `CHAR` es más rápido que `VARCHAR` para columnas de longitud fija y constante (códigos de país, códigos postales). `VARCHAR` es más eficiente para contenido variable.

```sql
-- Fijo: código de país siempre 2 caracteres
codigo_pais CHAR(2)

-- Variable: nombre puede tener cualquier longitud
nombre VARCHAR(150)

-- Contenido largo: descripción de producto
descripcion TEXT

-- Lista cerrada: estado del pedido
estado ENUM('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')
```

### Fechas y tiempos

```sql
DATE          -- Solo fecha: '2024-12-25'
TIME          -- Solo hora: '14:30:00'
DATETIME      -- Fecha y hora: '2024-12-25 14:30:00' (sin zona horaria)
TIMESTAMP     -- Como DATETIME pero con zona horaria (se convierte a UTC)
YEAR          -- Solo año: 2024
```

> `TIMESTAMP` se guarda en UTC y se convierte a la zona horaria de la sesión al leer. `DATETIME` se guarda exactamente como se inserta. Para aplicaciones globales, usa `TIMESTAMP`.

```sql
-- Registro de cuándo se creó/modificó un registro:
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

-- Fecha de nacimiento: no necesita hora
fecha_nacimiento DATE

-- Reserva de hotel con hora exacta:
check_in DATETIME
check_out DATETIME
```

### Binarios y especiales

```sql
TINYBLOB / BLOB / MEDIUMBLOB / LONGBLOB  -- Datos binarios (imágenes, archivos)
BOOLEAN / BOOL  -- Alias de TINYINT(1). 0=false, 1=true
JSON            -- Documento JSON (MySQL 5.7.8+)
```

> Evita guardar archivos binarios grandes directamente en la base de datos. Guarda la ruta al archivo en el sistema de archivos o en un storage (S3, etc.). La DB no está optimizada para servir binarios grandes.

---

## 4. DDL — Lenguaje de Definición de Datos

DDL (Data Definition Language) son los comandos que definen y modifican la **estructura** de la base de datos: crear, alterar y eliminar objetos.

### CREATE DATABASE

```sql
-- Crear base de datos con codificación UTF-8 completa (soporta emojis)
CREATE DATABASE IF NOT EXISTS tienda_online
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- Seleccionar la base de datos
USE tienda_online;
```

> `utf8mb4` es el verdadero UTF-8 de 4 bytes. El `utf8` de MySQL es un alias de 3 bytes que no soporta emojis ni caracteres raros. **Siempre usa `utf8mb4`**.

### CREATE TABLE

```sql
CREATE TABLE IF NOT EXISTS categorias (
    id          INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    nombre      VARCHAR(100)    NOT NULL,
    descripcion TEXT,
    activo      BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id),
    UNIQUE KEY uq_categorias_nombre (nombre)
);

CREATE TABLE IF NOT EXISTS productos (
    id              INT UNSIGNED    NOT NULL AUTO_INCREMENT,
    categoria_id    INT UNSIGNED    NOT NULL,
    nombre          VARCHAR(200)    NOT NULL,
    descripcion     TEXT,
    precio          DECIMAL(10, 2)  NOT NULL,
    stock           INT UNSIGNED    NOT NULL DEFAULT 0,
    sku             VARCHAR(50)     NOT NULL,
    activo          BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    PRIMARY KEY (id),
    UNIQUE KEY uq_productos_sku (sku),
    KEY idx_productos_categoria (categoria_id),
    KEY idx_productos_activo_precio (activo, precio),
    
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categorias (id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);
```

### ALTER TABLE — Modificar tablas existentes

```sql
-- Agregar columna
ALTER TABLE productos
    ADD COLUMN peso_kg DECIMAL(8, 3) AFTER stock;

-- Agregar columna al inicio
ALTER TABLE productos
    ADD COLUMN codigo_barras VARCHAR(50) FIRST;

-- Modificar tipo de dato de columna existente
ALTER TABLE productos
    MODIFY COLUMN descripcion MEDIUMTEXT;

-- Renombrar columna (MySQL 8.0+)
ALTER TABLE productos
    RENAME COLUMN peso_kg TO peso;

-- Eliminar columna
ALTER TABLE productos
    DROP COLUMN codigo_barras;

-- Agregar índice
ALTER TABLE productos
    ADD INDEX idx_nombre (nombre);

-- Eliminar índice
ALTER TABLE productos
    DROP INDEX idx_nombre;

-- Agregar FK después de crear la tabla
ALTER TABLE productos
    ADD CONSTRAINT fk_productos_proveedor
    FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
    ON DELETE SET NULL ON UPDATE CASCADE;

-- Varias operaciones en un solo ALTER (más eficiente)
ALTER TABLE productos
    ADD COLUMN descuento DECIMAL(5, 2) NOT NULL DEFAULT 0.00,
    ADD COLUMN destacado BOOLEAN NOT NULL DEFAULT FALSE,
    ADD INDEX idx_destacado (destacado);
```

### DROP y TRUNCATE

```sql
-- Eliminar tabla completa (estructura + datos)
DROP TABLE IF EXISTS productos;

-- Eliminar todos los datos, resetear AUTO_INCREMENT, mantener estructura
-- Más rápido que DELETE sin WHERE porque no registra cada fila
TRUNCATE TABLE productos;

-- Eliminar base de datos completa
DROP DATABASE IF EXISTS tienda_online;
```

> `TRUNCATE` no puede deshacerse con ROLLBACK en MySQL (implica COMMIT automático). `DELETE FROM tabla` sí puede deshacerse. Elige según tu contexto.

### RENAME TABLE

```sql
-- Renombrar una tabla
RENAME TABLE productos TO articulos;

-- Renombrar varias tablas en una operación (atómica)
RENAME TABLE
    productos TO articulos,
    categorias TO grupos;
```

---

## 5. Constraints — Restricciones e Integridad

Las constraints son reglas que MySQL aplica automáticamente para garantizar la integridad de los datos. Son la primera línea de defensa de tu arquitectura de datos.

### PRIMARY KEY

```sql
-- Simple (una columna)
PRIMARY KEY (id)

-- Compuesta (múltiples columnas — útil en tablas de relación)
CREATE TABLE pedido_productos (
    pedido_id   INT UNSIGNED NOT NULL,
    producto_id INT UNSIGNED NOT NULL,
    cantidad    INT UNSIGNED NOT NULL,
    precio_unit DECIMAL(10, 2) NOT NULL,
    
    PRIMARY KEY (pedido_id, producto_id)  -- Combinación única
);
```

### UNIQUE

```sql
-- Una columna
UNIQUE KEY uq_email (email)

-- Combinación única (el par debe ser único, cada uno puede repetirse)
UNIQUE KEY uq_usuario_producto (usuario_id, producto_id)
```

### NOT NULL vs NULL

```sql
-- Siempre debe tener valor
nombre VARCHAR(150) NOT NULL

-- Puede no tener valor (el default de columnas es NULL si no se especifica)
telefono VARCHAR(20) NULL

-- Con default para evitar NULL sin obligar al usuario
activo BOOLEAN NOT NULL DEFAULT TRUE
```

> Como arquitecto de software: sé explícito. Si una columna puede ser NULL, ponlo. Si no puede, ponlo como NOT NULL. Nunca asumas el comportamiento por defecto.

### FOREIGN KEY y sus acciones

```sql
FOREIGN KEY (categoria_id) REFERENCES categorias(id)
    ON DELETE [acción]
    ON UPDATE [acción]
```

| Acción | Descripción |
|--------|-------------|
| `RESTRICT` | Rechaza la operación si hay filas relacionadas |
| `CASCADE` | Propaga el DELETE o UPDATE a las filas relacionadas |
| `SET NULL` | Pone NULL en la FK de las filas relacionadas |
| `SET DEFAULT` | Pone el valor DEFAULT en la FK (poco soportado en MySQL) |
| `NO ACTION` | Equivale a RESTRICT en MySQL |

```sql
-- Ejemplo: si eliminas un usuario, sus pedidos también se eliminan
FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
    ON DELETE CASCADE

-- Si eliminas una categoría y tiene productos, lanza error
FOREIGN KEY (categoria_id) REFERENCES categorias(id)
    ON DELETE RESTRICT

-- Si eliminas un proveedor, los productos quedan sin proveedor (NULL)
FOREIGN KEY (proveedor_id) REFERENCES proveedores(id)
    ON DELETE SET NULL
```

### CHECK (MySQL 8.0.16+)

```sql
CREATE TABLE productos (
    id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    precio  DECIMAL(10,2) NOT NULL,
    stock   INT NOT NULL DEFAULT 0,
    
    -- El precio siempre debe ser positivo
    CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    
    -- El stock no puede ser negativo
    CONSTRAINT chk_stock_no_negativo CHECK (stock >= 0),
    
    -- Validar formato de SKU
    CONSTRAINT chk_sku_formato CHECK (sku REGEXP '^[A-Z]{3}-[0-9]{6}$')
);
```

### DEFAULT

```sql
activo      BOOLEAN     NOT NULL DEFAULT TRUE,
created_at  TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
descuento   DECIMAL(5,2) NOT NULL DEFAULT 0.00,
pais        CHAR(2)     NOT NULL DEFAULT 'CO',
prioridad   TINYINT     NOT NULL DEFAULT 5
```

---

## 6. DML — Lenguaje de Manipulación de Datos

DML (Data Manipulation Language) son los comandos que manipulan los **datos** dentro de las tablas: insertar, actualizar, eliminar.

### INSERT

```sql
-- Inserción básica con nombres de columnas (siempre explicita las columnas)
INSERT INTO categorias (nombre, descripcion, activo)
VALUES ('Electrónica', 'Dispositivos y gadgets electrónicos', TRUE);

-- Inserción múltiple en una sola sentencia (más eficiente que múltiples INSERT)
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Ropa', 'Prendas de vestir para todas las edades'),
    ('Hogar', 'Artículos para el hogar y decoración'),
    ('Deportes', 'Equipos y ropa deportiva'),
    ('Libros', 'Literatura, técnicos y educativos');

-- INSERT con SELECT — insertar datos desde otra tabla
INSERT INTO productos_archivo (id, nombre, precio, fecha_archivo)
SELECT id, nombre, precio, NOW()
FROM productos
WHERE activo = FALSE;

-- INSERT OR UPDATE: si existe actualiza, si no existe inserta
-- Útil para sincronizaciones de datos
INSERT INTO configuracion (clave, valor)
VALUES ('max_intentos', '5')
ON DUPLICATE KEY UPDATE
    valor = VALUES(valor),
    updated_at = CURRENT_TIMESTAMP;
```

### UPDATE

```sql
-- Actualizar una columna con condición
UPDATE productos
SET precio = precio * 1.10  -- Aumentar 10%
WHERE categoria_id = 1;

-- Actualizar múltiples columnas
UPDATE productos
SET
    precio = 29.99,
    stock = stock + 100,
    updated_at = CURRENT_TIMESTAMP
WHERE id = 5;

-- UPDATE con JOIN — actualizar basándose en otra tabla
UPDATE productos p
INNER JOIN categorias c ON p.categoria_id = c.id
SET p.activo = FALSE
WHERE c.nombre = 'Descontinuados';

-- UPDATE con subconsulta
UPDATE usuarios
SET nivel = 'premium'
WHERE id IN (
    SELECT DISTINCT usuario_id
    FROM pedidos
    WHERE total > 1000000
    AND created_at >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
);
```

> **Regla de oro:** Siempre prueba tu condición WHERE con un SELECT antes de ejecutar un UPDATE o DELETE. Un UPDATE sin WHERE afecta TODAS las filas.

### DELETE

```sql
-- Eliminar con condición específica
DELETE FROM productos
WHERE id = 10;

-- Eliminar múltiples registros
DELETE FROM productos
WHERE activo = FALSE
AND stock = 0;

-- DELETE con JOIN
DELETE p
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE c.activo = FALSE;

-- Soft delete — mejor práctica arquitectónica
-- En lugar de eliminar, marcar como inactivo
UPDATE productos
SET
    activo = FALSE,
    deleted_at = CURRENT_TIMESTAMP
WHERE id = 10;
```

> Como arquitecto: en sistemas de producción, casi nunca deberías usar DELETE físico. Implementa **soft delete** con una columna `deleted_at` o `activo`. Así puedes recuperar datos accidentalmente eliminados y mantener auditoría.

### REPLACE

```sql
-- Si la fila existe (por PK o UNIQUE), la elimina e inserta de nuevo
-- Si no existe, la inserta
-- CUIDADO: hace DELETE + INSERT, no UPDATE, así que pierde valores no especificados
REPLACE INTO configuracion (clave, valor)
VALUES ('timeout', '30');
```

---

## 7. DQL — Consultas SELECT en profundidad

SELECT es el corazón de SQL. Un desarrollador que domina SELECT puede extraer cualquier información de cualquier base de datos.

### Estructura completa de un SELECT

```sql
SELECT    [DISTINCT] columnas          -- 6. Qué mostrar
FROM      tabla                        -- 1. De dónde
[JOIN     ...]                         -- 2. Combinaciones
[WHERE    condición]                   -- 3. Filtrar filas
[GROUP BY columnas]                    -- 4. Agrupar
[HAVING   condición_grupo]             -- 5. Filtrar grupos
[ORDER BY columnas [ASC|DESC]]         -- 7. Ordenar
[LIMIT    n [OFFSET m]];              -- 8. Paginar
```

> El orden de ejecución lógica es diferente al orden de escritura. MySQL procesa: FROM → JOIN → WHERE → GROUP BY → HAVING → SELECT → DISTINCT → ORDER BY → LIMIT. Entender esto te ayuda a saber qué puedes referenciar en cada cláusula.

### SELECT básico

```sql
-- Todas las columnas (evitar en producción — trae columnas innecesarias)
SELECT * FROM productos;

-- Columnas específicas
SELECT id, nombre, precio FROM productos;

-- Con alias
SELECT
    id,
    nombre AS producto,
    precio AS precio_base,
    precio * 1.19 AS precio_con_iva
FROM productos;

-- Expresiones calculadas
SELECT
    nombre,
    precio,
    stock,
    precio * stock AS valor_inventario
FROM productos
ORDER BY valor_inventario DESC;
```

### WHERE — Filtrado avanzado

```sql
-- Operadores de comparación
WHERE precio > 50000
WHERE precio BETWEEN 10000 AND 100000
WHERE nombre = 'Laptop'
WHERE nombre != 'Laptop'
WHERE categoria_id IN (1, 3, 5)
WHERE categoria_id NOT IN (2, 4)

-- NULL siempre se compara con IS NULL / IS NOT NULL (nunca con =)
WHERE deleted_at IS NULL
WHERE proveedor_id IS NOT NULL

-- LIKE — búsqueda de patrones
WHERE nombre LIKE 'Lap%'        -- empieza con "Lap"
WHERE nombre LIKE '%book%'      -- contiene "book"
WHERE sku LIKE 'ELEC-______'   -- ELEC- seguido de exactamente 6 caracteres
WHERE nombre NOT LIKE '%usado%'

-- Operadores lógicos
WHERE activo = TRUE AND precio < 500000
WHERE categoria_id = 1 OR categoria_id = 2
WHERE NOT (precio < 10000 OR stock = 0)

-- Condiciones compuestas con paréntesis para claridad
WHERE (categoria_id = 1 OR categoria_id = 2)
  AND precio BETWEEN 50000 AND 500000
  AND activo = TRUE
  AND deleted_at IS NULL
```

### ORDER BY

```sql
-- Ascendente (default)
ORDER BY nombre ASC

-- Descendente
ORDER BY precio DESC

-- Múltiples columnas: primero por categoría, luego por precio
ORDER BY categoria_id ASC, precio DESC

-- Por posición de columna (evitar, poco legible)
ORDER BY 3 DESC

-- Con NULLS: en MySQL, NULL se ordena primero en ASC
-- Para poner NULL al final en ASC:
ORDER BY IF(columna IS NULL, 1, 0), columna ASC

-- FIELD — orden personalizado
ORDER BY FIELD(estado, 'pendiente', 'procesando', 'enviado', 'entregado')
```

### LIMIT y paginación

```sql
-- Los primeros 10 resultados
SELECT * FROM productos LIMIT 10;

-- Página 2 (offset = (página - 1) * por_página)
SELECT * FROM productos LIMIT 10 OFFSET 10;

-- Top 5 productos más caros
SELECT nombre, precio
FROM productos
WHERE activo = TRUE
ORDER BY precio DESC
LIMIT 5;
```

### DISTINCT

```sql
-- Valores únicos de una columna
SELECT DISTINCT categoria_id FROM productos;

-- Combinaciones únicas
SELECT DISTINCT categoria_id, activo FROM productos;
```

### CASE — Lógica condicional en SELECT

```sql
SELECT
    nombre,
    precio,
    stock,
    CASE
        WHEN stock = 0 THEN 'Sin stock'
        WHEN stock < 10 THEN 'Stock bajo'
        WHEN stock < 50 THEN 'Stock normal'
        ELSE 'Stock alto'
    END AS estado_stock,
    
    CASE categoria_id
        WHEN 1 THEN 'Electrónica'
        WHEN 2 THEN 'Ropa'
        WHEN 3 THEN 'Hogar'
        ELSE 'Otra categoría'
    END AS categoria_nombre
FROM productos;
```

### Funciones de cadena

```sql
SELECT
    UPPER(nombre)                       AS nombre_mayusculas,
    LOWER(email)                        AS email_minusculas,
    LENGTH(nombre)                      AS longitud,
    CHAR_LENGTH(nombre)                 AS longitud_chars,   -- Diferente con UTF-8
    SUBSTRING(nombre, 1, 20)            AS nombre_corto,
    CONCAT(nombre, ' - ', sku)          AS nombre_sku,
    CONCAT_WS(' | ', nombre, sku, precio) AS info_completa,  -- Separador
    TRIM(nombre)                        AS sin_espacios,
    LTRIM(nombre)                       AS sin_espacio_izq,
    RTRIM(nombre)                       AS sin_espacio_der,
    REPLACE(nombre, 'viejo', 'nuevo')   AS reemplazado,
    INSTR(nombre, 'libro')              AS posicion,          -- 0 si no encuentra
    LPAD(id, 6, '0')                    AS id_formateado,     -- "000042"
    REGEXP_REPLACE(telefono, '[^0-9]', '') AS solo_numeros
FROM productos;
```

### Funciones de fecha

```sql
SELECT
    NOW()                                   AS fecha_actual,
    CURDATE()                               AS solo_fecha,
    CURTIME()                               AS solo_hora,
    DATE(created_at)                        AS fecha_creacion,
    TIME(created_at)                        AS hora_creacion,
    YEAR(created_at)                        AS año,
    MONTH(created_at)                       AS mes,
    DAY(created_at)                         AS dia,
    DAYNAME(created_at)                     AS nombre_dia,
    MONTHNAME(created_at)                   AS nombre_mes,
    DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') AS fecha_formato,
    DATEDIFF(NOW(), created_at)             AS dias_desde_creacion,
    TIMESTAMPDIFF(MONTH, created_at, NOW()) AS meses_desde_creacion,
    DATE_ADD(created_at, INTERVAL 30 DAY)   AS vence_en_30_dias,
    DATE_SUB(NOW(), INTERVAL 1 YEAR)        AS hace_un_año
FROM productos;
```

### Funciones de control

```sql
SELECT
    -- IFNULL: devuelve segundo argumento si el primero es NULL
    IFNULL(descripcion, 'Sin descripción') AS descripcion,
    
    -- NULLIF: devuelve NULL si los dos argumentos son iguales
    NULLIF(descuento, 0) AS descuento_real,
    
    -- IF: ternario de SQL
    IF(activo, 'Activo', 'Inactivo') AS estado,
    
    -- COALESCE: devuelve el primer valor no-NULL de la lista
    COALESCE(telefono_movil, telefono_fijo, 'Sin teléfono') AS telefono
FROM productos;
```

---

## 8. JOINs — Relacionar tablas

Los JOINs son la característica definitoria de SQL relacional. Permiten combinar datos de múltiples tablas en una sola consulta.

### Schema de ejemplo para JOINs

```sql
CREATE TABLE departamentos (
    id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre  VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    departamento_id INT UNSIGNED NULL,  -- NULL = sin departamento
    jefe_id         INT UNSIGNED NULL,  -- NULL = es el jefe máximo
    salario         DECIMAL(10,2) NOT NULL,
    
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY (jefe_id) REFERENCES empleados(id)
);

-- Datos de prueba
INSERT INTO departamentos (nombre) VALUES ('IT'), ('Ventas'), ('RRHH'), ('Gerencia');

INSERT INTO empleados (nombre, departamento_id, jefe_id, salario) VALUES
    ('Carlos Méndez', 4, NULL, 15000000),   -- id=1, CEO
    ('Ana Rodríguez', 1, 1, 8000000),       -- id=2, Jefe IT
    ('Pedro López', 2, 1, 7500000),         -- id=3, Jefe Ventas
    ('María García', 1, 2, 5000000),        -- id=4, Dev
    ('Luis Torres', 1, 2, 4800000),         -- id=5, Dev
    ('Sofia Ruiz', 2, 3, 4200000),          -- id=6, Ventas
    ('Jorge Díaz', NULL, NULL, 3500000);    -- id=7, sin dept
```

### INNER JOIN

Devuelve solo las filas que tienen coincidencia en **ambas** tablas.

```sql
SELECT
    e.nombre AS empleado,
    d.nombre AS departamento,
    e.salario
FROM empleados e
INNER JOIN departamentos d ON e.departamento_id = d.id
ORDER BY e.salario DESC;

-- Resultado: Solo empleados CON departamento (Jorge Díaz no aparece)
```

### LEFT JOIN (LEFT OUTER JOIN)

Devuelve **todas las filas de la tabla izquierda** y las coincidencias de la derecha. Si no hay coincidencia, las columnas de la derecha son NULL.

```sql
SELECT
    e.nombre AS empleado,
    IFNULL(d.nombre, 'Sin departamento') AS departamento,
    e.salario
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, e.nombre;

-- Resultado: Todos los empleados, incluido Jorge Díaz con NULL en departamento
```

### RIGHT JOIN (RIGHT OUTER JOIN)

Devuelve **todas las filas de la tabla derecha** y las coincidencias de la izquierda. Si no hay coincidencia, las columnas de la izquierda son NULL.

```sql
SELECT
    IFNULL(e.nombre, 'Sin empleados') AS empleado,
    d.nombre AS departamento
FROM empleados e
RIGHT JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre;

-- Resultado: Todos los departamentos, incluido RRHH si no tiene empleados
```

> En la práctica, RIGHT JOIN se puede siempre reescribir como LEFT JOIN cambiando el orden de las tablas. La mayoría de los desarrolladores solo usan LEFT JOIN.

### FULL OUTER JOIN

MySQL no tiene FULL OUTER JOIN nativo. Se simula con UNION:

```sql
-- Todos los empleados y todos los departamentos, con o sin coincidencia
SELECT e.nombre AS empleado, d.nombre AS departamento
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id

UNION

SELECT e.nombre AS empleado, d.nombre AS departamento
FROM empleados e
RIGHT JOIN departamentos d ON e.departamento_id = d.id;
```

### CROSS JOIN

Producto cartesiano: cada fila de la primera tabla combinada con cada fila de la segunda.

```sql
-- Todas las combinaciones de tallas y colores (útil para generar variantes de producto)
SELECT t.nombre AS talla, c.nombre AS color
FROM tallas t
CROSS JOIN colores c
ORDER BY t.id, c.id;
```

### SELF JOIN — Una tabla unida consigo misma

```sql
-- Mostrar cada empleado con el nombre de su jefe
SELECT
    e.nombre AS empleado,
    IFNULL(j.nombre, 'Es el jefe máximo') AS jefe
FROM empleados e
LEFT JOIN empleados j ON e.jefe_id = j.id
ORDER BY j.nombre, e.nombre;
```

### JOINs múltiples

```sql
-- Consulta con 3 tablas
SELECT
    p.nombre AS producto,
    c.nombre AS categoria,
    pv.nombre AS proveedor,
    p.precio,
    p.stock
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
INNER JOIN proveedores pv ON p.proveedor_id = pv.id
WHERE p.activo = TRUE
ORDER BY c.nombre, p.nombre;
```

### Anti JOIN — Encontrar registros SIN coincidencia

```sql
-- Empleados SIN departamento (usando LEFT JOIN + IS NULL)
SELECT e.nombre
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE d.id IS NULL;

-- Departamentos SIN empleados
SELECT d.nombre
FROM departamentos d
LEFT JOIN empleados e ON e.departamento_id = d.id
WHERE e.id IS NULL;
```

---

## 9. Funciones de agregación y GROUP BY

Las funciones de agregación calculan un valor a partir de un conjunto de filas.

### Funciones básicas

```sql
SELECT
    COUNT(*)                    AS total_filas,
    COUNT(descripcion)          AS filas_con_desc,  -- No cuenta NULLs
    COUNT(DISTINCT categoria_id) AS categorias_usadas,
    SUM(stock)                  AS stock_total,
    SUM(precio * stock)         AS valor_inventario,
    AVG(precio)                 AS precio_promedio,
    MIN(precio)                 AS precio_minimo,
    MAX(precio)                 AS precio_maximo,
    STDDEV(precio)              AS desviacion_estandar
FROM productos
WHERE activo = TRUE;
```

### GROUP BY

```sql
-- Estadísticas por categoría
SELECT
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos,
    AVG(p.precio) AS precio_promedio,
    SUM(p.stock) AS stock_total,
    MIN(p.precio) AS precio_minimo,
    MAX(p.precio) AS precio_maximo
FROM categorias c
LEFT JOIN productos p ON p.categoria_id = c.id AND p.activo = TRUE
GROUP BY c.id, c.nombre
ORDER BY total_productos DESC;
```

### HAVING — Filtrar grupos

```sql
-- Solo categorías con más de 5 productos y precio promedio mayor a $50,000
SELECT
    c.nombre AS categoria,
    COUNT(p.id) AS total_productos,
    ROUND(AVG(p.precio), 0) AS precio_promedio
FROM categorias c
INNER JOIN productos p ON p.categoria_id = c.id
WHERE p.activo = TRUE
GROUP BY c.id, c.nombre
HAVING COUNT(p.id) > 5
   AND AVG(p.precio) > 50000
ORDER BY precio_promedio DESC;
```

> **WHERE vs HAVING:** WHERE filtra filas **antes** de agrupar. HAVING filtra **grupos** después de agrupar. No puedes usar funciones de agregación en WHERE.

### GROUP BY con ROLLUP

```sql
-- Subtotales y gran total automáticos
SELECT
    IFNULL(c.nombre, 'TOTAL GENERAL') AS categoria,
    COUNT(p.id) AS productos,
    SUM(p.stock) AS stock_total
FROM categorias c
LEFT JOIN productos p ON p.categoria_id = c.id
GROUP BY c.nombre WITH ROLLUP;
```

### Funciones de ventana (Window Functions) — MySQL 8.0+

Las funciones de ventana realizan cálculos sobre un conjunto de filas relacionadas con la fila actual, sin colapsar las filas como GROUP BY.

```sql
-- Ranking de productos por precio dentro de cada categoría
SELECT
    c.nombre AS categoria,
    p.nombre AS producto,
    p.precio,
    RANK() OVER (PARTITION BY c.id ORDER BY p.precio DESC) AS rank_precio,
    DENSE_RANK() OVER (PARTITION BY c.id ORDER BY p.precio DESC) AS dense_rank,
    ROW_NUMBER() OVER (PARTITION BY c.id ORDER BY p.precio DESC) AS fila_numero,
    
    -- Precio del producto más caro de su categoría
    MAX(p.precio) OVER (PARTITION BY c.id) AS precio_max_categoria,
    
    -- Diferencia con el precio más caro
    MAX(p.precio) OVER (PARTITION BY c.id) - p.precio AS diferencia_max,
    
    -- Promedio de precio en la categoría
    ROUND(AVG(p.precio) OVER (PARTITION BY c.id), 2) AS promedio_categoria,
    
    -- Total acumulado de stock ordenado por precio
    SUM(p.stock) OVER (PARTITION BY c.id ORDER BY p.precio) AS stock_acumulado
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.activo = TRUE
ORDER BY c.nombre, p.precio DESC;
```

```sql
-- LAG y LEAD: acceder a filas anteriores y siguientes
SELECT
    DATE(created_at) AS fecha,
    COUNT(*) AS pedidos_dia,
    LAG(COUNT(*), 1) OVER (ORDER BY DATE(created_at)) AS pedidos_dia_anterior,
    COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY DATE(created_at)) AS variacion
FROM pedidos
GROUP BY DATE(created_at)
ORDER BY fecha;
```

---

## 10. Subconsultas

Una subconsulta es un SELECT dentro de otro SELECT. Son fundamentales para resolver problemas complejos.

### Subconsulta en WHERE

```sql
-- Productos más caros que el precio promedio
SELECT nombre, precio
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos WHERE activo = TRUE)
ORDER BY precio DESC;

-- Empleados del departamento con mayor nómina
SELECT nombre, salario
FROM empleados
WHERE departamento_id = (
    SELECT departamento_id
    FROM empleados
    GROUP BY departamento_id
    ORDER BY SUM(salario) DESC
    LIMIT 1
);
```

### Subconsulta con IN

```sql
-- Clientes que han realizado pedidos en el último mes
SELECT nombre, email
FROM usuarios
WHERE id IN (
    SELECT DISTINCT usuario_id
    FROM pedidos
    WHERE created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH)
);

-- Productos que nunca han sido pedidos
SELECT nombre, precio
FROM productos
WHERE id NOT IN (
    SELECT DISTINCT producto_id
    FROM pedido_productos
);
```

### Subconsulta con EXISTS

```sql
-- EXISTS es más eficiente que IN cuando la subconsulta es grande
-- Devuelve TRUE en cuanto encuentra la primera coincidencia

SELECT u.nombre, u.email
FROM usuarios u
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.usuario_id = u.id
    AND p.total > 500000
);

-- Productos sin pedidos (NOT EXISTS es eficiente)
SELECT p.nombre
FROM productos p
WHERE NOT EXISTS (
    SELECT 1
    FROM pedido_productos pp
    WHERE pp.producto_id = p.id
);
```

### Subconsulta en FROM (tabla derivada)

```sql
-- Promedio de pedidos por usuario, luego filtrar los que están por encima del promedio global
SELECT usuario_id, promedio_pedidos
FROM (
    SELECT
        usuario_id,
        AVG(total) AS promedio_pedidos,
        COUNT(*) AS cantidad_pedidos
    FROM pedidos
    GROUP BY usuario_id
) AS estadisticas_usuario
WHERE promedio_pedidos > (
    SELECT AVG(total) FROM pedidos
)
ORDER BY promedio_pedidos DESC;
```

### CTE — Common Table Expressions (WITH)

Las CTEs son subconsultas nombradas que hacen el código más legible. Disponibles en MySQL 8.0+.

```sql
-- Equivalente al ejemplo anterior pero más legible
WITH estadisticas_usuario AS (
    SELECT
        usuario_id,
        AVG(total) AS promedio_pedidos,
        COUNT(*) AS cantidad_pedidos
    FROM pedidos
    GROUP BY usuario_id
),
promedio_global AS (
    SELECT AVG(total) AS promedio FROM pedidos
)
SELECT
    u.nombre,
    eu.promedio_pedidos,
    eu.cantidad_pedidos
FROM estadisticas_usuario eu
INNER JOIN usuarios u ON u.id = eu.usuario_id
CROSS JOIN promedio_global pg
WHERE eu.promedio_pedidos > pg.promedio
ORDER BY eu.promedio_pedidos DESC;
```

### CTE recursiva — Jerarquías

```sql
-- Recorrer jerarquía de empleados (jefe → subordinados)
WITH RECURSIVE jerarquia AS (
    -- Caso base: el empleado raíz (sin jefe)
    SELECT id, nombre, jefe_id, 0 AS nivel, nombre AS ruta
    FROM empleados
    WHERE jefe_id IS NULL
    
    UNION ALL
    
    -- Caso recursivo: subordinados del nivel anterior
    SELECT e.id, e.nombre, e.jefe_id, j.nivel + 1, CONCAT(j.ruta, ' > ', e.nombre)
    FROM empleados e
    INNER JOIN jerarquia j ON e.jefe_id = j.id
)
SELECT
    REPEAT('  ', nivel) AS sangria,
    nombre,
    nivel,
    ruta
FROM jerarquia
ORDER BY ruta;
```

---

## 11. Vistas

Una vista es una consulta SQL guardada que se comporta como una tabla virtual. No almacena datos por sí misma, sino que ejecuta la consulta subyacente cada vez que se accede.

### Crear vistas

```sql
-- Vista simple: productos activos con categoría
CREATE OR REPLACE VIEW v_productos_activos AS
SELECT
    p.id,
    p.nombre,
    p.sku,
    p.precio,
    p.stock,
    c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.activo = TRUE AND p.deleted_at IS NULL;

-- Vista con lógica de negocio: resumen de ventas por mes
CREATE OR REPLACE VIEW v_ventas_mensuales AS
SELECT
    YEAR(created_at) AS año,
    MONTH(created_at) AS mes,
    MONTHNAME(created_at) AS nombre_mes,
    COUNT(*) AS total_pedidos,
    SUM(total) AS ingresos,
    AVG(total) AS ticket_promedio,
    MAX(total) AS pedido_mayor
FROM pedidos
WHERE estado != 'cancelado'
GROUP BY YEAR(created_at), MONTH(created_at);
```

### Usar vistas

```sql
-- Se usa exactamente igual que una tabla
SELECT * FROM v_productos_activos WHERE categoria = 'Electrónica';

SELECT año, mes, ingresos
FROM v_ventas_mensuales
WHERE año = 2024
ORDER BY mes;
```

### Vistas actualizables

Una vista es actualizable si cumple ciertas condiciones (sin GROUP BY, DISTINCT, funciones de agregación, etc.):

```sql
-- Esta vista es actualizable
CREATE VIEW v_productos_basico AS
SELECT id, nombre, precio, stock, activo
FROM productos;

-- Se puede hacer UPDATE y DELETE a través de ella
UPDATE v_productos_basico SET precio = 99.99 WHERE id = 1;
```

### Administrar vistas

```sql
-- Ver la definición de una vista
SHOW CREATE VIEW v_productos_activos;

-- Ver todas las vistas
SELECT TABLE_NAME, VIEW_DEFINITION
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'tienda_online';

-- Eliminar vista
DROP VIEW IF EXISTS v_productos_activos;
```

---

## 12. Índices y rendimiento

Los índices son estructuras de datos que aceleran las consultas a costa de mayor espacio en disco y más tiempo en escrituras (INSERT, UPDATE, DELETE).

### Tipos de índices en MySQL

```sql
-- PRIMARY KEY: índice único que identifica cada fila
PRIMARY KEY (id)

-- UNIQUE: valores únicos, permite búsquedas rápidas y garantiza unicidad
UNIQUE KEY uq_email (email)

-- INDEX (KEY): índice estándar para acelerar búsquedas
INDEX idx_categoria (categoria_id)

-- Índice compuesto: para consultas que filtran por múltiples columnas
INDEX idx_activo_precio (activo, precio)

-- FULLTEXT: para búsquedas de texto completo
FULLTEXT INDEX ft_nombre_desc (nombre, descripcion)
```

### Cuándo crear índices

**Crea índices en:**
- Columnas usadas frecuentemente en WHERE
- Columnas usadas en JOIN (las FKs deberían tenerlos)
- Columnas usadas en ORDER BY
- Columnas usadas en GROUP BY

**No crees índices en:**
- Tablas pequeñas (el costo supera el beneficio)
- Columnas con muy poca cardinalidad (ej: columna booleana en una tabla con 2 valores)
- Columnas que se actualizan constantemente

### Regla del prefijo izquierdo (Left Prefix Rule)

Para un índice compuesto `(a, b, c)`:
- Consulta con `WHERE a = x` → **usa el índice**
- Consulta con `WHERE a = x AND b = y` → **usa el índice**
- Consulta con `WHERE a = x AND b = y AND c = z` → **usa el índice**
- Consulta con `WHERE b = y` → **NO usa el índice** (salta 'a')
- Consulta con `WHERE b = y AND c = z` → **NO usa el índice**

```sql
-- Índice para consultas de productos activos ordenados por precio
CREATE INDEX idx_activo_precio ON productos(activo, precio);

-- Esta consulta USARÁ el índice:
SELECT * FROM productos WHERE activo = TRUE ORDER BY precio DESC;

-- Esta NO lo usará eficientemente (salta 'activo'):
SELECT * FROM productos ORDER BY precio DESC;
```

### EXPLAIN — Analizar consultas

```sql
EXPLAIN SELECT p.nombre, c.nombre AS categoria
FROM productos p
INNER JOIN categorias c ON p.categoria_id = c.id
WHERE p.activo = TRUE AND p.precio > 50000;
```

Columnas importantes de EXPLAIN:

| Columna | Qué significa |
|---------|--------------|
| `type` | Tipo de acceso. `const` > `eq_ref` > `ref` > `range` > `index` > `ALL` |
| `key` | Índice que está usando |
| `rows` | Estimación de filas a examinar |
| `Extra` | Info adicional. `Using filesort` y `Using temporary` son señales de alerta |

```sql
-- Versión más detallada (MySQL 8.0+)
EXPLAIN FORMAT=JSON SELECT ...;

-- Análisis real de ejecución (ejecuta la consulta)
EXPLAIN ANALYZE SELECT ...;
```

### Índices FULLTEXT para búsqueda de texto

```sql
-- Crear índice fulltext
ALTER TABLE productos
ADD FULLTEXT INDEX ft_busqueda (nombre, descripcion);

-- Búsqueda en modo natural (relevancia automática)
SELECT nombre, precio,
    MATCH(nombre, descripcion) AGAINST('laptop gaming' IN NATURAL LANGUAGE MODE) AS relevancia
FROM productos
WHERE MATCH(nombre, descripcion) AGAINST('laptop gaming' IN NATURAL LANGUAGE MODE)
ORDER BY relevancia DESC;

-- Búsqueda booleana con operadores
SELECT nombre FROM productos
WHERE MATCH(nombre, descripcion)
AGAINST('+laptop -usado gaming*' IN BOOLEAN MODE);
-- + = debe contener
-- - = no debe contener
-- * = wildcard al final
```

---

## 13. Transacciones y control de concurrencia

Una transacción es un conjunto de operaciones que se ejecutan como una unidad atómica: o todas tienen éxito, o ninguna.

### Comandos de transacción

```sql
START TRANSACTION;  -- Inicia la transacción (también: BEGIN)
COMMIT;             -- Confirma todos los cambios
ROLLBACK;           -- Deshace todos los cambios desde el último START TRANSACTION
SAVEPOINT nombre;   -- Punto de guardado intermedio
ROLLBACK TO nombre; -- Deshace hasta el savepoint, no hasta el inicio
RELEASE SAVEPOINT nombre; -- Elimina el savepoint
```

### Ejemplo: transferencia bancaria

```sql
START TRANSACTION;

-- Verificar saldo disponible
SELECT saldo INTO @saldo_origen
FROM cuentas
WHERE id = 101
FOR UPDATE;  -- Bloquea la fila para evitar lectura sucia concurrente

IF @saldo_origen < 500000 THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente';
END IF;

-- Debitar cuenta origen
UPDATE cuentas
SET saldo = saldo - 500000
WHERE id = 101;

-- Acreditar cuenta destino
UPDATE cuentas
SET saldo = saldo + 500000
WHERE id = 202;

-- Registrar movimiento
INSERT INTO movimientos (cuenta_origen, cuenta_destino, monto, fecha)
VALUES (101, 202, 500000, NOW());

COMMIT;
```

### SAVEPOINTS — Control granular

```sql
START TRANSACTION;

INSERT INTO pedidos (usuario_id, total) VALUES (1, 150000);
SET @pedido_id = LAST_INSERT_ID();

SAVEPOINT sp_pedido_creado;

INSERT INTO pedido_productos (pedido_id, producto_id, cantidad, precio_unit)
VALUES (@pedido_id, 5, 2, 75000);

-- Si este segundo insert falla, solo volvemos al savepoint, no cancelamos el pedido
SAVEPOINT sp_producto_agregado;

-- Si algo sale mal después de agregar el producto:
-- ROLLBACK TO sp_pedido_creado;  -- El pedido existe pero sin productos

COMMIT;
```

### Niveles de aislamiento

```sql
-- Ver el nivel actual
SELECT @@transaction_isolation;

-- Cambiar nivel para la sesión actual
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

| Nivel | Lectura sucia | Lectura no repetible | Lectura fantasma |
|-------|:---:|:---:|:---:|
| READ UNCOMMITTED | ✓ posible | ✓ posible | ✓ posible |
| READ COMMITTED | ✗ imposible | ✓ posible | ✓ posible |
| REPEATABLE READ | ✗ imposible | ✗ imposible | ✓ posible |
| SERIALIZABLE | ✗ imposible | ✗ imposible | ✗ imposible |

> MySQL/InnoDB usa **REPEATABLE READ** por defecto, que además previene lecturas fantasma gracias a su implementación MVCC.

### Bloqueos

```sql
-- FOR UPDATE: bloqueo exclusivo, nadie más puede leer ni escribir la fila
SELECT * FROM productos WHERE id = 5 FOR UPDATE;

-- FOR SHARE (MySQL 8.0+): bloqueo compartido, otros pueden leer pero no escribir
SELECT * FROM productos WHERE id = 5 FOR SHARE;
```

---

## 14. Procedimientos almacenados

Un procedimiento almacenado es un bloque de código SQL guardado en el servidor que encapsula lógica de negocio compleja.

### Estructura completa

```sql
DELIMITER $$

CREATE PROCEDURE sp_crear_pedido(
    IN  p_usuario_id    INT UNSIGNED,
    IN  p_productos     JSON,           -- [{"id":1,"cantidad":2}, ...]
    OUT p_pedido_id     INT UNSIGNED,
    OUT p_mensaje       VARCHAR(500)
)
BEGIN
    -- Declarar variables SIEMPRE al inicio, antes de cualquier otra sentencia
    DECLARE v_total         DECIMAL(10,2) DEFAULT 0;
    DECLARE v_producto_id   INT UNSIGNED;
    DECLARE v_cantidad      INT UNSIGNED;
    DECLARE v_precio        DECIMAL(10,2);
    DECLARE v_stock         INT UNSIGNED;
    DECLARE v_i             INT DEFAULT 0;
    DECLARE v_count         INT;
    
    -- Handler para errores — siempre declara DESPUÉS de variables
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_pedido_id = NULL;
        SET p_mensaje = 'Error interno al crear el pedido';
    END;
    
    START TRANSACTION;
    
    -- Calcular total y verificar stock
    SET v_count = JSON_LENGTH(p_productos);
    
    WHILE v_i < v_count DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].id')));
        SET v_cantidad    = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].cantidad')));
        
        SELECT precio, stock INTO v_precio, v_stock
        FROM productos
        WHERE id = v_producto_id
        FOR UPDATE;
        
        IF v_stock < v_cantidad THEN
            ROLLBACK;
            SET p_pedido_id = NULL;
            SET p_mensaje = CONCAT('Stock insuficiente para producto ID: ', v_producto_id);
            LEAVE sp_crear_pedido;  -- Salir del procedimiento
        END IF;
        
        SET v_total = v_total + (v_precio * v_cantidad);
        SET v_i = v_i + 1;
    END WHILE;
    
    -- Crear el pedido
    INSERT INTO pedidos (usuario_id, total, estado, created_at)
    VALUES (p_usuario_id, v_total, 'pendiente', NOW());
    
    SET p_pedido_id = LAST_INSERT_ID();
    
    -- Insertar productos y descontar stock
    SET v_i = 0;
    WHILE v_i < v_count DO
        SET v_producto_id = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].id')));
        SET v_cantidad    = JSON_UNQUOTE(JSON_EXTRACT(p_productos, CONCAT('$[', v_i, '].cantidad')));
        
        SELECT precio INTO v_precio FROM productos WHERE id = v_producto_id;
        
        INSERT INTO pedido_productos (pedido_id, producto_id, cantidad, precio_unit)
        VALUES (p_pedido_id, v_producto_id, v_cantidad, v_precio);
        
        UPDATE productos
        SET stock = stock - v_cantidad
        WHERE id = v_producto_id;
        
        SET v_i = v_i + 1;
    END WHILE;
    
    COMMIT;
    SET p_mensaje = 'Pedido creado exitosamente';
    
END $$

DELIMITER ;

-- Llamar el procedimiento
CALL sp_crear_pedido(
    1,
    '[{"id":1,"cantidad":2},{"id":3,"cantidad":1}]',
    @pedido_id,
    @mensaje
);
SELECT @pedido_id, @mensaje;
```

### Cursores — Procesar fila por fila

```sql
DELIMITER $$

CREATE PROCEDURE sp_recalcular_totales()
BEGIN
    DECLARE v_done      INT DEFAULT FALSE;
    DECLARE v_pedido_id INT UNSIGNED;
    DECLARE v_nuevo_total DECIMAL(10,2);
    
    -- Declarar cursor
    DECLARE cur_pedidos CURSOR FOR
        SELECT id FROM pedidos WHERE estado = 'pendiente';
    
    -- Handler para cuando el cursor se agota
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = TRUE;
    
    OPEN cur_pedidos;
    
    loop_pedidos: LOOP
        FETCH cur_pedidos INTO v_pedido_id;
        
        IF v_done THEN
            LEAVE loop_pedidos;
        END IF;
        
        -- Calcular total real desde los productos
        SELECT SUM(cantidad * precio_unit) INTO v_nuevo_total
        FROM pedido_productos
        WHERE pedido_id = v_pedido_id;
        
        UPDATE pedidos
        SET total = IFNULL(v_nuevo_total, 0)
        WHERE id = v_pedido_id;
        
    END LOOP;
    
    CLOSE cur_pedidos;
    
    SELECT ROW_COUNT() AS pedidos_actualizados;
END $$

DELIMITER ;
```

---

## 15. Funciones definidas por el usuario

Las funciones son similares a los procedimientos pero siempre retornan un valor y pueden usarse dentro de consultas SELECT.

```sql
DELIMITER $$

-- Función para calcular el precio con IVA
CREATE FUNCTION fn_precio_con_iva(
    precio      DECIMAL(10,2),
    tasa_iva    DECIMAL(5,4)
) RETURNS DECIMAL(10,2)
DETERMINISTIC     -- El mismo input siempre produce el mismo output
READS SQL DATA
BEGIN
    RETURN ROUND(precio * (1 + tasa_iva), 2);
END $$

-- Función para obtener el nombre del nivel de stock
CREATE FUNCTION fn_estado_stock(stock INT UNSIGNED)
RETURNS VARCHAR(20)
DETERMINISTIC
NO SQL
BEGIN
    DECLARE v_estado VARCHAR(20);
    
    IF stock = 0 THEN
        SET v_estado = 'Sin stock';
    ELSEIF stock < 5 THEN
        SET v_estado = 'Crítico';
    ELSEIF stock < 20 THEN
        SET v_estado = 'Bajo';
    ELSEIF stock < 100 THEN
        SET v_estado = 'Normal';
    ELSE
        SET v_estado = 'Alto';
    END IF;
    
    RETURN v_estado;
END $$

DELIMITER ;

-- Usar funciones en consultas
SELECT
    nombre,
    precio,
    fn_precio_con_iva(precio, 0.19) AS precio_con_iva,
    stock,
    fn_estado_stock(stock) AS estado_stock
FROM productos
WHERE activo = TRUE;
```

---

## 16. Triggers

Un trigger es un bloque de código que se ejecuta automáticamente en respuesta a un evento (INSERT, UPDATE, DELETE) en una tabla.

### Tipos de triggers

```sql
-- BEFORE INSERT, AFTER INSERT
-- BEFORE UPDATE, AFTER UPDATE
-- BEFORE DELETE, AFTER DELETE
```

### Ejemplos prácticos

```sql
DELIMITER $$

-- AFTER INSERT: registrar en log cuando se crea un pedido
CREATE TRIGGER tr_pedidos_after_insert
AFTER INSERT ON pedidos
FOR EACH ROW
BEGIN
    INSERT INTO auditoria (
        tabla, operacion, registro_id, usuario_id, datos, fecha
    )
    VALUES (
        'pedidos', 'INSERT', NEW.id, NEW.usuario_id,
        JSON_OBJECT('total', NEW.total, 'estado', NEW.estado),
        NOW()
    );
END $$

-- BEFORE UPDATE: validar que el precio no baje más del 50%
CREATE TRIGGER tr_productos_before_update
BEFORE UPDATE ON productos
FOR EACH ROW
BEGIN
    IF NEW.precio < (OLD.precio * 0.5) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El precio no puede bajar más del 50% en una sola actualización';
    END IF;
    
    -- Registrar quién hizo el cambio de precio
    IF NEW.precio != OLD.precio THEN
        INSERT INTO historial_precios (producto_id, precio_anterior, precio_nuevo, fecha)
        VALUES (OLD.id, OLD.precio, NEW.precio, NOW());
    END IF;
END $$

-- AFTER DELETE: soft-backup antes de eliminar
CREATE TRIGGER tr_productos_after_delete
AFTER DELETE ON productos
FOR EACH ROW
BEGIN
    INSERT INTO productos_eliminados
    SELECT *, NOW() AS eliminado_at
    FROM (SELECT OLD.*) AS fila_eliminada;
END $$

DELIMITER ;
```

### Acceso a OLD y NEW

| Evento | OLD | NEW |
|--------|-----|-----|
| INSERT | No disponible | Valores insertados |
| UPDATE | Valores anteriores | Valores nuevos |
| DELETE | Valores eliminados | No disponible |

### Administrar triggers

```sql
-- Ver triggers de la base de datos
SHOW TRIGGERS FROM tienda_online;

-- Ver trigger específico
SHOW CREATE TRIGGER tr_pedidos_after_insert;

-- Eliminar trigger
DROP TRIGGER IF EXISTS tr_pedidos_after_insert;
```

---

## 17. Normalización

La normalización es el proceso de organizar las tablas para eliminar redundancia y garantizar integridad de datos. Es una de las habilidades más importantes de un arquitecto de base de datos.

### Primera Forma Normal (1FN)

**Regla:** Cada celda debe contener un valor atómico (indivisible). No pueden haber grupos repetidos ni listas en una columna.

```sql
-- MAL: No está en 1FN
-- +--------+---------------------------+
-- | nombre | telefonos                 |
-- +--------+---------------------------+
-- | Juan   | 3001234567, 6012345678   |
-- +--------+---------------------------+

-- BIEN: En 1FN
CREATE TABLE clientes (
    id     INT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE cliente_telefonos (
    id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    telefono   VARCHAR(20) NOT NULL,
    tipo       ENUM('movil','fijo','trabajo'),
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

### Segunda Forma Normal (2FN)

**Regla:** Debe estar en 1FN y cada columna no-clave debe depender de la **clave completa**, no de parte de ella. Aplica cuando hay claves primarias compuestas.

```sql
-- MAL: No está en 2FN (nombre_producto depende solo de producto_id, no del par)
-- +------------+------------+-----------------+----------+
-- | pedido_id  | producto_id| nombre_producto | cantidad |
-- +------------+------------+-----------------+----------+

-- BIEN: En 2FN
CREATE TABLE pedido_productos (
    pedido_id   INT UNSIGNED NOT NULL,
    producto_id INT UNSIGNED NOT NULL,
    cantidad    INT UNSIGNED NOT NULL,
    precio_unit DECIMAL(10,2) NOT NULL,  -- precio al momento de compra: sí depende del par
    PRIMARY KEY (pedido_id, producto_id)
);
-- nombre_producto se queda en la tabla productos, donde sí tiene dependencia total
```

### Tercera Forma Normal (3FN)

**Regla:** Debe estar en 2FN y no debe haber **dependencias transitivas** (columna no-clave que depende de otra columna no-clave).

```sql
-- MAL: No está en 3FN (ciudad depende de codigo_postal, no del id del cliente)
-- +----+--------+----------------+---------+
-- | id | nombre | codigo_postal  | ciudad  |
-- +----+--------+----------------+---------+

-- BIEN: En 3FN
CREATE TABLE codigos_postales (
    codigo  VARCHAR(10) PRIMARY KEY,
    ciudad  VARCHAR(100) NOT NULL,
    depto   VARCHAR(100) NOT NULL
);

CREATE TABLE clientes (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    codigo_postal   VARCHAR(10),
    FOREIGN KEY (codigo_postal) REFERENCES codigos_postales(codigo)
);
```

### Forma Normal de Boyce-Codd (FNBC)

**Regla:** Versión más estricta de 3FN. Cada determinante debe ser una clave candidata.

### Cuándo desnormalizar

La normalización completa no siempre es óptima en la práctica. La **desnormalización** controlada puede mejorar el rendimiento en sistemas de lectura intensiva:

```sql
-- En un sistema de reportes de alto tráfico, puede ser válido guardar
-- el total del pedido en lugar de calcularlo cada vez:
ALTER TABLE pedidos ADD COLUMN total DECIMAL(10,2) NOT NULL DEFAULT 0;
-- (Mantenido con triggers o lógica de aplicación)

-- O guardar el nombre de la categoría en productos para evitar JOINs en reportes:
ALTER TABLE productos ADD COLUMN categoria_nombre VARCHAR(100);
-- (Requiere sincronización cuidadosa)
```

> Como arquitecto: normaliza primero, desnormaliza después con evidencia de rendimiento. La desnormalización prematura es fuente de bugs e inconsistencias.

---

## 18. Optimización y buenas prácticas

### Consejos de rendimiento

```sql
-- 1. Selecciona solo las columnas que necesitas
-- MAL:
SELECT * FROM productos JOIN categorias ON ...;
-- BIEN:
SELECT p.nombre, p.precio, c.nombre AS categoria FROM productos p JOIN categorias c ON ...;

-- 2. Usa índices en columnas de JOIN y WHERE
-- Asegúrate de que las columnas de JOIN tengan índices:
SHOW INDEX FROM productos;

-- 3. Evita funciones en columnas indexadas en WHERE
-- MAL (no usa el índice en created_at):
WHERE YEAR(created_at) = 2024
-- BIEN (usa el índice):
WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31 23:59:59'

-- 4. Evita SELECT en subqueries correlacionadas cuando sea posible
-- MAL (ejecuta la subconsulta por cada fila):
SELECT nombre, (SELECT nombre FROM categorias WHERE id = p.categoria_id) AS cat
FROM productos p;
-- BIEN (un solo JOIN):
SELECT p.nombre, c.nombre AS cat
FROM productos p JOIN categorias c ON p.categoria_id = c.id;

-- 5. Usa LIMIT en consultas exploratorias
SELECT * FROM tabla_grande LIMIT 100;

-- 6. Prefiere EXISTS sobre COUNT para verificar existencia
-- MAL:
IF (SELECT COUNT(*) FROM pedidos WHERE usuario_id = 1) > 0 THEN ...
-- BIEN:
IF EXISTS (SELECT 1 FROM pedidos WHERE usuario_id = 1) THEN ...
```

### Convenciones de nomenclatura (profesional)

```sql
-- Tablas: snake_case, plural, sustantivos
CREATE TABLE pedido_productos (...);   -- Tabla de relación
CREATE TABLE usuarios (...);

-- Columnas: snake_case
primera_nombre, fecha_nacimiento, precio_unitario

-- PKs: siempre 'id'
id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY

-- FKs: {tabla_singular}_id
usuario_id, categoria_id, pedido_id

-- Índices: idx_{tabla}_{columnas}
INDEX idx_productos_categoria (categoria_id)
INDEX idx_productos_activo_precio (activo, precio)

-- UNIQUEs: uq_{tabla}_{columna}
UNIQUE KEY uq_usuarios_email (email)

-- FKs nombradas: fk_{tabla}_{referencia}
CONSTRAINT fk_productos_categoria FOREIGN KEY (categoria_id) REFERENCES categorias(id)

-- Procedimientos: sp_{accion}_{entidad}
sp_crear_pedido, sp_actualizar_stock

-- Funciones: fn_{descripcion}
fn_calcular_iva, fn_estado_stock

-- Triggers: tr_{tabla}_{momento}_{evento}
tr_pedidos_after_insert, tr_productos_before_update

-- Vistas: v_{descripcion}
v_productos_activos, v_ventas_mensuales
```

### Variables de sistema importantes

```sql
-- Ver variables relevantes
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';  -- Memoria caché para InnoDB
SHOW VARIABLES LIKE 'max_connections';           -- Máximo de conexiones simultáneas
SHOW VARIABLES LIKE 'slow_query_log%';          -- Log de consultas lentas
SHOW VARIABLES LIKE 'long_query_time';           -- Umbral de consulta lenta (segundos)

-- Activar log de consultas lentas en sesión
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- Consultas que toman más de 1 segundo
```

---

## 19. Seguridad en bases de datos

### Gestión de usuarios y privilegios

```sql
-- Crear usuario
CREATE USER 'app_user'@'localhost' IDENTIFIED BY 'password_seguro_aqui';
CREATE USER 'app_user'@'%' IDENTIFIED BY 'password_seguro';  -- Cualquier host

-- Otorgar privilegios mínimos necesarios (principio de menor privilegio)
-- Para aplicación: solo leer y escribir datos, no modificar estructura
GRANT SELECT, INSERT, UPDATE, DELETE ON tienda_online.* TO 'app_user'@'localhost';

-- Para reportes: solo lectura
GRANT SELECT ON tienda_online.* TO 'reportes_user'@'localhost';

-- Para migraciones: control total de estructura pero no SUPER
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX
    ON tienda_online.* TO 'migrations_user'@'localhost';

-- Ver privilegios de un usuario
SHOW GRANTS FOR 'app_user'@'localhost';

-- Revocar privilegios
REVOKE DELETE ON tienda_online.* FROM 'app_user'@'localhost';

-- Eliminar usuario
DROP USER IF EXISTS 'app_user'@'localhost';

-- Aplicar cambios de privilegios
FLUSH PRIVILEGES;
```

### Principios de seguridad

```sql
-- 1. Nunca conectes con el usuario root desde la aplicación
-- 2. Un usuario por aplicación con solo los permisos necesarios
-- 3. Usa vistas para limitar qué datos puede ver cada rol

-- Vista que oculta datos sensibles para el rol de soporte
CREATE VIEW v_usuarios_soporte AS
SELECT
    id,
    CONCAT(SUBSTRING(nombre, 1, 2), '***') AS nombre_parcial,
    CONCAT(SUBSTRING(email, 1, 3), '***@', SUBSTRING_INDEX(email, '@', -1)) AS email_parcial,
    estado,
    created_at
FROM usuarios;

GRANT SELECT ON tienda_online.v_usuarios_soporte TO 'soporte_user'@'localhost';

-- 4. Siempre usa prepared statements desde la aplicación (previene SQL injection)
-- Ejemplo desde Node.js:
-- connection.query('SELECT * FROM usuarios WHERE email = ?', [email], callback);

-- 5. Valida y sanitiza antes de insertar
```

---

## 20. Ejercicios prácticos finales

### Schema de práctica

Ejecuta este schema antes de los ejercicios:

```sql
CREATE DATABASE IF NOT EXISTS practica_sql CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE practica_sql;

CREATE TABLE departamentos (
    id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL
);

CREATE TABLE empleados (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    apellido        VARCHAR(150) NOT NULL,
    email           VARCHAR(200) NOT NULL,
    departamento_id INT UNSIGNED,
    jefe_id         INT UNSIGNED,
    salario         DECIMAL(12,2) NOT NULL,
    fecha_ingreso   DATE NOT NULL,
    activo          BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_email (email),
    FOREIGN KEY (departamento_id) REFERENCES departamentos(id),
    FOREIGN KEY (jefe_id) REFERENCES empleados(id)
);

CREATE TABLE proyectos (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(200) NOT NULL,
    presupuesto     DECIMAL(15,2) NOT NULL,
    fecha_inicio    DATE NOT NULL,
    fecha_fin       DATE,
    estado          ENUM('planificado','activo','pausado','completado','cancelado') NOT NULL DEFAULT 'planificado'
);

CREATE TABLE empleado_proyecto (
    empleado_id INT UNSIGNED NOT NULL,
    proyecto_id INT UNSIGNED NOT NULL,
    rol         VARCHAR(100) NOT NULL,
    horas       INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (empleado_id, proyecto_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(id),
    FOREIGN KEY (proyecto_id) REFERENCES proyectos(id)
);

-- Datos de prueba
INSERT INTO departamentos VALUES
    (1,'Tecnología','Bogotá'),
    (2,'Ventas','Medellín'),
    (3,'Recursos Humanos','Bogotá'),
    (4,'Finanzas','Cali'),
    (5,'Marketing','Bogotá');

INSERT INTO empleados VALUES
    (1,'Carlos','Méndez','cmendes@empresa.com',1,NULL,12000000,'2019-03-15',TRUE),
    (2,'Ana','Rodríguez','arodriguez@empresa.com',1,1,8500000,'2020-01-10',TRUE),
    (3,'Pedro','López','plopez@empresa.com',2,1,7800000,'2019-08-20',TRUE),
    (4,'María','García','mgarcia@empresa.com',1,2,5500000,'2021-05-01',TRUE),
    (5,'Luis','Torres','ltorres@empresa.com',1,2,5200000,'2021-11-15',TRUE),
    (6,'Sofía','Ruiz','sruiz@empresa.com',2,3,4800000,'2022-02-28',TRUE),
    (7,'Jorge','Díaz','jdiaz@empresa.com',3,1,6000000,'2020-07-01',TRUE),
    (8,'Laura','Morales','lmorales@empresa.com',4,1,9000000,'2018-09-10',TRUE),
    (9,'Andrés','Castro','acastro@empresa.com',NULL,NULL,3800000,'2023-01-05',FALSE),
    (10,'Valentina','Herrera','vherrera@empresa.com',5,1,5800000,'2022-08-15',TRUE);

INSERT INTO proyectos VALUES
    (1,'Sistema ERP',500000000,'2023-01-01','2024-06-30','completado'),
    (2,'App Móvil Clientes',200000000,'2023-06-01',NULL,'activo'),
    (3,'Migración Cloud',350000000,'2024-01-15',NULL,'activo'),
    (4,'Portal Web',80000000,'2022-01-01','2022-12-31','completado'),
    (5,'BI y Reportes',120000000,'2024-03-01',NULL,'planificado');

INSERT INTO empleado_proyecto VALUES
    (1,1,'Arquitecto',800),(2,1,'Desarrollador',600),(4,1,'Desarrollador',400),
    (5,1,'QA',300),(1,2,'Arquitecto',200),(2,2,'Líder Técnico',500),
    (4,2,'Desarrollador',300),(5,2,'Desarrollador',300),(1,3,'Arquitecto',150),
    (2,3,'Desarrollador',200),(3,3,'Consultor',100),(8,3,'Finanzas',50),
    (1,4,'Arquitecto',400),(2,4,'Desarrollador',600),(7,5,'Analista',100);
```

---

### Ejercicios Nivel 1 — Fundamentos

**E1.1** Lista todos los empleados activos ordenados por salario descendente.

**E1.2** Muestra nombre, apellido y salario de empleados con salario entre $5,000,000 y $9,000,000.

**E1.3** Cuenta cuántos empleados hay por departamento (incluye departamentos sin empleados).

**E1.4** Muestra los 3 empleados con mayor salario.

**E1.5** Lista empleados cuyo apellido empiece con 'R' o 'M'.

```sql
-- Soluciones E1

-- E1.1
SELECT nombre, apellido, salario
FROM empleados
WHERE activo = TRUE
ORDER BY salario DESC;

-- E1.2
SELECT nombre, apellido, salario
FROM empleados
WHERE salario BETWEEN 5000000 AND 9000000
ORDER BY salario DESC;

-- E1.3
SELECT d.nombre AS departamento, COUNT(e.id) AS total_empleados
FROM departamentos d
LEFT JOIN empleados e ON e.departamento_id = d.id AND e.activo = TRUE
GROUP BY d.id, d.nombre
ORDER BY total_empleados DESC;

-- E1.4
SELECT nombre, apellido, salario
FROM empleados
WHERE activo = TRUE
ORDER BY salario DESC
LIMIT 3;

-- E1.5
SELECT nombre, apellido
FROM empleados
WHERE apellido LIKE 'R%' OR apellido LIKE 'M%'
ORDER BY apellido;
```

---

### Ejercicios Nivel 2 — JOINs y Agregación

**E2.1** Muestra cada empleado con el nombre de su departamento y el nombre de su jefe directo.

**E2.2** Calcula el salario promedio, mínimo y máximo por departamento.

**E2.3** Lista los proyectos con el número de empleados asignados y el total de horas registradas.

**E2.4** Encuentra empleados que trabajan en más de un proyecto.

**E2.5** Departamentos cuya nómina total supera los $15,000,000.

```sql
-- Soluciones E2

-- E2.1
SELECT
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    IFNULL(d.nombre, 'Sin departamento') AS departamento,
    IFNULL(CONCAT(j.nombre, ' ', j.apellido), 'Sin jefe') AS jefe
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
LEFT JOIN empleados j ON e.jefe_id = j.id
ORDER BY d.nombre, e.apellido;

-- E2.2
SELECT
    d.nombre AS departamento,
    COUNT(e.id) AS empleados,
    FORMAT(AVG(e.salario), 0) AS salario_promedio,
    FORMAT(MIN(e.salario), 0) AS salario_minimo,
    FORMAT(MAX(e.salario), 0) AS salario_maximo
FROM departamentos d
LEFT JOIN empleados e ON e.departamento_id = d.id AND e.activo = TRUE
GROUP BY d.id, d.nombre;

-- E2.3
SELECT
    p.nombre AS proyecto,
    p.estado,
    COUNT(ep.empleado_id) AS empleados_asignados,
    IFNULL(SUM(ep.horas), 0) AS total_horas,
    FORMAT(p.presupuesto, 0) AS presupuesto
FROM proyectos p
LEFT JOIN empleado_proyecto ep ON ep.proyecto_id = p.id
GROUP BY p.id, p.nombre, p.estado, p.presupuesto
ORDER BY total_horas DESC;

-- E2.4
SELECT
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    COUNT(ep.proyecto_id) AS proyectos,
    SUM(ep.horas) AS total_horas
FROM empleados e
INNER JOIN empleado_proyecto ep ON ep.empleado_id = e.id
GROUP BY e.id, e.nombre, e.apellido
HAVING COUNT(ep.proyecto_id) > 1
ORDER BY proyectos DESC;

-- E2.5
SELECT
    d.nombre AS departamento,
    FORMAT(SUM(e.salario), 0) AS nomina_total,
    COUNT(e.id) AS empleados
FROM departamentos d
INNER JOIN empleados e ON e.departamento_id = d.id AND e.activo = TRUE
GROUP BY d.id, d.nombre
HAVING SUM(e.salario) > 15000000
ORDER BY SUM(e.salario) DESC;
```

---

### Ejercicios Nivel 3 — Avanzado

**E3.1** Para cada empleado, muestra su salario, el salario promedio de su departamento y qué tan por encima o por debajo está del promedio (usa Window Functions).

**E3.2** Encuentra la jerarquía completa de reportes usando CTE recursiva.

**E3.3** Crea un procedimiento almacenado `sp_reporte_departamento(dept_id)` que muestre estadísticas del departamento.

**E3.4** Crea un trigger que registre en una tabla `auditoria_salarios` cada cambio de salario de un empleado.

**E3.5** Escribe una consulta que muestre el "top 1 proyecto por horas" de cada empleado.

```sql
-- Soluciones E3

-- E3.1
SELECT
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    d.nombre AS departamento,
    FORMAT(e.salario, 0) AS salario,
    FORMAT(AVG(e.salario) OVER (PARTITION BY e.departamento_id), 0) AS promedio_depto,
    FORMAT(e.salario - AVG(e.salario) OVER (PARTITION BY e.departamento_id), 0) AS diferencia,
    RANK() OVER (PARTITION BY e.departamento_id ORDER BY e.salario DESC) AS ranking_depto
FROM empleados e
LEFT JOIN departamentos d ON e.departamento_id = d.id
WHERE e.activo = TRUE
ORDER BY d.nombre, e.salario DESC;

-- E3.2
WITH RECURSIVE jerarquia_org AS (
    SELECT
        id, nombre, apellido, jefe_id, salario,
        0 AS nivel,
        CONCAT(nombre, ' ', apellido) AS ruta_jerarquica
    FROM empleados
    WHERE jefe_id IS NULL AND activo = TRUE
    
    UNION ALL
    
    SELECT
        e.id, e.nombre, e.apellido, e.jefe_id, e.salario,
        j.nivel + 1,
        CONCAT(j.ruta_jerarquica, ' → ', e.nombre, ' ', e.apellido)
    FROM empleados e
    INNER JOIN jerarquia_org j ON e.jefe_id = j.id
    WHERE e.activo = TRUE
)
SELECT
    REPEAT('  ', nivel) AS sangria,
    CONCAT(nombre, ' ', apellido) AS empleado,
    nivel,
    FORMAT(salario, 0) AS salario,
    ruta_jerarquica
FROM jerarquia_org
ORDER BY ruta_jerarquica;

-- E3.3
DELIMITER $$
CREATE PROCEDURE sp_reporte_departamento(IN p_dept_id INT UNSIGNED)
BEGIN
    SELECT d.nombre AS departamento, d.ciudad FROM departamentos d WHERE d.id = p_dept_id;
    
    SELECT
        COUNT(*) AS total_empleados,
        FORMAT(SUM(salario), 0) AS nomina_total,
        FORMAT(AVG(salario), 0) AS salario_promedio,
        FORMAT(MIN(salario), 0) AS salario_minimo,
        FORMAT(MAX(salario), 0) AS salario_maximo
    FROM empleados
    WHERE departamento_id = p_dept_id AND activo = TRUE;
    
    SELECT CONCAT(nombre, ' ', apellido) AS empleado, FORMAT(salario, 0) AS salario
    FROM empleados
    WHERE departamento_id = p_dept_id AND activo = TRUE
    ORDER BY salario DESC;
END $$
DELIMITER ;

CALL sp_reporte_departamento(1);

-- E3.4
CREATE TABLE auditoria_salarios (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    empleado_id     INT UNSIGNED NOT NULL,
    salario_anterior DECIMAL(12,2) NOT NULL,
    salario_nuevo   DECIMAL(12,2) NOT NULL,
    diferencia      DECIMAL(12,2) NOT NULL,
    porcentaje_cambio DECIMAL(5,2) NOT NULL,
    fecha_cambio    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$
CREATE TRIGGER tr_empleados_salario_update
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    IF NEW.salario != OLD.salario THEN
        INSERT INTO auditoria_salarios
            (empleado_id, salario_anterior, salario_nuevo, diferencia, porcentaje_cambio)
        VALUES (
            OLD.id,
            OLD.salario,
            NEW.salario,
            NEW.salario - OLD.salario,
            ROUND(((NEW.salario - OLD.salario) / OLD.salario) * 100, 2)
        );
    END IF;
END $$
DELIMITER ;

-- E3.5 (Top 1 proyecto por horas por empleado)
WITH ranked_proyectos AS (
    SELECT
        ep.empleado_id,
        p.nombre AS proyecto,
        ep.horas,
        ep.rol,
        ROW_NUMBER() OVER (PARTITION BY ep.empleado_id ORDER BY ep.horas DESC) AS rn
    FROM empleado_proyecto ep
    INNER JOIN proyectos p ON p.id = ep.proyecto_id
)
SELECT
    CONCAT(e.nombre, ' ', e.apellido) AS empleado,
    rp.proyecto AS proyecto_principal,
    rp.rol,
    rp.horas AS horas_en_proyecto
FROM empleados e
INNER JOIN ranked_proyectos rp ON rp.empleado_id = e.id AND rp.rn = 1
ORDER BY rp.horas DESC;
```

---

## Resumen de comandos esenciales

```sql
-- DDL
CREATE DATABASE / TABLE / INDEX / VIEW
ALTER TABLE ... ADD / MODIFY / DROP / RENAME COLUMN
DROP DATABASE / TABLE / INDEX / VIEW
TRUNCATE TABLE

-- DML
INSERT INTO tabla (cols) VALUES (vals)
UPDATE tabla SET col = val WHERE condicion
DELETE FROM tabla WHERE condicion

-- DQL
SELECT cols FROM tabla
JOIN / LEFT JOIN / RIGHT JOIN / CROSS JOIN
WHERE / AND / OR / NOT / IN / BETWEEN / LIKE / IS NULL
GROUP BY / HAVING
ORDER BY / LIMIT / OFFSET
DISTINCT / CASE WHEN

-- TCL (Transaction Control)
START TRANSACTION / BEGIN
COMMIT / ROLLBACK
SAVEPOINT / ROLLBACK TO

-- DCL (Data Control)
GRANT privilegios ON db.tabla TO usuario
REVOKE privilegios ON db.tabla FROM usuario

-- Programabilidad
CREATE PROCEDURE / FUNCTION / TRIGGER / EVENT
DELIMITER $$ ... END $$
CALL procedimiento()
DROP PROCEDURE / FUNCTION / TRIGGER
```

---

*Documento generado como guía de aprendizaje de SQL — Nivel fundamentos a avanzado*
*Motor de referencia: MySQL 8.0+ / MariaDB 10.6+*
