-- Minlevel and multiplier are MANDATORY
-- Maxlevel is OPTIONAL, but is considered infinite by default
-- Create a stage with minlevel 1 and no maxlevel to disable stages
experienceStages = {
	{
		minlevel = 1,
		maxlevel = 60,
		multiplier = 100
	}, {
		minlevel = 61,
		maxlevel = 100,
		multiplier = 60
	}, {
		minlevel = 101,
		maxlevel = 130,
		multiplier = 40
	}, {
		minlevel = 131,
		maxlevel = 150,
		multiplier = 30
	}, {
		minlevel = 151,
		maxlevel = 180,
		multiplier = 25
	}, {
		minlevel = 181,
		maxlevel = 200,
		multiplier = 20
	}, {
		minlevel = 201,
		maxlevel = 300,
		multiplier = 16
	}, {
		minlevel = 301,
		maxlevel = 400,
		multiplier = 13
	}, {
		minlevel = 401,
		maxlevel = 500,
		multiplier = 10
	}, {
		minlevel = 501,
		maxlevel = 600,
		multiplier = 8
	}, {
		minlevel = 601,
		maxlevel = 700,
		multiplier = 6
	}, {
		minlevel = 701,
		maxlevel = 800,
		multiplier = 4
	}, {
		minlevel = 801,
		maxlevel = 900,
		multiplier = 3
	}, {
		minlevel = 901,
		multiplier = 2
	}
}

skillsStages = {
	{
		minlevel = 10,
		maxlevel = 60,
		multiplier = 100
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 50
	}, {
		minlevel = 81,
		maxlevel = 110,
		multiplier = 30
	}, {
		minlevel = 111,
		maxlevel = 125,
		multiplier = 17
	}, {
		minlevel = 126,
		multiplier = 15
	}
}

magicLevelStages = {
	{
		minlevel = 0,
		maxlevel = 60,
		multiplier = 30
	}, {
		minlevel = 61,
		maxlevel = 80,
		multiplier = 20
	}, {
		minlevel = 81,
		maxlevel = 100,
		multiplier = 15
	}, {
		minlevel = 101,
		maxlevel = 110,
		multiplier = 11
	}, {
		minlevel = 111,
		maxlevel = 125,
		multiplier = 10
	}, {
		minlevel = 126,
		multiplier = 9
	}
}
