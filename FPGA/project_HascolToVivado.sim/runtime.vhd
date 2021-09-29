library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use std.textio.all;
 
package runtime is
 
subtype stlv00 is std_logic_vector(0 downto 0);
subtype stlv01 is std_logic_vector(1 downto 0);


type intArray is array(integer range <>) of integer;

constant stlv00True : stlv00 := (others => '1');
constant stlv01True : stlv01 := (others => '1');

-- imagines that arr represents a multidim array of elts with given size and bounds. 
-- Creates a trim from the array given by indexes and of size given by trimSize. Returns it packed as a vector again 
-- for purposes of synthesis we expect that ub, lb, trimSizes are constants.
function generalComplexTrim(arr : std_logic_vector; constant ub, lb, trimSizes, indexes : intArray; constant eltSize : integer) return std_logic_vector;

function conv_boolean(x : stlv00) return boolean;

function conv_std_logic_vector(x : signed) return std_logic_vector;
function conv_std_logic_vector(x : unsigned) return std_logic_vector;
function conv_std_logic_vector(x : std_logic_vector) return std_logic_vector;
procedure conv_std_logic_vector(x : std_logic_vector; result : out std_logic_vector);
function conv_std_logic_vector(x : bit_vector) return std_logic_vector;
function conv_stlv00(x : std_logic_vector) return stlv00;
function conv_signed(x : std_logic_vector) return signed;
procedure conv_signed(x : std_logic_vector; result : out signed);
function conv_signed(x : std_logic_vector; z : integer) return signed;
function conv_unsigned(x : std_logic_vector) return unsigned;
procedure conv_unsigned(x : std_logic_vector; result : out unsigned);
function conv_unsigned(x : std_logic_vector; z : integer) return unsigned;

function generic_std_logic_vector_trim(arg : std_logic_vector; from, tto : integer) return std_logic_vector;

