
-- Crear la tabla `administrators`
-- Esta tabla almacena información sobre los administradores responsables de la gestión de los consorcios.
CREATE TABLE IF NOT EXISTS administrators (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del administrador
    first_name VARCHAR(255) NOT NULL,         -- Nombre del administrador
    last_name VARCHAR(255) NOT NULL,          -- Apellido del administrador
    phone VARCHAR(50),                        -- Número de teléfono del administrador
    email VARCHAR(255)                        -- Correo electrónico del administrador
);

-- Crear la tabla `condominiums`
-- Esta tabla contiene los detalles de cada condominio administrado, incluyendo nombre, dirección, y fondo de reserva.
CREATE TABLE IF NOT EXISTS condominiums (
    condo_id INT PRIMARY KEY AUTO_INCREMENT,      -- Identificador único del condominio
    condo_name VARCHAR(255) NOT NULL,             -- Nombre del condominio
    address VARCHAR(255) NOT NULL,                -- Dirección del condominio
    unit_count INT NOT NULL,                      -- Número de unidades en el condominio
    creation_date DATE NOT NULL,                  -- Fecha de creación del condominio
    admin_id INT,                                 -- Referencia al administrador responsable (FK)
    contact_phone VARCHAR(50),                    -- Teléfono de contacto del condominio
    contact_email VARCHAR(255),                   -- Correo electrónico de contacto del condominio
    reserve_fund DECIMAL(10, 2),                  -- Fondo de reserva disponible del condominio
    status VARCHAR(50),                           -- Estado actual del condominio (e.g., Activo, Inactivo)
    last_meeting_date DATE,                       -- Fecha de la última reunión del consorcio
    FOREIGN KEY (admin_id) REFERENCES administrators(admin_id)  -- Clave foránea que relaciona con la tabla `administrators`
);

-- Crear la tabla `units`
-- Esta tabla almacena la información de las unidades dentro de los condominios.
CREATE TABLE IF NOT EXISTS units (
    unit_id INT PRIMARY KEY AUTO_INCREMENT,      -- Identificador único de la unidad
    condo_id INT NOT NULL,                       -- Referencia al condominio al que pertenece la unidad (FK)
    number VARCHAR(50) NOT NULL,                 -- Número de la unidad
    type VARCHAR(50) NOT NULL,                   -- Tipo de unidad (e.g., Apartamento, Oficina)
    square_meters DECIMAL(10, 2),                -- Tamaño de la unidad en metros cuadrados
    owner_id INT,                                -- Referencia al propietario de la unidad (FK)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id),  -- Clave foránea que relaciona con la tabla `condominiums`
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id)         -- Clave foránea que relaciona con la tabla `owners`
);

-- Crear la tabla `owners`
-- Esta tabla guarda la información de los propietarios de las unidades dentro de los condominios.
CREATE TABLE IF NOT EXISTS owners (
    owner_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del propietario
    first_name VARCHAR(255) NOT NULL,         -- Nombre del propietario
    last_name VARCHAR(255) NOT NULL,          -- Apellido del propietario
    phone VARCHAR(50),                        -- Número de teléfono del propietario
    email VARCHAR(255)                        -- Correo electrónico del propietario
);

-- Crear la tabla `expenses`
-- Esta tabla almacena las expensas asociadas a cada unidad, incluyendo el monto y el estado de pago.
CREATE TABLE IF NOT EXISTS expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la expensa
    unit_id INT NOT NULL,                       -- Referencia a la unidad a la que corresponde la expensa (FK)
    month_year DATE NOT NULL,                   -- Mes y año de la expensa
    total_amount DECIMAL(10, 2) NOT NULL,       -- Monto total de la expensa
    payment_status VARCHAR(50) NOT NULL,        -- Estado del pago de la expensa (e.g., Pagado, Pendiente)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- Crear la tabla `payments`
