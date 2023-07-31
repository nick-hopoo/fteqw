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

void () slowgunAffliction =
{
    //do the stupid slowgun affliction bizz
        if (self.owner.bizz_slowgunafflictiontimer > 0 && self.owner.bizz_slowgunvictimpoppedup == 0)
        {
            self.owner.origin_z = self.owner.origin_z + 5;
            self.owner.velocity = self.owner.bizz_slowgunvictimangle * 10;
            self.owner.bizz_slowgunafflictiontimer = self.owner.bizz_slowgunafflictiontimer - 1;
            // test that this numberactually goes down vvvvv
            dprint (ftos(self.owner.bizz_slowgunafflictiontimer));
            self.owner.bizz_slowgunvictimpoppedup = 1;
        }
        else if (self.owner.bizz_slowgunafflictiontimer > 0)
        {
            if (vlen(self.owner.velocity) < vlen(self.owner.bizz_slowgunvictimangle) * 10 / 10)
            {
                self.owner.bizz_slowgunafflictiontimer = 0;
                T_Damage (self.owner, world, world, 50, MOD_SLOWGUN); 
                sound (self.owner, CHAN_VOICE, "player/land2.wav", 1, ATTN_NORM);
            }
            else
            {
                self.owner.velocity = self.owner.bizz_slowgunvictimangle * 10;
                self.owner.bizz_slowgunafflictiontimer --;
                // test that this numberactually goes down vvvvv
                dprint (ftos(self.owner.bizz_slowgunafflictiontimer));
            }
            
        }
        else if (self.owner.bizz_slowgunafflictiontimer == 0 && self.owner.bizz_slowgunvictimpoppedup == 1)
        {
            self.owner.bizz_slowgunvictimpoppedup = 0;
            remove(self);
        }
        self.nextthink = time + 0.1;
        

    //end affliction
};

void (entity victim) createSlowgunTimer = 
{
    local entity slowguntimer;

    slowguntimer = spawn();
    slowguntimer.owner = victim;
	slowguntimer.nextthink = time + 0.1;
	slowguntimer.think = slowgunAffliction;
}

void (entity victim) slowgunEffect =
{
    dprint("woo");
    //the time below has to respect the think step's speed to get 'seconds'.  We current are thinking at 0.1 thinks per second, so *10
    victim.bizz_slowgunafflictiontimer = 5 * 10;
    victim.bizz_slowgunvictimangle = self.velocity;
    createSlowgunTimer(victim);
};

