-- Seleccionar la base de datos para usarla
USE consortium_db;

-- Inserción de datos en la tabla `administrators`
-- Estos registros representan a los administradores responsables de los distintos condominios.
INSERT INTO administrators (first_name, last_name, phone, email) VALUES
('John', 'Doe', '555-0101', 'john.doe@example.com'),
('Jane', 'Smith', '555-0102', 'jane.smith@example.com'),
('Alice', 'Johnson', '555-0103', 'alice.johnson@example.com'),
('Bob', 'Lee', '555-0104', 'bob.lee@example.com'),
('Mike', 'Brown', '555-0105', 'mike.brown@example.com'),
('Charlie', 'Davis', '555-0106', 'charlie.davis@example.com'),
('David', 'Martinez', '555-0107', 'david.martinez@example.com'),
('Sarah', 'Lewis', '555-0108', 'sarah.lewis@example.com'),
('Rachel', 'Walker', '555-0109', 'rachel.walker@example.com'),
('Tom', 'Hall', '555-0110', 'tom.hall@example.com');

-- Inserción de datos en la tabla `condominiums`
-- Estos registros representan a los distintos condominios gestionados por los administradores.
INSERT INTO condominiums (condo_name, address, unit_count, creation_date, admin_id, contact_phone, contact_email, reserve_fund, status, last_meeting_date) VALUES
('Condo One', '123 Main St', 20, '2021-01-01', 1, '555-1001', 'contact@condoone.com', 10000, 'Active', '2023-07-01'),
('Condo Two', '234 Elm St', 30, '2021-02-01', 2, '555-1002', 'contact@condotwo.com', 15000, 'Active', '2023-06-01'),
('Condo Three', '345 Oak St', 25, '2021-03-01', 3, '555-1003', 'contact@condothree.com', 12000, 'Active', '2023-05-01'),
('Condo Four', '456 Pine St', 40, '2021-04-01', 4, '555-1004', 'contact@condofour.com', 20000, 'Active', '2023-04-01'),
('Condo Five', '567 Birch St', 35, '2021-05-01', 5, '555-1005', 'contact@condofive.com', 18000, 'Active', '2023-03-01'),
('Condo Six', '678 Cedar St', 15, '2021-06-01', 6, '555-1006', 'contact@condosix.com', 9000, 'Active', '2023-02-01'),
('Condo Seven', '789 Spruce St', 10, '2021-07-01', 7, '555-1007', 'contact@condoseven.com', 5000, 'Active', '2023-01-01'),
('Condo Eight', '890 Willow St', 50, '2021-08-01', 8, '555-1008', 'contact@condoeight.com', 25000, 'Active', '2022-12-01'),
('Condo Nine', '901 Maple St', 45, '2021-09-01', 9, '555-1009', 'contact@condonine.com', 22000, 'Active', '2022-11-01'),
('Condo Ten', '1012 Ash St', 50, '2021-10-01', 10, '555-1010', 'contact@condoten.com', 30000, 'Active', '2022-10-01');


-- Inserción de datos en la tabla `units`
-- Estos registros representan las unidades dentro de los condominios y su relación con los propietarios.
INSERT INTO units (condo_id, number, type, square_meters, owner_id) VALUES
(1, '101', 'Apartment', 75.0, 1),
(1, '102', 'Apartment', 75.0, 2),
(1, '103', 'Apartment', 75.0, 3),
(1, '104', 'Apartment', 75.0, 4),
(1, '105', 'Apartment', 75.0, 5),
(1, '106', 'Apartment', 75.0, 6),
(1, '107', 'Apartment', 75.0, 7),
(1, '108', 'Apartment', 75.0, 8),
(1, '109', 'Apartment', 75.0, 9),
(1, '110', 'Apartment', 75.0, 10);

