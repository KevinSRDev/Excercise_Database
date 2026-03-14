# Procedimientos Almacenados en MySQL

## ¿Qué son?

Un procedimiento almacenado es un bloque de código SQL guardado en la base de datos que puedes ejecutar cuando quieras, como si fuera una función. En lugar de escribir la misma consulta varias veces, la encapsulas en un procedimiento y la llamas por nombre.

**Ventajas:**
- Evitas repetir lógica SQL en múltiples lugares
- Puedes reutilizarlos desde cualquier cliente o aplicación
- Permiten encapsular transacciones complejas
- Mejoran la organización del código de base de datos

---

## Sintaxis básica

```sql
DELIMITER $$

CREATE PROCEDURE nombre_procedimiento(parámetros)
BEGIN
    -- código SQL
END $$

DELIMITER ;
```

> [!IMPORTANT] 
> `DELIMITER $$` le dice a MySQL que el terminador de sentencia ya no es `;` sino `$$`, porque dentro del procedimiento los `;` son parte del código, no el final del comando. Al terminar se vuelve a establecer `;` como delimitador.

---

## Tipos de parámetros

| Tipo | Descripción |
|------|-------------|
| `IN` | El procedimiento **recibe** un valor (entrada) |
| `OUT` | El procedimiento **devuelve** un valor (salida) |
| `INOUT` | El procedimiento recibe y devuelve un valor |

---

## Cómo crearlos paso a paso

1. Abre tu cliente MySQL (terminal, MySQL Workbench, DBeaver, etc.)
2. Selecciona la base de datos: `USE nombre_db;`
3. Cambia el delimitador: `DELIMITER $$`
4. Escribe el procedimiento con `BEGIN ... END $$`
5. Restaura el delimitador: `DELIMITER ;`
6. Llama el procedimiento con: `CALL nombre_procedimiento();`

---

## Ejemplos

### 1. Sin parámetros — consulta fija

```sql
DELIMITER $$

CREATE PROCEDURE obtener_usuarios()
BEGIN
    SELECT * FROM users;
END $$

DELIMITER ;

-- Ejecutar:
CALL obtener_usuarios();
```

---

### 2. Con parámetro IN — buscar por ID

```sql
DELIMITER $$

CREATE PROCEDURE obtener_usuario_por_id(IN p_id INT)
BEGIN
    SELECT * FROM users WHERE id = p_id;
END $$

DELIMITER ;

-- Ejecutar:
CALL obtener_usuario_por_id(5);
```

---

### 3. Con parámetro OUT — contar registros

```sql
DELIMITER $$

CREATE PROCEDURE contar_usuarios(OUT p_total INT)
BEGIN
    SELECT COUNT(*) INTO p_total FROM users;
END $$

DELIMITER ;

-- Ejecutar:
CALL contar_usuarios(@total);
SELECT @total;
```

> La variable `@total` es una variable de sesión en MySQL. El valor se guarda ahí y luego se consulta con `SELECT`.

---

### 4. Con lógica condicional — insertar si no existe

```sql
DELIMITER $$

CREATE PROCEDURE crear_usuario(
    IN p_nombre VARCHAR(100),
    IN p_email VARCHAR(100)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        INSERT INTO users (nombre, email) VALUES (p_nombre, p_email);
        SELECT 'Usuario creado' AS mensaje;
    ELSE
        SELECT 'El email ya existe' AS mensaje;
    END IF;
END $$

DELIMITER ;

-- Ejecutar:
CALL crear_usuario('Kevin', 'kevin@mail.com');
```

---

### 5. Con DECLARE — variables locales

```sql
DELIMITER $$

CREATE PROCEDURE resumen_usuarios()
BEGIN
    DECLARE total INT;
    DECLARE activos INT;

    SELECT COUNT(*) INTO total FROM users;
    SELECT COUNT(*) INTO activos FROM users WHERE activo = 1;

    SELECT total AS total_usuarios, activos AS usuarios_activos;
END $$

DELIMITER ;

-- Ejecutar:
CALL resumen_usuarios();
```

> `DECLARE` se usa para variables **locales** dentro del procedimiento. Van al inicio del bloque `BEGIN`, antes de cualquier otra sentencia.

---

### 6. Con transacción — operación segura

```sql
DELIMITER $$

CREATE PROCEDURE transferir_rol(
    IN p_user_id INT,
    IN p_nuevo_rol INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Error en la transacción' AS mensaje;
    END;

    START TRANSACTION;
        DELETE FROM user_roles WHERE user_id = p_user_id;
        INSERT INTO user_roles (user_id, rol_id) VALUES (p_user_id, p_nuevo_rol);
    COMMIT;

    SELECT 'Rol actualizado correctamente' AS mensaje;
END $$

DELIMITER ;
```

> `DECLARE EXIT HANDLER FOR SQLEXCEPTION` captura cualquier error SQL. Si algo falla, ejecuta `ROLLBACK` automáticamente y cancela todos los cambios.

---

### 7. Con LOOP — iterar sobre datos

```sql
DELIMITER $$

CREATE PROCEDURE actualizar_estados()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE v_id INT;

    DECLARE cur CURSOR FOR SELECT id FROM users WHERE activo = 0;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    loop_usuarios: LOOP
        FETCH cur INTO v_id;
        IF done THEN
            LEAVE loop_usuarios;
        END IF;
        UPDATE users SET estado = 'inactivo' WHERE id = v_id;
    END LOOP;

    CLOSE cur;
END $$

DELIMITER ;
```

> Esto usa un **cursor** para recorrer fila por fila el resultado de una consulta. Es útil cuando necesitas procesar cada registro individualmente.

---

## Comandos útiles

```sql
-- Ver todos los procedimientos de la base de datos actual
SHOW PROCEDURE STATUS WHERE Db = 'nombre_de_tu_db';

-- Ver el código fuente de un procedimiento
SHOW CREATE PROCEDURE nombre_procedimiento;

-- Eliminar un procedimiento
DROP PROCEDURE IF EXISTS nombre_procedimiento;

-- Modificar un procedimiento (primero se elimina, luego se recrea)
DROP PROCEDURE IF EXISTS nombre_procedimiento;
-- ... luego CREATE PROCEDURE de nuevo
```

---

## Manejo de errores con HANDLER

```sql
DELIMITER $$

CREATE PROCEDURE ejemplo_errores()
BEGIN
    -- Captura cualquier error SQL y continúa
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Ocurrió un error' AS mensaje;
    END;

    -- Captura cuando un cursor no encuentra más filas
    DECLARE CONTINUE HANDLER FOR NOT FOUND
    BEGIN
        SELECT 'No se encontraron registros' AS mensaje;
    END;

    SELECT * FROM tabla_que_no_existe;
END $$

DELIMITER ;
```

| Tipo de HANDLER | Descripción |
|----------------|-------------|
| `EXIT` | Detiene el procedimiento al ocurrir el error |
| `CONTINUE` | Continúa la ejecución después del error |
| `SQLEXCEPTION` | Captura cualquier error SQL |
| `NOT FOUND` | Captura cuando un cursor no tiene más filas |

---

## ¿Cuándo usarlos?

- Operaciones repetitivas (reportes, inserciones complejas)
- Lógica de negocio que siempre debe ejecutarse igual
- Operaciones que requieren transacciones (garantizar integridad)
- Cuando quieres que la app solo llame un nombre y no maneje el SQL directamente
- Procesos batch que afectan muchos registros a la vez