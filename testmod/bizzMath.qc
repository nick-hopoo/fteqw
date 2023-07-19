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

// this is a repeat of anglemod that I wrote myself by accident, but it does account for when things ==360
// things go wrong if we dip into 360 or -360 instead of treating them as 0, so this is better for Sin/Cos etc.
float(float x) ClampTo360 =
{
	if (x > 360 || x < -360)
	{
		if (x >= 0)
		{
			while (x > 360)
			{
				x = x - 360;
			}
		}
		else 
		{
			while (x < -360)
			{
				x = x + 360;
			}
		}
	}

	if (x == 360 || x == -360)
	{
		x = 0;
	}

	return x;
};

float(float x) RadiansToDegrees =
	{
		float Degrees = x * 57.2957795131;
		Degrees = ClampTo360(Degrees);
		// above is 180/pi so we can go to Degrees.
		return Degrees;
	};
float(float x) DegreesToRadians =
	{
		x = ClampTo360(x);
		float Radians = x * 0.01745329251;
		// above is pi/180 so we can go to Radians.
		// dprint(ftos(x));
		// dprint(" converted to");
		// dprint(ftos(Radians));
		return Radians;
	};

	// We want to use 'taylor expansion' here to manually calc for Sine of "x", in degrees.
float(float x) Sine =
	{
		float Sine;
		x = DegreesToRadians(x);
		Sine = x - (ToExponent(x, 3)/ToFactorial(3)) + (ToExponent(x, 5) / ToFactorial(5)) - (ToExponent(x, 7) / ToFactorial(7)) + (ToExponent(x, 9) / ToFactorial(9));
		// dprint(" Sine is calculated as");
		// dprint(ftos(Sine));
		//dprint("Radians.")
		return Sine;
	};
float(float x) Cosine =
	{
		float Cosine;
		x = DegreesToRadians(x);
		Cosine = 1 - (ToExponent(x, 2)/ToFactorial(2)) + (ToExponent(x, 4) / ToFactorial(4)) - (ToExponent(x, 6) / ToFactorial(6)) + (ToExponent(x, 8) / ToFactorial(8));
		// dprint(" Cosine is calculated as");
		//dprint(ftos(Cosine));
		//dprint("Radians.")
		return Cosine;
	};
float(float oppositeLength, float adjacentLength) ArctangentFromLengths =
	{
		// just incase you fucking forgot, Arctangent finds "angle X" ( in rads ) by
		// arctan (oppositeSideLength / adjacentSideLength) = angle X
		// so u can get that lil angle on any right triangle/ two perpendicular vectors.
		// o|\
		// p| \
		// p|  \
		// o|   \
		// s|    \
		// i|     \
		// t|     x\
		// e----------
		//   adjacent
		float Arctangent;
		//float degrees;
		float x = oppositeLength / adjacentLength;
		Arctangent = x - (ToExponent(x, 3)/ 3) + (ToExponent(x, 5) / 5) - (ToExponent(x, 7) / 7) + (ToExponent(x, 9) / 9);
		// dprint(" Arctangent is calculated as");
		//  dprint(ftos(Arctangent));
		//  dprint("Radians or ");
		//  degrees = RadiansToDegrees(x);
		//  dprint(ftos(degrees));
		//  dprint(" degrees. ");
		return Arctangent;
	};
float(float x) Arctangent =
	{
		float Arctangent;
		//float degrees;
		Arctangent = x - (ToExponent(x, 3)/ 3) + (ToExponent(x, 5) / 5) - (ToExponent(x, 7) / 7) + (ToExponent(x, 9) / 9);
		// dprint(" Arctangent is calculated as");
		//  dprint(ftos(Arctangent));
		//  dprint("Radians or ");
		//  degrees = RadiansToDegrees(x);
		//  dprint(ftos(degrees));
		//  dprint(" degrees. ");
		return Arctangent;
	};

// below doesnt work in any anticipated way.  Might not be correct at all?
// should rotate a 2d vector 'horizontally' via the degreesDesired.  I dunno.
vector(vector vectorA, float degreesDesired) RotateVectorZAxis =
{
	float newX = Cosine(vectorA_x)* degreesDesired - Sine(vectorA_y)* degreesDesired;
	float newY = Sine(vectorA_x)* degreesDesired + Cosine(vectorA_y)* degreesDesired;
	vectorA_x = newX;
	vectorA_y = newY;
	return vectorA;
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