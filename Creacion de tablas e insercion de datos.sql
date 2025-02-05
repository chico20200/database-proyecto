create database gestion_hoteles;
use gestion_hoteles;

-- Tabla personas (almacena información general de todas las personas)
create table personas (
    id int not null primary key auto_increment,
    identificacion varchar(10) not null unique,
    nombres varchar(50) not null,
    apellidos varchar(50) not null,
    telefono varchar(10) not null unique,
    correo varchar(50) not null unique,
    direccion varchar(100) not null,
    edad int not null check (edad >= 0) 
);

-- Tabla empleados (relacionada con personas)
create table empleados (
    id int not null primary key auto_increment,
    persona_id int not null,
    puesto varchar(50) not null,
    salario double not null,
    fecha_contratacion date not null,
    usuario varchar(50) not null unique,
    contrasenia varchar(255) not null,
    foreign key (persona_id) references personas(id) on delete cascade
);

-- Tabla huéspedes (relacionada con personas)
create table huespedes (
    id int not null primary key auto_increment,
    persona_id int not null,
    sexo enum('Masculino', 'Femenino', 'Otro') not null,
    pais_origen varchar(50) not null,
    foreign key (persona_id) references personas(id) on delete cascade
);

-- Tabla habitaciones
create table habitaciones (
    numero_habitacion int not null primary key,
    precio_por_noche double not null,
    numero_camas int not null,
    descripcion varchar(100),
    tipo_habitacion enum('Suite', 'Junior suite', 'Gran suite', 'Normal', 'Habitación matrimonial') not null
);

-- Tabla reservas (relacionada con huéspedes, empleados y habitaciones)
create table reservas (
    id int not null primary key auto_increment,
    numero_personas int not null,
    numero_habitacion int not null,
    empleado_id int not null,
    huesped_id int not null,
    fecha_entrada date not null,
    fecha_salida date not null,
    foreign key (numero_habitacion) references habitaciones(numero_habitacion) on delete cascade,
    foreign key (empleado_id) references empleados(id) on delete cascade,
    foreign key (huesped_id) references huespedes(id) on delete cascade
);

-- Tabla servicios (almacena los servicios disponibles)
create table servicios (
    id int not null primary key auto_increment,
    nombre varchar(50) not null,
    costo double not null,
    descripcion varchar(100) not null
);

-- Tabla facturación (relacionada con reservas)
create table facturacion (
    id int not null primary key auto_increment,
    reserva_id int not null,
    metodo_pago enum('En efectivo', 'Con tarjeta de crédito', 'Con tarjeta de débito') not null,
    fecha_facturacion date not null,
    observaciones varchar(100),
    costo_total double not null,
    impuestos double not null,
    cargos_adicionales double not null,
    foreign key (reserva_id) references reservas(id) on delete cascade
);

/* ---------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INSERCION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>------------------- */

insert into personas (identificacion, nombres, apellidos, telefono, correo, direccion, edad) values
('1102567890', 'Odaliz', 'Balseca', '0987654321', 'odaliz.balseca@gmail.com', 'Quito', 25),
('1103578910', 'Sebastian', 'Chico', '0987123456', 'sebastian.chico@gmail.com', 'Guayaquil', 30),
('1104589123', 'María', 'González', '0912345678', 'maria.gonzalez@gmail.com', 'Cuenca', 40),
('1105698123', 'Carlos', 'Ramírez', '0923456789', 'carlos.ramirez@gmail.com', 'Loja', 45);

insert into empleados (persona_id, puesto, salario, fecha_contratacion, usuario, contrasenia) values
(3, 'Recepcionista', 800, '2023-05-01', 'maria.gonzalez', '123456'),
(4, 'Gerente', 1500, '2022-01-10', 'carlos.ramirez', '789012');

insert into huespedes (persona_id, sexo, pais_origen) values
(1, 'Femenino', 'Ecuador'), 
(2, 'Masculino', 'Ecuador'), 
(3, 'Femenino', 'Colombia'),
(4, 'Masculino', 'Perú');

insert into habitaciones (numero_habitacion, precio_por_noche, numero_camas, descripcion, tipo_habitacion) values
(101, 50.00, 2, 'Vista al mar', 'Suite'),
(102, 35.00, 1, 'Cómoda y acogedora', 'Normal'),
(103, 45.00, 1, 'Amplia y luminosa', 'Habitación matrimonial');

insert into reservas (numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida) values
(2, 101, 1, 1, '2025-02-05', '2025-02-10'), 
(1, 102, 2, 2, '2025-02-07', '2025-02-12'); 

insert into servicios (nombre, costo, descripcion) values
('Comida incluida', 20.00, 'Desayuno, almuerzo y cena'),
('Limpieza diaria', 10.00, 'Servicio de limpieza todos los días'),
('WiFi gratuito', 0.00, 'Acceso ilimitado a internet');

insert into facturacion (reserva_id, metodo_pago, fecha_facturacion, observaciones, costo_total, impuestos, cargos_adicionales) values
(1, 'Con tarjeta de crédito', '2025-02-05', 'Sin observaciones', 250.00, 25.00, 10.00),
(2, 'En efectivo', '2025-02-07', 'Pago en recepción',175.00,17.50,5.00);

-- COMPROBACIÓN DE LOS TRIGGERS 
-- PERSONAS
INSERT INTO personas (identificacion, nombres, apellidos, telefono, correo, direccion, edad)
VALUES 
('1234567890', 'Juan', 'Pérez', '0987623532', 'juan.perez@example.com', 'Calle 123, Ciudad', 30),
('2345678901', 'María', 'Gómez', '0976543210', 'maria.gomez@example.com', 'Avenida 456, Ciudad', 25),
('3456789012', 'Carlos', 'López', '0965432109', 'carlos.lopez@example.com', 'Calle 789, Ciudad', 40);

