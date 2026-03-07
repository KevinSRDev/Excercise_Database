> [!IMPORTANT] 
> # Solución a Taller [Taller Base de Datos SQL](https://1drv.ms/b/c/73b18dccb0a722be/IQDn4iinEtJ4QrErjpk1_rdUAfoMmDwluicUXhWLjdZHB_k?e=sQeG3P)


# 1. Taller Práctico: Evolución de Modelos Relacionales Mediante DDL
Asignatura: Bases de Datos

Únicamente sentencias DDL

## *Bloque 1: Seguridad e Integridad*
### 1. Unicidad de usuario: 

```SQL
USE  api_crud_taller; 


ALTER TABLE users 

ADD CONSTRAINT uq_users_user_user UNIQUE (User_user); 
```

> [!NOTE]
>  Lo use para evitar riesgos al usar `MODIFY COLUMN` para colocar el `UNIQUE`, al ser una tabla ya creada y para no perder propiedades que ya tenia la columna.
>
> Pero si no tuviera datos utilizaria directamente el `MODIFY COLUMN User_user VARCHAR(255) NOT NULL UNIQUE;` sin omitir ninguna propiedad existente

### 2. Verificación de Cuenta:

```SQL
USE  api_crud_taller;

ALTER TABLE users
ADD COLUMN is_verified TINYINT(1) UNSIGNED NOT NULL DEFAULT 0;


-- Es mejor usar el BOOLEAN, aunque MySQL despues lo convierta a TINYINT(1)

ALTER TABLE users 
MODIFY is_verified BOOLEAN;
```

Usar `TINYINT` porque si se usa `BOOLEAN` **MySQL** lo convierte internamente a `TINYINT(1)`;

### 3. Registro de Accesos:

```SQL
USE  api_crud_taller;

CREATE TABLE login_logs (
	log_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(255) NOT NULL,
    User_fk INT(11) UNSIGNED NOT NULL,
    ip_address VARCHAR(45) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_login_logs_user FOREIGN KEY (User_fk) REFERENCES users(User_id)
);
```
> [!TIP] 
> *¿Por qué ponerle nombre con `CONSTRAINT` a la FK?*
>
> **Rta:** Nombrar los constraints es documentación viva cuando algo falla y se necesita eliminar el `CONSTRAINT` o las restricciones.

## *Bloque 2: Expansión Geográfica y Social*

### 4. Maestro de Países:

```SQL
USE  api_crud_taller;

CREATE TABLE countries (
	country_id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL,
    CONSTRAINT uq_countries_name UNIQUE (country_name)
);
```

### 5. Localización de Perfiles:

```SQL
USE  api_crud_taller;

ALTER TABLE profiles
	ADD COLUMN country_fk INT(11) UNSIGNED,
    ADD CONSTRAINT fk_profiles_country FOREIGN KEY (country_fk) REFERENCES countries(country_id);
```
```SQL
-- Se elimina esta columna porque es un dato duplicado, ya esxite en la tabla users
ALTER TABLE profiles
DROP COLUMN Profile_email;
```

### 6. Multimedia

```SQL
USE  api_crud_taller;

ALTER TABLE profiles
	ADD COLUMN profile_bio TEXT;
```

## *Bloque 3: Auditoría y Mejores Prácticas*

### 7. Borrado Lógico:

```SQL
USE  api_crud_taller;

ALTER TABLE users
	ADD COLUMN deleted_at TIMESTAMP NULL DEFAULT NULL;
    
ALTER TABLE roles
	ADD COLUMN deleted_at TIMESTAMP NULL DEFAULT NULL; 
```
### 8. Control de API:

```SQL
USE  api_crud_taller;

ALTER TABLE api_users
	ADD COLUMN api_token CHAR(64) NOT NULL,
    ADD CONSTRAINT uq_api_users_token UNIQUE (api_token);
```

### 9. Jerarquía:

> [!TIP] 
> **¿qué es una auto-referencia?**
> 
> - Una tabla que tiene una FK que apunta
a su propia PK
> 
> - Un registro puede ser `"padre"` de
otro registro de la misma tabla
>
> - Permite representar JERARQUÍAS
dentro de una sola tabla


