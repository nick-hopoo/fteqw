//bizzSineCosine.qc
// QuakeC doesnt have sine or cosine so i'll have to just estimate it this ancient maths way
// kinda cool though math is kinda cool.
// this code is actually probably bad but i'll keep it here. It's lossy and weird dont use it.

//function used to modulo 360 deg angles back to within 360 deg.  This was in the AI code first, shifted here.
float(float v) anglemod =
{
	while (v >= 360)
	{
		v = v - 360;
	}
	while ((v < FALSE))
	{
		v = v + 360;
	}
	return v;
};

//function used to set angles to nearest 90 if we want them to square up to the grid. best used with anglemodded variables
float(float ang) ToNearest90 =
{
	ang = anglemod(ang);

	if (ang < 45)
	{
		ang = 0;
	}
	else if (ang < 135)
	{
		ang = 90;
	}
	else if (ang < 225)
	{
		ang = 180;
	}
	else if (ang < 315)
	{
		ang = 270;
	}
	else
	{
		ang = 0;
	}

	return ang;
};


// generic function to generate an exponent of (initialvalue ^ exponentvalue)
float(float initialvalue, float exponentvalue) ToExponent =
{
	local float Answer;
	Answer = initialvalue;
	while (exponentvalue > 1)
	{
		Answer = initialvalue * Answer;
		exponentvalue = exponentvalue - 1;
	}
	return Answer;
};

// generic function to generate factorial, or (x)! .  Everything multiplied by the things before it. 4 * 3 * 2 * 1 etc.
float(float number) ToFactorial =
{
	local float fact = 1;
	local float i = 2;
	while (i <= number)
	{
		fact = i * fact;
		i = i + 1;
	}
	return fact;
};

// this shit does not work yet, its miswritten but we would use the factorial and exponent code to solve it.
float(float vari) RoughSine =
{
	local float helper;
	local float helper2;
	local float Answer;
	local float iterationsDesired;
	local float goNext;

	goNext = 0;
	iterationsDesired = 10;
	Answer = 0;

	while (iterationsDesired >= 1)
	{
		Answer = ToExponent(-1, iterationsDesired);
		helper = (2 * iterationsDesired) + 1;
		helper = ToFactorial(helper);
		Answer = Answer / helper;
		helper2 = (2 * iterationsDesired) + 1;
		helper = ToExponent(vari, helper2);

		iterationsDesired = iterationsDesired - 1;
		
		Answer + goNext;
		goNext = Answer * helper;
	}
	
	

	// Iteration1 = vari;
	// Iteration2 = vari * vari * vari / 6;
	// Iteration3 = vari * vari * vari * vari * vari / 120;
	// Iteration4 = vari * vari * vari * vari * vari * vari * vari / 5040;
	// Iteration5 = vari * vari * vari * vari * vari * vari * vari * vari * vari / 362880;
	// Answer = Iteration1 - Iteration2 + Iteration3 - Iteration4 + Iteration5;

	dprint("the sine is");
	dprint(ftos(goNext));
	//33sin deg = .54463
	//33sin rad = 0.999911860
	return goNext;
	
};

// this shit is even further behind the above code.  I'll finish both someday maybe, though sine and cosine use is limited.
float(float vari) RoughCosine =
{
	local float Iteration1;
	local float Iteration2;
	local float Iteration3;
	local float Iteration4;
	local float Answer;

	Iteration1 = vari * vari / 2;
	Iteration2 = vari * vari * vari * vari / 24;
	Iteration3 = vari * vari * vari * vari * vari * vari / 720;
	Iteration4 = vari * vari * vari * vari * vari * vari * vari * vari / 40320;
	Answer = 1 - Iteration1 + Iteration2 - Iteration3 + Iteration4;
	return Answer;
};

                                                                                   
// pog
// BBBBBBBBBBBBBBBBB        IIIIIIIIII     ZZZZZZZZZZZZZZZZZZZ     ZZZZZZZZZZZZZZZZZZZ
// B::::::::::::::::B       I::::::::I     Z:::::::::::::::::Z     Z:::::::::::::::::Z
// B::::::BBBBBB:::::B      I::::::::I     Z:::::::::::::::::Z     Z:::::::::::::::::Z
// BB:::::B     B:::::B     II::::::II     Z:::ZZZZZZZZ:::::Z      Z:::ZZZZZZZZ:::::Z 
//   B::::B     B:::::B       I::::I       ZZZZZ     Z:::::Z       ZZZZZ     Z:::::Z  
//   B::::B     B:::::B       I::::I               Z:::::Z                 Z:::::Z    
//   B::::BBBBBB:::::B        I::::I              Z:::::Z                 Z:::::Z     
//   B:::::::::::::BB         I::::I             Z:::::Z                 Z:::::Z      
//   B::::BBBBBB:::::B        I::::I            Z:::::Z                 Z:::::Z       
//   B::::B     B:::::B       I::::I           Z:::::Z                 Z:::::Z        
//   B::::B     B:::::B       I::::I          Z:::::Z                 Z:::::Z         
//   B::::B     B:::::B       I::::I       ZZZ:::::Z     ZZZZZ     ZZZ:::::Z     ZZZZZ
// BB:::::BBBBBB::::::B     II::::::II     Z::::::ZZZZZZZZ:::Z     Z::::::ZZZZZZZZ:::Z
// B:::::::::::::::::B      I::::::::I     Z:::::::::::::::::Z     Z:::::::::::::::::Z
// B::::::::::::::::B       I::::::::I     Z:::::::::::::::::Z     Z:::::::::::::::::Z
// BBBBBBBBBBBBBBBBB        IIIIIIIIII     ZZZZZZZZZZZZZZZZZZZ     ZZZZZZZZZZZZZZZZZZZ                                                                            