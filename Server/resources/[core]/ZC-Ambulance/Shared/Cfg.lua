Cfg = { }

Cfg.objects = {
	ButtonToLayOnBed = 38,
	SitAnimation = {anim='PROP_HUMAN_SEAT_CHAIR_MP_PLAYER'},
	BedBackAnimation = {dict='anim@gangops@morgue@table@', anim='ko_front'},
	BedStomachAnimation = {anim='WORLD_HUMAN_SUNBATHE'},
	BedSitAnimation = {anim='WORLD_HUMAN_PICNIC'},
	locations = {
		{object="v_med_bed2", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true},
		{object="v_med_emptybed", verticalOffsetX=0.0, verticalOffsetY=0.13, verticalOffsetZ=-0.2, direction=90.0, bed=true},
		{object="v_med_bed1", verticalOffsetX=0.0, verticalOffsetY=0.0, verticalOffsetZ=-1.4, direction=0.0, bed=true}
	}
}

Cfg.Text = {
	SitOnBed = '~y~E~w~ para ~g~sentarte~w~',
	LieOnBed = '~y~E~w~ para tumbarte~w~',
	SwitchBetween = 'Cambiar: ~y~Flecha Izq.~w~ y ~y~Flecha Der.~w~',
	Standup = '~y~X~w~ para levantarte',
}

Cfg.WhitelistedAdmins = {
    ["license:9b7d895c323517a30f137d06d744caa565600912"] = true,
}