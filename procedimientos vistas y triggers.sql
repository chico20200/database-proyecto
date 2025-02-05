use gestion_hoteles;
DELIMITER //

CREATE PROCEDURE CalcularPrecioTotalReserva(
    IN reserva_id INT,               
    IN descuento DECIMAL(5,2),       
    IN cargos_adicionales DECIMAL(10,2) 
)
BEGIN
    DECLARE precio_habitacion DECIMAL(10,2); 
    DECLARE noches INT;                      
    DECLARE precio_total DECIMAL(10,2);      
    DECLARE precio_final DECIMAL(10,2);      

    -- Obtener el precio por noche de la habitación y el número de noches
    SELECT 
        h.precio_por_noche,
        DATEDIFF(r.fecha_salida, r.fecha_entrada) INTO precio_habitacion, noches
    FROM reservas r
    JOIN habitaciones h ON r.numero_habitacion = h.numero_habitacion
    WHERE r.id = reserva_id;

    -- Calcular el precio total sin descuentos ni cargos
    SET precio_total = precio_habitacion * noches;

    -- Aplicar descuento (si existe)
    IF descuento > 0 THEN
        SET precio_total = precio_total - (precio_total * (descuento / 100));
    END IF;

    -- Aplicar cargos adicionales (si existen)
    IF cargos_adicionales > 0 THEN
        SET precio_total = precio_total + cargos_adicionales;
    END IF;

    -- Devolver el precio final
    SELECT precio_total AS Precio_Final;
END //

DELIMITER ;

CALL CalcularPrecioTotalReserva(9, 10.00, 50.00);

-- VISTAS 
CREATE VIEW VistaInfoHuespedes AS
SELECT 
    p.identificacion,
    CONCAT(p.nombres, ' ', p.apellidos) AS nombre_completo,
    p.telefono,
    p.correo,
    h.sexo,
    h.pais_origen,
    r.numero_habitacion,
    r.fecha_entrada,
    r.fecha_salida
FROM personas p
JOIN huespedes h ON p.id = h.persona_id
LEFT JOIN reservas r ON h.id = r.huesped_id;

CREATE VIEW VistaDetallesReservas AS
SELECT 
    r.id AS reserva_id,
    r.numero_personas,
    hab.precio_por_noche,
    hab.tipo_habitacion,
    CONCAT(pe.nombres, ' ', pe.apellidos) AS empleado_responsable,
    CONCAT(ph.nombres, ' ', ph.apellidos) AS huesped,
    r.fecha_entrada,
    r.fecha_salida
FROM reservas r
JOIN habitaciones hab ON r.numero_habitacion = hab.numero_habitacion
JOIN empleados e ON r.empleado_id = e.id
JOIN personas pe ON e.persona_id = pe.id  
JOIN huespedes h ON r.huesped_id = h.id
JOIN personas ph ON h.persona_id = ph.id;

CREATE VIEW VistaFacturacionCompleta AS
SELECT 
    f.id AS factura_id,
    r.numero_habitacion,
    DATEDIFF(r.fecha_salida, r.fecha_entrada) AS noches,
    hab.precio_por_noche,
    (hab.precio_por_noche * DATEDIFF(r.fecha_salida, r.fecha_entrada)) AS costo_base,
    f.cargos_adicionales,
    f.impuestos,
    f.costo_total AS total_pagado,
    f.metodo_pago,
    f.fecha_facturacion
FROM facturacion f
JOIN reservas r ON f.reserva_id = r.id
JOIN habitaciones hab ON r.numero_habitacion = hab.numero_habitacion;

SELECT * FROM VistaInfoHuespedes;

SELECT * FROM VistaDetallesReservas WHERE tipo_habitacion = 'Suite';

SELECT 
    factura_id,
    noches,
    costo_base,
    total_pagado 
FROM VistaFacturacionCompleta 
WHERE fecha_facturacion BETWEEN '2023-10-01' AND '2023-12-31';