-- Inserción de datos en la tabla `owners`
-- Estos registros representan a los propietarios de las unidades en los distintos condominios.
INSERT INTO owners (first_name, last_name, phone, email) VALUES
('Liam', 'Wilson', '555-2001', 'liam.wilson@example.com'),
('Emma', 'Moore', '555-2002', 'emma.moore@example.com'),
('Noah', 'Taylor', '555-2003', 'noah.taylor@example.com'),
('Olivia', 'Anderson', '555-2004', 'olivia.anderson@example.com'),
('William', 'Thomas', '555-2005', 'william.thomas@example.com'),
('Sophia', 'Jackson', '555-2006', 'sophia.jackson@example.com'),
('James', 'White', '555-2007', 'james.white@example.com'),
('Isabella', 'Harris', '555-2008', 'isabella.harris@example.com'),
('Lucas', 'Martin', '555-2009', 'lucas.martin@example.com'),
('Mia', 'Thompson', '555-2010', 'mia.thompson@example.com');

-- Inserción de datos en la tabla `expenses`
-- Estos registros representan las expensas generadas para cada unidad en los condominios.
INSERT INTO expenses (unit_id, month_year, total_amount, payment_status) VALUES
(1, '2023-06-01', 200.00, 'Paid'),
(2, '2023-06-01', 200.00, 'Paid'),
(3, '2023-06-01', 200.00, 'Paid'),
(4, '2023-06-01', 200.00, 'Paid'),
(5, '2023-06-01', 200.00, 'Paid'),
(6, '2023-06-01', 200.00, 'Paid'),
(7, '2023-06-01', 200.00, 'Paid'),
(8, '2023-06-01', 200.00, 'Paid'),
(9, '2023-06-01', 200.00, 'Paid'),
(10, '2023-06-01', 200.00, 'Paid');

-- Inserción de datos en la tabla `payments`
-- Estos registros representan los pagos realizados por los propietarios para cubrir las expensas de sus unidades.
INSERT INTO payments (expense_id, payment_date, amount, payment_method) VALUES
(1, '2023-06-02', 200.00, 'Transfer'),
(2, '2023-06-02', 200.00, 'Transfer'),
(3, '2023-06-02', 200.00, 'Transfer'),
(4, '2023-06-02', 200.00, 'Transfer'),
(5, '2023-06-02', 200.00, 'Transfer'),
(6, '2023-06-02', 200.00, 'Transfer'),
(7, '2023-06-02', 200.00, 'Transfer'),
(8, '2023-06-02', 200.00, 'Transfer'),
(9, '2023-06-02', 200.00, 'Transfer'),
(10, '2023-06-02', 200.00, 'Transfer');

-- Inserción de datos en la tabla `maintenance`
-- Estos registros representan trabajos de mantenimiento programados para los distintos condominios.
INSERT INTO maintenance (condo_id, description, scheduled_date, provider, estimated_cost) VALUES
(1, 'Limpieza general', '2023-07-10', 'CleanCo', 500.00),
(2, 'Reparación de ascensores', '2023-07-15', 'LiftFix', 2000.00),
(3, 'Mantenimiento de jardines', '2023-07-20', 'GreenThumb', 300.00),
(4, 'Pintura exterior', '2023-07-25', 'PaintPro', 1500.00),
(5, 'Reparación de tuberías', '2023-07-30', 'PipeMaster', 800.00);

-- Inserción de datos en la tabla `service_providers`
-- Estos registros representan a los proveedores de servicios asociados con los condominios.
INSERT INTO service_providers (name, phone, email, service_type) VALUES
('CleanCo', '555-3001', 'contact@cleanco.com', 'Limpieza'),
('LiftFix', '555-3002', 'support@liftfix.com', 'Reparación de ascensores'),
('GreenThumb', '555-3003', 'info@greenthumb.com', 'Mantenimiento de jardines'),
('PaintPro', '555-3004', 'services@paintpro.com', 'Pintura'),
('PipeMaster', '555-3005', 'help@pipemaster.com', 'Reparación de tuberías');

-- Inserción de datos en la tabla `meetings`
-- Estos registros representan reuniones de consorcio programadas para los distintos condominios.
INSERT INTO meetings (condo_id, meeting_date, agenda, minutes) VALUES
(1, '2023-07-05', 'Revisión de presupuestos', 'Minutas de la reunión: Se revisaron los presupuestos de mantenimiento.'),
(2, '2023-07-12', 'Actualización de normas', 'Minutas de la reunión: Se discutieron cambios en las normas de convivencia.'),
(3, '2023-07-19', 'Elección de administrador', 'Minutas de la reunión: Se eligió un nuevo administrador para el condominio.'),
(4, '2023-07-26', 'Planificación de eventos', 'Minutas de la reunión: Se planificaron eventos comunitarios.'),
(5, '2023-08-02', 'Mantenimiento preventivo', 'Minutas de la reunión: Se programaron actividades de mantenimiento preventivo.');

