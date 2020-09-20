/* conditionals involving more complicated boolean expressions */

  if (1 > 0 && 0 > -1)
    x = 1;

  if (1 >= 0 || 0 > -1)
    x = 1;
  else 
    x = 2;

  if (u < 0 || 0 == 1) 
    x = 1;
  else 
    x = 2;

  if (u <= x && x >= u) 
    x = 1;
  else 
    x = 2;

  if (u != x && x != y && y != z[z[z[0]]]) 
    x = 1;
  else 
    x = 2;

  if (!(u != x) && x == y)
    x = 1;
  else 
    x = 2;

  if (!!!!!!!!!!(u != x) && x == y)
    x = 1;
  else 
    x = 2;

  if (x > 0 && !(x <= y && !(y > 1 || !(u == x))) || (x <= y && !(y > 1 || !(u == x))))
    x = 1;
  else 
    x = 2;

  if (1 > 0 && 2 > 1 && 3 > 2 && 4 > 3 && 5 > 4 && 6 > 5 && 7 > 6 && 8 > 7 && 9 > 8)
    x = 1;


