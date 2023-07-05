#define crandom() (2*(random()-0.5))


void() PRJ_WarpTouch =
{
	local vector raiseMe;
	raiseMe.z = 32;
	self.owner.origin = self.origin + raiseMe;
	remove(self);
};

void() PRJ_WarpExpire =
{
	other = self;
	PRJ_WarpTouch();	
};

void() PRJ_SetBouncyWarpProjectile =
{
	newmis.proj_touch = _PRJ_Bounce;
	newmis.movetype = MOVETYPE_BOUNCE;
	newmis.avelocity = '0 333 0';
};

// replacement of PRJ_FireProjectile for warp
void(entity parent, string modl, vector org, vector vel, INTEGER effect, INTEGER damg, INTEGER damgmod, float expiretime) PRJ_FireWarpProjectile =
{
	newmis = spawn ();
	newmis.owner = parent;
	newmis.movetype = MOVETYPE_FLYMISSILE;
	newmis.solid = SOLID_BBOX;
//	newmis.classname = class;
	newmis.velocity = vel;

	newmis.damage_direct = damg;
	newmis.mod_direct = damgmod;
	newmis.proj_effect = effect;

	newmis.touch = PRJ_WarpTouch;
	newmis.expire_time = time + expiretime;

	newmis.think = PRJ_WarpExpire;
	newmis.nextthink = time + expiretime;

	
	newmis.angles = vectoangles(newmis.velocity);

	setmodel (newmis, modl);
	local vector bottomLeft;
	local vector topRight;
	bottomLeft = '-18 -18 -18';
	topRight = '18 18 18';
	setsize (newmis, bottomLeft, topRight);             
	setorigin (newmis, org);
	
	//
};

//w_firegrenade except it does no damage and only pushes you.
void() W_FireBounceBomb =
{
	local vector vel;

	if (deathmatch != 4)
	{
		self.ammo_rockets_real -= 1;
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

	VK_smallkick(self);
	PRJ_FireWarpProjectile(self, "progs/player.mdl", self.origin, vel, PE_EXPLOSIONGROUND, 0, 0, 2.5);
	PRJ_SetRadiusDamage(120, 160, MOD_GRENADE);
	PRJ_SetBouncyWarpProjectile();

	if (deathmatch == 4)
	{
		self.attack_finished = time + 1.1;
		T_Damage (self, self, self.owner, 10, MOD_GRENADE);
	}
};