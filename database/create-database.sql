-- Database: eyesync_db

-- DROP DATABASE IF EXISTS eyesync_db;
-- 
CREATE DATABASE eyesync_db
    WITH
    OWNER = admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = True;

COMMENT ON DATABASE eyesync_db
    IS 'General EyeSync Database Project';

GRANT TEMPORARY, CONNECT ON DATABASE eyesync_db TO PUBLIC;

GRANT ALL ON DATABASE eyesync_db TO admin;

GRANT TEMPORARY ON DATABASE eyesync_db TO pg_database_owner;

GRANT TEMPORARY ON DATABASE eyesync_db TO postgres;

CREATE TYPE lab_ticket_status AS ENUM (
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled'
);

CREATE TYPE lens_type AS ENUM ('single_vision', 'bifocal', 'progressive');

CREATE TYPE lens_material AS ENUM ('plastic', 'polycarbonate', 'high_index');

CREATE TYPE type_products AS ENUM ('sunglasses', 'eyeglasses', 'safety_glasses');

CREATE TYPE status_items_inventory AS ENUM (
    'Ready for Sale',
    'Defective',
    'On Return',
    'ICT (to receive in MN)',
    'ICT (sent and not received)'
);

CREATE TYPE type_products AS ENUM (
    'optical',
    'sunglasses'
);


CREATE TYPE lens_material AS ENUM (
    'Plastic',
    'Glass',
    'Polycarbonate',
    '1.6O Index',
    'n/a'
);

CREATE TYPE gender AS ENUM ('Male', 'Female', 'Other');

CREATE TYPE pronoun AS ENUM ('He/Him', 'She/Her', 'They/Them', 'Other');

CREATE TYPE paid_insurance_status AS ENUM (
    'Billed',
    'Pending',
    'Paid'
);

CREATE TYPE dominant_eye AS ENUM ('Right', 'Left', 'n/a');

CREATE TYPE angle_estimation_eye AS ENUM (
    '1',
    '2',
    '3',
    '4',
    'n/a'
);

CREATE TYPE tonometry_eye AS ENUM (
    'NCT',
    'Goldmann',
    'ICare',
    'Tonopen',
    'Other'
);

CREATE TYPE iris_color AS ENUM (
    'Blue',
    'Green',
    'Hazel',
    'Brown',
    'Heterochromia'
);




CREATE TABLE race (
    id_race SERIAL PRIMARY KEY,
    race_name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE race IS 'Race information';



CREATE TABLE ethnicity (
    id_ethnicity SERIAL PRIMARY KEY,
    ethnicity_name VARCHAR(50) NOT NULL
);
COMMENT ON TABLE ethnicity IS 'Ethnicity information';



CREATE TABLE agreement (
    id_agreement SERIAL PRIMARY KEY,
    link_to_file VARCHAR(255),
    date_agreement date,
    date_end date
);
COMMENT ON TABLE agreement IS 'agreements with vendors';



CREATE TABLE vendor (
    id_vendor SERIAL PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    short_name VARCHAR(20),
    phone VARCHAR(20),
    street_address VARCHAR(100),
    address_line_2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(2),
    website VARCHAR(100),
    fax VARCHAR(20),
    email VARCHAR(100)
);
COMMENT ON TABLE vendor IS 'Vendors';


CREATE TABLE brand (
    id_brand SERIAL PRIMARY KEY,
    brand_name VARCHAR(100),
    short_name VARCHAR(2)
);
COMMENT ON TABLE brand IS 'Brands';


CREATE TABLE product (
    id_product BIGSERIAL PRIMARY KEY,
    title_product VARCHAR(150) NOT NULL,
    brand_id BIGINT,
    vendor_id BIGINT,

    CONSTRAINT product_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES brand (id_brand),
    CONSTRAINT product_vendor_id_fkey FOREIGN KEY (vendor_id) REFERENCES vendor (id_vendor)
);
COMMENT ON TABLE product IS 'Products / Items';



CREATE TABLE model (
    id_model BIGSERIAL PRIMARY KEY,
    product_id BIGINT NOT NULL,
    title_variant VARCHAR(100) NOT NULL,
    upc VARCHAR(16),
    ean VARCHAR(16),
    gtim VARCHAR(16),
    lens_type lens_type,  -- Assuming ENUM TYPE lens_type is already defined
    lens_material lens_material,  -- Assuming ENUM TYPE lens_material is already defined
    mirror BOOLEAN DEFAULT FALSE,
    backside_ar BOOLEAN DEFAULT FALSE,
    size_lens_width VARCHAR(3),
    size_bridge_width VARCHAR(3),
    size_temple_length VARCHAR(4),
    type_products type_products,  -- Using the new ENUM TYPE type_products
    materials_frame VARCHAR,
    materials_temple VARCHAR,
    color VARCHAR,

    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product (id_product)
);
COMMENT ON TABLE model IS 'Models of products / items like colors, sizes, materials and etc';



CREATE TABLE price_book (
    id_price_book BIGSERIAL PRIMARY KEY,
    purchase_price numeric(10,2) NOT NULL,
    regular_price numeric(10,2) NOT NULL,
    low_price numeric(10,2) NOT NULL,
    discount numeric(10,2),
    model_id BIGINT NOT NULL,

    CONSTRAINT model_product_id_fkey FOREIGN KEY (model_id) REFERENCES model (id_model)
);
COMMENT ON TABLE price_book IS 'Prices book where purchase_price for our from vendor, regular_price for sale';


CREATE TABLE job_title (
    id_job_title SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    doctor BOOLEAN DEFAULT FALSE,
    short_title VARCHAR(3)
);
COMMENT ON TABLE job_title IS 'Job title of employees';


CREATE TABLE store (
    id_store SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    short_name VARCHAR(2),
    street_address VARCHAR(100),
    address_line_2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(2),
    postal_code VARCHAR(20),
    country VARCHAR(50),
    phone VARCHAR(20),
    website VARCHAR(100),
    fax VARCHAR(20),
    email VARCHAR(100),
    working_hours VARCHAR(200)
);
COMMENT ON TABLE store IS 'Store';


CREATE TABLE work_shift (
    id_work_shift BIGSERIAL PRIMARY KEY,
    title VARCHAR(100),
    monday BOOLEAN DEFAULT TRUE,
    tuesday BOOLEAN DEFAULT TRUE,
    wednesday BOOLEAN DEFAULT TRUE,
    thursday BOOLEAN DEFAULT TRUE,
    friday BOOLEAN DEFAULT TRUE,
    saturday BOOLEAN DEFAULT FALSE,
    sunday BOOLEAN DEFAULT FALSE,
    monday_time_start TIME WITHOUT TIME ZONE DEFAULT '10:00:00',
    monday_time_end TIME WITHOUT TIME ZONE DEFAULT '19:00:00',
    tuesday_time_start TIME WITHOUT TIME ZONE DEFAULT '10:00:00',
    tuesday_time_end TIME WITHOUT TIME ZONE DEFAULT '19:00:00',
    wednesday_time_start TIME WITHOUT TIME ZONE DEFAULT '10:00:00',
    wednesday_time_end TIME WITHOUT TIME ZONE DEFAULT '19:00:00',
    thursday_time_start TIME WITHOUT TIME ZONE DEFAULT '10:00:00',
    thursday_time_end TIME WITHOUT TIME ZONE DEFAULT '19:00:00',
    friday_time_start TIME WITHOUT TIME ZONE DEFAULT '10:00:00',
    friday_time_end TIME WITHOUT TIME ZONE DEFAULT '19:00:00',
    saturday_time_start TIME WITHOUT TIME ZONE,
    saturday_time_end TIME WITHOUT TIME ZONE,
    sunday_time_start TIME WITHOUT TIME ZONE,
    sunday_time_end TIME WITHOUT TIME ZONE,
    lunch_duration INTERVAL DEFAULT '00:30:00'
);
COMMENT ON TABLE work_shift IS 'Work Shift of enployees / default=5/2 40.0h / 10am-7pm';


CREATE TABLE rate_per_hour (
    id_rate_per_hour SERIAL PRIMARY KEY,
    rate_per_hour NUMERIC(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    hours_per_week REAL DEFAULT 40.00,
    over_time NUMERIC(10,2) GENERATED ALWAYS AS (rate_per_hour * 1.5) STORED
);
COMMENT ON TABLE rate_per_hour IS 'rate';


CREATE TABLE login (
    id_login SERIAL PRIMARY KEY,
    login VARCHAR(255) NOT NULL,
    md5_password VARCHAR(255) NOT NULL
);
COMMENT ON TABLE login IS 'User Login Information';



CREATE TABLE employee (
    id_employee SERIAL PRIMARY KEY,
    first_name VARCHAR(20) NOT NULL,
    middle_name VARCHAR(20),
    last_name VARCHAR(20) NOT NULL,
    suffix VARCHAR(4),
    dob DATE,
    phone VARCHAR(10),
    email VARCHAR(100),
    street_address VARCHAR(100),
    address_line_2 VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(100),
    login_id BIGINT NOT NULL,
    job_title_id BIGINT,
    work_shift_id BIGINT,
    store_id BIGINT,
    rate_per_hour_id BIGINT,
    CONSTRAINT fk_login FOREIGN KEY (login_id) REFERENCES login (id_login),
    CONSTRAINT fk_job_title FOREIGN KEY (job_title_id) REFERENCES job_title (id_job_title),
    CONSTRAINT fk_work_shift FOREIGN KEY (work_shift_id) REFERENCES work_shift (id_work_shift),
    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES store (id_store),
    CONSTRAINT fk_rate_per_hour FOREIGN KEY (rate_per_hour_id) REFERENCES rate_per_hour (id_rate_per_hour)
);
COMMENT ON TABLE employee IS 'Employee information';



CREATE TABLE payment_method (
    id_payment_method SERIAL PRIMARY KEY,
    method_name VARCHAR(30) NOT NULL,
    short_name VARCHAR(2)
);
COMMENT ON TABLE payment_method IS 'Payment methods';


CREATE TABLE patient (
    id_patient BIGSERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    dob DATE,
    gender gender,  -- Using the ENUM type created earlier
    phone VARCHAR(15),
    phone_home VARCHAR(15),
    cell_work VARCHAR(15),
    email VARCHAR(100),
    street_address VARCHAR(100),
    address_line_2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10),
    race_id BIGINT,
    ethnicity_id BIGINT,
    ssn VARCHAR(11),
    pref VARCHAR(100),
    pronoun pronoun,  -- Using the ENUM type created earlier
    assigned_sex gender,  -- Using the ENUM type created earlier
    mailing_list BOOLEAN,
    survey BOOLEAN,  
    CONSTRAINT fk_race FOREIGN KEY (race_id) REFERENCES race (id_race),
    CONSTRAINT fk_ethnicity FOREIGN KEY (ethnicity_id) REFERENCES ethnicity (id_ethnicity)
);
COMMENT ON TABLE patient IS 'Patient information';



CREATE TABLE invoice (
    id_invoice BIGSERIAL PRIMARY KEY,
    number_invoice VARCHAR(16) NOT NULL,
    date_create TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    payment_method_id BIGINT,
    paid_insurance_status paid_insurance_status,  -- Using the ENUM type created earlier
    employee_id BIGINT,
    notified TEXT,
    pt_bal NUMERIC(10,2),
    discount NUMERIC(10,2),
    total_amount NUMERIC(10,2),
    final_amount NUMERIC(10,2),
    status VARCHAR,
    quantity INT,
    referral VARCHAR(100),
    class VARCHAR(100),
    reason VARCHAR(100),
    doctor_id BIGINT,
    vendor_invoice_id BIGINT,
    patient_id BIGINT,
    CONSTRAINT fk_payment_method FOREIGN KEY (payment_method_id) REFERENCES payment_method (id_payment_method),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employee (id_employee),
    CONSTRAINT fk_doctor FOREIGN KEY (doctor_id) REFERENCES employee (id_employee)
        CHECK (EXISTS (SELECT 1 FROM employee WHERE id_employee = doctor_id AND doctor = TRUE)),
    CONSTRAINT fk_vendor_invoice FOREIGN KEY (vendor_invoice_id) REFERENCES vendor_invoice (id_vendor_invoice),
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patient (id_patient)
);
COMMENT ON TABLE invoice IS 'Invoice details';




CREATE TABLE orders_lens (
    id_orders_lens BIGSERIAL PRIMARY KEY,
    number_order VARCHAR(16) NOT NULL,
    date_create TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) NOT NULL,
    total_amount NUMERIC(10,2)
);
COMMENT ON TABLE orders_lens IS 'Orders for lenses';