Ejemplo por Claude IA:
```SQL
¿Cómo funciona la auto-referencia?

modules
──────────────────────────────
Module_id  ◄──────────────────┐
Module_name                   │
Modules_parent_module ────────┘
        ↑
apunta a la PK de la misma tabla ✅

CREATE TABLE menu (
    menu_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    menu_name   VARCHAR(100) NOT NULL,
    menu_url    VARCHAR(255),
    parent_id   INT UNSIGNED,
    menu_order  INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_menu_parent
        FOREIGN KEY (parent_id) REFERENCES menu(menu_id)
);

2️⃣ Categorías de productos (ecommerce)
Ropa           (id:1, parent:NULL)
├── Hombre     (id:2, parent:1)
│   ├── Camisas(id:4, parent:2)
│   └── Jeans  (id:5, parent:2)
└── Mujer      (id:3, parent:1)
    ├── Blusas (id:6, parent:3)
    └── Faldas (id:7, parent:3)
```

### Answer
```SQL
USE  api_crud_taller;

-- Si se a convertir en FK y no puede ser un VARCHAR, se cambia a INT
ALTER TABLE modules
MODIFY COLUMN Modules_parent_module INT UNSIGNED;

-- Se hace la auto-referencia
ALTER TABLE modules
ADD CONSTRAINT fk_modules_parent
    FOREIGN KEY (Modules_parent_module)
    REFERENCES modules(Modules_id);
```

### 10.​Renombramiento:

```SQL
USE  api_crud_taller;

RENAME TABLE user_status TO status_catalog; 
```

# 2. Taller Práctico: Manipulación de Datos y Lógica de Servidor (DML PL/SQL)

**Objetivo:** Gestionar el ciclo de vida de la información mediante inserciones masivas, consultas
complejas y la automatización de procesos en la base de datos.

## Actividad 1: Poblamiento de Datos (DML)

### 1. Status_catalog

```SQL
INSERT INTO status_catalog (User_status_name, User_status_description) VALUES
('Activo',       'Usuario con acceso completo al sistema'),
('Inactivo',     'Usuario sin actividad reciente'),
('Bloqueado',    'Usuario bloqueado por seguridad'),
('Pendiente',    'Usuario pendiente de aprobación'),
('Suspendido',   'Usuario suspendido temporalmente'),
('En revisión',  'Usuario en proceso de verificación'),
('Eliminado',    'Usuario eliminado lógicamente'),
('Sin verificar','Usuario sin confirmar correo'),
('Verificado',   'Usuario con correo confirmado'),
('Expirado',     'Sesión o cuenta expirada'),
('En espera',    'Usuario en lista de espera'),
('Rechazado',    'Solicitud de acceso rechazada'),
('Aprobado',     'Usuario aprobado por administrador'),
('Archivado',    'Usuario archivado sin acceso'),
('Temporal',     'Usuario con acceso temporal');
```

### 2. countries

```SQL
INSERT INTO countries (country_name) VALUES
('Colombia'),
('México'),
('España'),
('Argentina'),
('Chile'),
('Perú'),
('Ecuador'),
('Venezuela'),
('Brasil'),
('Uruguay'),
('Paraguay'),
('Bolivia'),
('Costa Rica'),
('Panamá'),
('Guatemala');
```

### 3. roles

```SQL
INSERT INTO roles (Roles_name, Roles_description) VALUES
('SuperAdmin',    'Acceso total sin restricciones'),
('Admin',         'Administrador general del sistema'),
('Auditor',       'Revisión y control de operaciones'),
('Ventas',        'Gestión de ventas y clientes'),
('Soporte',       'Atención y soporte técnico'),
('Moderador',     'Moderación de contenido'),
('Editor',        'Creación y edición de contenido'),
('Analista',      'Análisis de datos y reportes'),
('Desarrollador', 'Desarrollo y mantenimiento'),
('Contador',      'Gestión financiera y contable'),
('RRHH',          'Gestión de recursos humanos'),
('Marketing',     'Estrategias de mercadeo'),
('Logística',     'Coordinación de operaciones'),
('Supervisor',    'Supervisión de equipos'),
('Invitado',      'Acceso limitado de solo lectura');
```

