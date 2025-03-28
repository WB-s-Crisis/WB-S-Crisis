importScript("data/scripts/game/MachineDodge");

function create() {
	drainCount = 2;
	drainMax = 2;
}

//还得感谢雪溪留了个那么死妈的文件给我
function stepHit(step:Int) {
	switch(step) {
		case 496 | 526 | 591 | 616 | 674 | 980 | 1016 | 1042 | 1075 | 1098 | 1115 | 1157 | 2046 | 2082 | 2115 | 2143 | 2191 | 2262:
			execute();
	}
}