CREATE TABLE inventory (
    id_inventory BIGSERIAL PRIMARY KEY,
    sku VARCHAR(12) NOT NULL,
    modified_date TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status_items_inventory status_items_inventory NOT NULL,  -- Using the ENUM type created earlier
    store_id BIGINT NOT NULL,
    model_id BIGINT NOT NULL,
    invoice_id BIGINT NOT NULL,
    orders_lens_id BIGINT,
    employee_id BIGINT NOT NULL,

    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES store (id_store),
    CONSTRAINT fk_model FOREIGN KEY (model_id) REFERENCES model (id_model),
    CONSTRAINT fk_invoice FOREIGN KEY (invoice_id) REFERENCES invoice (id_invoice),
    CONSTRAINT fk_orders_lens FOREIGN KEY (orders_lens_id) REFERENCES orders_lens (id_orders_lens),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employee (id_employee)
);
COMMENT ON TABLE inventory IS 'General list of all inventory';


CREATE TABLE batch (
    id_batch BIGSERIAL PRIMARY KEY,
    store_id BIGINT,
    brand_id BIGINT,
    qty INTEGER,
    cost DECIMAL(10,2),
    employee_id_prep_by BIGINT,
    employee_id_created BIGINT,
    employee_id_updated BIGINT,
    notes TEXT,

    CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES store (id_store),
    CONSTRAINT fk_employee_prep FOREIGN KEY (employee_id_prep_by) REFERENCES employee (id_employee),
    CONSTRAINT fk_employee_created FOREIGN KEY (employee_id_created) REFERENCES employee (id_employee),
    CONSTRAINT fk_employee_updated FOREIGN KEY (employee_id_updated) REFERENCES employee (id_employee)
);
COMMENT ON TABLE batch IS 'batches from vendors';


CREATE TABLE inventory_transfer (
    id_transfer BIGSERIAL PRIMARY KEY,
    inventory_id BIGINT NOT NULL,
    from_store_id BIGINT NOT NULL,
    to_store_id BIGINT NOT NULL,
    date_transfer TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    transferred_by BIGINT,
    received_by BIGINT,
    status VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(id_inventory),
    CONSTRAINT fk_from_store FOREIGN KEY (from_store_id) REFERENCES store(id_store),
    CONSTRAINT fk_to_store FOREIGN KEY (to_store_id) REFERENCES store(id_store),
    CONSTRAINT fk_transferred_by FOREIGN KEY (transferred_by) REFERENCES employee(id_employee),
    CONSTRAINT fk_received_by FOREIGN KEY (received_by) REFERENCES employee(id_employee)
);
COMMENT ON TABLE inventory_transfer IS 'Tracks inventory transfers between stores';

