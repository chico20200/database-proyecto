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
(2, 'En efectivo', '2025-02-07', 'Pago en recepción', 175.00, 17.50, 5.00);

-- Crear y gestionar Indices
-- Índice en identificaciones para búsqueda rápida de personas
create index idx_identificacion on personas(identificacion);

-- Índice en nombre de servicios (si se usa mucho en consultas)
create index idx_servicio_nombre on servicios(nombre);

-- Índice en fechas de reserva (optimiza búsquedas por fechas)
create index idx_reserva_fecha on reservas(fecha_entrada, fecha_salida);

-- Índice en método de pago (si se usa mucho en consultas y reportes)
create index idx_facturacion_metodo on facturacion(metodo_pago);

-- PARTE 3
-- Búsqueda rápida por Identificación  
select * from personas where identificacion = '1102567890'; 
 
 -- Verificar si un usuario existe antes de insertarlo: 
select count(*) from personas where identificacion = '1102567890'; 

explain select * from personas where identificacion = '1102567890';


select r.id, p.nombres, p.apellidos, hab.numero_habitacion, r.fecha_entrada  
from reservas r
join huespedes h on r.huesped_id = h.id
join personas p on h.persona_id = p.id
join habitaciones hab on r.numero_habitacion = hab.numero_habitacion
where r.fecha_entrada >= '2025-02-01';



SELECT * FROM RESERVAS
-- Usar el índice en una subconsulta optimizada: 
select nombres, apellidos  from personas  
where identificacion in (select identificacion from personas where identificacion like '1102%'); 

insert into reservas (id, numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida)  
select id, numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida  
from reservas_old;
 drop table reservas_old
-- PARTICION 
rename table reservas to reservas_old;
create table reservas (
    id int not null auto_increment,
    numero_personas int not null,
    numero_habitacion int not null,
    empleado_id int not null,
    huesped_id int not null,
    fecha_entrada date not null,
    fecha_salida date not null,
    primary key (id, fecha_entrada)  -- Incluir fecha_entrada en la clave primaria
) partition by range (year(fecha_entrada)) (
    partition p2024 values less than (2025),
    partition p2025 values less than (2026),
    partition p2026 values less than (2027),
    partition p2027 values less than (2028)
);


-- INSERTAR UNA RESERVA
insert into reservas (numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida)  
values (2, 101, 1, 1, '2025-06-10', '2025-06-15');  -- Se guardará en la partición `p2025`

select * from reservas where year(fecha_entrada) = 2025;









