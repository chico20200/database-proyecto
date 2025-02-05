use gestion_hoteles;
/* ---------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< USUARIOS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-------------------   */
/*Creacion de usuarios para la tabla "huespedes"*/
create user 'administrador'@'localhost' identified by 'admin1234'; 
create user 'empleado'@'localhost' identified by 'empleado1234';
create user 'cliente'@'localhost' identified by 'cliente1234'; 
/*Permisos a los usuarios anteriormente creados*/
grant all privileges on gestion_hoteles.huespedes to 'administrador'@'localhost'; 
grant select, insert, update, delete on gestion_hoteles.huespedes to 'empleado'@'localhost'; 
grant select, insert, update, delete on gestion_hoteles.reservas to 'empleado'@'localhost'; 
grant select, insert, update, delete on gestion_hoteles.facturacion to 'empleado'@'localhost'; 
grant select on gestion_hoteles.huespedes to 'cliente'@'localhost';
grant select on gestion_hoteles.reservas to 'cliente'@'localhost'; 
grant select on gestion_hoteles.facturacion to 'cliente'@'localhost';  


Show grants for 'cliente'@'localhost';

select user, host FROM mysql.user;
INSERT INTO empleados (persona_id, puesto, salario, fecha_contratacion, usuario, contrasenia)
VALUES (1, 'Gerente', 50000.00, '2023-10-01', 'juan_perez', SHA2('miContraseñaSegura123', 256));
select * from empleados;
/* ---------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< AUDITORIA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-------------------   */
/*Tabla en donde se guardará los cambios*/
create table datosOperaciones(
	id_datosOperaciones int not null auto_increment primary key, 
    usuario_operacion varchar(50),
    fecha_operacion datetime, 
    operacion_que_se_ejecuto varchar(2000) default null, 
    operacion_que_revierte varchar(2000) default null
); 

-- insertar huespedes
DROP TRIGGER IF EXISTS despues_insertar_huespedes;
DELIMITER $$
CREATE TRIGGER despues_insertar_huespedes
AFTER INSERT ON huespedes 
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT(
            'INSERT INTO huespedes (id, persona_id, sexo, pais_origen) VALUES (', 
            NEW.id, ', ', NEW.persona_id, ', "', NEW.sexo, '", "', NEW.pais_origen, '");'
        ),
        CONCAT('DELETE FROM huespedes WHERE id=', NEW.id, ';')
    );
END$$
DELIMITER ;

-- eliminar huespedes
DROP TRIGGER IF EXISTS despues_eliminacion_huespedes;
DELIMITER $$

CREATE TRIGGER despues_eliminacion_huespedes
AFTER DELETE ON huespedes
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('DELETE FROM huespedes WHERE id=', OLD.id, ';'),
        CONCAT(
            'INSERT INTO huespedes (id, persona_id, sexo, pais_origen) VALUES (', 
            OLD.id, ', ', OLD.persona_id, ', "', OLD.sexo, '", "', OLD.pais_origen, '");'
        )
    );
END$$

DELIMITER ;

-- actualizar huespedes
DROP TRIGGER IF EXISTS despues_actualizacion_huespedes;
DELIMITER $$

CREATE TRIGGER despues_actualizacion_huespedes
AFTER UPDATE ON huespedes
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT(
            'UPDATE huespedes SET persona_id = ', NEW.persona_id, ', sexo = "', NEW.sexo, '", pais_origen = "', NEW.pais_origen, '" WHERE id = ', NEW.id, ';'
        ),
        CONCAT(
            'UPDATE huespedes SET persona_id = ', OLD.persona_id, ', sexo = "', OLD.sexo, '", pais_origen = "', OLD.pais_origen, '" WHERE id = ', OLD.id, ';'
        )
    );
END$$

DELIMITER ;

-- insertar habitaciones
DROP TRIGGER IF EXISTS despues_insertar_habitaciones;
DELIMITER $$

