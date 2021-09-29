
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.runtime.all;

package IOShuvalkin is

  type stringPtr is access string;
  type stringPtrArray is array(integer range <>) of stringPtr;
  type stringPtrList; 
  type stringPtrListPtr is access stringPtrList;
  type stringPtrList is record 
  	nxt  : stringPtrListPtr;
  	s    : stringPtr;
  end record;

  type string_ptr is access string;
  type char_file is file of character;
  -- **************************************************************************************************************************************
  -- The file type declaration above implicitly defines the following operations:
  -- procedure file_open (                               file f : char_file; name : in string; open_kind : in file_open_kind := read_mode);
  -- procedure file_open (status : out file_open_status; file f : char_file; name : in string; open_kind : in file_open_kind := read_mode);
  -- procedure file_close(file f : char_file);
  -- procedure read (file f : char_file; value : out character);
  -- procedure write(file f : char_file; value : in  character);
  -- function  endfile(file f : char_file) return boolean;
  -- **************************************************************************************************************************************

  type stlv32arr is array(integer range <>) of std_logic_vector(31 downto 0);

  file stdin  : char_file open read_mode  is "STD_INPUT";
  file stdout : char_file open write_mode is "STD_OUTPUT";

  --============================================================================
  -- Printing to a file and stdout:
  constant newline : string := "" & lf;

  -- prints a string pointer then deallocates it
  procedure fprint_stringPtr(file f : char_file; value : inout stringPtr);
  procedure fprint_string (file f : char_file; value : in string);
  procedure print_string(value : in string);
  function to_string(value : in std_logic_vector) return string;
  procedure toStringList(prefix : string; width : integer; x : std_logic_vector; variable res : inout stringPtrListPtr);


  procedure read_identifier(file f : char_file; value : inout string_ptr);
  procedure read_integer(file f : char_file; value : out integer);
  --============================================================================

  -- Conversion functions
  function to_std_logic_vector(value : in integer; width : in positive) return std_logic_vector;
  function to_unsigned_integer(value : in std_logic_vector) return natural;
  function to_unsigned_integer(value : in std_logic) return natural;
  function to_signed_integer  (value : in std_logic_vector) return integer;
  function to_integer         (value : in string) return integer;
  

  function toString(x : in std_logic_vector) return stringPtr;
  function toString(value : in integer; width : in positive := 1) return stringPtr;

  function to_string(value : in std_logic) return string;

  function toString(x : in signed) return stringPtr;
  function toString(value : in unsigned) return stringPtr;
  function toStringSigned(x : std_logic_vector) return stringPtr;
  function toStringUnsigned(x : std_logic_vector) return stringPtr;
  function toStringBool(x : stlv00) return stringPtr;
  procedure toStringList(prefix : string; width : integer; x : unsigned; variable res : inout stringPtrListPtr);
  procedure toStringList(prefix : string; width : integer; x :   signed; variable res : inout stringPtrListPtr);
  procedure toStringList(prefix : string; width : integer; x :  integer; variable res : inout stringPtrListPtr);

  function toString(x : in stlv32arr) return stringPtr;

  procedure fromFile(file f : char_file; variable result : out integer);
  procedure fromFile(file f : char_file; variable result : out std_logic_vector);
  procedure fromFile(file f : char_file; variable result : out signed);
  procedure fromFileSigned(file f : char_file; variable result : out std_logic_vector);
  procedure fromFile(file f : char_file; variable result : out unsigned);
  procedure fromFile(file f : char_file; variable result : out stlv32arr);

  -- prints the list. Reverts it before printing!!
  procedure print(variable l : inout stringPtrListPtr);

  -- link r to the end of l
  procedure concat(variable l, r : in stringPtrListPtr);
  -- a tricky step of the printing algorithm
  procedure printingStep(variable newList, oldList : inout stringPtrListPtr; outerstdprefix, stdprefix, objectName : string; screenWidth : integer; last : boolean);
  -- constructor of a one element list 
  procedure cons(s : string; result : out stringPtrListPtr);
  -- produce a loooong string for a given list
  -- just revert a list
  procedure rev(variable l : inout stringPtrListPtr);
  -- reverts the list in the process!! 
  procedure toString(variable l : inout stringPtrListPtr; result : inout stringPtr);
  procedure deallocateList(variable l : inout stringPtrListPtr);

  procedure strcpy(dest : inout stringPtr; startPos : integer; src : string);


end IOShuvalkin;

