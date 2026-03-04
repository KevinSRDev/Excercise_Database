> [!IMPORTANT] 
> # Solución a Taller [Taller Base de Datos SQL]([Http](https://1drv.ms/b/c/73b18dccb0a722be/IQDn4iinEtJ4QrErjpk1_rdUAfoMmDwluicUXhWLjdZHB_k?e=sQeG3P))

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

ALTER TABLE modules
	ADD CONSTRAINT fk_modules_parent FOREIGN KEY (Moudules_parent_module) REFERENCES modules(Module_id);
```

### 10.​Renombramiento:

```SQL
USE  api_crud_taller;

RENAME TABLE user_status TO status_catalog; 
```

# 2. Taller Práctico: Manipulación de Datos y Lógica de Servidor (DML PL/SQL)

