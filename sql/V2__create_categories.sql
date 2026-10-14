
CREATE TABLE categories (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    owner_user_id BIGINT REFERENCES users(user_id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT categories_name_not_blank
        CHECK (BTRIM(name) <> ''),

    CONSTRAINT categories_default_owner
        CHECK (NOT is_default OR owner_user_id IS NULL),

    CONSTRAINT categories_custom_owner
        CHECK (is_default OR owner_user_id IS NOT NULL)
);

CREATE UNIQUE INDEX categories_default_name_unique
    ON categories (LOWER(name))
    WHERE is_default = TRUE;

CREATE UNIQUE INDEX categories_owner_name_unique
    ON categories (owner_user_id, LOWER(name))
    WHERE owner_user_id IS NOT NULL;
