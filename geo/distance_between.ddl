--The function returns the ditance between two coordinates in meters, taking into account the radius of the Earth
create or replace function distance_between (latitude_begin number,longitude_begin number,latitude_end number,longitude_end number) return number DETERMINISTIC is
   distance number;
   radius_earth BINARY_DOUBLE:=6372795;
   cos_value BINARY_DOUBLE;

   v_lat_begin BINARY_DOUBLE default latitude_begin;
   v_lng_begin BINARY_DOUBLE default longitude_begin;
   v_lat_end BINARY_DOUBLE default latitude_end;
   v_lng_end BINARY_DOUBLE default longitude_end;

BEGIN
   v_lat_begin:=v_lat_begin*acos(-1d)/180.0d;
   v_lng_begin:=v_lng_begin*acos(-1d)/180.0d;
   v_lat_end:=v_lat_end*acos(-1d)/180.0d;
   v_lng_end:=v_lng_end*acos(-1d)/180.0d;

   cos_value :=  sin( v_lat_begin ) * sin( v_lat_end ) + cos( v_lat_begin ) * cos( v_lat_end ) * cos( v_lng_begin - v_lng_end );
   -- the variable cos_ can take a value similar to 1,00000000000000000000000001, but argument of function acos must be in the range of -1 to 1
   if( cos_value > 1d) then
    cos_value := 1d;
   elsif (cos_value < -1d) then
    cos_value := -1d;
   end if;

   distance := to_number(radius_earth * acos( cos_value ) );
   return distance;
END distance_between ;