-- Esta tabla registra los pagos realizados por los propietarios para cubrir las expensas de sus unidades.
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del pago
    expense_id INT NOT NULL,                    -- Referencia a la expensa relacionada con el pago (FK)
    payment_date DATE NOT NULL,                 -- Fecha en la que se realizó el pago
    amount DECIMAL(10, 2) NOT NULL,             -- Monto pagado
    payment_method VARCHAR(50) NOT NULL,        -- Método de pago utilizado (e.g., Transferencia, Tarjeta)
    FOREIGN KEY (expense_id) REFERENCES expenses(expense_id)  -- Clave foránea que relaciona con la tabla `expenses`
);

-- Crear la tabla `common_expenses`
-- Esta tabla contiene los gastos comunes que se aplican a todo el condominio, como mantenimiento, servicios y reparaciones.
CREATE TABLE IF NOT EXISTS common_expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del gasto común
    condo_id INT NOT NULL,                      -- Referencia al condominio al que corresponde el gasto común (FK)
    description VARCHAR(255) NOT NULL,          -- Descripción del gasto común
    date DATE NOT NULL,                         -- Fecha en la que se registró el gasto
    amount DECIMAL(10, 2) NOT NULL,             -- Monto del gasto común
    category VARCHAR(50) NOT NULL,              -- Categoría del gasto (e.g., Mantenimiento, Servicios, Reparaciones)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `common_expenses_audit`
