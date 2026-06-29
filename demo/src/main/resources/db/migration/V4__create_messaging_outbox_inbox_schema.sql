CREATE TABLE outbox_event (
    id CHAR(36) NOT NULL,
    aggregate_type VARCHAR(80) NOT NULL,
    aggregate_id CHAR(36) NOT NULL,
    event_type VARCHAR(120) NOT NULL,
    exchange_name VARCHAR(150) NOT NULL,
    routing_key VARCHAR(150) NOT NULL,
    payload JSON NOT NULL,
    headers JSON NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    retry_count INT NOT NULL DEFAULT 0,
    max_retries INT NOT NULL DEFAULT 5,
    next_retry_at DATETIME NULL,
    published_at DATETIME NULL,
    locked_at DATETIME NULL,
    locked_by VARCHAR(120) NULL,
    error_message VARCHAR(1000) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_outbox_event PRIMARY KEY (id),
    CONSTRAINT chk_outbox_event_retry_count CHECK (retry_count >= 0),
    CONSTRAINT chk_outbox_event_max_retries CHECK (max_retries >= 0),
    CONSTRAINT chk_outbox_event_status CHECK (status IN ('PENDING', 'PROCESSING', 'PUBLISHED', 'FAILED', 'DEAD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_outbox_event_status_retry_created_at ON outbox_event (status, next_retry_at, created_at);
CREATE INDEX idx_outbox_event_aggregate ON outbox_event (aggregate_type, aggregate_id);
CREATE INDEX idx_outbox_event_event_type ON outbox_event (event_type);
CREATE INDEX idx_outbox_event_locked_at ON outbox_event (locked_at);

CREATE TABLE inbox_event (
    id CHAR(36) NOT NULL,
    message_id VARCHAR(150) NOT NULL,
    consumer_name VARCHAR(120) NOT NULL,
    event_type VARCHAR(120) NOT NULL,
    routing_key VARCHAR(150) NULL,
    payload JSON NULL,
    headers JSON NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'RECEIVED',
    retry_count INT NOT NULL DEFAULT 0,
    received_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at DATETIME NULL,
    locked_at DATETIME NULL,
    locked_by VARCHAR(120) NULL,
    error_message VARCHAR(1000) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT pk_inbox_event PRIMARY KEY (id),
    CONSTRAINT uk_inbox_event_message_consumer UNIQUE (message_id, consumer_name),
    CONSTRAINT chk_inbox_event_retry_count CHECK (retry_count >= 0),
    CONSTRAINT chk_inbox_event_status CHECK (status IN ('RECEIVED', 'PROCESSING', 'PROCESSED', 'FAILED', 'DEAD'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE INDEX idx_inbox_event_status_received_at ON inbox_event (status, received_at);
CREATE INDEX idx_inbox_event_event_type ON inbox_event (event_type);
CREATE INDEX idx_inbox_event_locked_at ON inbox_event (locked_at);
