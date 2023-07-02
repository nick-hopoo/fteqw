// Here is my fancy little file where I sort of interject other files for my custom files for cleanliness.


// ================
// W_FireAxe, except it hooks.
// W_HookAxe
// ================
void() W_FireAxe =
{
	local   vector  source;
	local   vector  org;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	// original below line was source + v_forward*64, I increased 64 to increase range - Bizz
	traceline (source, source + v_forward*128, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

	if (trace_ent.takedamage)
	{
		SpawnBlood (org, 20);
		if (deathmatch > 3)
			T_Damage (trace_ent, self, self, 75, MOD_AXE);
		else
			T_Damage (trace_ent, self, self, 20, MOD_AXE);
	}
	else
	{       // hit wall
		sound (self, CHAN_WEAPON, "player/axhit2.wav", 1, ATTN_NORM);

		TE_gunshot(org);
		// attempting to fling player additively toward facing angle when striking wall - Bizz
		local vector helper;
		local vector desiredHorizontal;
		local vector currentHorizontal;
		local float desiredMaxSpeed;
		local float desiredY;
		local float desiredZ;
		desiredMaxSpeed = -1 * 500;
		helper = (self.origin - trace_endpos);
		helper = normalize(helper);
		local string debugString;
		// note to self: strip the vector apart and compare X Y and Z, then only make a change
		// to each component if the new component part is higher, we don't want to
		// do velocity + helper * -1 * magnitude desired because it'll stack forever, so instead
		// just send a little push.  The Z component should be additive, so you can't hook upward forever.
		// so X and Y can be set, but Z must be added.  X and Y are compared, Z isn't ever.
		// X and Y can be added BUT we'll have to check against some maximum 'gain speed', so
		// we can add it, but only up to like 500 units/ps or whatever.  That way you can
		// naturally go over max run speed for fun but you can't go to infinite crack speed
		// by repeating the motion indefinitely.
		desiredHorizontal.x = helper.x;
		desiredHorizontal.y = helper.y;
		desiredHorizontal.z = 0;
		currentHorizontal.x = self.velocity.x;
		currentHorizontal.y = self.velocity.y;
		currentHorizontal.z = 0;
		desiredHorizontal = desiredHorizontal * desiredMaxSpeed;

		if (vlen(desiredHorizontal) > vlen(currentHorizontal))
		{
			self.velocity.x = desiredHorizontal.x;
			self.velocity.y = desiredHorizontal.y;
		}

		self.velocity.z = self.velocity.z + helper.z * desiredMaxSpeed / self.BIZZ_AXECLIMB;
		if (self.BIZZ_AXECLIMB < 8)
		{
		self.BIZZ_AXECLIMB = self.BIZZ_AXECLIMB * 2;
		}
		dprint (ftos(self.BIZZ_AXECLIMB));
		//end of attempt
	}
};