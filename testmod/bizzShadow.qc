// its the code for the shadow that follows under you when you jump
// I should utilize the vore code potentially to get it to 'follow' you though I think
//I could also just use the think function and update it rapidly enough to beneath u.

$cd testmod/progs/shadowplane
$frame Key1 Key2 Key3 Key4 Key5 Key6 Key7 Key8 Key9 Key10

void()  shadow_Key1 =[        $Key1,       shadow_Key1   ] {};
void( ) shadow_Key2  =[      $Key2, shadow_Key3 ] {};
void( ) shadow_Key3  =[      $Key3, shadow_Key4 ] {};
void( ) shadow_Key4  =[      $Key4, shadow_Key5 ] {};
void( ) shadow_Key5  =[      $Key5, shadow_Key6 ] {};
void( ) shadow_Key6  =[      $Key6, shadow_Key7 ] {};
void( ) shadow_Key7  =[      $Key7, shadow_Key8 ] {};
void( ) shadow_Key8  =[      $Key8, shadow_Key9 ] {};
void( ) shadow_Key9  =[      $Key9, shadow_Key9 ] {};
void() shadow_Key10  =[      $Key10, shadow_null ] {};

void() shadow_null =
{
    return;
};

void(entity shadow)updateShadow =
{
    local float framesRangeDesired;
    local float n;
	local vector source = '0 0 1';
    local float distanceToMeasure = 256;
	traceline (self.origin, self.origin + source*-1*distanceToMeasure, TRUE, self);
    local float distanceBelow = self.origin_z - trace_endpos_z;
    if (self.flags & FL_ONGROUND)
    {
        local float isGrounded = TRUE;
    }
    else
    {
        isGrounded = FALSE;
    }
    if (trace_fraction != 1 && isGrounded == FALSE)
    {
        local vector org = trace_endpos;
        org_z = org_z + 5;
        setorigin (shadow, org);
        // old bad iterative shadow size check
        // while (trace_fraction < n*distanceToMeasure / distanceToMeasure && n > 0)
        // {
        //     shadow.frame = iterativeShadowSize;
        //     n = n - 0.1;
        //     iterativeShadowSize ++;
        // }
        local float scaleUp = 0.2;
        if (trace_fraction < scaleUp)
        {
            framesRangeDesired = 5;
            n = rint(trace_fraction * 1/scaleUp * framesRangeDesired);
        }
        else
        {
            //get the shadow size out of the X frames we care about because later ones are too big
            framesRangeDesired = 5;
            //invert to get big to small instead of small to big
            n = framesRangeDesired - rint(trace_fraction * framesRangeDesired);
        }
        shadow.frame = n;
    }
    else
    {
        // this just hides the shadow at world origin.
        setorigin (shadow, VEC_ORIGIN);
    }
    
};

void(float size)shadowSize =
{
    shadow_Key9();
    return;
};

void(entity player)createShadow = 
{
    if (player.BIZZ_SHADOW.classname != "bizzShadow")
    {
        
        local vector source = '0 0 1';
	    traceline (self.origin, self.origin + source*-256, TRUE, self);
        if (trace_fraction != 1)
        {
            newmis = spawn ();
            newmis.owner = player;
            newmis.movetype = MOVETYPE_NOCLIP;
            newmis.solid = SOLID_NOT;
            newmis.classname = "bizzShadow";
            setmodel (newmis, "progs/shadowplane.mdl");
            newmis.angles_x = 90;
            newmis.angles_y = 0;
            newmis.angles_z = 0;
            local vector org = trace_endpos;
            org_z = org_z + 5;
            setorigin (newmis, org);
            player.BIZZ_SHADOW = newmis;
            
        }
        
    }
};

// dont use this, just hide the shadow.
void(entity shadow)destroyShadow =
{
    if (self.flags & FL_ONGROUND)
	{
		remove(shadow);
	}
};

// void(entity parent, string modl, vector org, float oldXAng, float oldYAng, float oldZAng) CreateBoxWithCollision =
// {
// 	//dprint("fire");
// 	newmis = spawn ();
// 	newmis.movetype = MOVETYPE_STEP;
// 	newmis.solid = SOLID_BBOX;
// 	newmis.classname = "bizzCrate";

// 	setmodel (newmis, modl);
// 	//set angle to nearest 90 so it can always match hitbox but also be near its last visual rotation on landing
// 	newmis.angles_x = ToNearest90(oldXAng);
// 	newmis.angles_y = ToNearest90(oldYAng);
// 	newmis.angles_z = ToNearest90(oldZAng);

// 	local vector bottomLeft;
// 	local vector topRight;
// 	bottomLeft = '-16 -16 -16';
// 	topRight = '16 16 16';
// 	setsize (newmis, bottomLeft, topRight); 
// 	//dprint(ftos(newmis.angles_y));          
// 	setorigin (newmis, org);
// 	newmis.think = UnstuckParent;
// 	newmis.nextthink = time + 0.1;

// 	//below i am storing the old x y and z into axeclimb via digits so i can ask later how to tilt them based on
// 	//their previously percieved rotational arc.
// 	// I'll split them afterwards in SettleAnimation;
// 	//newmis.BIZZ_AXECLIMB = newmis.owner.angles_x * 1000000 + newmis.owner.angles_y * 1000 + newmis.owner.angles_z;
// 	//newmis.think = SettleAnimation;
// 	//newmis.nextthink = time + 0.05;
// };

// /*
// ================
// ShalMissile
// ================
// */
// float() ShalMissileTouch;
// void() ShalHome;
// void() ShalMissile =
// {
// 	local	vector	dir;
// 	local	float	dist, flytime;

// 	dir = normalize((self.enemy.origin + '0 0 10') - self.origin);
// 	dist = vlen (self.enemy.origin - self.origin);
// 	flytime = dist * 0.002;
// 	if (flytime < 0.1)
// 		flytime = 0.1;

// 	muzzleflash();
// 	sound (self, CHAN_WEAPON, "shalrath/attack2.wav", 1, ATTN_NORM);

// 	PRJ_FireProjectile(self,
// 		"progs/v_spike.mdl",
// 		self.origin + '0 0 10',
// 		dir * 400,
// 		PE_EXPLOSION,
// 		0,
// 		0,
// 		30);
// 	PRJ_SetRadiusDamage(40, 80, MOD_SHALRATH);
// 	PRJ_SetThink(ShalHome, flytime, 0.2);
// 	PRJ_SetTouch(ShalMissileTouch);
// 	newmis.avelocity = '300 300 300';
// 	newmis.enemy = self.enemy;
// };

// void() ShalHome =
// {
// 	local vector	dir, vtemp;
// 	vtemp = self.enemy.origin + '0 0 10';
// 	if (self.enemy.health < 1)
// 	{
// 		remove(self);
// 		return;
// 	}

// 	dir = normalize(vtemp - self.origin);
// 	if (skill > 2)
// 		self.velocity = dir * 350;
// 	else
// 		self.velocity = dir * 250;
// };

// float() ShalMissileTouch =
// {
// 	if (other.classname == "monster_zombie")
// 		T_Damage (other, self, self, 110, MOD_SHALRATH);	

// 	return 0; // always explode on touch
// };