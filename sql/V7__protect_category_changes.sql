CREATE OR REPLACE FUNCTION protect_category_changes()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.is_default IS DISTINCT FROM OLD.is_default THEN
        RAISE EXCEPTION
            'A category cannot change between shared and custom status';
    END IF;

    IF NEW.owner_user_id IS DISTINCT FROM OLD.owner_user_id THEN
        RAISE EXCEPTION
            'A category owner cannot be changed';
    END IF;

    IF OLD.is_default = TRUE THEN
        RAISE EXCEPTION
            'Shared default categories cannot be modified';
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER categories_protect_changes_trigger
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION protect_category_changes();