CREATE TRIGGER despues_insertar_habitaciones
AFTER INSERT ON habitaciones
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT(
            'INSERT INTO habitaciones (numero_habitacion, precio_por_noche, numero_camas, descripcion, tipo_habitacion) VALUES (', 
            NEW.numero_habitacion, ', ', NEW.precio_por_noche, ', ', NEW.numero_camas, ', "', NEW.descripcion, '", "', NEW.tipo_habitacion, '");'
        ),
        CONCAT('DELETE FROM habitaciones WHERE numero_habitacion=', NEW.numero_habitacion, ';')
    );
END$$

DELIMITER ;

-- eliminar habitacion
DROP TRIGGER IF EXISTS despues_eliminacion_habitaciones;
DELIMITER $$

CREATE TRIGGER despues_eliminacion_habitaciones
AFTER DELETE ON habitaciones
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('DELETE FROM habitaciones WHERE numero_habitacion=', OLD.numero_habitacion, ';'),
        CONCAT(
            'INSERT INTO habitaciones (numero_habitacion, precio_por_noche, numero_camas, descripcion, tipo_habitacion) VALUES (', 
            OLD.numero_habitacion, ', ', OLD.precio_por_noche, ', ', OLD.numero_camas, ', "', OLD.descripcion, '", "', OLD.tipo_habitacion, '");'
        )
    );
END$$

DELIMITER ;

-- update habitacion
DROP TRIGGER IF EXISTS despues_actualizacion_habitaciones;
DELIMITER $$

CREATE TRIGGER despues_actualizacion_habitaciones
AFTER UPDATE ON habitaciones
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT(
            'UPDATE habitaciones SET numero_habitacion = ', NEW.numero_habitacion, 
            ', precio_por_noche = ', NEW.precio_por_noche, 
            ', numero_camas = ', NEW.numero_camas, 
            ', descripcion = "', NEW.descripcion, '"', 
            ', tipo_habitacion = "', NEW.tipo_habitacion, '"', 
            ' WHERE numero_habitacion = ', OLD.numero_habitacion, ';'
        ),
        CONCAT(
            'UPDATE habitaciones SET numero_habitacion = ', OLD.numero_habitacion, 
            ', precio_por_noche = ', OLD.precio_por_noche, 
            ', numero_camas = ', OLD.numero_camas, 
            ', descripcion = "', OLD.descripcion, '"', 
            ', tipo_habitacion = "', OLD.tipo_habitacion, '"', 
            ' WHERE numero_habitacion = ', NEW.numero_habitacion, ';'
        )
    );
END$$

DELIMITER ;

-- triggers de servicios
DROP TRIGGER IF EXISTS despues_insertar_servicios;
DELIMITER $$

CREATE TRIGGER despues_insertar_servicios
AFTER INSERT ON servicios
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('INSERT INTO servicios(id, nombre, costo, descripcion) VALUES (', NEW.id, ', "', NEW.nombre, '", ', NEW.costo, ', "', NEW.descripcion, '");'), 
        CONCAT('DELETE FROM servicios WHERE id=', NEW.id, ';')
    );
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS despues_eliminacion_servicios;
DELIMITER $$

CREATE TRIGGER despues_eliminacion_servicios
AFTER DELETE ON servicios
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('DELETE FROM servicios WHERE id=', OLD.id, ';'), 
        CONCAT('INSERT INTO servicios(id, nombre, costo, descripcion) VALUES (', OLD.id, ', "', OLD.nombre, '", ', OLD.costo, ', "', OLD.descripcion, '");')
    );
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS despues_actualizacion_servicios;
DELIMITER $$

CREATE TRIGGER despues_actualizacion_servicios
AFTER UPDATE ON servicios
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('UPDATE servicios SET nombre = "', NEW.nombre, '", costo = ', NEW.costo, ', descripcion = "', NEW.descripcion, '" WHERE id = ', NEW.id, ';'), 
        CONCAT('UPDATE servicios SET nombre = "', OLD.nombre, '", costo = ', OLD.costo, ', descripcion = "', OLD.descripcion, '" WHERE id = ', OLD.id, ';')
    );
END$$

DELIMITER ;