### 4. users

```SQL
INSERT INTO users (User_user, User_email, User_password, Roles_fk, User_status_fk, is_verified) VALUES
('superadmin',    'superadmin@mail.com',  SHA2('pass001', 256), 1,  1,  1),
('admin_john',    'john@mail.com',        SHA2('pass002', 256), 2,  1,  1),
('auditor_ana',   'ana@mail.com',         SHA2('pass003', 256), 3,  1,  1),
('ventas_luis',   'luis@mail.com',        SHA2('pass004', 256), 4,  1,  1),
('soporte_mar',   'mar@mail.com',         SHA2('pass005', 256), 5,  2,  0),
('mod_carlos',    'carlos@mail.com',      SHA2('pass006', 256), 6,  1,  1),
('editor_sofia',  'sofia@mail.com',       SHA2('pass007', 256), 7,  3,  0),
('analista_pedro','pedro@mail.com',       SHA2('pass008', 256), 8,  1,  1),
('dev_laura',     'laura@mail.com',       SHA2('pass009', 256), 9,  4,  0),
('cont_miguel',   'miguel@mail.com',      SHA2('pass010', 256), 10, 1,  1),
('rrhh_diana',    'diana@mail.com',       SHA2('pass011', 256), 11, 5,  1),
('mkt_roberto',   'roberto@mail.com',     SHA2('pass012', 256), 12, 1,  0),
('log_carmen',    'carmen@mail.com',      SHA2('pass013', 256), 13, 3,  1),
('sup_jorge',     'jorge@mail.com',       SHA2('pass014', 256), 14, 1,  1),
('guest_maria',   'maria@mail.com',       SHA2('pass015', 256), 15, 8,  0);
```

### 5. profiles

```SQL
INSERT INTO profiles (Profile_name, Profile_photo, profile_bio, User_id_fk, country_fk) VALUES
('Super Admin',    'photos/superadmin.jpg', 'Administrador principal del sistema.',         1,  1),
('John Pérez',     'photos/john.jpg',       'Administrador con 5 años de experiencia.',     2,  1),
('Ana Gómez',      'photos/ana.jpg',        'Auditora certificada en seguridad.',           3,  2),
('Luis Torres',    'photos/luis.jpg',       'Ejecutivo de ventas región norte.',            4,  3),
('María Ruiz',     'photos/mar.jpg',        'Especialista en soporte técnico.',             5,  4),
('Carlos Mora',    'photos/carlos.jpg',     'Moderador de contenido y comunidad.',          6,  5),
('Sofía Vargas',   'photos/sofia.jpg',      'Editora de contenidos digitales.',             7,  6),
('Pedro Díaz',     'photos/pedro.jpg',      'Analista de datos y reportes.',                8,  7),
('Laura Méndez',   'photos/laura.jpg',      'Desarrolladora fullstack.',                    9,  8),
('Miguel Castro',  'photos/miguel.jpg',     'Contador con enfoque en finanzas digitales.',  10, 9),
('Diana Flores',   'photos/diana.jpg',      'Gestora de recursos humanos.',                 11, 10),
('Roberto Silva',  'photos/roberto.jpg',    'Especialista en marketing digital.',           12, 11),
('Carmen López',   'photos/carmen.jpg',     'Coordinadora de logística.',                   13, 12),
('Jorge Ramírez',  'photos/jorge.jpg',      'Supervisor de operaciones.',                   14, 13),
('María Invitada', 'photos/maria.jpg',      'Usuario invitado con acceso limitado.',        15, 14);
```

---

## Regla de oro
```
Un dato debe vivir en UN solo lugar
        ↓
El email es dato de autenticación
        ↓
Pertenece a users ✅
profiles solo tiene datos de presentación:
nombre, foto, bio, país ✅
```

### 6. modules

