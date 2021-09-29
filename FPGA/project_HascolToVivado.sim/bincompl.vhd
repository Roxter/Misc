library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

use std.textio.all;
library work;
use work.runtime.all;
--use work.runtime.all;
 
package bincompl is
 
--    описание типов

--    описание прототипов функций 
function bc_signed_eadd(l, r : std_logic_vector) return std_logic_vector;
function bc_unsigned_eadd(l, r : std_logic_vector) return std_logic_vector;
function bc_unsigned_add(l, r : std_logic_vector) return std_logic_vector;
function bc_signed_add(l, r : std_logic_vector) return std_logic_vector;

function bc_abs(x : std_logic_vector) return std_logic_vector;

function bc_unsigned_sub(l, r : std_logic_vector) return std_logic_vector;
function bc_signed_esub(l, r : std_logic_vector) return std_logic_vector;    -- == sign extend operands and do the substraction
function bc_unsigned_esub(l, r : std_logic_vector) return std_logic_vector;    -- == sign extend operands and do the substraction
function bc_signed_sub(l, r : std_logic_vector) return std_logic_vector;

function bc_signed_mul(x, y : std_logic_vector) return std_logic_vector;
function bc_unsigned_mul(x, y : std_logic_vector) return std_logic_vector;
function bc_unsigned_emul(l, r : std_logic_vector) return std_logic_vector;
function bc_signed_emul(l, r : std_logic_vector) return std_logic_vector;

function bc_signed_ge(x, y : std_logic_vector) return stlv00;
function bc_signed_gt(x, y : std_logic_vector) return stlv00;
function bc_signed_lt(x, y : std_logic_vector) return stlv00;
function bc_signed_le(x, y : std_logic_vector) return stlv00;
function bc_signed_ne(x, y : std_logic_vector) return stlv00;

function bc_unsigned_not(x : std_logic_vector) return std_logic_vector;
function bc_unsigned_and(x, y : std_logic_vector) return std_logic_vector;
function bc_unsigned_xor(x, y : std_logic_vector) return std_logic_vector;
function bc_unsigned_or(x, y : std_logic_vector) return std_logic_vector;

function bc_unsigned_ge(x, y : std_logic_vector) return stlv00;
function bc_unsigned_gt(x, y : std_logic_vector) return stlv00;
function bc_unsigned_lt(x, y : std_logic_vector) return stlv00;
function bc_unsigned_le(x, y : std_logic_vector) return stlv00;
function bc_unsigned_ne(x, y : std_logic_vector) return stlv00;

function bc_signed_c_ext(arg : std_logic_vector; new_size : integer) return std_logic_vector;
function bc_unsigned_c_ext(arg : std_logic_vector; new_size : integer) return std_logic_vector;
function bc_signed_c_sxt(arg : std_logic_vector; new_size : integer) return std_logic_vector;

function shlUns(arg : std_logic_vector; count : std_logic_vector) return std_logic_vector;
function shrUns(arg : std_logic_vector; count : std_logic_vector) return std_logic_vector;

function shlConst(arg : std_logic_vector; count : integer) return std_logic_vector;
function shrConst(arg : std_logic_vector; count : integer) return std_logic_vector;

function conv_integer_bound_signed(x : std_logic_vector; dflt : integer) return integer;
function conv_integer_bound_unsigned(x : std_logic_vector; dflt : integer) return integer;

function bc_bool_not(x : stlv00) return stlv00;
function bc_bool_and(x, y : stlv00) return stlv00;
function bc_bool_xor(x, y : stlv00) return stlv00;
function bc_bool_or(x, y : stlv00) return stlv00;

function decode3to8(blockNum : std_logic_vector(2 downto 0)) return std_logic_vector;
function decode2to4(blockNum : std_logic_vector(1 downto 0)) return std_logic_vector;

function bc_signed_not(x : std_logic_vector) return std_logic_vector;

function conv_integer_bound_bool(x : stlv00; dflt : integer) return integer;

function left(x : std_logic_vector; k : integer) return std_logic_vector;
function right(x : std_logic_vector; k : integer) return std_logic_vector;

function bc_unsigned_div_by_const(x : std_logic_vector; k : integer) return std_logic_vector; 

