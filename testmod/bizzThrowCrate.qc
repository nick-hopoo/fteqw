#define crandom() (2*(random()-0.5))



// void() WarpMe =
// {
// 	local vector raiseMe;
// 	raiseMe.z = 0;
// 	self.owner.origin = self.origin + raiseMe;
// 	remove(self);
// };

void(entity struckCrate) AutoSwitchToCratesOnAxeHit =
{
	remove(struckCrate);
	self.ammo_crates_real = 1;
	W_UpdateAmmoCounts(self);
	self.weapon = IT_CRATES;
	self.weaponmodel = "progs/v_holdbox.mdl";
	self.items = self.items | IT_CRATES;
	self.ammo_type = AT_CRATES;
	self.weaponframe = 0;
};

void() WaitForPlayerExit =
{
	local float StopThinking = 0;
	local entity foundThing;
	local float Attempts = 5;
	foundThing=findradius(self.origin, 55);
	while (foundThing && Attempts > 0)
	{
		if (foundThing.classname == "player")
		{
			self.owner = foundThing;
			self.think = WaitForPlayerExit;
	 		self.nextthink = time + 0.1;
			return;
		}
		else
		{
			self.owner = self;
			StopThinking = 1;
			foundThing=foundThing.chain; 
		}
		Attempts = Attempts - 1;
	}
	if (StopThinking == 0)
	{
		self.think = WaitForPlayerExit;
		self.nextthink = time + 0.1;
	}
	
};

void(float timeFired) UnstuckParent =
{
	local entity foundThing;
	local float Attempts = 5;
	foundThing=findradius(self.origin, 55);
	while (foundThing && Attempts > 0)
	{
		if (foundThing.classname == "player")
		{
			dprint("Found a player!");
			self.owner = foundThing;
			WaitForPlayerExit();
			return;
		}
		else
		{
			foundThing=foundThing.chain; 
		}
		Attempts = Attempts - 1;
	}
};

// fuck this below thing i dont care anymore lol
void(float xOldAng, float yOldAng, float zOldAng) SettleAnimation =
{
	self.avelocity_x = self.avelocity_x + 2;
	self.avelocity_y = self.avelocity_y + 2;
	self.avelocity_z = self.avelocity_z + 2;
	self.think = SettleAnimation;
	self.nextthink = time + 0.05;
};

void(entity parent, string modl, vector org, float oldXAng, float oldYAng, float oldZAng) CreateBoxWithCollision =
{
	//dprint("fire");
	newmis = spawn ();
	newmis.movetype = MOVETYPE_STEP;
	newmis.solid = SOLID_BBOX;
	newmis.classname = "bizzCrate";

	setmodel (newmis, modl);
	//set angle to nearest 90 so it can always match hitbox but also be near its last visual rotation on landing
	newmis.angles_x = ToNearest90(oldXAng);
	newmis.angles_y = ToNearest90(oldYAng);
	newmis.angles_z = ToNearest90(oldZAng);

	local vector bottomLeft;
	local vector topRight;
	bottomLeft = '-16 -16 -16';
	topRight = '16 16 16';
	setsize (newmis, bottomLeft, topRight); 
	//dprint(ftos(newmis.angles_y));          
	setorigin (newmis, org);
	newmis.think = UnstuckParent;
	newmis.nextthink = time + 0.1;

	//below i am storing the old x y and z into axeclimb via digits so i can ask later how to tilt them based on
	//their previously percieved rotational arc.
	// I'll split them afterwards in SettleAnimation;
	//newmis.BIZZ_AXECLIMB = newmis.owner.angles_x * 1000000 + newmis.owner.angles_y * 1000 + newmis.owner.angles_z;
	//newmis.think = SettleAnimation;
	//newmis.nextthink = time + 0.05;
};

void() PRJ_WarpExpire =
{
	other = self;
	//make the final hitbox-ready art.
	CreateBoxWithCollision(self, "progs/movecube.mdl", self.origin, self.angles_x, self.angles_y,self.angles_z);
	remove(self);
};

void() PRJ_StoppedForAwhile =
{
	//reparent to self so it can bonk player but they dont get stuck inside immediately
	//, probably honestly shouldnt do it this way
	if(self.owner.classname == "player")
	{
		self.owner = self;
	}

	if (self.BIZZ_AXECLIMB == 7)
	{
		//setting to higher number to check to see if we stayed in the same state for 2 checks in a row
		self.BIZZ_AXECLIMB = 8;
			local vector lookDown = '0 0 -1';
			traceline (self.origin, self.origin + lookDown*17, FALSE, self);
			if (trace_fraction != 1.0)
			{
				if (trace_ent.classname == "player")
				{
					self.movetype = MOVETYPE_WALK;
				}
				else
				{
					PRJ_WarpExpire();
					return;
				}
			}
		
	}
	else if (self.BIZZ_AXECLIMB == 8)
	{
		
			local vector lookDown = '0 0 -1';
			traceline (self.origin, self.origin + lookDown*17, FALSE, self);
			if (trace_fraction != 1.0)
			{
				if (trace_ent.classname == "player")
				{
					self.movetype = MOVETYPE_WALK;
				}
				else
				{
					PRJ_WarpExpire();
					return;
				}
			}
		
	}
	else if (self.velocity == '0 0 0')
	{
		// setting to strange number while still
		self.BIZZ_AXECLIMB = 7;
		local vector lookDown = '0 0 -1';
			traceline (self.origin, self.origin + lookDown*17, FALSE, self);
			if (trace_fraction != 1.0)
			{
				if (trace_ent.classname == "player")
				{
					self.movetype = MOVETYPE_WALK;
				}
			}
			else
			{
				PRJ_WarpExpire();
				return;
			}
		
	}
	
	self.nextthink = time + 0.05;
};