```SQL
-- Primero corregir el tipo de columna
ALTER TABLE modules
MODIFY COLUMN Modules_parent_module INT UNSIGNED;

ALTER TABLE modules
ADD CONSTRAINT fk_modules_parent
    FOREIGN KEY (Modules_parent_module)
    REFERENCES modules(Modules_id);

-- Módulos raíz
INSERT INTO modules (Modules_name, Modules_description, Modules_route, Modules_icon, Modules_submodule, Modules_parent_module) VALUES
('Dashboard',     'Panel principal',           '/dashboard',     'home',     0, NULL),
('Ventas',        'Gestión de ventas',         '/ventas',        'cart',     0, NULL),
('Inventario',    'Control de inventario',     '/inventario',    'box',      0, NULL),
('RRHH',          'Recursos humanos',          '/rrhh',          'people',   0, NULL),
('Configuración', 'Configuración del sistema', '/config',        'settings', 0, NULL);

-- Hijos de Ventas (Modules_id: 2)
INSERT INTO modules (Modules_name, Modules_description, Modules_route, Modules_icon, Modules_submodule, Modules_parent_module) VALUES
('Reporte Ventas', 'Reportes de ventas',    '/ventas/reportes',     'chart',    1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Ventas')),
('Clientes',       'Gestión de clientes',   '/ventas/clientes',     'person',   1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Ventas')),
('Cotizaciones',   'Gestión cotizaciones',  '/ventas/cotizaciones', 'document', 1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Ventas'));

-- Hijos de Inventario
INSERT INTO modules (Modules_name, Modules_description, Modules_route, Modules_icon, Modules_submodule, Modules_parent_module) VALUES
('Productos',   'Gestión de productos',   '/inventario/productos',   'cube',  1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Inventario')),
('Proveedores', 'Gestión de proveedores', '/inventario/proveedores', 'truck', 1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Inventario')),
('Stock',       'Control de stock',       '/inventario/stock',       'stack', 1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Inventario'));

-- Hijos de RRHH
INSERT INTO modules (Modules_name, Modules_description, Modules_route, Modules_icon, Modules_submodule, Modules_parent_module) VALUES
('Empleados', 'Gestión de empleados', '/rrhh/empleados', 'id-card', 1, (SELECT Modules_id FROM modules WHERE Modules_name = 'RRHH')),
('Nómina',    'Gestión de nómina',    '/rrhh/nomina',    'money',   1, (SELECT Modules_id FROM modules WHERE Modules_name = 'RRHH'));

-- Hijos de Configuración
INSERT INTO modules (Modules_name, Modules_description, Modules_route, Modules_icon, Modules_submodule, Modules_parent_module) VALUES
('Usuarios', 'Gestión de usuarios', '/config/usuarios', 'person',  1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Configuración')),
('Roles',    'Gestión de roles',    '/config/roles',    'shield',  1, (SELECT Modules_id FROM modules WHERE Modules_name = 'Configuración'));
```

---

## Orden correcto de ejecución
```
1. status_catalog  → sin dependencias
2. countries       → sin dependencias
3. roles           → sin dependencias
4. users           → depende de roles y status_catalog
5. profiles        → depende de users y countries
6. ALTER modules   → corregir tipo de columna primero
7. modules raíz    → sin parent
8. modules hijos   → dependen de módulos raíz
```

## Actividad 2: Consultas con JOINs

> [!TIP] 
> ## **JOINs**
> 
> Un JOIN combina filas de dos o más tablas basándose en una columna relacionada entre ellas
> 
> En vez de consultar tablas por separado las unes en una sola consulta ✅


Analogía simple
```
Tienes dos listas:

Lista users                 Lista roles
───────────────             ───────────────
id │ nombre  │ rol_id       id │ rol_nombre
 1 │ Juan    │ 2             1 │ Admin
 2 │ María   │ 1             2 │ Ventas

JOIN las une por rol_id = id
───────────────────────────────────
nombre │ rol_nombre
Juan   │ Ventas
María  │ Admin
```

### 1. Reporte Maestro de Usuarios:

### Answer 

```SQL
USE api_crud_taller;

SELECT
    users.User_user        AS 'Usuario',
    users.User_email       AS 'Email',
    roles.Roles_name       AS 'Rol',
    status_catalog.User_status_name  AS 'Estado',
    countries.country_name AS 'País'
FROM users
JOIN roles 
    ON users.Roles_fk = roles.Roles_id
JOIN status_catalog 
    ON users.User_status_fk = status_catalog.User_status_id
JOIN profiles 
    ON users.User_id = profiles.User_id_fk
JOIN countries 
    ON profiles.country_fk = countries.country_id
ORDER BY users.User_user ASC;
```

