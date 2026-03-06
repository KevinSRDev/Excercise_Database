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

### 1. Reporte Maestro de Usuarios:

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

### Answer 

```SQL
SELECT
    u.User_user         AS 'Usuario',
    u.User_email        AS 'Email',
    r.Roles_name        AS 'Rol',
    s.User_status_name  AS 'Estado',
    c.country_name      AS 'País'
FROM users u
JOIN roles r          ON u.Roles_fk       = r.Roles_id
JOIN status_catalog s ON u.User_status_fk = s.User_status_id
JOIN profiles p       ON u.User_id        = p.User_id_fk
JOIN countries c      ON p.country_fk     = c.country_id
ORDER BY u.User_user ASC;
```

---

## ¿Por qué cada JOIN?
```
users  ──JOIN──► roles
                 para obtener el nombre del rol ✅

users  ──JOIN──► status_catalog
                 para obtener el nombre del estado ✅

users  ──JOIN──► profiles
                 para llegar a countries
                 el país vive en profiles, no en users ✅

profiles ──JOIN──► countries
                   para obtener el nombre del país ✅
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

---

## Regla de oro de los JOINs
```
Por cada FK en las tablas
necesitas un JOIN
        ↓
users tiene 3 FK:
├── Roles_fk       → JOIN roles          ✅
├── User_status_fk → JOIN status_catalog ✅
└── profiles tiene country_fk
                   → JOIN profiles       ✅
                   → JOIN countries      ✅
```