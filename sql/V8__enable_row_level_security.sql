-- Enable row-level security on private user data.
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE budgets ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_log ENABLE ROW LEVEL SECURITY;

-- Users can read only their own user record.
CREATE POLICY users_read_policy
ON users
FOR SELECT
USING (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

-- Users can update only their own user record.
CREATE POLICY users_update_policy
ON users
FOR UPDATE
USING (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
)
WITH CHECK (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

-- Users can see shared default categories and their own custom categories.
CREATE POLICY categories_read_policy
ON categories
FOR SELECT
USING (
    is_default = TRUE
    OR owner_user_id =
       NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

CREATE POLICY categories_insert_policy
ON categories
FOR INSERT
WITH CHECK (
    is_default = FALSE
    AND owner_user_id =
        NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

CREATE POLICY categories_update_policy
ON categories
FOR UPDATE
USING (
    is_default = FALSE
    AND owner_user_id =
        NULLIF(current_setting('app.user_id', true), '')::BIGINT
)
WITH CHECK (
    is_default = FALSE
    AND owner_user_id =
        NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

CREATE POLICY categories_delete_policy
ON categories
FOR DELETE
USING (
    is_default = FALSE
    AND owner_user_id =
        NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

-- Users can access only their own expenses.
CREATE POLICY expenses_user_isolation_policy
ON expenses
FOR ALL
USING (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
)
WITH CHECK (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

-- Users can access only their own budgets.
CREATE POLICY budgets_user_isolation_policy
ON budgets
FOR ALL
USING (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
)
WITH CHECK (
    user_id = NULLIF(current_setting('app.user_id', true), '')::BIGINT
);

-- Users may read only audit records associated with their own actions.
CREATE POLICY audit_log_actor_read_policy
ON audit_log
FOR SELECT
USING (
    actor_user_id =
    NULLIF(current_setting('app.user_id', true), '')::BIGINT
);