function equal(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00;

function and2(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00;
function or2(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00;
function not2(constant x : std_logic_vector) return stlv00;

function bool2stlv(x : boolean) return stlv00;
function bool2std_logic(x : boolean) return std_logic;
function stlv2bool(x : stlv00) return boolean;

function generic_std_logic_vector_join(a, b : std_logic_vector) return std_logic_vector;

function conv_integer_bound(x : integer; dflt : integer) return integer;

function disjunction(x, y : std_logic_vector) return std_logic_vector;
function disjunction(x, y : integer) return integer;
function disjunction(x, y : signed) return signed;
function disjunction(x, y : unsigned) return unsigned;

function halfMux(c : stlv00; x : std_logic_vector) return std_logic_vector;
function halfMux(c : stlv00; x : integer) return integer;
function halfMux(c : stlv00; x : signed) return signed;
function halfMux(c : stlv00; x : unsigned) return unsigned;

function zero(x : std_logic_vector) return std_logic_vector;
function zero(x : signed) return signed;
function zero(x : unsigned) return unsigned;
function zero(x : integer) return integer;

-- returns leftBound if index is not between leftBound and rightBound, thus disabling range checking in a simulator 
function notCheck(index, leftBound, rightBound : integer) return integer;

function dotProduct(a, b : intArray) return integer;

-- a common code that allows to make an arbitrary trim from an array that is aliased as std_logic_vector
-- the array is given together with slice parameters (indexes and trimsizes) and with sizes of array's dimensions 
function arrayAsAliasTrim(data : std_logic_vector; indexes, trimSizes, cumulativeDimSizes : intArray) return std_logic_vector;

procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout std_logic_vector); 

end package;
 
package body runtime is

function generalComplexTrim(arr : std_logic_vector; constant ub, lb, trimSizes, indexes : intArray; constant eltSize : integer) return std_logic_vector is

  function rectSize(constant ub, lb : intArray) return integer is 
  variable result : integer := 1;
  begin
    for i in ub'range loop result := result * (ub(i) - lb(i) + 1); end loop;
    return result; 
  end rectSize;

variable subarrSize : integer;

begin
  if ub'left = ub'right then
    return arr((trimSizes(lb'left) + indexes(lb'left) - lb(lb'left)) * eltSize - 1 downto (indexes(lb'left) - lb(lb'left)) * eltSize);
  else
    subarrSize := rectSize(ub, lb) * eltSize; 
    return generalComplexTrim(
	arr((trimSizes(lb'left) + indexes(lb'left) - lb(lb'left)) * subarrSize - 1 downto (indexes(lb'left) - lb(lb'left)) * subarrSize),
	ub(lb'left + 1 to lb'right),
        lb(lb'left + 1 to lb'right),
        trimSizes(lb'left + 1 to lb'right),
	indexes(lb'left + 1 to lb'right),
	eltSize
    );
  end if;
end generalComplexTrim;

function bool2std_logic(x : boolean) return std_logic is
begin
  if x then return '1'; else return '0'; end if;
end bool2std_logic;

procedure shiftRight(dataIn : in std_logic; dataOut : out std_logic; data : inout std_logic_vector) is
begin
  if data'high = data'low then
    dataOut := data(0);
    data(0) := dataIn;
  else
    dataOut := data(0);
    data(data'high - 2 downto 0) := data(data'high - 1 downto 1);
    data(data'high - 1) := dataIn;
  end if;
end shiftRight;

procedure conv_signed(x : std_logic_vector; result : out signed) is 
begin
	result := conv_signed(x);
end conv_signed;

procedure conv_unsigned(x : std_logic_vector; result : out unsigned) is
begin
	result := conv_unsigned(x);
end conv_unsigned;

procedure conv_std_logic_vector(x : std_logic_vector; result : out std_logic_vector) is
begin
	result := x;
end conv_std_logic_vector;

function dotProduct(a, b : intArray) return integer is
variable result : integer := 0;
begin
  for i in a'range loop result := result + a(i) * b(i); end loop;
  return result;
end dotProduct;

function multElements(x : intArray) return integer is
variable result : integer := 1;
begin
  for i in x'range loop result := result * x(i); end loop;
  return result;
end multElements; 

function arrayAsAliasTrim(data : std_logic_vector; indexes, trimSizes, cumulativeDimSizes : intArray) return std_logic_vector is
variable eltsize : integer := cumulativeDimSizes(cumulativeDimSizes'high);
variable result : std_logic_vector(eltsize * multElements(trimSizes) - 1 downto 0);
variable offsetInResult : integer := 0;
variable upperBounds : intArray(indexes'range);
variable curIndexes : intArray(indexes'range) := indexes;
variable offset, j : integer;
begin
  for i in indexes'range loop upperBounds(i) := indexes(i) + trimSizes(i) - 1; end loop;
  loop 
    offset := dotProduct(indexes, cumulativeDimSizes);
    result(offsetInResult + eltsize - 1 downto offsetInResult) := data(offset + eltsize - 1 downto offset);
    offsetInResult := offsetInResult + eltsize;

    j := curIndexes'high;
    while j >= 0 and curIndexes(j) = upperBounds(j) loop curIndexes(j) := indexes(j); j := j - 1; end loop;
    if j = -1 then exit; end if;
    curIndexes(j) := curIndexes(j) + 1;

--  while not lastIteration(curIndexes, upperBounds)
  end loop;
  return result;
end arrayAsAliasTrim;


function conv_std_logic_vector(x : bit_vector) return std_logic_vector is
variable result : std_logic_vector(x'range);
begin
for i in x'range loop
  if x(i) = '0' then result(i) := '0'; else result(i) := '1'; end if;
end loop;
return result;
end conv_std_logic_vector;

function conv_stlv00(x : std_logic_vector) return stlv00 is
begin return x; end conv_stlv00;

function disjunction(x, y : signed) return signed is
begin  return signed(disjunction(std_logic_vector(x), std_logic_vector(y))); end disjunction;

function disjunction(x, y : unsigned) return unsigned is
begin return unsigned(disjunction(std_logic_vector(x), std_logic_vector(y))); end disjunction;

-- TODO: not a very good implementation. though this is only for simulation
function disjunction(x, y : integer) return integer is 
begin return conv_integer(disjunction(conv_unsigned(x, 128), conv_unsigned(y, 128))); end disjunction;

function disjunction(x, y : std_logic_vector) return std_logic_vector is
variable result : std_logic_vector(x'range);
begin
    for i in x'range loop
	result(i) := x(i) or y(i);
    end loop;
    return result;
end disjunction;

function halfMux(c : stlv00; x : signed) return signed is
begin  return signed(halfMux(c, std_logic_vector(x))); end halfMux;

function halfMux(c : stlv00; x : unsigned) return unsigned is
begin return unsigned(halfMux(c, std_logic_vector(x))); end halfMux;

function halfMux(c : stlv00; x : integer) return integer is 
begin if c(0) = '1' then return x; else return 0; end if; end halfMux;

function halfMux(c : stlv00; x : std_logic_vector) return std_logic_vector is
variable result : std_logic_vector(x'range);
begin
    for i in x'range loop
	result(i) := c(0) and x(i);
    end loop;
    return result;
end halfMux;

function zero(x : std_logic_vector) return std_logic_vector is
variable result : std_logic_vector(x'range) := (others => '0');
begin return result; end zero;

function zero(x : signed) return signed is
variable result : signed(x'range) := (others => '0');
begin return result; end zero;

function zero(x : unsigned) return unsigned is
variable result : unsigned(x'range) := (others => '0');
begin return result; end zero;

function zero(x : integer) return integer is
begin return 0; end zero;

function conv_integer_bound(x : integer; dflt : integer) return integer is
--begin if x = -2147483648 then return dflt; else return x; end if; end conv_integer_bound;
begin return x; end conv_integer_bound;

function and2(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00 is 
begin 
    if a(0) = '1' and b(0) = '1' then 
	return (others => '1');
    else
	return (others => '0');
    end if;
end and2;

function or2(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00 is 
begin 
    if a(0) = '1' or b(0) = '1' then 
	return (others => '1');
    else
	return (others => '0');
    end if;
end or2;

function not2(constant x : std_logic_vector) return stlv00 is 
begin
    if x(0) = '1' then
	return (others => '0');
    else
	return (others => '1');
    end if;
end not2;

function conv_std_logic_vector(x : std_logic_vector) return std_logic_vector is
begin return x; end conv_std_logic_vector;

function generic_std_logic_vector_join(a, b : std_logic_vector) return std_logic_vector is
begin
return a & b;
end generic_std_logic_vector_join;

function bool2stlv(x : boolean) return stlv00 is
begin 
    if x then 
	return (others => '1');
    else 
	return (others => '0');
    end if;
end bool2stlv;

procedure write(variable l : inout line; x : std_logic) is
begin
   if x = 'U' then write(l, String'("Uninitialized"));
elsif x = 'X' then write(l, String'("Forcing  Unknown"));
elsif x = '0' then write(l, String'("Forcing  0"));
elsif x = '1' then write(l, String'("Forcing  1"));
elsif x = 'Z' then write(l, String'("High Impedance"));
elsif x = 'W' then write(l, String'("Weak     Unknown"));
elsif x = 'L' then write(l, String'("Weak     0"));
elsif x = 'H' then write(l, String'("Weak     1"));
end if;
end write;

function stlv2bool(x : stlv00) return boolean is
variable l : line;
begin 
    if x(0) = '1' then return true; 
    elsif x(0) = '0' then return false; 
    elsif x(0) = 'U' then return true;
    else
--	write(l, String'("incorrect boolean ")); write(l, x(0)); writeline(output, l);
        assert false report "incorrect boolean in stlv2bool" severity failure;
	return true;
    end if;
end stlv2bool;

function equal(constant a : std_logic_vector; constant b : std_logic_vector) return stlv00 is
--variable i : integer;
--constant al : integer := a'low;
--constant bl : integer := b'low;
--constant ah : integer := a'high;
--constant bh : integer := b'high;
--constant a0 : std_logic_vector(a'length - 1 downto 0) := a(ah downto al);
--alias a0 : std_logic_vector(0 to a'length - 1) is a(al to ah);
--constant b0 : std_logic_vector(b'length - 1 downto 0) := b(bh downto bl);
--alias b0 : std_logic_vector(0 to b'length - 1) is b(bl to bh);
--constant alen : integer := a'length;
--variable result : boolean := true;
begin
--assert a'length = b'length
--report "a and b must be of the same length for equal(a, b)"
--severity failure;
--for i in 0 to alen - 1 loop
--    result := result and (a(i) = b(i));
--end loop;
--return bool2stlv(result);
return bool2stlv(a = b);
end equal;

function generic_std_logic_vector_trim(arg : std_logic_vector; from, tto : integer) return std_logic_vector is
constant lbound : integer := arg'low + from ;
constant rbound : integer := arg'low + tto;
variable res : std_logic_vector(tto - from downto 0);
variable l : line;
begin 
--write(l, String'("lbound = ")); write(l, lbound);
--write(l, String'(" rbound = ")); write(l, rbound);
--write(l, String'(" arg'low = ")); write(l, arg'low);
--write(l, String'(" arg'high = ")); write(l, arg'high);
--writeline(output, l);
res := arg(rbound downto lbound);
return res; end generic_std_logic_vector_trim;
 
function conv_std_logic_vector(x : signed) return std_logic_vector is
begin
return conv_std_logic_vector(x, x'length); 
end conv_std_logic_vector;

function conv_std_logic_vector(x : unsigned) return std_logic_vector is
begin
return conv_std_logic_vector(x, x'length); 
end conv_std_logic_vector;

function conv_signed(x : std_logic_vector) return signed is
variable y : signed(x'low to x'high) := signed(x);
begin return y; end conv_signed;

function conv_signed(x : std_logic_vector; z : integer) return signed is
variable y : signed(x'low to x'high) := signed(x);
begin return y; end conv_signed;

function conv_unsigned(x : std_logic_vector) return unsigned is
variable y : unsigned(x'low to x'high) := unsigned(x);
begin return y; end conv_unsigned;

function conv_unsigned(x : std_logic_vector; z : integer) return unsigned is
variable y : unsigned(x'low to x'high) := unsigned(x);
begin return y; end conv_unsigned;

function conv_boolean(x : stlv00) return boolean is 
begin return x(0) = '1'; end conv_boolean;

function notCheck(index, leftBound, rightBound : integer) return integer is
begin
  if index >= leftBound and index <= rightBound then 
    return index;
  else
    return leftBound;
  end if;
end notCheck;

end runtime;