-- Esta tabla de auditoría registra los cambios realizados en los gastos comunes, permitiendo un seguimiento detallado de las modificaciones.
CREATE TABLE IF NOT EXISTS common_expenses_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del registro de auditoría
    expense_id INT,                           -- Referencia al gasto común que fue modificado (FK)
    condo_id INT,                             -- Referencia al condominio asociado al gasto común (FK)
    old_amount DECIMAL(10, 2),                -- Monto anterior del gasto común antes de la modificación
    new_amount DECIMAL(10, 2),                -- Monto nuevo del gasto común después de la modificación
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- Fecha y hora en que se realizó la modificación
    FOREIGN KEY (expense_id) REFERENCES common_expenses(expense_id),  -- Clave foránea que relaciona con la tabla `common_expenses`
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)           -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `maintenance`
-- Esta tabla almacena los detalles de los trabajos de mantenimiento programados para cada condominio.
CREATE TABLE IF NOT EXISTS maintenance (
    maintenance_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del trabajo de mantenimiento
    condo_id INT NOT NULL,                          -- Referencia al condominio al que pertenece el mantenimiento (FK)
    description VARCHAR(255) NOT NULL,              -- Descripción del trabajo de mantenimiento
    scheduled_date DATE NOT NULL,                   -- Fecha programada para el mantenimiento
    provider VARCHAR(255) NOT NULL,                 -- Proveedor del servicio de mantenimiento
    estimated_cost DECIMAL(10, 2) NOT NULL,         -- Costo estimado del mantenimiento
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `service_providers`
-- Esta tabla almacena la información de los proveedores de servicios de mantenimiento y otros servicios.
CREATE TABLE IF NOT EXISTS service_providers (
    provider_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del proveedor de servicios
    name VARCHAR(255) NOT NULL,                  -- Nombre del proveedor de servicios
    phone VARCHAR(50) NOT NULL,                  -- Número de teléfono del proveedor
    email VARCHAR(255) NOT NULL,                 -- Correo electrónico del proveedor
    service_type VARCHAR(255) NOT NULL           -- Tipo de servicio proporcionado (e.g., Mantenimiento, Seguridad)
);

-- Crear la tabla `meetings`
-- Esta tabla almacena la información sobre las reuniones de consorcio programadas para cada condominio.
CREATE TABLE IF NOT EXISTS meetings (
    meeting_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la reunión
    condo_id INT NOT NULL,                      -- Referencia al condominio asociado a la reunión (FK)
    meeting_date DATE NOT NULL,                 -- Fecha de la reunión
    agenda TEXT NOT NULL,                       -- Agenda de la reunión
    minutes TEXT,                               -- Minutas de la reunión
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `violations`
-- Esta tabla almacena las violaciones a las reglas del consorcio cometidas por los propietarios o inquilinos.
CREATE TABLE IF NOT EXISTS violations (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la violación
    unit_id INT NOT NULL,                         -- Referencia a la unidad relacionada con la violación (FK)
    description VARCHAR(255) NOT NULL,            -- Descripción de la violación
    date DATE NOT NULL,                           -- Fecha de la violación
    penalty DECIMAL(10, 2),                       -- Penalización impuesta por la violación
    status VARCHAR(50) NOT NULL,                  -- Estado de la violación (e.g., Pendiente, Resuelto)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- Crear la tabla `complaints`
-- Esta tabla almacena las quejas presentadas por los propietarios o inquilinos en relación con el consorcio o la administración.
CREATE TABLE IF NOT EXISTS complaints (
    complaint_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la queja
    unit_id INT NOT NULL,                         -- Referencia a la unidad desde donde se presentó la queja (FK)
    description TEXT NOT NULL,                    -- Descripción de la queja
    date_submitted DATE NOT NULL,                 -- Fecha en la que se presentó la queja
    status VARCHAR(50) NOT NULL,                  -- Estado de la queja (e.g., Pendiente, Resuelto)
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)  -- Clave foránea que relaciona con la tabla `units`
);

-- Crear la tabla `events`
-- Esta tabla almacena los eventos comunitarios organizados en los condominios.
CREATE TABLE IF NOT EXISTS events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del evento
    condo_id INT NOT NULL,                    -- Referencia al condominio donde se realizará el evento (FK)
    event_name VARCHAR(255) NOT NULL,         -- Nombre del evento
    event_date DATE NOT NULL,                 -- Fecha del evento
    description TEXT,                         -- Descripción del evento
    organizer VARCHAR(255) NOT NULL,          -- Organizador del evento
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `emergency_contacts`
-- Esta tabla almacena los contactos de emergencia para cada condominio.
CREATE TABLE IF NOT EXISTS emergency_contacts (
    contact_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único del contacto de emergencia
    condo_id INT NOT NULL,                      -- Referencia al condominio al que pertenece el contacto (FK)
    contact_name VARCHAR(255) NOT NULL,         -- Nombre del contacto de emergencia
    phone VARCHAR(50) NOT NULL,                 -- Número de teléfono del contacto de emergencia
    email VARCHAR(255),                         -- Correo electrónico del contacto de emergencia
    relationship VARCHAR(50) NOT NULL,          -- Relación del contacto con el consorcio (e.g., Bomberos, Policía)
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

-- Crear la tabla `insurance_policies`
-- Esta tabla almacena la información de las pólizas de seguro asociadas a los condominios.
CREATE TABLE IF NOT EXISTS insurance_policies (
    policy_id INT PRIMARY KEY AUTO_INCREMENT,  -- Identificador único de la póliza de seguro
    condo_id INT NOT NULL,                     -- Referencia al condominio cubierto por la póliza (FK)
    provider_name VARCHAR(255) NOT NULL,       -- Nombre del proveedor del seguro
    policy_number VARCHAR(255) NOT NULL,       -- Número de la póliza
    coverage_amount DECIMAL(10, 2) NOT NULL,   -- Monto de la cobertura
    expiration_date DATE NOT NULL,             -- Fecha de vencimiento de la póliza
    contact_phone VARCHAR(50) NOT NULL,        -- Teléfono de contacto del proveedor del seguro
    contact_email VARCHAR(255),                -- Correo electrónico del proveedor del seguro
    FOREIGN KEY (condo_id) REFERENCES condominiums(condo_id)  -- Clave foránea que relaciona con la tabla `condominiums`
);

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

-- Crear la vista `unit_details_view`
-- Esta vista proporciona un resumen de las unidades, incluyendo información sobre el condominio, el propietario, y los detalles específicos de cada unidad.
CREATE VIEW unit_details_view AS
SELECT 
    u.unit_id,
    u.number AS unit_number,
    u.type AS unit_type,
    u.square_meters,
    c.condo_name,
    o.first_name AS owner_first_name,
    o.last_name AS owner_last_name,
    o.phone AS owner_phone,
    o.email AS owner_email
FROM 
    units u
JOIN 
    condominiums c ON u.condo_id = c.condo_id
JOIN 
    owners o ON u.owner_id = o.owner_id;

-- Crear la vista `expense_payment_status_view`
-- Esta vista muestra los detalles de las expensas de cada unidad, incluyendo el estado de pago y el método de pago utilizado.
CREATE VIEW expense_payment_status_view AS
SELECT 
    e.expense_id,
    u.number AS unit_number,
    c.condo_name,
    e.month_year,
    e.total_amount,
    e.payment_status,
    p.payment_method,
    p.payment_date
FROM 
    expenses e
JOIN 
    payments p ON e.expense_id = p.expense_id
JOIN 
    units u ON e.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id;

-- Crear la vista `upcoming_maintenance_view`
-- Esta vista detalla los próximos trabajos de mantenimiento programados para cada condominio, proporcionando una referencia fácil para la administración.
CREATE VIEW upcoming_maintenance_view AS
SELECT 
    m.maintenance_id,
    c.condo_name,
    m.description AS maintenance_description,
    m.scheduled_date,
    m.provider,
    m.estimated_cost
FROM 
    maintenance m
JOIN 
    condominiums c ON m.condo_id = c.condo_id
WHERE 
    m.scheduled_date >= CURRENT_DATE()
ORDER BY 
    m.scheduled_date;

-- Crear la vista `service_provider_list_view`
-- Esta vista proporciona una lista de proveedores de servicios asociados con los condominios.
CREATE VIEW service_provider_list_view AS
SELECT 
    s.provider_id,
    s.name AS provider_name,
    s.phone AS provider_phone,
    s.email AS provider_email,
    s.service_type
FROM 
    service_providers s;

-- Crear la vista `meeting_agenda_view`
-- Esta vista muestra las agendas y minutas de las reuniones de consorcio.
CREATE VIEW meeting_agenda_view AS
SELECT 
    m.meeting_id,
    c.condo_name,
    m.meeting_date,
    m.agenda,
    m.minutes
FROM 
    meetings m
JOIN 
    condominiums c ON m.condo_id = c.condo_id
ORDER BY 
    m.meeting_date DESC;

-- Crear la vista `violations_report_view`
-- Esta vista muestra un informe de las violaciones a las reglas del consorcio, incluyendo el estado de cada una.
CREATE VIEW violations_report_view AS
SELECT 
    v.violation_id,
    u.number AS unit_number,
    c.condo_name,
    v.description AS violation_description,
    v.date,
    v.penalty,
    v.status
FROM 
    violations v
JOIN 
    units u ON v.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
ORDER BY 
    v.date DESC;

-- Crear la vista `complaints_status_view`
-- Esta vista proporciona un resumen del estado de las quejas presentadas por propietarios o inquilinos.
CREATE VIEW complaints_status_view AS
SELECT 
    comp.complaint_id,
    u.number AS unit_number,
    c.condo_name,
    comp.description AS complaint_description,
    comp.date_submitted,
    comp.status
FROM 
    complaints comp
JOIN 
    units u ON comp.unit_id = u.unit_id
JOIN 
    condominiums c ON u.condo_id = c.condo_id
ORDER BY 
    comp.date_submitted DESC;

-- Crear la vista `event_schedule_view`
-- Esta vista proporciona un calendario de eventos organizados en los condominios.
CREATE VIEW event_schedule_view AS
SELECT 
    e.event_id,
    c.condo_name,
    e.event_name,
    e.event_date,
    e.description AS event_description,
    e.organizer
FROM 
    events e
JOIN 
    condominiums c ON e.condo_id = c.condo_id
ORDER BY 
    e.event_date DESC;

-- Crear la vista `insurance_policies_view`
-- Esta vista muestra un resumen de las pólizas de seguro asociadas a los condominios.
CREATE VIEW insurance_policies_view AS
SELECT 
    i.policy_id,
    c.condo_name,
    i.provider_name,
    i.policy_number,
    i.coverage_amount,
    i.expiration_date,
    i.contact_phone,
    i.contact_email
FROM 
    insurance_policies i
JOIN 
    condominiums c ON i.condo_id = c.condo_id
ORDER BY 
    i.expiration_date DESC;

-- Crear el procedimiento almacenado `add_common_expense_and_update_reserve`
-- Este procedimiento permite agregar un nuevo gasto común y actualizar el fondo de reserva del consorcio correspondiente.
DELIMITER //

CREATE PROCEDURE add_common_expense_and_update_reserve(
    IN condo_id_param INT,
    IN description_param VARCHAR(255),
    IN date_param DATE,
    IN amount_param DECIMAL(10, 2),
    IN category_param VARCHAR(50)
)
BEGIN
    -- Insertar el nuevo gasto común
    INSERT INTO common_expenses (condo_id, description, date, amount, category)
    VALUES (condo_id_param, description_param, date_param, amount_param, category_param);
    
    -- Actualizar el fondo de reserva del consorcio, restando el monto del gasto
    UPDATE condominiums
    SET reserve_fund = reserve_fund - amount_param
    WHERE condo_id = condo_id_param;
    
    -- Verificar que el fondo de reserva no sea negativo y emitir una advertencia si es necesario
    SELECT reserve_fund INTO @new_reserve
    FROM condominiums
    WHERE condo_id = condo_id_param;

    IF @new_reserve < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Advertencia: El fondo de reserva ha quedado en negativo.';
    END IF;

END //

DELIMITER ;

-- Crear el procedimiento almacenado `get_owner_total_expenses`
-- Este procedimiento calcula el total de expensas pagadas por un propietario para todas las unidades que posee en un año específico.
DELIMITER //

CREATE PROCEDURE get_owner_total_expenses(
    IN owner_id_param INT, 
    IN year_param YEAR, 
    OUT total_expenses DECIMAL(10, 2)
)
BEGIN
    -- Calcular el total de expensas pagadas por el propietario en el año especificado
    SELECT SUM(p.amount) INTO total_expenses
    FROM payments p
    JOIN expenses e ON p.expense_id = e.expense_id
    JOIN units u ON e.unit_id = u.unit_id
    WHERE u.owner_id = owner_id_param 
    AND YEAR(e.month_year) = year_param 
    AND e.payment_status = 'Paid';

    -- Si no hay registros, devolver 0
    IF total_expenses IS NULL THEN
        SET total_expenses = 0;
    END IF;
END //

DELIMITER ;

-- Crear el procedimiento almacenado `get_condo_maintenance_summary`
-- Este procedimiento proporciona un resumen de los gastos de mantenimiento realizados en un condominio durante un año específico.
DELIMITER //

CREATE PROCEDURE get_condo_maintenance_summary(
    IN condo_id_param INT, 
    IN year_param YEAR
)
BEGIN
    -- Generar el resumen de mantenimiento
    SELECT 
        m.description AS Maintenance_Description,
        m.scheduled_date AS Scheduled_Date,
        m.provider AS Service_Provider,
        m.estimated_cost AS Estimated_Cost,
        IFNULL(SUM(p.amount), 0) AS Amount_Paid
    FROM maintenance m
    LEFT JOIN payments p ON m.maintenance_id = p.expense_id
    WHERE m.condo_id = condo_id_param 
    AND YEAR(m.scheduled_date) = year_param
    GROUP BY m.maintenance_id;
END //

DELIMITER ;

-- Crear el procedimiento almacenado `record_violation`
-- Este procedimiento registra una nueva violación a las reglas del consorcio y actualiza el estado correspondiente.
DELIMITER //

CREATE PROCEDURE record_violation(
    IN unit_id_param INT,
    IN description_param VARCHAR(255),
    IN date_param DATE,
    IN penalty_param DECIMAL(10, 2),
    IN status_param VARCHAR(50)
)
BEGIN
    -- Insertar la nueva violación en la tabla `violations`
    INSERT INTO violations (unit_id, description, date, penalty, status)
    VALUES (unit_id_param, description_param, date_param, penalty_param, status_param);
    
    -- Actualizar el estado de la violación si es necesario
    UPDATE violations
    SET status = status_param
    WHERE unit_id = unit_id_param
    AND description = description_param
    AND date = date_param;
END //

DELIMITER ;

-- Crear el procedimiento almacenado `resolve_complaint`
-- Este procedimiento marca una queja como resuelta y actualiza el estado en la base de datos.
DELIMITER //

CREATE PROCEDURE resolve_complaint(
    IN complaint_id_param INT
)
BEGIN
    -- Actualizar el estado de la queja a 'Resuelto'
    UPDATE complaints
    SET status = 'Resuelto'
    WHERE complaint_id = complaint_id_param;
END //

DELIMITER ;

-- Crear el trigger `after_payment_insert`
-- Este trigger se ejecuta después de que se inserta un nuevo pago y actualiza el fondo de reserva del consorcio asociado.
DELIMITER //

CREATE TRIGGER after_payment_insert
AFTER INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE condo_id INT;

    -- Obtener el ID del consorcio asociado a la unidad que realizó el pago
    SELECT u.condo_id INTO condo_id
    FROM units u
    JOIN expenses e ON u.unit_id = e.unit_id
    WHERE e.expense_id = NEW.expense_id;

    -- Actualizar el fondo de reserva del consorcio sumando el monto del pago
    UPDATE condominiums
    SET reserve_fund = reserve_fund + NEW.amount
    WHERE condo_id = condo_id;
END //

DELIMITER ;

-- Crear el trigger `before_owner_delete`
-- Este trigger previene la eliminación de un propietario si todavía tiene unidades asociadas activas en el sistema.
DELIMITER //

CREATE TRIGGER before_owner_delete
BEFORE DELETE ON owners
FOR EACH ROW
BEGIN
    DECLARE unit_count INT;

    -- Contar el número de unidades asociadas al propietario que se intenta eliminar
    SELECT COUNT(*)
    INTO unit_count
    FROM units
    WHERE owner_id = OLD.owner_id;

    -- Si hay unidades asociadas, prevenir la eliminación del propietario
    IF unit_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede eliminar al propietario porque todavía tiene unidades asociadas.';
    END IF;
END //

DELIMITER ;

-- Crear el trigger `after_common_expense_update`
-- Este trigger registra cualquier cambio en la tabla `common_expenses` en una tabla de auditoría para mantener un historial de modificaciones.
DELIMITER //

CREATE TRIGGER after_common_expense_update
AFTER UPDATE ON common_expenses
FOR EACH ROW
BEGIN
    -- Insertar los cambios en la tabla de auditoría
    INSERT INTO common_expenses_audit (expense_id, condo_id, old_amount, new_amount)
    VALUES (OLD.expense_id, OLD.condo_id, OLD.amount, NEW.amount);
END //

DELIMITER ;

-- Crear el trigger `after_violation_insert`
-- Este trigger se ejecuta después de que se inserta una nueva violación y notifica al propietario.
DELIMITER //

CREATE TRIGGER after_violation_insert
AFTER INSERT ON violations
FOR EACH ROW
BEGIN
    -- Notificación o lógica adicional para manejar la violación
    -- (Este trigger puede usarse para enviar notificaciones o actualizar otras tablas)
    CALL notify_owner_of_violation(NEW.unit_id, NEW.description, NEW.date);
END //

DELIMITER ;