function bc_any_sub(x : std_logic_vector; low : integer; high : integer) return std_logic_vector;
function bc_sub_onebit(x : std_logic_vector; pos : integer) return stlv00;
function bc_cat(x, y : std_logic_vector) return std_logic_vector;

end package;
 
package body bincompl is

function bc_abs(x : std_logic_vector) return std_logic_vector is
variable xs : signed(x'range) := signed(x);
variable xu : std_logic_vector(x'range);
begin
  if xs < conv_signed(0, x'high - x'low + 1) then 
    xu := std_logic_vector(signed'(conv_signed(0, x'high - x'low + 1)-xs)); 
  else 
    xu := std_logic_vector(xs); 
  end if ;
  return xu; 
end bc_abs;

function bc_signed_esub(l, r : std_logic_vector) return std_logic_vector is    -- == sign extend operands and do the substraction
begin
  return std_logic_vector(signed'(signed(sxt(l, l'high - l'low + 2)) - signed(sxt(r, r'high - r'low + 2))));
end bc_signed_esub;

function bc_unsigned_esub(l, r : std_logic_vector) return std_logic_vector is    -- == sign extend operands and do the substraction
begin
  return std_logic_vector(signed'(signed('0' & l) - signed('0' & r)));
end bc_unsigned_esub;


function left(x : std_logic_vector; k : integer) return std_logic_vector is
begin
  return x(x'high downto x'high - k + 1);
end left;

function right(x : std_logic_vector; k : integer) return std_logic_vector is
begin
  return x(k - 1 + x'low downto x'low);
end right;

function conv_integer_bound_bool(x : stlv00; dflt : integer) return integer is
begin return conv_integer_bound_unsigned(x, dflt); end conv_integer_bound_bool;

function bc_signed_not(x : std_logic_vector) return std_logic_vector is
variable res : signed(x'range) := -signed(x);
begin
    return std_logic_vector(res);
end bc_signed_not;

function bc_unsigned_emul(l, r : std_logic_vector) return std_logic_vector is
variable x : unsigned(l'high + r'high + 1 downto 0) := unsigned(l) * unsigned(r);
begin
  return std_logic_vector(x);
end bc_unsigned_emul;

function bc_signed_emul(l, r : std_logic_vector) return std_logic_vector is
variable x : signed(l'high + r'high + 1 downto 0) := signed(l) * signed(r);
begin
  return std_logic_vector(x);
end bc_signed_emul;

function bc_unsigned_add(l, r : std_logic_vector) return std_logic_vector is
variable x : unsigned(l'range) := unsigned(l) + unsigned(r);
begin 
  return std_logic_vector(x); 
end bc_unsigned_add;

function bc_unsigned_sub(l, r : std_logic_vector) return std_logic_vector is
variable x : unsigned(l'range) := unsigned(l) - unsigned(r);
begin 
  return std_logic_vector(x); 
end bc_unsigned_sub;

function bc_signed_add(l, r : std_logic_vector) return std_logic_vector is
variable x : signed(l'range) := signed(l) + signed(r);
begin 
  return std_logic_vector(x); 
end bc_signed_add;

function bc_signed_sub(l, r : std_logic_vector) return std_logic_vector is
variable x : signed(l'range) := signed(l) - signed(r);
begin 
  return std_logic_vector(x); 
end bc_signed_sub;

function decode3to8(blockNum : std_logic_vector(2 downto 0)) return std_logic_vector is
begin
case blockNum is
when B"000" => return X"01";
when B"001" => return X"02";
when B"010" => return X"04";
when B"011" => return X"08";
when B"100" => return X"10";
when B"101" => return X"20";
when B"110" => return X"40";
when B"111" => return X"80";
when others => return X"00";
end case;
end decode3to8;

function decode2to4(blockNum : std_logic_vector(1 downto 0)) return std_logic_vector is
begin
case blockNum is
when B"00" => return X"1";
when B"01" => return X"2";
when B"10" => return X"4";
when B"11" => return X"8";
when others => return X"0";
end case;
end decode2to4;

function bc_unsigned_and(x, y : std_logic_vector) return std_logic_vector is
begin
  return x and y; 
end bc_unsigned_and;

function bc_unsigned_or(x, y : std_logic_vector) return std_logic_vector is
begin
  return x or y; 
end bc_unsigned_or;

function bc_unsigned_xor(x, y : std_logic_vector) return std_logic_vector is
begin
  return x xor y; 
end bc_unsigned_xor;

function bc_unsigned_not(x : std_logic_vector) return std_logic_vector is
begin
  return not x; 
end bc_unsigned_not;

function to01(x : std_logic_vector) return std_logic_vector is
variable result : std_logic_vector(x'range);
variable i : integer;
begin 
  for i in x'range loop 
    if x(i) = '1' then result(i) := '1'; else result(i) := '0'; end if;
  end loop;
  return result;
end function;

function conv_integer_bound_signed(x : std_logic_vector; dflt : integer) return integer is 
variable res : integer;
begin 
    res := conv_integer(signed(to01(x)));
    if res = 0 then res := dflt; end if;
    return res;
end conv_integer_bound_signed;

function conv_integer_bound_unsigned(x : std_logic_vector; dflt : integer) return integer is 
variable res : integer;
begin 
    res := conv_integer(unsigned(x));
    if res = 0 then res := dflt; end if;
    return res;
end conv_integer_bound_unsigned;

function shlUns(arg : std_logic_vector; count : std_logic_vector) return std_logic_vector is 
begin return shlConst(arg, conv_integer(unsigned(count))); end shlUns;

function shrUns(arg : std_logic_vector; count : std_logic_vector) return std_logic_vector is 
begin return shrConst(arg, conv_integer(unsigned(count))); end shrUns;

function shlConst(arg : std_logic_vector; count : integer) return std_logic_vector is
begin return std_logic_vector(ieee.numeric_std.shift_left(ieee.numeric_std.unsigned(arg), natural(count))); end shlConst;

function shrConst(arg : std_logic_vector; count : integer) return std_logic_vector is
begin return std_logic_vector(ieee.numeric_std.shift_right(ieee.numeric_std.unsigned(arg), natural(count))); end shrConst;

function REMOVEMEshlConst(arg : std_logic_vector; count : integer) return std_logic_vector is
alias arg0 : std_logic_vector(arg'length - 1 downto 0) is arg;
variable result : std_logic_vector(arg'length - 1 downto 0) := (others => '0');
begin
    if (count < arg'length) and (count >= 0) then
	result(arg'length - 1 downto count) := arg0(arg'length - count - 1 downto 0);
    end if;
    return result;
end REMOVEMEshlConst;

function REMOVEMEshrConst(arg : std_logic_vector; count : integer) return std_logic_vector is
alias arg0 : std_logic_vector(arg'length - 1 downto 0) is arg;
variable result : std_logic_vector(arg'length - 1 downto 0) := (others => '0');
begin
    if (count < arg'length) and (count >= 0) then
	result(arg'length - count - 1 downto 0) := arg0(arg'length - 1 downto count);
    end if;
    return result;
end REMOVEMEshrConst;

function bc_signed_c_ext(arg : std_logic_vector; new_size : integer) return std_logic_vector is
begin return ext(arg, new_size); end bc_signed_c_ext;

function bc_unsigned_c_ext(arg : std_logic_vector; new_size : integer) return std_logic_vector is
begin return ext(arg, new_size); end bc_unsigned_c_ext;

function bc_signed_c_sxt(arg : std_logic_vector; new_size : integer) return std_logic_vector is
begin return (sxt((arg), new_size)); end bc_signed_c_sxt;

function bool2stlv(x : boolean) return stlv00 is
begin 
    if x then 
	return (others => '1');
    else 
	return (others => '0');
    end if;
end bool2stlv;

function stlv2bool(x : stlv00) return boolean is
begin 
    if x(0) = '1' then return true; 
    elsif x(0) = '0' then return false; 
    else 
	assert false report "incorrect boolean in stlv2bool" severity failure;
	return false;
    end if;
end stlv2bool;

function bc_unsigned_eadd(l, r : std_logic_vector) return std_logic_vector is
variable res : unsigned(l'high + 1 downto l'low) := unsigned('0' & l) + unsigned('0' & r);
begin
  return std_logic_vector(res);
end bc_unsigned_eadd;

function bc_signed_eadd(l, r : std_logic_vector) return std_logic_vector is
variable res : signed(l'high + 1 downto l'low) := signed(l(l'high) & l) + signed(r(r'high) & r);
begin
  return std_logic_vector(res);
end bc_signed_eadd;

procedure equalLengths(x, y : std_logic_vector) is
begin
    ASSERT x'length = y'length
    REPORT "only signed types of equal lengths can be given to bc_signed_mul"
    SEVERITY FAILURE;
end equalLengths;

function bc_signed_mul(x, y : std_logic_vector) return std_logic_vector is
variable result : signed(x'length + y'length - 1 downto 0) := signed(x) * signed(y);
begin
    equalLengths(x, y);
    return std_logic_vector(result(x'length - 1 downto 0));
end bc_signed_mul;

function bc_unsigned_mul(x, y : std_logic_vector) return std_logic_vector is
variable result : std_logic_vector(x'length + y'length - 1 downto 0) := unsigned(x) * unsigned(y);
begin
    equalLengths(x, y);
    return result(x'length - 1 downto 0);
end bc_unsigned_mul;

function bc_signed_lt(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(signed(x) < signed(y)); end bc_signed_lt;

function bc_signed_le(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(signed(x) <= signed(y)); end bc_signed_le;

function bc_signed_gt(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(signed(x) > signed(y)); end bc_signed_gt;

function bc_signed_ge(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(signed(x) >= signed(y)); end bc_signed_ge;

function bc_unsigned_lt(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(unsigned(x) < unsigned(y)); end bc_unsigned_lt;

function bc_unsigned_le(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(unsigned(x) <= unsigned(y)); end bc_unsigned_le;

function bc_unsigned_gt(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(unsigned(x) > unsigned(y)); end bc_unsigned_gt;

function bc_unsigned_ge(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(unsigned(x) >= unsigned(y)); end bc_unsigned_ge;

function bc_signed_ne(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(signed(x) /= signed(y)); end bc_signed_ne;

function bc_unsigned_ne(x, y : std_logic_vector) return stlv00 is
begin return bool2stlv(unsigned(x) /= unsigned(y)); end bc_unsigned_ne;

function isInBoolRange(x : stlv00) return boolean is
begin return (x(0) = '1') or (x(0) = '0'); end isInBoolRange;

function bc_bool_not(x : stlv00) return stlv00 is
begin  
    if x(0) = '1' then 
	return (others => '0'); 
    elsif x(0) = '0' then
	return (others => '1');
    else
	return x;
    end if;
end bc_bool_not;
    
function bc_bool_and(x, y : stlv00) return stlv00 is
begin
    if x(0) = '1' and y(0) = '1' then 
	return (others => '1');
    elsif isInBoolRange(x) and isInBoolRange(y) then
	return (others => '0');
    else
	return x;
    end if;
end bc_bool_and;

function bc_bool_or(x, y : stlv00) return stlv00 is
begin
    if isInBoolRange(x) and isInBoolRange(y) then
      if x(0) = '1' or y(0) = '1' then
	return (others => '1');
      else
        return (others => '0');
      end if;
    else
	return x;
    end if;
end bc_bool_or;

function bc_bool_xor(x, y : stlv00) return stlv00 is
begin
    if isInBoolRange(x) and isInBoolRange(y) then
      if x(0) = '1' xor y(0) = '1' then
	return (others => '1');
      else
        return (others => '0');
      end if;
    else
	return x;
    end if;
end bc_bool_xor;

function bc_unsigned_div_by_const(x : std_logic_vector; k : integer) return std_logic_vector is
variable result : unsigned(x'range);
begin
  result := conv_unsigned(conv_integer(unsigned(x)) / k, x'high - x'low + 1);
  return std_logic_vector(result);
end bc_unsigned_div_by_const;



function bc_any_sub(x : std_logic_vector; low : integer; high : integer) return std_logic_vector is 
begin
  return x(high downto low); 
end bc_any_sub;

function bc_sub_onebit(x : std_logic_vector; pos : integer) return stlv00 is 
variable result : stlv00; 
begin 
  result(0) := x(pos);
  return result; 
end bc_sub_onebit;

function bc_cat(x, y : std_logic_vector) return std_logic_vector is 
begin
  return x & y; 
end bc_cat; 

end bincompl;

