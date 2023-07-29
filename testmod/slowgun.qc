// squps slowgun idea.  It's a nailgun but it looks like a cartoon laser gun and
//shoots nails that are way too fucking slow lol

// /____  ____  _     ____  _  _  _ 
// / ___\/  _ \/ \ /\/  __\/ \/ \/ \
// |    \| / \|| | |||  \/|| || || |
// \___ || \_\|| \_/||  __/\_/\_/\_/
// \____/\____\\____/\_/   (_)(_)(_)
//squp
//bizz

void(float ox) W_FireSlowGun =
{
	if (self.ammo_nails_real < 1)
	{
		W_WeaponSwitch (W_BestWeapon ());
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/rocket1i.wav", 1, ATTN_NORM);
	if (deathmatch != 4)
	{
		self.ammo_nails_real -= 1;
		W_UpdateAmmoCounts(self);
	}

	VK_smallkick(self);
    //ref
    //void(entity parent, string modl, vector org, vector vel, INTEGER effect, INTEGER damg, INTEGER damgmod, float expiretime) PRJ_FireProjectile =
	// PRJ_FireProjectile(self,
	// 	"progs/spike.mdl",
	// 	self.origin + '0 0 16' + v_right*ox,
	// 	aim(self, 1000) * 25,
	// 	PE_SLOWGUN,
	// 	1,
	// 	MOD_SLOWGUN,
	// 	10);
    local float p = 10;
    local float offsetBullet = -60;
    while (p > 0)
    {
        p --;
        PRJ_FireProjectile(self,
            "progs/spike.mdl",
            self.origin + '0 0 0' + v_right*offsetBullet,
            aim(self, 1000) * 25,
            PE_SLOWGUN,
            1,
            MOD_SLOWGUN,
            10);
        offsetBullet = offsetBullet + 12;
    }
    
};

void (entity victim) slowgunEffect =
{
    dprint("woo");
    victim.bizz_slowgunafflictiontimer = 60 * 5;
    victim.bizz_slowgunvictimangle = self.velocity;
};

void (entity slowBullet) slowgunStartBounce =
{
};