void() PRJ_WarpTouch =
{
	//spin less every time you bump
	self.avelocity_x = self.avelocity_x / 2;
	self.avelocity_y = self.avelocity_y / 2;
	self.avelocity_z = self.avelocity_z / 2;

	//only allow 3 bounces
	if (self.BIZZ_AXECLIMB < 2)
	{
		self.BIZZ_AXECLIMB = self.BIZZ_AXECLIMB + 1;
	}
	else
	{
		//check if actually standing
		local vector lookDown = '0 0 -1';
		traceline (self.origin, self.origin + lookDown*17, FALSE, self);
		if (trace_fraction != 1.0)
		{
			if (trace_ent.classname != "player")
			{
				PRJ_WarpExpire();
			}
			else
			{
				self.movetype = MOVETYPE_WALK;
			}
		}
	}
		
};

float() PRJ_DampenedBounce =
//honestly all this code might be worthless, I could probably just use _PRJ_Bounce
{
	if (other.takedamage == DAMAGE_AIM)
		return 0; // explode

	sound (self, CHAN_WEAPON, "weapons/bounce.wav", 1, ATTN_NORM);  // bounce sound
	
	if (self.velocity == '0 0 0')
		self.avelocity = '0 0 0';

	return 1; // keep bouncing
};

void() PRJ_SetBouncyWarpProjectile =
// this code is only valuable over _PRJ_SetBounceProjectile because i can do custom avelocity here.
{
	newmis.proj_touch = PRJ_DampenedBounce;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.avelocity = '0 333 0';
};

// replacement of PRJ_FireProjectile for warp
void(entity parent, string modl, vector org, vector vel, INTEGER effect, INTEGER damg, INTEGER damgmod, float expiretime) PRJ_FireWarpProjectile =
{
	newmis = spawn ();
	newmis.owner = parent;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_SLIDEBOX;
	newmis.classname = "bizzCrate";
	newmis.velocity = vel;

	newmis.damage_direct = damg;
	newmis.mod_direct = damgmod;
	newmis.proj_effect = effect;

	newmis.touch = PRJ_WarpTouch;
	newmis.expire_time = time + expiretime;
	// enter the check for if we've been still for more than a few frames
	newmis.think = PRJ_StoppedForAwhile;
	newmis.nextthink = time + 0.1;

	
	newmis.angles = vectoangles(newmis.velocity);

	setmodel (newmis, modl);
	local vector bottomLeft;
	local vector topRight;
	// 16 is a magic number that i just think is like a unit, i could probably just use a bounding box.
	bottomLeft = '-16 -16 -16';
	topRight = '16 16 16';
	setsize (newmis, bottomLeft, topRight);             
	setorigin (newmis, org);
	
	//
};

//w_firegrenade except it does no damage and only pushes you.
void() W_FireCrate =
{
	local vector vel;
	// all the deathmatch code is probably worthless but I won't remove it.
	if (deathmatch != 4)
	{
		self.ammo_crates_real -= 1;
		W_UpdateAmmoCounts(self);
	}
	
	sound (self, CHAN_WEAPON, "weapons/grenade.wav", 1, ATTN_NORM);

	if (self.v_angle_x)
		vel = v_forward*600 + v_up * 200 + crandom()*v_right*10 + crandom()*v_up*10;
	else
	{
		vel = aim(self, 10000) * 600;
		vel_z = 200;
	}
	//bad check to just keep this thing always faster than you
	if (vlen(vel) <= vlen(self.velocity))
	{
		vel_x = vel_x + self.velocity_x;
		vel_y = vel_y + self.velocity_y;
		vel_z = vel_z + self.velocity_z;
	}

	VK_smallkick(self);
	//below sets everything in motion for the custom behavior
	PRJ_FireWarpProjectile(self, "progs/movecube.mdl", self.origin, vel, PE_EXPLOSIONGROUND, 0, 0, 2.5);
	//the damage probably isn't worth anything but maybe we'll use it for bumping stuff dmg? probably not.
	PRJ_SetRadiusDamage(120, 160, MOD_GRENADE);
	//below is probably important too since its custom from above
	PRJ_SetBouncyWarpProjectile();
	// all the deathmatch code is probably worthless but I won't remove it.
	if (deathmatch == 4)
	{
		self.attack_finished = time + 1.1;
		T_Damage (self, self, self.owner, 10, MOD_GRENADE);
	}
};