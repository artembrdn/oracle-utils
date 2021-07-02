--The function returns the ditance between two coordinates in meters, taking into account the radius of the Earth
create or replace function distance_between (LatitudeBegin number,LongitudeBegin number,LatitudeEnd number,LongitudeEnd number) return number DETERMINISTIC is
   Distance number;
   radius_eq BINARY_DOUBLE:=6378100;
   radius_pl BINARY_DOUBLE:=6356800;
   radius_sr BINARY_DOUBLE:=6372795;
   earth_radius BINARY_DOUBLE;
   cos_ BINARY_DOUBLE;

   v_latBegin BINARY_DOUBLE default LatitudeBegin;
   v_lngBegin BINARY_DOUBLE default LongitudeBegin;
   v_latEnd BINARY_DOUBLE default LatitudeEnd;
   v_lngEnd BINARY_DOUBLE default LongitudeEnd;

BEGIN
   v_latBegin:=v_latBegin*acos(-1d)/180.0d;
   v_lngBegin:=v_lngBegin*acos(-1d)/180.0d;
   v_latEnd:=v_latEnd*acos(-1d)/180.0d;
   v_lngEnd:=v_lngEnd*acos(-1d)/180.0d;



   cos_ :=  sin( v_latBegin ) * sin( v_latEnd ) + cos( v_latBegin ) * cos( v_latEnd ) * cos( v_lngBegin - v_lngEnd );
   -- the variable cos_ can take a value similar to 1,00000000000000000000000001, but argument of function acos must be in the range of -1 to 1
   if( cos_ > 1d) then
    cos_ := 1d;
   elsif (cos_ < -1d) then
    cos_ := -1d;
   end if;

   Distance := to_number(radius_sr * acos( cos_ ) );
   return Distance;
END distance_between ;