---

## Resultado esperado
```
Usuario        │ Email              │ Rol         │ Estado  │ País
───────────────┼────────────────────┼─────────────┼─────────┼──────────
admin_john     │ john@mail.com      │ Admin       │ Activo  │ Colombia
analista_pedro │ pedro@mail.com     │ Analista    │ Activo  │ Ecuador
auditor_ana    │ ana@mail.com       │ Auditor     │ Activo  │ México
dev_laura      │ laura@mail.com     │ Desarrollad │ Pendien │ Venezuela
...
```

### 2.​ Módulos por Rol

> [!WARNING]
> ## No se puede hacer el `JOIN` porque la tabla intermedia `role_modules` esta vacia.
>
> ### Se tendria que insertar asignaciones

### 3. Auditoría de Accesos:

> [!IMPORTANT]
> ### Se debe poblar la tabla primero para que devuelva resultados

**Data**

```SQL
INSERT INTO login_logs (session_id, User_fk, ip_address) VALUES
(SHA2('session001', 256), 1,  '192.168.1.1'),
(SHA2('session002', 256), 2,  '192.168.1.2'),
(SHA2('session003', 256), 3,  '190.210.45.1'),
(SHA2('session004', 256), 4,  '181.50.30.2'),
(SHA2('session005', 256), 5,  '200.10.20.3'),
(SHA2('session006', 256), 6,  '190.85.60.4'),
(SHA2('session007', 256), 7,  '181.70.40.5'),
(SHA2('session008', 256), 1,  '192.168.1.1'),
(SHA2('session009', 256), 3,  '190.210.45.1'),
(SHA2('session010', 256), 2,  '192.168.1.2'),
(SHA2('session011', 256), 8,  '200.30.50.6'),
(SHA2('session012', 256), 9,  '181.90.70.7'),
(SHA2('session013', 256), 10, '190.100.80.8'),
(SHA2('session014', 256), 11, '200.50.90.9'),
(SHA2('session015', 256), 12, '181.110.100.10');
```

**JOIN**
```SQL
SELECT
    users.User_user         AS 'Usuario',
    countries.country_name  AS 'País',
    login_logs.ip_address   AS 'IP',
    login_logs.created_at   AS 'Fecha acceso'
FROM login_logs
JOIN users
    ON login_logs.User_fk       = users.User_id
JOIN profiles
    ON users.User_id            = profiles.User_id_fk
JOIN countries
    ON profiles.country_fk      = countries.country_id
ORDER BY login_logs.created_at DESC
LIMIT 5;
```

## Resultado esperado
```
Usuario      │ País      │ IP               │ Fecha acceso
─────────────┼───────────┼──────────────────┼─────────────────────
mkt_roberto  │ Paraguay  │ 181.110.100.10   │ 2026-03-04 10:35:22
rrhh_diana   │ Uruguay   │ 200.50.90.9      │ 2026-03-04 10:35:21
cont_miguel  │ Brasil    │ 190.100.80.8     │ 2026-03-04 10:35:20
dev_laura    │ Venezuela │ 181.90.70.7      │ 2026-03-04 10:35:19
analista_pedro│ Ecuador  │ 200.30.50.6      │ 2026-03-04 10:35:18
```

## Actividad 3: Objetos Programables (Vistas y Procedimientos)

> [!NOTE]
>
> Una vista es una consulta guardada en la BD
> 
> No almacena datos propios
> 
> Cada vez que la consultas ejecuta el SELECT internamente ✅

### Analogia
```
Sin vista                      Con vista
─────────────────              ─────────────────
Escribes el JOIN completo      SELECT * FROM vw_active_admins
cada vez que lo necesitas ❌   una sola línea ✅
```

### 1. Vista de Seguridad:

```SQL
CREATE VIEW vw_active_admins AS
SELECT
    users.User_id,
    users.User_user         AS 'Usuario',
    users.User_email        AS 'Email',
    roles.Roles_name        AS 'Rol',
    status_catalog.User_status_name  AS 'Estado',
    users.is_verified       AS 'Verificado',
    users.created_at        AS 'Fecha registro'
FROM users
JOIN roles
    ON users.Roles_fk = roles.Roles_id
JOIN status_catalog
    ON users.User_status_fk = status_catalog.User_status_id
WHERE roles.Roles_name            = 'Admin'
AND   status_catalog.User_status_name = 'Activo';
```