-- Inserción de datos en la tabla `violations`
-- Estos registros representan violaciones a las reglas del consorcio cometidas por propietarios o inquilinos.
INSERT INTO violations (unit_id, description, date, penalty, status) VALUES
(1, 'Ruidos molestos', '2023-06-15', 50.00, 'Resuelto'),
(2, 'Mascota sin correa', '2023-06-20', 25.00, 'Pendiente'),
(3, 'Uso indebido de áreas comunes', '2023-06-25', 100.00, 'Resuelto'),
(4, 'Fumar en áreas prohibidas', '2023-07-01', 75.00, 'Pendiente'),
(5, 'Estacionamiento en zona no permitida', '2023-07-05', 30.00, 'Resuelto');

-- Inserción de datos en la tabla `complaints`
-- Estos registros representan quejas presentadas por propietarios o inquilinos.
INSERT INTO complaints (unit_id, description, date_submitted, status) VALUES
(1, 'Fuga de agua en el baño', '2023-06-15', 'Resuelto'),
(2, 'Ruido constante por obras', '2023-06-20', 'Pendiente'),
(3, 'Falta de iluminación en pasillos', '2023-06-25', 'Resuelto'),
(4, 'Problemas con la calefacción', '2023-07-01', 'Pendiente'),
(5, 'Mal funcionamiento del ascensor', '2023-07-05', 'Resuelto');

-- Inserción de datos en la tabla `events`
-- Estos registros representan eventos comunitarios organizados en los condominios.
INSERT INTO events (condo_id, event_name, event_date, description, organizer) VALUES
(1, 'Fiesta de bienvenida', '2023-07-20', 'Evento para dar la bienvenida a los nuevos residentes.', 'Comité de bienvenida'),
(2, 'Reunión social', '2023-08-05', 'Reunión para fortalecer los lazos entre vecinos.', 'Comité social'),
(3, 'Taller de reciclaje', '2023-08-15', 'Taller educativo sobre prácticas de reciclaje.', 'Comité ecológico'),
(4, 'Jornada de limpieza', '2023-08-25', 'Día dedicado a la limpieza de áreas comunes.', 'Comité de mantenimiento'),
(5, 'Campeonato de fútbol', '2023-09-10', 'Torneo de fútbol para los residentes.', 'Comité deportivo');

-- Inserción de datos en la tabla `emergency_contacts`
-- Estos registros representan los contactos de emergencia para cada condominio.
INSERT INTO emergency_contacts (condo_id, contact_name, phone, email, relationship) VALUES
(1, 'Bomberos Locales', '555-4001', 'fire@localfiredept.com', 'Bomberos'),
(2, 'Policía Local', '555-4002', 'police@localpolicedept.com', 'Policía'),
(3, 'Ambulancia', '555-4003', 'ambulance@localmedservice.com', 'Servicios Médicos'),
(4, 'Electricista de Guardia', '555-4004', 'electric@emergencyservices.com', 'Electricidad'),
(5, 'Plomero de Guardia', '555-4005', 'plumber@emergencyservices.com', 'Plomería');

-- Inserción de datos en la tabla `insurance_policies`
-- Estos registros representan pólizas de seguro asociadas a los condominios.
INSERT INTO insurance_policies (condo_id, provider_name, policy_number, coverage_amount, expiration_date, contact_phone, contact_email) VALUES
(1, 'Seguros ABC', 'POL123456', 100000.00, '2023-12-31', '555-5001', 'support@segurosabc.com'),
(2, 'Protección Total', 'POL654321', 150000.00, '2024-01-15', '555-5002', 'info@protecciontotal.com'),
(3, 'Cuidado Hogar', 'POL789123', 120000.00, '2024-03-20', '555-5003', 'contact@cuidadohogar.com'),
(4, 'Seguros Estrella', 'POL321987', 180000.00, '2024-05-10', '555-5004', 'help@segurosestrella.com'),
(5, 'Protección Integral', 'POL456789', 140000.00, '2024-07-25', '555-5005', 'service@proteccionintegral.com');