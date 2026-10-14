CREATE TABLE audit_log (
    audit_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    actor_user_id BIGINT
        REFERENCES users(user_id) ON DELETE SET NULL,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action VARCHAR(10) NOT NULL,
    old_values JSONB,
    new_values JSONB,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT audit_log_action_valid
        CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),

    CONSTRAINT audit_log_table_name_not_blank
        CHECK (BTRIM(table_name) <> '')
);

CREATE INDEX audit_log_record_idx
    ON audit_log (table_name, record_id);

CREATE INDEX audit_log_changed_at_idx
    ON audit_log (changed_at DESC);

CREATE INDEX audit_log_actor_changed_idx
    ON audit_log (actor_user_id, changed_at DESC);