-- FUNCTION
CREATE OR REPLACE FUNCTION log_inventory_transaction() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO inventory_transaction (
        inventory_id,
        transaction_type,
        transaction_date,
        quantity,
        source_store_id,
        destination_store_id,
        employee_id,
        notes
    ) VALUES (
        NEW.id_inventory,
        'Addition',
        CURRENT_TIMESTAMP,
        1,
        NULL,
        NEW.store_id,
        NEW.employee_id,
        'New item added to inventory'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--TRIGGER
CREATE TRIGGER after_inventory_insert
AFTER INSERT ON inventory
FOR EACH ROW
EXECUTE FUNCTION log_inventory_transaction();



CREATE TABLE lab (
    id_lab SERIAL PRIMARY KEY,
    title_lab VARCHAR(100) NOT NULL,
    short_name VARCHAR(3)
);
COMMENT ON TABLE lab IS 'Lab information';


CREATE TABLE lab_ticket (
    id_ticket BIGSERIAL PRIMARY KEY,
    number_ticket VARCHAR(7) NOT NULL,
    status lab_ticket_status NOT NULL,  -- Using the ENUM type created earlier
    promised_date DATE,
    employee_id BIGINT NOT NULL,
    notified TEXT,
    invoice_id BIGINT NOT NULL,
    CONSTRAINT fk_lab_employee FOREIGN KEY (employee_id) REFERENCES employee (id_employee),
    CONSTRAINT fk_lab_invoice FOREIGN KEY (invoice_id) REFERENCES invoice (id_invoice)
);
COMMENT ON TABLE lab_ticket IS 'Lab ticket information';


CREATE TABLE schedule (
    id_schedule SERIAL PRIMARY KEY,
    id_employee BIGINT NOT NULL,
    day_of_week VARCHAR(10) NOT NULL,
    start_time TIME WITHOUT TIME ZONE NOT NULL,
    end_time TIME WITHOUT TIME ZONE NOT NULL,
    appointment_duration INTEGER DEFAULT 15,
    lunch_start TIME WITHOUT TIME ZONE,
    lunch_end TIME WITHOUT TIME ZONE,
    CONSTRAINT schedule_id_employee_fkey FOREIGN KEY (id_employee) REFERENCES employee (id_employee)
);
COMMENT ON TABLE schedule IS 'Employee schedule';

--FUNCTION
CREATE OR REPLACE FUNCTION set_lunch_end() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.lunch_start IS NOT NULL THEN
        NEW.lunch_end := NEW.lunch_start + interval '30 minutes';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--TRIGGER
CREATE TRIGGER set_lunch_end_trigger
BEFORE INSERT OR UPDATE ON schedule
FOR EACH ROW
EXECUTE FUNCTION set_lunch_end();



CREATE TABLE appointment (
    id_appointment BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL,
    patient_id BIGINT NOT NULL,
    appointment_date DATE NOT NULL,
    start_time TIME WITHOUT TIME ZONE NOT NULL,
    end_time TIME WITHOUT TIME ZONE NOT NULL,
    status VARCHAR(30) NOT NULL,
    notes TEXT,

    CONSTRAINT fk_id_schedule FOREIGN KEY (schedule_id) REFERENCES schedule (id_schedule),
    CONSTRAINT fk_id_patient FOREIGN KEY (patient_id) REFERENCES patient (id_patient)
);
COMMENT ON TABLE appointment IS 'Appointment details';



CREATE TABLE documents_patient (
    id_documents_patient BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    file_name VARCHAR NOT NULL,
    file_path VARCHAR NOT NULL,
    document_type VARCHAR,
    upload_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patient (id_patient)
);
COMMENT ON TABLE documents_patient IS 'Documents related to patients';



CREATE TABLE insurance_company (
    id_insurance_company SERIAL PRIMARY KEY,
    company_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(15),
    contact_email VARCHAR(100),
    address VARCHAR(100),
    address_line_2 VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(2),
    zip_code VARCHAR(10)
);
COMMENT ON TABLE insurance_company IS 'Insurance company information';


CREATE TABLE insurance_policy (
    id_insurance_policy BIGSERIAL PRIMARY KEY,
    policy_number VARCHAR(50) NOT NULL,
    group_number VARCHAR(50),
    effective_date DATE,
    expiration_date DATE,
    coverage_details TEXT,
    patient_id BIGINT NOT NULL,
    insurance_company_id INTEGER NOT NULL,
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patient (id_patient),
    CONSTRAINT fk_insurance_company FOREIGN KEY (insurance_company_id) REFERENCES insurance_company (id_insurance_company)
);
COMMENT ON TABLE insurance_policy IS 'Insurance policy information';


CREATE TABLE barcode (
    id_barcode SERIAL PRIMARY KEY,
    inventory_id BIGINT NOT NULL,
    barcode_path VARCHAR(255),
    CONSTRAINT fk_inventory FOREIGN KEY (inventory_id) REFERENCES inventory(id_inventory)
);
COMMENT ON TABLE barcode IS 'Link to file img bargode';


--MEDICAL BLOCK

CREATE TABLE aided_ph_distance (
    id_aided_ph_distance BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL
);
COMMENT ON TABLE aided_ph_distance IS 'Comp.Exam -> Preliminary -> Aided PH Distance (Dist)';


CREATE TABLE aided_va_distance (
    id_aided_va_distance BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL,
    ou_20 REAL
);
COMMENT ON TABLE aided_va_distance IS 'Comp.Exam -> Preliminary -> Aided VA Distance (Dist)';


CREATE TABLE aided_va_near (
    id_aided_va_near BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL,
    ou_20 REAL
);
COMMENT ON TABLE aided_va_near IS 'Comp.Exam -> Preliminary -> Aided VA Near';


CREATE TABLE alcohol_use (
    id_alcohol_use BIGSERIAL PRIMARY KEY,
    alcohol_use_name VARCHAR(100)
);
COMMENT ON TABLE alcohol_use IS 'Comp.Exam -> History -> Social History -> Alcohol Use';


CREATE TABLE tobacco_use (
    id_tobacco_use SERIAL PRIMARY KEY,
    tobacco_use_name VARCHAR(255) NOT NULL
);
COMMENT ON TABLE tobacco_use IS 'Comp.Exam -> History -> Social History -> Tobacco Use';



CREATE TABLE referral_letter (
    id_referral_letter BIGSERIAL PRIMARY KEY,
    title_letter VARCHAR,
    intro_letter TEXT,
    tests_letter TEXT,
    issue_letter TEXT
);
COMMENT ON TABLE referral_letter IS 'Comp.Exam -> Referral -> Referral Letter';




CREATE TABLE assessment_eye (
    id_assessment_eye BIGSERIAL PRIMARY KEY,
    impression_assesment_1 TEXT,
    plan_assesment_1 TEXT,
    impression_assesment_2 TEXT,
    plan_assesment_2 TEXT,
    impression_assesment_3 TEXT,
    plan_assesment_3 TEXT,
    impression_assesment_4 TEXT,
    plan_assesment_4 TEXT,
    impression_assesment_5 TEXT,
    plan_assesment_5 TEXT,
    impression_assesment_6 TEXT,
    plan_assesment_6 TEXT,
    impression_assesment_7 TEXT,
    plan_assesment_7 TEXT,
    impression_assesment_8 TEXT,
    plan_assesment_8 TEXT,
    impression_assesment_9 TEXT,
    plan_assesment_9 TEXT,
    impression_assesment_10 TEXT,
    plan_assesment_10 TEXT,
    impression_assesment_11 TEXT,
    plan_assesment_11 TEXT,
    impression_assesment_12 TEXT,
    plan_assesment_12 TEXT,
    impression_assesment_13 TEXT,
    plan_assesment_13 TEXT,
    impression_assesment_14 TEXT,
    plan_assesment_14 TEXT,
    impression_assesment_15 TEXT,
    plan_assesment_15 TEXT,
    impression_assesment_16 TEXT,
    plan_assesment_16 TEXT,
    impression_assesment_17 TEXT,
    plan_assesment_17 TEXT,
    impression_assesment_18 TEXT,
    plan_assesment_18 TEXT,
    impression_assesment_19 TEXT,
    plan_assesment_19 TEXT,
    impression_assesment_20 TEXT,
    plan_assesment_20 TEXT
);
COMMENT ON TABLE assessment_eye IS 'Comp.Exam -> Assessment (full page)';


CREATE TABLE diagnosis (
    id_diagnosis BIGSERIAL PRIMARY KEY,
    first_letter CHAR(1) NOT NULL,
    paragraph VARCHAR(4) NOT NULL,
    subparagraph VARCHAR(4) NOT NULL,
    title_diagnos VARCHAR(255) NOT NULL,
    full_name VARCHAR(266) GENERATED ALWAYS AS (first_letter || paragraph || subparagraph || ' ' || title_diagnos) STORED
);
COMMENT ON TABLE diagnosis IS 'List of diagnoses for Assessment';




CREATE TABLE assessment_diagnosis (
    id_assessment_diagnosis BIGSERIAL PRIMARY KEY,
    assessment_eye_id BIGINT NOT NULL,
    diagnosis_id BIGINT NOT NULL,
    
    CONSTRAINT fk_assessment_eye FOREIGN KEY (assessment_eye_id) REFERENCES assessment_eye (id_assessment_eye),
    CONSTRAINT fk_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES diagnosis (id_diagnosis)
);

COMMENT ON TABLE assessment_diagnosis IS 'Table of keys / 
    Relationship between assessments and diagnoses /
    from many to many*';


CREATE TABLE blood_pressure (
    id_blood_pressure BIGSERIAL PRIMARY KEY,
    sbp VARCHAR,
    dbp VARCHAR
);
COMMENT ON TABLE blood_pressure IS 'Comp.Exam -> Preliminary -> Blood Pressure';


CREATE TABLE auto_keratometer_near_point_test (
    id_auto_keratometer_near_point_test BIGSERIAL PRIMARY KEY,
    od_pw1 VARCHAR,
    os_pw1 VARCHAR,
    od_pw2 VARCHAR,
    os_pw2 VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR
);
COMMENT ON TABLE auto_keratometer_near_point_test IS 'Comp.Exam -> Preliminary -> Auto Keratometer';


CREATE TABLE autorefractor_near_point_test (
    id_autorefractor_near_point_test BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    pd VARCHAR
);
COMMENT ON TABLE autorefractor_near_point_test IS 'Comp.Exam -> Preliminary -> Autorefractor';


CREATE TABLE cup_disc_ratio_posterior (
    id_cup_disc_ratio_posterior BIGSERIAL PRIMARY KEY,
    od_v VARCHAR,
    os_v VARCHAR,
    od_h VARCHAR,
    os_h VARCHAR
);
COMMENT ON TABLE cup_disc_ratio_posterior IS 'Comp.Exam -> Posterior -> Cup / Disc Ratio:';


CREATE TABLE findings_posterior (
    id_findings_posterior BIGSERIAL PRIMARY KEY,
    od_view VARCHAR,
    os_view VARCHAR,
    od_vitreous VARCHAR,
    os_vitreous VARCHAR,
    od_macula VARCHAR,
    os_macula VARCHAR,
    od_background VARCHAR,
    os_background VARCHAR,
    od_vessels VARCHAR,
    os_vessels VARCHAR,
    od_peripheral_fundus VARCHAR,
    os_peripheral_fundus VARCHAR,
    od_optics_nerve VARCHAR,
    os_optics_nerve VARCHAR
);
COMMENT ON TABLE findings_posterior IS 'Comp.Exam -> Posterior -> Findings';


CREATE TABLE pach_external_sle (
    id_pach_external_sle BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR
);
COMMENT ON TABLE pach_external_sle IS 'Comp.Exam -> External / SLE -> PACH';


CREATE TABLE gonioscopy_external_sle (
    id_gonioscopy_external_sle BIGSERIAL PRIMARY KEY,
    od_sup VARCHAR,
    os_sup VARCHAR,
    od_inf VARCHAR,
    os_inf VARCHAR,
    od_nasal VARCHAR,
    os_nasal VARCHAR,
    od_temp VARCHAR,
    os_temp VARCHAR
);
COMMENT ON TABLE gonioscopy_external_sle IS 'Comp.Exam -> External / SLE -> Gonioscopy';


CREATE TABLE findings_external_sle (
    id_findings_external_sle BIGSERIAL PRIMARY KEY,
    externals VARCHAR,
    od_lids_lashes VARCHAR,
    os_lids_lashes VARCHAR,
    od_conjunctiva_sclera VARCHAR,
    os_conjunctiva_sclera VARCHAR,
    od_cornea VARCHAR,
    os_cornea VARCHAR,
    od_tear_film VARCHAR,
    os_tear_film VARCHAR,
    od_anterior_chamber VARCHAR,
    os_anterior_chamber VARCHAR,
    od_iris VARCHAR,
    os_iris VARCHAR,
    od_lens VARCHAR,
    os_lens VARCHAR
);
COMMENT ON TABLE findings_external_sle IS 'Comp.Exam -> External / SLE -> Findings';


CREATE TABLE first_trial (
    id_first_trial BIGSERIAL PRIMARY KEY,
    od_brand VARCHAR,
    os_brand VARCHAR,
    od_b_cur VARCHAR,
    os_b_cur VARCHAR,
    od_dia VARCHAR,
    os_dia VARCHAR,
    od_pwr VARCHAR,
    os_pwr VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_dva_20 VARCHAR,
    os_dva_20 VARCHAR,
    od_nva_20 VARCHAR,
    os_nva_20 VARCHAR,
    trial BOOLEAN DEFAULT false,
    final BOOLEAN DEFAULT false,
    need_to_order BOOLEAN DEFAULT false,
    dispense_from_stock BOOLEAN DEFAULT false,
    front_desk_note TEXT,
    expire_date DATE
);
COMMENT ON TABLE first_trial IS 'Comp.Exam -> CL Fitting -> #1 Trial ';



CREATE TABLE fitting_1 (
    id_fitting_1 BIGSERIAL PRIMARY KEY,
    od_brand TEXT,
    os_brand TEXT,
    od_b_cur TEXT,
    os_b_cur TEXT,
    od_dia TEXT,
    os_dia TEXT,
    od_pwr TEXT,
    os_pwr TEXT,
    od_cyl TEXT,
    os_cyl TEXT,
    od_axis TEXT,
    os_axis TEXT,
    od_add TEXT,
    os_add TEXT,
    od_dva_20 TEXT,
    os_dva_20 TEXT,
    od_nva_20 TEXT,
    os_nva_20 TEXT,
    od_over_refraction TEXT,
    os_over_refraction TEXT,
    od_final BOOLEAN,
    os_final BOOLEAN,
    evaluation TEXT,
    dominant_eye dominant_eye DEFAULT 'n/a'::dominant_eye NOT NULL
);
COMMENT ON TABLE fitting_1 IS 'Comp.Exam -> CL Fitting -> Fitting 1 ';


CREATE TABLE final (
    id_final BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_h_prism VARCHAR,
    od_h_prism_list REAL,
    os_h_prism VARCHAR,
    os_h_prism_list REAL,
    od_v_prism VARCHAR,
    od_v_prism_list REAL,
    os_v_prism VARCHAR,
    os_v_prism_list REAL,
    od_dva_20 REAL,
    os_dva_20 REAL,
    od_nva_20 REAL,
    os_nva_20 REAL,
    ou_dva_20 REAL,
    ou_nva_20 REAL,
    od_pd VARCHAR,
    os_pd VARCHAR,
    ou_pd VARCHAR,
    od_npd VARCHAR,
    os_npd VARCHAR,
    ou_npd VARCHAR,
    expire_date DATE
);
COMMENT ON TABLE final IS 'Comp.Exam -> Refraction -> Final ';


CREATE TABLE manifest (
    id_manifest BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_h_prism VARCHAR,
    od_h_prism_list REAL,
    os_h_prism VARCHAR,
    os_h_prism_list REAL,
    od_v_prism VARCHAR,
    od_v_prism_list REAL,
    os_v_prism VARCHAR,
    os_v_prism_list REAL,
    od_dva_20 REAL,
    os_dva_20 REAL,
    od_nva_20 REAL,
    os_nva_20 REAL,
    ou_dva_20 REAL,
    ou_nva_20 REAL,
    od_final BOOLEAN DEFAULT false,
    os_final BOOLEAN DEFAULT false,
    od_pd VARCHAR,
    os_pd VARCHAR,
    ou_pd VARCHAR,
    od_npd VARCHAR,
    os_npd VARCHAR,
    ou_npd VARCHAR
);
COMMENT ON TABLE manifest IS 'Comp.Exam -> Refraction -> Manifest ';


CREATE TABLE cyclo (
    id_cyclo BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_h_prism VARCHAR,
    od_h_prism_list REAL,
    os_h_prism VARCHAR,
    os_h_prism_list REAL,
    od_v_prism VARCHAR,
    od_v_prism_list REAL,
    os_v_prism VARCHAR,
    os_v_prism_list REAL,
    od_dva_20 REAL,
    os_dva_20 REAL,
    od_nva_20 REAL,
    os_nva_20 REAL,
    ou_dva_20 REAL,
    ou_nva_20 REAL,
    od_final BOOLEAN DEFAULT false,
    os_final BOOLEAN DEFAULT false,
    od_pd VARCHAR,
    os_pd VARCHAR,
    ou_pd VARCHAR,
    od_npd VARCHAR,
    os_npd VARCHAR,
    ou_npd VARCHAR
);
COMMENT ON TABLE cyclo IS 'Comp.Exam -> Refraction -> Cyclo ';


CREATE TABLE retinoscopy (
    retinoscopy_id BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_h_prism VARCHAR,
    od_h_prism_list REAL,
    os_h_prism VARCHAR,
    os_h_prism_list REAL,
    od_v_prism VARCHAR,
    od_v_prism_list REAL,
    os_v_prism VARCHAR,
    os_v_prism_list REAL,
    od_dva_20 REAL,
    os_dva_20 REAL,
    od_nva_20 REAL,
    os_nva_20 REAL,
    ou_dva_20 REAL,
    ou_nva_20 REAL,
    od_final BOOLEAN DEFAULT false,
    os_final BOOLEAN DEFAULT false
);
COMMENT ON TABLE retinoscopy IS 'Comp.Exam -> Refraction -> Retinoscopy ';


CREATE TABLE auto_kerato_refraction (
    id_auto_kerato_refraction BIGSERIAL PRIMARY KEY,
    od_pw1 VARCHAR,
    os_pw1 VARCHAR,
    od_pw2 VARCHAR,
    os_pw2 VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR
);
COMMENT ON TABLE auto_kerato_refraction IS 'Comp.Exam -> Refraction -> Auto Kerato (maybe autoinserts)';


CREATE TABLE autorefractor_refraction (
    id_autorefractor_refraction BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR
);
COMMENT ON TABLE autorefractor_refraction IS 'Comp.Exam -> Refraction -> Auto Refractor (maybe autoinserts)';


CREATE TABLE entrance_rx_refraction (
    id_entrance_rx_refraction BIGSERIAL PRIMARY KEY,
    od_sph VARCHAR,
    os_sph VARCHAR,
    od_cyl VARCHAR,
    os_cyl VARCHAR,
    od_axis VARCHAR,
    os_axis VARCHAR,
    od_add VARCHAR,
    os_add VARCHAR,
    od_h_prism VARCHAR,
    os_h_prism VARCHAR,
    od_v_prism VARCHAR,
    os_v_prism VARCHAR
);
COMMENT ON TABLE entrance_rx_refraction IS 'Comp.Exam -> Refraction -> Entrance Rx (maybe autoinserts)';


CREATE TABLE near_point_testing (
    id_near_point_testing SERIAL PRIMARY KEY,
    autorefractor_near_point_test_id BIGSERIAL REFERENCES autorefractor_near_point_tests(id_autorefractor_near_point_test),
    auto_keratometer_near_point_test_id BIGSERIAL REFERENCES auto_keratometer_near_point_tests(id_auto_keratometer_near_point_test),
    blood_pressure_id INT REFERENCES blood_pressure_measurements(id_blood_pressure)
);
COMMENT ON TABLE near_point_testing IS 'Comp.Exam -> Preliminary -> Near Point Testing';


CREATE TABLE near_von_graefe_phoria (
    id_near_von_graefe_phoria BIGSERIAL PRIMARY KEY,
    h_near_vgp VARCHAR,
    v_near_vgp VARCHAR
);
COMMENT ON TABLE near_von_graefe_phoria IS 'Comp.Exam -> Preliminary -> Near Von Graefe Phoria';


CREATE TABLE distance_von_graefe_phoria (
    id_distance_von_graefe_phoria BIGSERIAL PRIMARY KEY,
    h_dist_vgp VARCHAR,
    v_dist_vgp VARCHAR
);
COMMENT ON TABLE distance_von_graefe_phoria IS 'Comp.Exam -> Preliminary -> Distance Von Graefe Phoria';


CREATE TABLE amsler_grid (
    id_amsler_grid BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR
);
COMMENT ON TABLE amsler_grid IS 'Comp.Exam -> Preliminary -> Amsler Grid';


CREATE TABLE bruckner (
    id_bruckner BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR,
    good_reflex BOOLEAN
);
COMMENT ON TABLE bruckner IS 'Comp.Exam -> Preliminary -> Bruckner';


CREATE TABLE color_vision (
    id_color_vision BIGSERIAL PRIMARY KEY,
    od1 VARCHAR,
    od2 VARCHAR,
    os1 VARCHAR,
    os2 VARCHAR
);
COMMENT ON TABLE color_vision IS 'Comp.Exam -> Preliminary -> Color Vision';


CREATE TABLE pupils (
    id_pupils BIGSERIAL PRIMARY KEY,
    od_mm_dim REAL,
    od_mm_bright REAL,
    os_mm_dim REAL,
    os_mm_bright REAL,
    perrla BOOLEAN DEFAULT false,
    perrla_text VARCHAR,
    apd BOOLEAN DEFAULT false,
    apd_text VARCHAR
);
COMMENT ON TABLE pupils IS 'Comp.Exam -> Preliminary -> Pupils';


CREATE TABLE motility (
    id_motility BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR
);
COMMENT ON TABLE motility IS 'Comp.Exam -> Preliminary -> Motility';


CREATE TABLE automated (
    id_automated BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR
);
COMMENT ON TABLE automated IS 'Comp.Exam -> Preliminary -> Automated';


CREATE TABLE confrontation (
    id_confrontation BIGSERIAL PRIMARY KEY,
    od VARCHAR,
    os VARCHAR
);
COMMENT ON TABLE confrontation IS 'Comp.Exam -> Preliminary -> Confrontation';


CREATE TABLE unaided_va_near (
    id_unaided_va_near BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL,
    ou_20 REAL
);
COMMENT ON TABLE unaided_va_near IS 'Comp.Exam -> Preliminary -> Unaided VA Near';


CREATE TABLE unaided_ph_distance (
    id_unaided_ph_distance BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL,
);
COMMENT ON TABLE unaided_ph_distance IS 'Comp.Exam -> Preliminary -> Unaided PH Dist';


CREATE TABLE unaided_va_distance (
    id_unaided_va_distance BIGSERIAL PRIMARY KEY,
    od_20 REAL,
    os_20 REAL,
    ou_20 REAL
);
COMMENT ON TABLE unaided_va_distance IS 'Comp.Exam -> Preliminary -> Unaided VA Dist';


CREATE TABLE entrance_cont_lens (
    id_entrance_cont_lens BIGSERIAL PRIMARY KEY,
    data DATE,
    od_brand VARCHAR(100),
    os_brand VARCHAR(100),
    od_base_c VARCHAR(50),
    os_base_c VARCHAR(50),
    od_dia VARCHAR(50),
    os_dia VARCHAR(50),
    od_pwr VARCHAR(50),
    os_pwr VARCHAR(50),
    od_cyl VARCHAR(50),
    os_cyl VARCHAR(50),
    od_axis VARCHAR(50),
    os_axis VARCHAR(50),
    od_add VARCHAR(50),
    os_add VARCHAR(50)
);
COMMENT ON TABLE entrance_cont_lens IS 'Comp.Exam -> Preliminary -> Entrance CL';


CREATE TABLE entrance_glaucoma (
    id_entrance_glaucoma BIGSERIAL PRIMARY KEY,
    data DATE,
    od_sph VARCHAR(10),
    os_sph VARCHAR(10),
    od_cyl VARCHAR(10),
    os_cyl VARCHAR(10),
    od_axis VARCHAR(10),
    os_axis VARCHAR(10),
    od_add VARCHAR(10),
    os_add VARCHAR(10),
    od_h_prism REAL,
    os_h_prism REAL,
    od_v_prism REAL,
    os_v_prism REAL,
    note TEXT
);
COMMENT ON TABLE entrance_glaucoma IS 'Comp.Exam -> Preliminary -> Entrance GL';


CREATE TABLE eye_exam_type (
    id_eye_exam_type BIGSERIAL PRIMARY KEY,
    exam_type_name TEXT NOT NULL
);
COMMENT ON TABLE eye_exam_type IS 'Dr. Desk -> Appoiments -> Patient -> Exam Type';


CREATE TABLE tobacco_use (
    id_tobacco_use INT PRIMARY KEY,
    tobacco_use_name VARCHAR(100)
);
COMMENT ON TABLE tobacco_use IS 'Comp.Exam -> History -> Social History -> Tobacco Use';


CREATE TABLE medical_record (
    id_medical_record BIGSERIAL PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    occupation VARCHAR(255),
    race_id BIGINT,
    ethnicity_id BIGINT,
    insurance_id BIGINT,
    persisting_patient_note VARCHAR(255),
    CONSTRAINT fk_patient FOREIGN KEY (patient_id) REFERENCES patient (id_patient),
    CONSTRAINT fk_race FOREIGN KEY (race_id) REFERENCES race (id_race),
    CONSTRAINT fk_ethnicity FOREIGN KEY (ethnicity_id) REFERENCES ethnicity (id_ethnicity),
    CONSTRAINT fk_insurance FOREIGN KEY (insurance_id) REFERENCES insurance (id_insurance)
);
COMMENT ON TABLE medical_record IS 'Comp.Exam -> History  -> Persisting Patient Note (General Dr. note)';


CREATE TABLE ocular_history (
    id_ocular_history BIGSERIAL PRIMARY KEY, 
    prev_eye_history TEXT,  
    last_exam TEXT,  
    cl_current_wear TEXT, 
    scl TEXT,  
    rgp TEXT,  
    other TEXT,  
    modality TEXT[],  
    modality_other TEXT  
);
COMMENT ON TABLE ocular_history IS 'Comp.Exam -> History -> Ocular History';



CREATE TABLE ros_medical_history (
    id_ros_medical_history BIGSERIAL PRIMARY KEY,
    eyes BOOLEAN NOT NULL,
    eyes_text TEXT,
    general BOOLEAN NOT NULL,
    general_text TEXT,
    genitourinary BOOLEAN NOT NULL,
    genitourinary_text TEXT,
    gastrointenstinal BOOLEAN NOT NULL,
    gastrointenstinal_text TEXT,
    psychiatric BOOLEAN NOT NULL,
    psychiatric_text TEXT,
    endocrine BOOLEAN NOT NULL,
    endocrine_text TEXT,
    ear_nose_throat BOOLEAN NOT NULL,
    ear_nose_throat_text TEXT,
    allergy_immun BOOLEAN NOT NULL,
    allergy_immun_text TEXT,
    integumentary BOOLEAN NOT NULL,
    integumentary_text TEXT,
    cardiovascular BOOLEAN NOT NULL,
    cardiovascular_text TEXT,
    musculoskeletal BOOLEAN NOT NULL,
    musculoskeletal_text TEXT,
    respiratory BOOLEAN NOT NULL,
    respiratory_text TEXT,
    hematological_lymp BOOLEAN NOT NULL,
    hematological_lymp_text TEXT,
    neurological BOOLEAN NOT NULL,
    neurological_text TEXT
);
COMMENT ON TABLE ros_medical_history IS 'Comp.Exam -> History -> ROS / Medical History';


CREATE TABLE family_history (
    id_family_history BIGSERIAL PRIMARY KEY,
    cataract BOOLEAN NOT NULL DEFAULT FALSE,
    glaucoma BOOLEAN NOT NULL DEFAULT FALSE,
    macular_degeneration BOOLEAN NOT NULL DEFAULT FALSE,
    hyperlension BOOLEAN NOT NULL DEFAULT FALSE,
    diabetes BOOLEAN NOT NULL DEFAULT FALSE,
    cancer BOOLEAN NOT NULL DEFAULT FALSE,
    heart_disease BOOLEAN NOT NULL DEFAULT FALSE,
    note TEXT
);
COMMENT ON TABLE family_history IS 'Comp.Exam -> History -> Family History';


CREATE TABLE social_history (
    id_social_history BIGSERIAL PRIMARY KEY,
    alcohol_use_id BIGINT,
    tobacco_use_id BIGINT,
    alert_to_time BOOLEAN,
    alert_to_place BOOLEAN,
    aware_of_self BOOLEAN,
    sits_upright BOOLEAN,
    CONSTRAINT fk_alcohol_use FOREIGN KEY (alcohol_use_id) REFERENCES alcohol_use(id_alcohol_use),
    CONSTRAINT fk_tobacco_use FOREIGN KEY (tobacco_use_id) REFERENCES tobacco_use(id_tobacco_use)
);
COMMENT ON TABLE social_history IS 'Comp.Exam -> History -> Social history';


CREATE TABLE chief_complaint_hpi_eye (
    id_chief_complaint_hpi_eye BIGSERIAL PRIMARY KEY,
    note_chief_complaint VARCHAR,
    location VARCHAR,
    quality VARCHAR,
    severity VARCHAR,
    duration VARCHAR,
    timing VARCHAR,
    context VARCHAR,
    factors VARCHAR,
    symptoms VARCHAR
);
COMMENT ON TABLE chief_complaint_hpi_eye IS 'Comp.Exam -> CC /HPI -> Chief Complaint + HPI';



CREATE TABLE secondary_complaint_hpi_eye (
    id_secondary_complaint_hpi_eye BIGSERIAL PRIMARY KEY,
    note_secondary_complaint VARCHAR,
    location VARCHAR,
    quality VARCHAR,
    severity VARCHAR,
    duration VARCHAR,
    timing VARCHAR,
    context VARCHAR,
    factors VARCHAR,
    symptoms VARCHAR
);
COMMENT ON TABLE secondary_complaint_hpi_eye IS 'Comp.Exam -> CC /HPI -> Secondary Complaint + HPI';


CREATE TABLE preliminary_eye_exam (
    id_preliminary_eye_exam BIGSERIAL PRIMARY KEY,
    entrance_glaucoma_id BIGINT,
    entrance_cont_lens_id BIGINT,
    unaided_va_distance_id BIGINT,
    unaided_ph_distance_id BIGINT,
    unaided_va_near_id BIGINT,
    aided_va_distance_id BIGINT,
    aided_ph_distance_id BIGINT,
    aided_va_near_id BIGINT,
    aided_by_glasses BOOLEAN DEFAULT false,
    aided_by_contacts BOOLEAN DEFAULT false,
    confrontation_id BIGINT,
    automated_id BIGINT,
    motility_id BIGINT,
    pupils_id BIGINT,
    color_vision_id BIGINT,
    distance_cover_test VARCHAR,
    near_cover_test VARCHAR,
    npc_test VARCHAR,
    bruckner_id BIGINT,
    amsler_grid_id BIGINT,
    worth_4_dot VARCHAR,
    stereo_vision VARCHAR,
    fixation_disparity VARCHAR,
    distance_von_graefe_phoria_id BIGINT,
    near_von_graefe_phoria_id BIGINT,
    near_point_testing_id BIGINT,
    iris_color iris_color,
    note TEXT,
    CONSTRAINT fk_preliminary_eye_exam_entrance_glaucoma_id FOREIGN KEY (entrance_glaucoma_id) REFERENCES entrance_glaucoma(id_entrance_glaucoma),
    CONSTRAINT fk_preliminary_eye_exam_entrance_cont_lens_id FOREIGN KEY (entrance_cont_lens_id) REFERENCES entrance_cont_lens(id_entrance_cont_lens),
    CONSTRAINT fk_preliminary_eye_exam_unaided_va_distance_id FOREIGN KEY (unaided_va_distance_id) REFERENCES unaided_va_distance(id_unaided_va_distance),
    CONSTRAINT fk_preliminary_eye_exam_unaided_ph_distance_id FOREIGN KEY (unaided_ph_distance_id) REFERENCES unaided_ph_distance(id_unaided_ph_distance),
    CONSTRAINT fk_preliminary_eye_exam_unaided_va_near_id FOREIGN KEY (unaided_va_near_id) REFERENCES unaided_va_near(id_unaided_va_near),
    CONSTRAINT fk_preliminary_eye_exam_aided_va_distance_id FOREIGN KEY (aided_va_distance_id) REFERENCES aided_va_distance(id_aided_va_distance),
    CONSTRAINT fk_preliminary_eye_exam_aided_ph_distance_id FOREIGN KEY (aided_ph_distance_id) REFERENCES aided_ph_distance(id_aided_ph_distance),
    CONSTRAINT fk_preliminary_eye_exam_aided_va_near_id FOREIGN KEY (aided_va_near_id) REFERENCES aided_va_near(id_aided_va_near),
    CONSTRAINT fk_preliminary_eye_exam_confrontation_id FOREIGN KEY (confrontation_id) REFERENCES confrontation(id_confrontation),
    CONSTRAINT fk_preliminary_eye_exam_automated_id FOREIGN KEY (automated_id) REFERENCES automated(id_automated),
    CONSTRAINT fk_preliminary_eye_exam_motility_id FOREIGN KEY (motility_id) REFERENCES motility(id_motility),
    CONSTRAINT fk_preliminary_eye_exam_pupils_id FOREIGN KEY (pupils_id) REFERENCES pupils(id_pupils),
    CONSTRAINT fk_preliminary_eye_exam_color_vision_id FOREIGN KEY (color_vision_id) REFERENCES color_vision(id_color_vision),
    CONSTRAINT fk_preliminary_eye_exam_bruckner_id FOREIGN KEY (bruckner_id) REFERENCES bruckner(id_bruckner),
    CONSTRAINT fk_preliminary_eye_exam_amsler_grid_id FOREIGN KEY (amsler_grid_id) REFERENCES amsler_grid(id_amsler_grid),
    CONSTRAINT fk_preliminary_eye_exam_distance_von_graefe_phoria_id FOREIGN KEY (distance_von_graefe_phoria_id) REFERENCES distance_von_graefe_phoria(id_distance_von_graefe_phoria),
    CONSTRAINT fk_preliminary_eye_exam_near_von_graefe_phoria_id FOREIGN KEY (near_von_graefe_phoria_id) REFERENCES near_von_graefe_phoria(id_near_von_graefe_phoria),
    CONSTRAINT fk_preliminary_eye_exam_near_point_testing_id FOREIGN KEY (near_point_testing_id) REFERENCES near_point_testing(id_near_point_testing)
);
COMMENT ON TABLE preliminary_eye_exam IS 'Comp.Exam -> Preliminary';


CREATE TABLE refraction_eye (
    id_refraction_eye BIGSERIAL PRIMARY KEY,
    entrance_rx_refraction_id BIGINT,
    autorefractor_refraction_id BIGINT,
    auto_kerato_refraction_id BIGINT,
    retinoscopy_id BIGINT,
    cyclo_id BIGINT,
    manifest_id BIGINT,
    final_id BIGINT,
    dr_note TEXT,
    CONSTRAINT fk_entrance_rx_refraction FOREIGN KEY (entrance_rx_refraction_id) REFERENCES entrance_rx_refraction (id_entrance_rx_refraction),
    CONSTRAINT fk_autorefractor_refraction FOREIGN KEY (autorefractor_refraction_id) REFERENCES autorefractor_refraction (id_autorefractor_refraction),
    CONSTRAINT fk_auto_kerato_refraction FOREIGN KEY (auto_kerato_refraction_id) REFERENCES auto_kerato_refraction (id_auto_kerato_refraction),
    CONSTRAINT fk_retinoscopy FOREIGN KEY (retinoscopy_id) REFERENCES retinoscopy (id_retinoscopy),
    CONSTRAINT fk_cyclo FOREIGN KEY (cyclo_id) REFERENCES cyclo (id_cyclo),
    CONSTRAINT fk_manifest FOREIGN KEY (manifest_id) REFERENCES manifest (id_manifest),
    CONSTRAINT fk_final FOREIGN KEY (final_id) REFERENCES final (id_final)
);
COMMENT ON TABLE refraction_eye IS 'Comp.Exam -> Refraction';


CREATE TABLE cl_fitting (
    id_cl_fitting BIGSERIAL PRIMARY KEY,
    fitting_1_id BIGINT,
    first_trial_id BIGINT,
    dr_note TEXT,
    CONSTRAINT fk_fitting_1 FOREIGN KEY (fitting_1_id) REFERENCES fitting_1 (id_fitting_1),
    CONSTRAINT fk_first_trial FOREIGN KEY (first_trial_id) REFERENCES first_trial (id_first_trial)
);
COMMENT ON TABLE cl_fitting IS 'Comp.Exam -> CL Fitting';


CREATE TABLE external_sle_eye (
    id_external_sle_eye BIGSERIAL PRIMARY KEY,
    findings_external_sle_id BIGINT,
    add_drawind VARCHAR, -- for link image downloaded
    gonioscopy_external_sle_id BIGINT,
    pach_external_sle_id BIGINT,
    od_angle_estimation angle_estimation_eye DEFAULT 'n/a',
    os_angle_estimation angle_estimation_eye DEFAULT 'n/a',
    method_tonometry_eye tonometry_eye,
    method_tonometry_eye_other VARCHAR(100),
    date_tonometry_eye DATE,
    time_tonometry_eye TIME,
    od_tonometry_eye VARCHAR(6),
    os_tonometry_eye VARCHAR(6),
    iop_drops_fluress BOOLEAN DEFAULT false,
    iop_drops_proparacaine BOOLEAN DEFAULT false,
    iop_drops_fluoro_strip BOOLEAN DEFAULT false,
    note TEXT,
    CONSTRAINT fk_findings_external_sle_id FOREIGN KEY (findings_external_sle_id) REFERENCES findings_external_sle (id_findings_external_sle),
    CONSTRAINT fk_gonioscopy_external_sle_id FOREIGN KEY (gonioscopy_external_sle_id) REFERENCES gonioscopy_external_sle (id_gonioscopy_external_sle),
    CONSTRAINT fk_pach_external_sle_id FOREIGN KEY (pach_external_sle_id) REFERENCES pach_external_sle (id_pach_external_sle)
);
COMMENT ON TABLE external_sle_eye IS 'Comp.Exam -> External / SLE';


CREATE TABLE posterior_eye (
    id_posterior_eye BIGSERIAL PRIMARY KEY,
    info_bio BOOLEAN DEFAULT false,
    info_90d BOOLEAN DEFAULT false,
    info_optomap BOOLEAN DEFAULT false,
    info_rha BOOLEAN DEFAULT false,
    info_other TEXT,
    medication_patient_educated BOOLEAN DEFAULT false,
    medication_ilation_declined BOOLEAN DEFAULT false,
    medication_paremyd BOOLEAN DEFAULT false,
    medication_atropine BOOLEAN DEFAULT false,
    medication_tropicamide BOOLEAN DEFAULT false,
    medication_cyclopentolate BOOLEAN DEFAULT false,
    medication_homatropine BOOLEAN DEFAULT false,
    medication_phenylephrine BOOLEAN DEFAULT false,
    medication_rha BOOLEAN DEFAULT false,
    time_dilated TIME,
    other VARCHAR(100),
    findings_posterior_id BIGINT,
    cup_disc_ratio_posterior_id BIGINT,
    note TEXT,
    CONSTRAINT fk_findings_posterior_id FOREIGN KEY (findings_posterior_id) REFERENCES findings_posterior (id_findings_posterior),
    CONSTRAINT fk_cup_disc_ratio_posterior_id FOREIGN KEY (cup_disc_ratio_posterior_id) REFERENCES cup_disc_ratio_posterior (id_cup_disc_ratio_posterior)
);
COMMENT ON TABLE posterior_eye IS 'Comp.Exam -> Posterior';


CREATE TABLE eye_exam (
    id_eye_exam BIGSERIAL PRIMARY KEY,
    eye_exam_date TIMESTAMPTZ NOT NULL,
    medical_record_id BIGINT UNIQUE,
    employee_id BIGINT NOT NULL,
    eye_exam_type_id BIGINT NOT NULL,
    ocular_history_id BIGINT UNIQUE,
    primary_care_physician VARCHAR(100),
    other_1_primary_care_physician VARCHAR(100),
    other_2_primary_care_physician VARCHAR(100),
    medication TEXT NOT NULL DEFAULT 'No Medications',
    allergy TEXT NOT NULL DEFAULT 'No Known Allergies',
    ros_medical_history_id BIGINT UNIQUE,
    family_history_id BIGINT UNIQUE,
    social_history_id BIGINT UNIQUE,
    chief_complaint_hpi_eye_id BIGINT UNIQUE,
    chief_complaint_note VARCHAR,
    secondary_complaint_hpi_eye_id BIGINT UNIQUE,
    preliminary_eye_exam_id BIGINT UNIQUE,
    refraction_eye_id BIGINT UNIQUE,
    cl_fitting_id BIGINT UNIQUE,
    external_sle_eye_id BIGINT UNIQUE,
    posterior_eye_id BIGINT UNIQUE,
    assessment_eye_id BIGINT UNIQUE,
    referral_letter_id BIGINT UNIQUE,
    CONSTRAINT fk_medical_record_id FOREIGN KEY (medical_record_id) REFERENCES medical_record (id_medical_record),
    CONSTRAINT fk_employee_id FOREIGN KEY (employee_id) REFERENCES employee (id_employee),
    CONSTRAINT fk_eye_exam_type_id FOREIGN KEY (eye_exam_type_id) REFERENCES eye_exam_type (id_eye_exam_type),
    CONSTRAINT fk_ocular_history_id FOREIGN KEY (ocular_history_id) REFERENCES ocular_history (id_ocular_history),
    CONSTRAINT fk_ros_medical_history_id FOREIGN KEY (ros_medical_history_id) REFERENCES ros_medical_history (id_ros_medical_history),
    CONSTRAINT fk_family_history_id FOREIGN KEY (family_history_id) REFERENCES family_history (id_family_history),
    CONSTRAINT fk_social_history_id FOREIGN KEY (social_history_id) REFERENCES social_history (id_social_history),
    CONSTRAINT fk_chief_complaint_hpi_eye_id FOREIGN KEY (chief_complaint_hpi_eye_id) REFERENCES chief_complaint_hpi_eye (id_chief_complaint_hpi_eye),
    CONSTRAINT fk_secondary_complaint_hpi_eye_id FOREIGN KEY (secondary_complaint_hpi_eye_id) REFERENCES secondary_complaint_hpi_eye (id_secondary_complaint_hpi_eye),
    CONSTRAINT fk_preliminary_eye_exam_id FOREIGN KEY (preliminary_eye_exam_id) REFERENCES preliminary_eye_exam (id_preliminary_eye_exam),
    CONSTRAINT fk_refraction_eye_id FOREIGN KEY (refraction_eye_id) REFERENCES refraction_eye (id_refraction_eye),
    CONSTRAINT fk_cl_fitting_id FOREIGN KEY (cl_fitting_id) REFERENCES cl_fitting (id_cl_fitting),
    CONSTRAINT fk_external_sle_eye_id FOREIGN KEY (external_sle_eye_id) REFERENCES external_sle_eye (id_external_sle_eye),
    CONSTRAINT fk_posterior_eye_id FOREIGN KEY (posterior_eye_id) REFERENCES posterior_eye (id_posterior_eye),
    CONSTRAINT fk_assessment_eye_id FOREIGN KEY (assessment_eye_id) REFERENCES assessment_eye (id_assessment_eye),
    CONSTRAINT fk_referral_letter_id FOREIGN KEY (referral_letter_id) REFERENCES referral_letter (id_referral_letter)
);
COMMENT ON TABLE eye_exam IS 'General Eye Exam ';