-- triggers empleados
DROP TRIGGER IF EXISTS despues_insertar_empleados;
DELIMITER $$

CREATE TRIGGER despues_insertar_empleados
AFTER INSERT ON empleados
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('INSERT INTO empleados (id, persona_id, puesto, salario, fecha_contratacion, usuario, contrasenia) VALUES (', 
            NEW.id, ', ', NEW.persona_id, ', "', NEW.puesto, '", ', NEW.salario, ', "', NEW.fecha_contratacion, '", "', NEW.usuario, '", "', NEW.contrasenia, '");'),
        CONCAT('DELETE FROM empleados WHERE id=', NEW.id, ';')
    );
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS despues_eliminacion_empleados;
DELIMITER $$

CREATE TRIGGER despues_eliminacion_empleados
AFTER DELETE ON empleados
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('DELETE FROM empleados WHERE id=', OLD.id, ';'),
        CONCAT('INSERT INTO empleados (id, persona_id, puesto, salario, fecha_contratacion, usuario, contrasenia) VALUES (', 
            OLD.id, ', ', OLD.persona_id, ', "', OLD.puesto, '", ', OLD.salario, ', "', OLD.fecha_contratacion, '", "', OLD.usuario, '", "', OLD.contrasenia, '");')
    );
END$$

DELIMITER ;

DROP TRIGGER IF EXISTS despues_actualizacion_empleados;
DELIMITER $$

CREATE TRIGGER despues_actualizacion_empleados
AFTER UPDATE ON empleados
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(), 
        NOW(), 
        CONCAT('UPDATE empleados SET persona_id = ', NEW.persona_id, ', puesto = "', NEW.puesto, '", salario = ', NEW.salario, ', fecha_contratacion = "', NEW.fecha_contratacion, '", usuario = "', NEW.usuario, '", contrasenia = "', NEW.contrasenia, '" WHERE id = ', NEW.id, ';'),
        CONCAT('UPDATE empleados SET persona_id = ', OLD.persona_id, ', puesto = "', OLD.puesto, '", salario = ', OLD.salario, ', fecha_contratacion = "', OLD.fecha_contratacion, '", usuario = "', OLD.usuario, '", contrasenia = "', OLD.contrasenia, '" WHERE id = ', OLD.id, ';')
    );
END$$

DELIMITER ;

-- triggers reservas
/* Para después de las INSERCIONES */
DROP TRIGGER IF EXISTS despues_insertar_reservas;
CREATE TRIGGER despues_insertar_reservas
AFTER INSERT ON reservas 
FOR EACH ROW 
INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
VALUES (
    CURRENT_USER(), 
    NOW(), 
    CONCAT("INSERT INTO reservas (id, numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida) VALUES (", 
        NEW.id, ", ", NEW.numero_personas, ", ", NEW.numero_habitacion, ", ", NEW.empleado_id, ", ", NEW.huesped_id, ", '", NEW.fecha_entrada, "', '", NEW.fecha_salida, "');"), 
    CONCAT("DELETE FROM reservas WHERE id=", NEW.id, ";")
);

/* Para después de la ELIMINACIÓN */
DROP TRIGGER IF EXISTS despues_eliminacion_reservas;
CREATE TRIGGER despues_eliminacion_reservas
AFTER DELETE ON reservas
FOR EACH ROW
INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
VALUES (
    CURRENT_USER(), 
    NOW(), 
    CONCAT("DELETE FROM reservas WHERE id=", OLD.id, ";"), 
    CONCAT("INSERT INTO reservas (id, numero_personas, numero_habitacion, empleado_id, huesped_id, fecha_entrada, fecha_salida) VALUES (", 
        OLD.id, ", ", OLD.numero_personas, ", ", OLD.numero_habitacion, ", ", OLD.empleado_id, ", ", OLD.huesped_id, ", '", OLD.fecha_entrada, "', '", OLD.fecha_salida, "');")
);

