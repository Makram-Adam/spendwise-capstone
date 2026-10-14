CREATE TABLE budgets (
    budget_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id BIGINT NOT NULL
        REFERENCES users(user_id) ON DELETE CASCADE,
    category_id BIGINT
        REFERENCES categories(category_id) ON DELETE RESTRICT,
    amount_limit NUMERIC(12, 2) NOT NULL,
    budget_month DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT budgets_amount_positive
        CHECK (amount_limit > 0),

    CONSTRAINT budgets_month_start
        CHECK (EXTRACT(DAY FROM budget_month) = 1)
);

-- One overall budget per user per month.
CREATE UNIQUE INDEX budgets_user_month_overall_unique
    ON budgets (user_id, budget_month)
    WHERE category_id IS NULL;

-- One budget per category, user, and month.
CREATE UNIQUE INDEX budgets_user_category_month_unique
    ON budgets (user_id, category_id, budget_month)
    WHERE category_id IS NOT NULL;

CREATE INDEX budgets_user_month_idx
    ON budgets (user_id, budget_month DESC);