package body IOShuvalkin is

  procedure strcpy(dest : inout stringPtr; startPos : integer; src : string) is
  begin
      for i in 1 to src'high loop
  	dest.all(startPos + i - 1) := src(i);
      end loop;
  end strcpy;

  procedure totalLen(variable l : in stringPtrListPtr; result : inout integer) is
  variable t : stringPtrListPtr := l;
  begin
    result := 0;
    while not (t = NULL) loop result := result + t.all.s.all'high + 2; t := t.all.nxt; end loop;
  end totalLen;

  -- revert a list
  procedure rev(variable l : inout stringPtrListPtr) is
  variable t, t1 : stringPtrListPtr;
  begin
    if not (l = NULL) then
      t := l.all.nxt;   
      l.all.nxt := NULL;
      while not (t = NULL) loop
        t1 := t.all.nxt;
        t.all.nxt := l;
        l := t;
        t := t1;
      end loop;
    end if;
  end rev;

  procedure deallocateList(variable l : inout stringPtrListPtr) is
  variable t : stringPtrListPtr;
  begin
    while not (l = NULL) loop
      t := l.all.nxt;
      deallocate(l);
      l := t;
    end loop;
  end deallocateList;


  -- produce a loooong string for a given list
  procedure toString(variable l : inout stringPtrListPtr; result : inout stringPtr) is
  variable pos : integer;
  variable t : stringPtrListPtr;
  begin
    rev(l);
    t := l;
    totalLen(l, pos);
    result := new string(1 to pos);
    for i in 1 to pos loop result.all(i) := ' '; end loop;
    pos := 1;
    while not (t = NULL) loop 
      result.all(pos to pos + t.all.s.all'high - 1) := t.all.s.all;
      pos := pos + t.all.s.all'high;
      result.all(pos) := lf;
      pos := pos + 1;
      t := t.all.nxt;
    end loop;
  end toString;

  procedure findlast(variable l : in stringPtrListPtr; variable t : inout stringPtrListPtr) is 
  begin
    t := l;
    while not (t.all.nxt = NULL) loop t := t.all.nxt; end loop;
  end findlast;

  -- just concatenate 2 lists
  procedure concat(variable l, r : in stringPtrListPtr) is
  variable t : stringPtrListPtr := l;
  begin
    findlast(l, t);
    t.all.nxt := r;
  end concat;

  procedure cons(s : string; result : out stringPtrListPtr) is 
  begin
    result := new stringPtrList'(nxt => NULL, s => new string'(s));
  end cons;

  procedure cons(size : integer; result : out stringPtrListPtr) is 
  begin
    result := new stringPtrList'(nxt => NULL, s => new string(1 to size));
  end cons;

  -- a tricky step of the printing algorithm
  procedure printingStep(variable newList, oldList : inout stringPtrListPtr; outerstdprefix, stdprefix, objectName : string; screenWidth : integer; last : boolean) is 
  variable olds : stringPtr := oldList.all.s;
  variable oldlen : integer := oldList.all.s.all'high;
  variable newlen : integer := newList.all.s.all'high;
  variable t : stringPtrListPtr;
  begin
  --if newList.all.nxt = NULL and (screenWidth - oldlen) >= objectName'high + 7 + newlen then  
  if newList.all.nxt = NULL and (screenWidth - oldlen) >=  7 + newlen then  
    -- we concatenate the string fro newList with the string in oldList
    if not last then 
      oldList.all.s := new string'(olds.all & objectName & " = (" & newList.all.s.all & "), ");
    else 
      oldList.all.s := new string'(olds.all & objectName & " = (" & newList.all.s.all & ") ");
    end if;
    deallocate(olds);
    deallocate(newList.s);
    deallocate(newList);
    newList := oldList; 
  else
    oldList.all.s := new string'(olds.all & objectName & " = (");
    deallocate(olds);
    findlast(newList, t);
    olds := t.all.s;
  --  t.all.s := new string'(stdprefix & "." & objectName & ": " & olds.all);
    t.all.s := new string'(stdprefix & ": " & olds.all);
    deallocate(olds);
    concat(newList, oldList);
    if not last then 
      cons(stdprefix & ": ), ", oldList);
      concat(oldList, newList);
      cons(stdprefix & ": ", newList); 
      concat(newList, oldList);
    else 
      cons(outerstdprefix & ": )", t);
      concat(t, newList);
      newList := t;
    end if;
  end if;  
  end printingStep;


  function toStringBool(x : stlv00) return stringPtr is
  begin 
   return toString(x);

   if x(0) = '1' then 
     return new string'("true"); 
   elsif x(0) = '0' then 
     return new string'("false"); 
   else return new string'("undef");
   end if; 
  end toStringBool;

  function toStringUnsigned(x : in std_logic_vector) return stringPtr is
  begin return toString(unsigned(x)); end toStringUnsigned;

  function toStringSigned(x : in std_logic_vector) return stringPtr is
  begin return toString(signed(x)); end toStringSigned;

  procedure fromFileSigned(file f : char_file; variable result : out std_logic_vector) is 
  variable res0 : signed(result'range);
  begin
    fromFile(f, res0);
    result := std_logic_vector(res0);
  end fromFileSigned;

  procedure print(variable l : inout stringPtrListPtr) is 
  variable t : stringPtrListPtr;
  begin
    rev(l);
    t := l;
    while not (t = NULL) loop
      print_string(t.all.s.all & lf);
      t := t.all.nxt;
    end loop;
  end print;

  procedure toStringList(prefix : string; width : integer; x :  integer; variable res : inout stringPtrListPtr) is
  begin
    res := new stringPtrList'(nxt => NULL, s => toString(x));
  end toStringList;

  procedure toStringList(prefix : string; width : integer; x : std_logic_vector; variable res : inout stringPtrListPtr) is
  begin
    cons(to_string(x), res);
  end toStringList;

  procedure toStringList(prefix : string; width : integer; x : unsigned; variable res : inout stringPtrListPtr) is
  variable s : stringPtr;
  begin
    s := toString(x);
    cons(s.all, res);
    deallocate(s);
  end toStringList;

  procedure toStringList(prefix : string; width : integer; x :   signed; variable res : inout stringPtrListPtr) is
  variable s : stringPtr;
  begin
    s := toString(x);
    cons(s.all, res);
    deallocate(s);
  end toStringList;

  procedure fromFile(file f : char_file; variable result : out stlv32arr) is
  begin
    for i1 in result'range(1) loop
      fromFileSigned(f,  result(i1));
    end loop;
  end fromFile;

  function toString(x : in stlv32arr) return stringPtr is
	variable tmpStrings : stringPtrArray(0 to 3 * (x'high(1) - x'low(1) + 1));
	variable buf : stringPtr;
	variable stringsOffs : integer := 0;
	variable stringsSize : integer := 0;
	variable bufOffs : integer := 1;
	variable bufSize : integer := 0;
  begin
	tmpStrings(stringsSize) := new string'("("); stringsSize := stringsSize + 1;
	for i1 in x'range(1) loop
		tmpStrings(stringsSize) := toStringSigned(x(i1));
		stringsSize := stringsSize + 1;
		if i1 /= x'high(1) then
			tmpStrings(stringsSize) := new string'(", ");
			stringsSize := stringsSize + 1;
		end if;
	end loop;
	tmpStrings(stringsSize) := new string'(")"); stringsSize := stringsSize + 1;
	for i in 0 to stringsSize - 1 loop
		bufSize := bufSize + tmpStrings(i).all'high;
	end loop;
	buf := new string(1 to bufSize);
	for i in 0 to stringsSize - 1 loop
		strcpy(buf, bufOffs, tmpStrings(i).all);
		bufOffs := bufOffs + tmpStrings(i).all'high;
		deallocate(tmpStrings(i));
	end loop;
	return buf;
  end toString;


  procedure fprint_stringPtr (file f : char_file; value : inout stringPtr) is
  begin
    for i in value'range loop
      write(f, value.all(i));
    end loop;
    deallocate(value);
  end procedure fprint_stringPtr;

  procedure fprint_string (file f : char_file; value : in string) is
  begin
    for i in value'range loop
      write(f, value(i));
      if i mod 100 = 0 then 
        write(f, lf);
      end if;
    end loop;
  end procedure fprint_string;

  procedure print_string(value : in string) is
  begin
    fprint_string(stdout, value);
  end procedure print_string;

  procedure read_integer(file f : char_file; value : out integer) is
    variable buf  : string(1 to 256);
    variable ch0  : character;
    variable idx  : positive;
  begin
    -- Searching for first character:
    while true loop
      assert not(endfile(f)) report "read_integer(): Unexpected End Of File." severity failure;
      read(f, ch0);
      exit when ((ch0 >= '0')and(ch0 <= '9'))or(ch0 = '-');
    end loop;

    buf(1) := ch0;
    idx    := 2;

    -- Reading other characters:
    while (not(endfile(f))) loop
      read(f, ch0);
      if ((ch0 >= '0')and(ch0 <= '9'))or((ch0 >= 'a')and(ch0 <= 'f'))or((ch0 >= 'A')and(ch0 <= 'F'))or(ch0 = 'x') then
        buf(idx) := ch0;
        idx := idx + 1;
      else
        exit;
      end if;
    end loop;
    value := to_integer(buf(1 to idx - 1));
  end procedure read_integer;

  procedure read_identifier(file f : char_file; value : inout string_ptr) is
    variable buf  : string(1 to 256);
    variable ch0  : character;
    variable idx  : positive;
  begin
    -- Searching for first character:
    while true loop
      assert not(endfile(f)) report "read_identifier(): Unexpected End Of File." severity failure;
      read(f, ch0);
      exit when ((ch0 >= 'A')and(ch0 <= 'Z'))or((ch0 >= 'a')and(ch0 <= 'z'))or(ch0 = '_');
    end loop;

    buf(1) := ch0;
    idx    := 2;

    -- Reading other characters:
    while (not(endfile(f))) loop
      read(f, ch0);
      if ((ch0 >= 'A')and(ch0 <= 'Z'))or((ch0 >= 'a')and(ch0 <= 'z'))or((ch0 >= '0')and(ch0 <= '9'))or(ch0 = '_') then
        buf(idx) := ch0;
        idx := idx + 1;
      else
        exit;
      end if;
    end loop;
    deallocate(value);
    value := new string'(buf(1 to idx - 1));
  end procedure read_identifier;

  function to_std_logic_vector(value : in integer; width : in positive) return std_logic_vector is
    variable result : std_logic_vector(width - 1 downto 0);
    variable temp   : integer;
  begin
    temp := value;
    for i in 0 to width - 1 loop
      if (temp mod 2) = 1 then
        result(i) := '1';
      else 
        result(i) := '0';
      end if;
      if temp > 0 then
        temp := temp / 2;
      elsif (temp > integer'low) then
        temp := (temp - 1) / 2; -- simulate ASR
      else
        temp := temp / 2; -- simulate ASR
      end if;
    end loop;
    return result;
  end function to_std_logic_vector;


  function to_unsigned_integer(value : in std_logic_vector) return natural is
     variable return_int : integer := 0;
  begin
    for i in value'range loop
      return_int := return_int * 2;
      case value(i) is
          when '1'    => return_int := return_int + 1;
          when 'H'    => return_int := return_int + 1;
          when others => null;
      end case;
    end loop;
    return return_int;
  end function to_unsigned_integer;

  function to_unsigned_integer(value : in std_logic) return natural is
     variable return_int : integer := 0;
  begin
    if (value = '1')or(value = 'H') then
      return_int := 1;
    else
      return_int := 0;
    end if;
    return return_int;
  end function to_unsigned_integer;


  function to_signed_integer(value : in std_logic_vector) return integer is
     variable return_int : integer;
  begin
    for i in value'range loop
      if (i = value'left) then
        case value(i) is
            when '1'    => return_int := -1;
            when 'H'    => return_int := -1;
            when others => return_int := 0;
        end case;
      else
        return_int := return_int * 2;
        case value(i) is
            when '1'    => return_int := return_int + 1;
            when 'H'    => return_int := return_int + 1;
            when others => null;
        end case;
      end if;
    end loop;
    return return_int;
  end function to_signed_integer;

  function to_integer(value : in string) return integer is
    variable value_local : integer := 0;
    variable start_idx   : positive;
    variable negative    : boolean;
  begin
    if (value'right > 2)and(value(1) = '0')and(value(2) = 'x') then -- hex format
      start_idx := 3;
        
      for i in start_idx to value'right loop
        if    (value(i) >= 'a')and(value(i) <= 'f') then
          value_local := (16 * value_local) + (character'pos(value(i)) - character'pos('a') + 10);
        elsif (value(i) >= 'A')and(value(i) <= 'F') then
          value_local := (16 * value_local) + (character'pos(value(i)) - character'pos('A') + 10);
        else
          value_local := (16 * value_local) + (character'pos(value(i)) - character'pos('0'));
        end if;
      end loop;
    else
      if (value(1) = '-') then
        negative  := true;
        start_idx := 2;
      else
        negative  := false;
        start_idx := 1;
      end if;
        
      for i in start_idx to value'right loop
        value_local := (10 * value_local) + (character'pos(value(i)) - character'pos('0'));
      end loop;

      if (negative) then
        value_local := (-1) * value_local;
      end if;
    end if;

    return value_local;
  end function to_integer;

  function to_string(value : in std_logic) return string is
  variable result : string(1 downto 1);
  begin
    case value is
      when '0' => result(1) := '0';
      when '1' => result(1) := '1';
      when 'U' => result(1) := 'U';
      when 'H' => result(1) := 'H';
      when 'L' => result(1) := 'L';
      when 'Z' => result(1) := 'Z';
      when 'X' => result(1) := 'X';
      when others => result(1) := '?';
    end case;
    return result;
  end to_string;

  function to_string(value : in std_logic_vector) return string is
    variable res_string : string((((value'length + 3)/4) + 2) downto 1);
    variable res_idx    : positive;
    variable hex_digit  : integer;
  begin
    
    hex_digit := 0;
    res_idx   := 1;
    for idx in value'right to value'left loop
      if    (value(idx)  = '1') then
        hex_digit := hex_digit + 2**((idx - value'right) rem 4);
      elsif (value(idx) /= '0') then
        hex_digit := hex_digit + 100;
      end if;
      if (((idx - value'right) rem 4) = 3)or(idx = value'left) then
        case hex_digit is
          when  0     => res_string(res_idx) := '0';
          when  1     => res_string(res_idx) := '1';
          when  2     => res_string(res_idx) := '2';
          when  3     => res_string(res_idx) := '3';
          when  4     => res_string(res_idx) := '4';
          when  5     => res_string(res_idx) := '5';
          when  6     => res_string(res_idx) := '6';
          when  7     => res_string(res_idx) := '7';
          when  8     => res_string(res_idx) := '8';
          when  9     => res_string(res_idx) := '9';
          when 10     => res_string(res_idx) := 'A';
          when 11     => res_string(res_idx) := 'B';
          when 12     => res_string(res_idx) := 'C';
          when 13     => res_string(res_idx) := 'D';
          when 14     => res_string(res_idx) := 'E';
          when 15     => res_string(res_idx) := 'F';
          when others => res_string(res_idx) := 'X';
        end case;
        hex_digit := 0;
        res_idx   := res_idx + 1;
      end if;
    end loop;
    res_string(res_string'left)     := '0';
    res_string(res_string'left - 1) := 'x';

    return res_string;
  end function to_string;

  function toString(value : in integer; width : in positive := 1) return stringPtr is
    variable idx  : positive;
    variable buf  : string(1 to 80);
    variable negative : boolean := (value < 0);
    variable value_local : integer := abs(value);
  begin
    -- a very special case that doesn't work with the general algorithm, cause 
    -- abs(min_int) = min_int --- it is a very negative number! :))
    if value = -2147483648 then     
      return new string'("-2147483648");
    end if;

    idx := 80;

    if (value_local = 0) then
      buf(idx) := '0';
      idx := idx - 1;
    end if;

    while (value_local /= 0) loop
      buf(idx) := character'val((value_local rem 10) + character'pos('0'));
      value_local := value_local / 10;
      idx := idx - 1;
    end loop;

    if (negative) then
      buf(idx) := '-';
      idx := idx - 1;
    end if;

    while ((80 - idx) < width) loop
      buf(idx) := ' ';
      idx := idx - 1;
    end loop;
    
    buf(1 to (80 - idx)) := buf((1 + idx) to 80);

    return new string'(buf(1 to (80 - idx)));
  end function toString;

  function toString(value : in unsigned) return stringPtr is
  begin
    return new string'(to_string(std_logic_vector(value)));
  end function toString;

  function toString(x : in std_logic_vector) return stringPtr is 
  variable offset : integer := 1 - x'low;
  variable result : string(x'high - x'low + 1 downto 1);
  begin
    for i in x'range loop
      if x(i) = '0' then
        result(i + offset) := '0';
      elsif x(i) = '1' then
        result(i + offset) := '1';
      elsif x(i) = 'U' then
        result(i + offset) := 'U';
      else
        result (i + offset) := '?';
      end if;
    end loop;
    return new string'("B""" & result & """");
  end toString;

  function toString(x : in signed) return stringPtr is 
  begin
    return new string'(to_string(std_logic_vector(x)));
  end toString;

  procedure fromFile(file f : char_file; variable result : out integer) is
  begin read_integer(f, result); end fromFile;
  
  procedure fromFile(file f : char_file; variable result : out std_logic_vector) is
    variable x : unsigned(result'range);
  begin fromFile(f, x); result := std_logic_vector(x); end fromFile;
  
  procedure fromFile(file f : char_file; variable result : out signed) is
    variable x : integer;
  begin read_integer(f, x); result := conv_signed(x, result'length); end fromFile;
  
  procedure fromFile(file f : char_file; variable result : out unsigned) is
    variable x : integer;
  begin read_integer(f, x); result := conv_unsigned(x, result'length); end fromFile;

end IOShuvalkin;

