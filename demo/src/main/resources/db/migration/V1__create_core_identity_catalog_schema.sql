CREATE TABLE ce_branch (
    id CHAR(36) NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    address VARCHAR(255) NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(150) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    timezone VARCHAR(50) NOT NULL DEFAULT 'Asia/Ho_Chi_Minh',
    supports_pickup BOOLEAN NOT NULL DEFAULT TRUE,
    supports_delivery BOOLEAN NOT NULL DEFAULT FALSE,
    average_preparation_minutes INT NOT NULL DEFAULT 15,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ce_branch PRIMARY KEY (id),
    CONSTRAINT uk_ce_branch_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ce_branch_status ON ce_branch (status);
CREATE INDEX idx_ce_branch_location ON ce_branch (latitude, longitude);

CREATE TABLE ia_account (
    id CHAR(36) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    auth_provider VARCHAR(30) NOT NULL DEFAULT 'LOCAL',
    provider_id VARCHAR(150) NULL,
    has_local_password BOOLEAN NOT NULL DEFAULT TRUE,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NULL,
    phone VARCHAR(20) NULL,
    avatar_url VARCHAR(500) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    last_login_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_account PRIMARY KEY (id),
    CONSTRAINT uk_ia_account_username UNIQUE (username),
    CONSTRAINT uk_ia_account_email UNIQUE (email),
    CONSTRAINT uk_ia_account_phone UNIQUE (phone),
    CONSTRAINT uk_ia_account_provider UNIQUE (auth_provider, provider_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ia_account_auth_provider ON ia_account (auth_provider);
CREATE INDEX idx_ia_account_status ON ia_account (status);

CREATE TABLE ia_role (
    id CHAR(36) NOT NULL,
    code VARCHAR(80) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255) NULL,
    role_type VARCHAR(30) NOT NULL DEFAULT 'SYSTEM',
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_role PRIMARY KEY (id),
    CONSTRAINT uk_ia_role_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ia_role_status ON ia_role (status);

CREATE TABLE ia_permission (
    id CHAR(36) NOT NULL,
    code VARCHAR(120) NOT NULL,
    name VARCHAR(150) NOT NULL,
    module VARCHAR(80) NOT NULL,
    description VARCHAR(255) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_permission PRIMARY KEY (id),
    CONSTRAINT uk_ia_permission_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ia_permission_module_status ON ia_permission (module, status);

CREATE TABLE ia_role_permission (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    role_id CHAR(36) NOT NULL,
    permission_id CHAR(36) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_role_permission PRIMARY KEY (id),
    CONSTRAINT uk_ia_role_permission_role_permission UNIQUE (role_id, permission_id),
    CONSTRAINT fk_ia_role_permission_role FOREIGN KEY (role_id) REFERENCES ia_role (id) ON DELETE CASCADE,
    CONSTRAINT fk_ia_role_permission_permission FOREIGN KEY (permission_id) REFERENCES ia_permission (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ia_role_permission_role ON ia_role_permission (role_id);
CREATE INDEX idx_ia_role_permission_permission ON ia_role_permission (permission_id);

CREATE TABLE ia_scope (
    id CHAR(36) NOT NULL,
    scope_type VARCHAR(30) NOT NULL,
    branch_id CHAR(36) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_scope PRIMARY KEY (id),
    CONSTRAINT fk_ia_scope_branch FOREIGN KEY (branch_id) REFERENCES ce_branch (id) ON DELETE CASCADE,
    CONSTRAINT chk_ia_scope_branch_required CHECK (
        (scope_type = 'SYSTEM' AND branch_id IS NULL)
        OR (scope_type = 'BRANCH' AND branch_id IS NOT NULL)
    )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE UNIQUE INDEX uk_ia_scope_scope_branch ON ia_scope (scope_type, (COALESCE(branch_id, '')));
CREATE INDEX idx_ia_scope_scope_status ON ia_scope (scope_type, status);
CREATE INDEX idx_ia_scope_branch_status ON ia_scope (branch_id, status);

CREATE TABLE ia_account_role_assignment (
    id CHAR(36) NOT NULL,
    account_id CHAR(36) NOT NULL,
    role_id CHAR(36) NOT NULL,
    scope_id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    assigned_by CHAR(36) NULL,
    expires_at DATETIME NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_ia_account_role_assignment PRIMARY KEY (id),
    CONSTRAINT uk_ia_account_role_assignment_account_role_scope UNIQUE (account_id, role_id, scope_id),
    CONSTRAINT fk_ia_account_role_assignment_account FOREIGN KEY (account_id) REFERENCES ia_account (id) ON DELETE CASCADE,
    CONSTRAINT fk_ia_account_role_assignment_role FOREIGN KEY (role_id) REFERENCES ia_role (id) ON DELETE RESTRICT,
    CONSTRAINT fk_ia_account_role_assignment_scope FOREIGN KEY (scope_id) REFERENCES ia_scope (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_ia_account_role_assignment_account_status ON ia_account_role_assignment (account_id, status);
CREATE INDEX idx_ia_account_role_assignment_role_scope ON ia_account_role_assignment (role_id, scope_id);

CREATE TABLE cu_customer_profile (
    id CHAR(36) NOT NULL,
    account_id CHAR(36) NOT NULL,
    customer_code VARCHAR(50) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(150) NULL,
    date_of_birth DATE NULL,
    gender VARCHAR(20) NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_cu_customer_profile PRIMARY KEY (id),
    CONSTRAINT uk_cu_customer_profile_account UNIQUE (account_id),
    CONSTRAINT uk_cu_customer_profile_customer_code UNIQUE (customer_code),
    CONSTRAINT fk_cu_customer_profile_account FOREIGN KEY (account_id) REFERENCES ia_account (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_cu_customer_profile_phone ON cu_customer_profile (phone);
CREATE INDEX idx_cu_customer_profile_email ON cu_customer_profile (email);
CREATE INDEX idx_cu_customer_profile_status ON cu_customer_profile (status);

CREATE TABLE cu_customer_address (
    id CHAR(36) NOT NULL,
    customer_id CHAR(36) NOT NULL,
    receiver_name VARCHAR(150) NOT NULL,
    receiver_phone VARCHAR(20) NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    ward VARCHAR(100) NULL,
    district VARCHAR(100) NULL,
    city VARCHAR(100) NULL,
    latitude DECIMAL(10,7) NULL,
    longitude DECIMAL(10,7) NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_cu_customer_address PRIMARY KEY (id),
    CONSTRAINT fk_cu_customer_address_customer FOREIGN KEY (customer_id) REFERENCES cu_customer_profile (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_cu_customer_address_customer_status ON cu_customer_address (customer_id, status);
CREATE INDEX idx_cu_customer_address_customer_default ON cu_customer_address (customer_id, is_default);

CREATE TABLE pr_category (
    id CHAR(36) NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(255) NULL,
    image_url VARCHAR(500) NULL,
    display_order INT NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_pr_category PRIMARY KEY (id),
    CONSTRAINT uk_pr_category_code UNIQUE (code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_pr_category_status_display_order ON pr_category (status, display_order);

CREATE TABLE pr_product (
    id CHAR(36) NOT NULL,
    category_id CHAR(36) NOT NULL,
    code VARCHAR(50) NOT NULL,
    name VARCHAR(150) NOT NULL,
    description VARCHAR(500) NULL,
    image_url VARCHAR(500) NULL,
    base_price DECIMAL(12,2) NOT NULL,
    preparation_minutes INT NOT NULL DEFAULT 10,
    is_featured BOOLEAN NOT NULL DEFAULT FALSE,
    is_best_seller BOOLEAN NOT NULL DEFAULT FALSE,
    available_ice_levels VARCHAR(50) NOT NULL DEFAULT '0,30,50,70,100',
    available_sugar_levels VARCHAR(50) NOT NULL DEFAULT '0,30,50,70,100',
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_pr_product PRIMARY KEY (id),
    CONSTRAINT uk_pr_product_code UNIQUE (code),
    CONSTRAINT fk_pr_product_category FOREIGN KEY (category_id) REFERENCES pr_category (id) ON DELETE RESTRICT,
    CONSTRAINT chk_pr_product_base_price CHECK (base_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_pr_product_category_status ON pr_product (category_id, status);
CREATE INDEX idx_pr_product_status ON pr_product (status);
CREATE INDEX idx_pr_product_featured_status ON pr_product (is_featured, status);

CREATE TABLE pr_product_variant (
    id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    variant_code VARCHAR(50) NOT NULL,
    variant_name VARCHAR(100) NOT NULL,
    size_label VARCHAR(30) NOT NULL,
    price_delta DECIMAL(12,2) NOT NULL DEFAULT 0,
    display_order INT NOT NULL DEFAULT 0,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_pr_product_variant PRIMARY KEY (id),
    CONSTRAINT uk_pr_product_variant_product_code UNIQUE (product_id, variant_code),
    CONSTRAINT fk_pr_product_variant_product FOREIGN KEY (product_id) REFERENCES pr_product (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_pr_product_variant_product_status_display_order ON pr_product_variant (product_id, status, display_order);

CREATE TABLE mn_branch_product_availability (
    id CHAR(36) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
    branch_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    is_available BOOLEAN NOT NULL DEFAULT TRUE,
    sale_price DECIMAL(12,2) NULL,
    sold_out_reason VARCHAR(255) NULL,
    available_from DATETIME NULL,
    available_to DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by CHAR(36) NULL,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    updated_by CHAR(36) NULL,
    CONSTRAINT pk_mn_branch_product_availability PRIMARY KEY (id),
    CONSTRAINT uk_mn_branch_product_availability_branch_product UNIQUE (branch_id, product_id),
    CONSTRAINT fk_mn_branch_product_availability_branch FOREIGN KEY (branch_id) REFERENCES ce_branch (id) ON DELETE CASCADE,
    CONSTRAINT fk_mn_branch_product_availability_product FOREIGN KEY (product_id) REFERENCES pr_product (id) ON DELETE CASCADE,
    CONSTRAINT chk_mn_branch_product_availability_sale_price CHECK (sale_price IS NULL OR sale_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_mn_branch_product_availability_branch_available ON mn_branch_product_availability (branch_id, is_available);
CREATE INDEX idx_mn_branch_product_availability_product ON mn_branch_product_availability (product_id);