### Como usarla despues 
```SQL
-- Así de simple
SELECT * FROM vw_active_admins;

-- También puedes filtrar sobre ella
SELECT * FROM vw_active_admins
WHERE is_verified = 1;

-- O contarlos
SELECT COUNT(*) AS total_admins 
FROM vw_active_admins;
```

### 2.​ Procedimiento de Inserción de Usuario:

> [!NOTE]
> ### ¿Qué es un Procedimiento Almacenado?
> 
> - Un procedimiento almacenado es un bloque de código `SQL` guardado en la `BD`
>         
> - Recibe parámetros
> 
> - Ejecuta lógica
> 
> - Maneja errores
> 
> - Se llama con una sola línea ✅
> 
> ### ¿Qué es una Transacción?
>
> Una transacción agrupa varios `INSERT/UPDATE`
> 
> en una sola operación atómica
> 
> O todo sale bien → `COMMIT` ✅
> 
> O algo falla    → `ROLLBACK` ❌ deshace todo

### Answer

```SQL
DELIMITER $$

CREATE PROCEDURE sp_register_user_full(
    -- Datos del usuario
    IN p_user        VARCHAR(255),
    IN p_email       VARCHAR(256),
    IN p_password    VARCHAR(255),
    IN p_roles_fk    INT UNSIGNED,
    IN p_status_fk   INT UNSIGNED,
    -- Datos del perfil
    IN p_name        VARCHAR(30),
    IN p_photo       VARCHAR(255),
    IN p_bio         TEXT,
    IN p_country_fk  INT UNSIGNED
)
BEGIN
    -- Variables internas
    DECLARE v_new_user_id INT UNSIGNED;
    DECLARE v_error       BOOLEAN DEFAULT FALSE;

    -- Capturar cualquier error SQL
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        SET v_error = TRUE;

    -- Inicio de transacción
    START TRANSACTION;

        -- Paso 1: Insertar en users
        INSERT INTO users (
            User_user,
            User_email,
            User_password,
            Roles_fk,
            User_status_fk,
            is_verified
        ) VALUES (
            p_user,
            p_email,
            SHA2(p_password, 256),
            p_roles_fk,
            p_status_fk,
            0  -- nace sin verificar
        );

        -- Guardar el ID del usuario recién insertado
        SET v_new_user_id = LAST_INSERT_ID();

        -- Paso 2: Insertar en profiles con ese ID
        INSERT INTO profiles (
            Profile_name,
            Profile_photo,
            profile_bio,
            User_id_fk,
            country_fk
        ) VALUES (
            p_name,
            p_photo,
            p_bio,
            v_new_user_id,  -- ← ID del usuario recién creado
            p_country_fk
        );

    -- Verificar si hubo error
    IF v_error THEN
        ROLLBACK;
        SELECT 'ERROR: No se pudo registrar el usuario.' AS mensaje;
    ELSE
        COMMIT;
        SELECT 
            v_new_user_id           AS 'ID Usuario creado',
            p_user                  AS 'Usuario',
            p_email                 AS 'Email',
            'Registrado con éxito'  AS 'Mensaje';
    END IF;

END$$

DELIMITER ;
```

### ¿Qué hace cada parte?

```SQL
DELIMITER $$
        ↓
Cambia el delimitador de ; a $$
para que MySQL no confunda los ; internos
con el fin del procedimiento ✅

DECLARE v_new_user_id
        ↓
Variable que guarda el ID del usuario
recién insertado para usarlo en profiles ✅

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        ↓
Si ocurre cualquier error SQL
captura el error y continúa
para poder hacer ROLLBACK ✅

LAST_INSERT_ID()
        ↓
Obtiene el ID AUTO_INCREMENT
del último INSERT ejecutado ✅

START TRANSACTION → COMMIT o ROLLBACK
        ↓
Garantiza que users y profiles
se insertan juntos o ninguno ✅
```

