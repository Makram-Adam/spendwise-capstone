-- Ensure an expense uses either a shared default category
-- or a custom category owned by the same user.
CREATE OR REPLACE FUNCTION check_expense_category_ownership()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM categories c
        WHERE c.category_id = NEW.category_id
          AND (
              c.is_default = TRUE
              OR c.owner_user_id = NEW.user_id
          )
    ) THEN
        RAISE EXCEPTION
            'Category does not exist or is not available to this user';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER expenses_category_ownership_trigger
BEFORE INSERT OR UPDATE OF category_id, user_id
ON expenses
FOR EACH ROW
EXECUTE FUNCTION check_expense_category_ownership();


-- Ensure a budget uses either a shared default category
-- or a custom category owned by the same user.
-- A NULL category_id represents an overall budget.
CREATE OR REPLACE FUNCTION check_budget_category_ownership()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.category_id IS NOT NULL
       AND NOT EXISTS (
           SELECT 1
           FROM categories c
           WHERE c.category_id = NEW.category_id
             AND (
                 c.is_default = TRUE
                 OR c.owner_user_id = NEW.user_id
             )
       )
    THEN
        RAISE EXCEPTION
            'Category does not exist or is not available to this user';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER budgets_category_ownership_trigger
BEFORE INSERT OR UPDATE OF category_id, user_id
ON budgets
FOR EACH ROW
EXECUTE FUNCTION check_budget_category_ownership();
