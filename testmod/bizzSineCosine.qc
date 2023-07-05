//bizzSineCosine.qc
// QuakeC doesnt have sine or cosine so i'll have to just estimate it this ancient maths way
// kinda cool though math is kinda cool.
// this code is actually probably bad but i'll keep it here. It's lossy and weird dont use it.
float(float vari) RoughSine =
{
	local float Iteration1;
	local float Iteration2;
	local float Iteration3;
	local float Iteration4;
	local float Iteration5;
	local float Answer;

	Iteration1 = vari;
	Iteration2 = vari * vari * vari / 6;
	Iteration3 = vari * vari * vari * vari * vari / 120;
	Iteration4 = vari * vari * vari * vari * vari * vari * vari / 5040;
	Iteration5 = vari * vari * vari * vari * vari * vari * vari * vari * vari / 362880;
	Answer = Iteration1 - Iteration2 + Iteration3 - Iteration4 + Iteration5;
	return Answer;
	
};

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