### ¿Cómo se llama el procedimiento?

```SQL
CALL sp_register_user_full(
    'nuevo_user',        -- User_user
    'nuevo@mail.com',    -- User_email
    'password123',       -- User_password (se hashea interno)
    2,                   -- Roles_fk (Admin)
    1,                   -- User_status_fk (Activo)
    'Nuevo Usuario',     -- Profile_name
    'photos/nuevo.jpg',  -- Profile_photo
    'Bio del usuario.',  -- profile_bio
    1                    -- country_fk (Colombia)
);
```

---

### Flujo completo de la transacción

```
CALL sp_register_user_full(...)
        ↓
START TRANSACTION
        ↓
INSERT users ──────────────── ✅ ok
        ↓
LAST_INSERT_ID() → guarda ID
        ↓
INSERT profiles ─────────────¿ok?
        ↓                         ↓
      ✅ ok                    ❌ error
        ↓                         ↓
    COMMIT                    ROLLBACK
  todo guardado            todo deshecho
        ✅                        ✅
```

### 3.​ Procedimiento de Reporte de Actividad:

```SQL
DELIMITER $$

CREATE PROCEDURE sp_get_user_logs(
    IN p_user_id INT UNSIGNED
)
BEGIN
    -- Verificar si el usuario existe
    IF NOT EXISTS (
        SELECT 1 FROM users 
        WHERE User_id = p_user_id
    ) THEN
        SELECT 'ERROR: El usuario no existe.' AS mensaje;

    -- Verificar si tiene logs
    ELSEIF NOT EXISTS (
        SELECT 1 FROM login_logs 
        WHERE User_fk = p_user_id
    ) THEN
        SELECT 'El usuario no tiene historial de accesos.' AS mensaje;

    -- Todo ok → devolver historial
    ELSE
        SELECT
            login_logs.log_id           AS 'ID Log',
            users.User_user             AS 'Usuario',
            users.User_email            AS 'Email',
            login_logs.ip_address       AS 'IP',
            login_logs.session_id       AS 'Sesión',
            login_logs.created_at       AS 'Fecha acceso'
        FROM login_logs
        JOIN users
            ON login_logs.User_fk = users.User_id
        WHERE login_logs.User_fk = p_user_id
        ORDER BY login_logs.created_at DESC;

    END IF;

END$$

DELIMITER ;
```

### ¿Qué hace cada parte?
```SQL
IN p_user_id INT UNSIGNED
        ↓
Recibe el ID del usuario
como parámetro de entrada ✅

IF NOT EXISTS (SELECT 1 FROM users...)
        ↓
Verifica que el usuario existe
antes de buscar sus logs ✅
SELECT 1 es más eficiente que SELECT *
solo verifica existencia sin traer datos ✅

ELSEIF NOT EXISTS (SELECT 1 FROM login_logs...)
        ↓
Verifica que tiene logs
antes de intentar mostrarlos ✅

ORDER BY created_at DESC
        ↓
Los más recientes primero ✅
```

---

### ¿Por qué no necesita transacción?
```SQL
Transacción → operaciones que escriben datos
              INSERT, UPDATE, DELETE
                    ↓
              Si algo falla hay que deshacer ✅

sp_get_user_logs → solo lee datos (SELECT)
                   no modifica nada en la BD
                        ↓
                   No hay nada que deshacer ✅
                   No necesita transacción ✅
```

### ¿Cómo se llama?

```SQL
-- Ver logs del usuario con ID 1
CALL sp_get_user_logs(1);

-- Ver logs del usuario con ID 3
CALL sp_get_user_logs(3);

-- Usuario que no existe
CALL sp_get_user_logs(999);
-- Resultado: 'ERROR: El usuario no existe.'

-- Usuario sin logs
CALL sp_get_user_logs(13);
-- Resultado: 'El usuario no tiene historial de accesos.'
```

---

# 3. Taller de Conceptos e Ingeniería Inversa

## Parte A: Conceptos Fundamentales (Cuestionario)

### 1.​ Diferencia de Lenguaje: ¿En qué se diferencia el comando `DROP` del comando `DELETE`?

