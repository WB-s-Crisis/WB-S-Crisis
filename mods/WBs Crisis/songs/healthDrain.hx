function create() {
	strumLines.members[0].onHit.add(function(event) {
		/**
		 * 主播主播😥
		 * 你的杨戬确实很强😋
		 * 但还是太吃操作了🤢
		 * 有没有更加简单又强势的英雄推荐一下呢😗
		 * ......
		 * 有的兄弟，有的😋
		 * 这么强的英雄当然不止一个啦🐵
		 * 一共有9位...👺
		 * 都是当前版本T0.5的强势英雄，兄弟👾
		 * 掌握一到两个的牢铁们上个荣耀白金小标都是没问题的😋
		 * 如果能掌握一半以上的牢铁们，英雄的话
		 * 打个巅峰巅峰前百前十都是相当轻松的😋
		 */
		var drain:{var max:Float; var min:Float;} = switch(SONG.meta.name.toLowerCase()) {
    		case "friendship broken": {max: 0.06, min: 0.007};
    		case "bloody scissors": {max: 0.105, min: 0.005};
    		case "he died unjustly" | "cruel cartoon": {max: 0.08, min: 0.005};
    		case "cruel cartoon erect": {max: 0.130, min: 0};
    		case "blood dispute": {max: 0.130, min: 0};
    		case "unprovoked": {max: 0.05, min: 0.007};
    		case "murder": {max: 0.05, min: 0.007};
    		default: {max: 0, min: 0};
		};
	
		health -= (((drain.max - drain.min) / maxHealth) * health);
	});
}

// 2 => 0.0
// 0 => 0.005

// 2*k + b = 0.05;
// b = 0.005
// 2k + 0.005 = 0.05
// 2k = 0.045
// k = 0.995 / 2