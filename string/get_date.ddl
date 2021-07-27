-- the function tries to convert a string to a date based on an array of masks, returns valid DATE or NULL
-- for a new date format, just add a new mask
CREATE OR REPLACE FUNCTION get_date(date_str in varchar2) return date DETERMINISTIC IS
    l_mask_id PLS_INTEGER;
    date_validated date;
    
    TYPE date_masks_type IS TABLE OF varchar2(400);
    date_masks_arr date_masks_type := date_masks_type ( 'DD.MM.RR', 'DD.MM.RR hh24:mi:ss','FXyyyy.mm.dd' ); --FX means exact matching "2020.01.01" != "2020-01-01"

    function validate_date_mask( mask in varchar2) return date is
        date_temp date;
    begin
        date_temp := to_date(date_str, mask);
    
        return date_temp;
    exception when others then
        return null;
    end;
    
BEGIN
    if(date_str is null) then
      return null;
    end if;

    l_mask_id := date_masks_arr.FIRST;

    WHILE (l_mask_id IS NOT NULL)
    LOOP
        date_validated := validate_date_mask(date_masks_arr(l_mask_id));
        if date_validated is not null then
            return date_validated;
        end if;

        l_mask_id := date_masks_arr.NEXT (l_mask_id);
    END LOOP;

    return null;
END; 