- RTA: `DELETE` elimina los datos osea el contenido de las tablas, mientras que `DROP` puede eliminar tablas, vistas, procedimientos en la base de datos

> [!NOTE]
> `DELETE`: elimina los datos pero las tablas siguen existiendo
>
> `DROP`: elimina todo para siempre

### 2.​ Integridad Referencial: ¿Qué sucede si intento eliminar un registro en la tabla roles que está siendo referenciado por 5 usuarios en la tabla users?

- RTA: Si se hiciera los usuarios quedarian huerfanos y MySQL lo impide, a esto se le llama Integridad Referencial y garantiza que nunca exista un usuario apuntando a un rol que no existe.
> [!TIP]
> Habria una opcion que seria hacer un `Soft Delete`: marcarlo como eliminado pero no eliminarlo fisicamente
>
> - El rol sigue existiendo
> 
> - Los 5 usuarios siguen apuntando a él
> 
> - Nadie puede asignarlo a nuevos usuarios


### 3.​ Transacciones: Explique para qué sirven los comandos COMMIT y ROLLBACK en un procedimiento almacenado.

- RTA: El `COMMIT` nos confirma todos los cambios y los escribe definitivamente en la BD. Mientras el `ROLLBACK` deshace todos los cambios y la BD vuelve al estado anterior

### 4.​ Optimización: ¿Qué es un índice y en qué escenario penaliza el rendimiento de la base de datos?

- RTA: Un indice es una estructura de datos separada que MySQL mantiene para acelerar búsquedas, similar al índice de un libro:
    - no lees todo el libro para encontrar un tema
    - vas directo a la página

- **El indice penaliza el rendimiento en varias ocasiones:**
    - Escrituras frecuentes
    - Tablas pequeñas
    - Columnas con pocos valores distintos
    - Exceso de índices
    - LIKE con comodín al inicio

> [!NOTE]
> **Escrituras frecuentes:** Cada `INSERT`, `UPDATE`, `DELETE`. 
> **MySQL** actualiza el dato y además actualiza CADA índice
>
> **Tablas pequeñas:** Tabla con 10 registros, MySQL decide leer los 10 directo en vez de consultar el índice y el índice es overhead innecesario
>
> **Columnas con pocos valores distintos:** `is_verified → solo 0 o 1` `deleted_at  → solo NULL o fecha` el índice no filtra casi nada y MySQL recorre la mitad de la tabla igual eso es espacio consumido sin beneficio
>
> **Exceso de índices:** Tabla con 15 índices, cada índice consume espacio en disco, cada modificación actualiza 15 índices y el optimizador de MySQL se confunde
>
> **LIKE con comodín al inicio:** LIKE con % al inicio, al ejecutar el indice se ignora

### 5.​ Normalización: ¿A qué forma normal (1FN, 2FN o 3FN) pertenece la separación de los países de la tabla de perfiles a una tabla independiente? Justifique.

- RTA: Es la forma `3FN` porque *no debe haber dependencias
transitivas entre columnas* lo que significa que una columna no puede depender
de otra columna que no sea la PK.
- `country_name` no depende directamente de `Profile_id`, depende de sí mismo, no del perfil y esto es una dependencia transitiva.
- Lo correcto seria tener a `country_name` en una tabla separada y comunicarla con `Profile_id`.

## Parte B: Ingeniería Inversa -- PENDIENTE

1.​ Análisis de Estructura: Identifique todas las relaciones existentes indicando:
+ Tabla Origen y Tabla Destino.
+ Campo Llave Primaria (PK) y Campo Llave Foránea (FK).
+ Cardinalidad (1:1, 1:N, N:M).

2.​ Modelo Entidad-Relación (MER): Utilizando una herramienta de modelado (MySQL
Workbench, Lucidchart, Draw.io o manual), genere el diagrama físico de la base de
datos.
+ Debe incluir atributos, tipos de datos y nombres de las restricciones.
+ Resalte visualmente la auto-referencia en la tabla modules.

3.​ Diccionario de Datos: Cree una tabla en Word/Excel que describa cada tabla del script,
el propósito de cada columna y si permite valores nulos.

# 4. Caso de Estudio: Sistema de Gestión de Co-Working "SmartSpace" ---PENDIENTE