/* Para después de la ACTUALIZACIÓN */
DROP TRIGGER IF EXISTS despues_actualizacion_reservas;
CREATE TRIGGER despues_actualizacion_reservas
AFTER UPDATE ON reservas
FOR EACH ROW
INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
VALUES (
    CURRENT_USER(), 
    NOW(), 
    CONCAT("UPDATE reservas SET numero_personas=", NEW.numero_personas, ", numero_habitacion=", NEW.numero_habitacion, ", empleado_id=", NEW.empleado_id, ", huesped_id=", NEW.huesped_id, ", fecha_entrada='", NEW.fecha_entrada, "', fecha_salida='", NEW.fecha_salida, "' WHERE id=", NEW.id, ";"),
    CONCAT("UPDATE reservas SET numero_personas=", OLD.numero_personas, ", numero_habitacion=", OLD.numero_habitacion, ", empleado_id=", OLD.empleado_id, ", huesped_id=", OLD.huesped_id, ", fecha_entrada='", OLD.fecha_entrada, "', fecha_salida='", OLD.fecha_salida, "' WHERE id=", OLD.id, ";")
);


-- triggers de facturación
DROP TRIGGER IF EXISTS despues_insertar_facturacion;
DELIMITER $$
CREATE TRIGGER despues_insertar_facturacion
AFTER INSERT ON facturacion
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(),
        NOW(),
        CONCAT("INSERT INTO facturacion (id, reserva_id, metodo_pago, fecha_facturacion, observaciones, costo_total, impuestos, cargos_adicionales) VALUES (", 
            NEW.id, ", ", NEW.reserva_id, ", '", NEW.metodo_pago, "', '", NEW.fecha_facturacion, "', '", NEW.observaciones, "', ", NEW.costo_total, ", ", NEW.impuestos, ", ", NEW.cargos_adicionales, ");"),
        CONCAT("DELETE FROM facturacion WHERE id=", NEW.id, ";")
    );
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS despues_eliminacion_facturacion;
DELIMITER $$
CREATE TRIGGER despues_eliminacion_facturacion
AFTER DELETE ON facturacion
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(),
        NOW(),
        CONCAT("DELETE FROM facturacion WHERE id=", OLD.id, ";"),
        CONCAT("INSERT INTO facturacion (id, reserva_id, metodo_pago, fecha_facturacion, observaciones, costo_total, impuestos, cargos_adicionales) VALUES (", 
            OLD.id, ", ", OLD.reserva_id, ", '", OLD.metodo_pago, "', '", OLD.fecha_facturacion, "', '", OLD.observaciones, "', ", OLD.costo_total, ", ", OLD.impuestos, ", ", OLD.cargos_adicionales, ");")
    );
END $$
DELIMITER ;

DROP TRIGGER IF EXISTS despues_actualizacion_facturacion;
DELIMITER $$
CREATE TRIGGER despues_actualizacion_facturacion
AFTER UPDATE ON facturacion
FOR EACH ROW 
BEGIN
    INSERT INTO datosOperaciones(usuario_operacion, fecha_operacion, operacion_que_se_ejecuto, operacion_que_revierte)
    VALUES (
        CURRENT_USER(),
        NOW(),
        CONCAT("UPDATE facturacion SET reserva_id=", NEW.reserva_id, ", metodo_pago='", NEW.metodo_pago, "', fecha_facturacion='", NEW.fecha_facturacion, "', observaciones='", NEW.observaciones, "', costo_total=", NEW.costo_total, ", impuestos=", NEW.impuestos, ", cargos_adicionales=", NEW.cargos_adicionales, " WHERE id=", NEW.id, ";"),
        CONCAT("UPDATE facturacion SET reserva_id=", OLD.reserva_id, ", metodo_pago='", OLD.metodo_pago, "', fecha_facturacion='", OLD.fecha_facturacion, "', observaciones='", OLD.observaciones, "', costo_total=", OLD.costo_total, ", impuestos=", OLD.impuestos, ", cargos_adicionales=", OLD.cargos_adicionales, " WHERE id=", OLD.id, ";")
    );
END $$
DELIMITER ;

-- 

