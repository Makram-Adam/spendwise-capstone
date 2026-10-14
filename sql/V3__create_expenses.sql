
CREATE TABLE expenses (
    expense_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL
        REFERENCES users(user_id) ON DELETE CASCADE,
    category_id BIGINT NOT NULL
        REFERENCES categories(category_id) ON DELETE RESTRICT,
    amount NUMERIC(12, 2) NOT NULL,
    description VARCHAR(500) NOT NULL,
    expense_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT expenses_amount_positive
        CHECK (amount > 0),

    CONSTRAINT expenses_description_not_blank
        CHECK (BTRIM(description) <> '')
);

CREATE INDEX expenses_user_date_idx
    ON expenses (user_id, expense_date DESC);

CREATE INDEX expenses_user_category_date_idx
    ON expenses (user_id, category_id, expense_date DESC);
