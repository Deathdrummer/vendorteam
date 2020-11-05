const 	domain			= 'vendorteam.loc', // прописать домен
		prodDir			= 'production', // директория для продакшн версии

		{src, dest, parallel, series, watch} = require('gulp'),
		browserSync    	= require('browser-sync').create(),
		babel			= require('gulp-babel');
		gulpUtil      	= require('gulp-util'),
		sass           	= require('gulp-sass'),
		sass.compiler 	= require('node-sass'),
		connectPhp     	= require('gulp-connect-php'),
		concat         	= require('gulp-concat'),
		uglify         	= require('gulp-uglify'),
		cleanCSS       	= require('gulp-clean-css'),
		rename         	= require('gulp-rename'),
		del            	= require('del'),
		cache          	= require('gulp-cache'),
		autoprefixer   	= require('gulp-autoprefixer'),
		bourbon        	= require('node-bourbon'),
		notify         	= require("gulp-notify"),
		tinypng 		= require('gulp-tinypng-compress'),
		cheerio     	= require("gulp-cheerio"),
		replace   		= require("gulp-replace"),
		svgSprite    	= require("gulp-svg-sprite"),
		svgmin         	= require("gulp-svgmin"),
		
		args        	= require('yargs').argv, // gulp t(название функции) --env(переменная) [аргументы]
		dirTree 		= require("directory-tree"),
		publicDirs		= dirTree('../public/views/').children; // директории public
		






// Отслеживание файлов
function startWatch() {
	var watchDirs = args.dirs != undefined ? args.dirs.split(',') : publicDirs;
	
	browserSync.init({
		//server: {baseDir: '../'},
		proxy: domain,
		notify: false,
		online: true,
		open: false
	})
	
	watch('../public/svg/icons/**/*.svg', svg);
	watch(['../public/css/assets/**/*.{sass,scss}', '../public/css/libraries/**/*.{sass,scss}', '../public/css/styles/*.{sass,scss}'], sassToCss);
	watch('../public/js/plugins/**/*.css', pluginsCss);
	watch(['../public/js/assets/**/*.js'], pluginsJs);
	
	if (watchDirs) {
		var jsDirs = [];
		watchDirs.forEach(function(dir) {
			var dirName = dir.name || dir;
			watch('../public/js/'+dirName+'.js').on('change', browserSync.reload);;	
			watch(['../public/views/'+dirName+'/**/*.tpl']).on('change', browserSync.reload);
		});
	} else {
		console.log('Нет директорий для отслеживания файлов!');
	}
}






// Формирование паблик версии
async function build() {
	await src(['../app/**/*']).pipe(dest('../'+prodDir+'/app'));
	await src(['../system/**/*']).pipe(dest('../'+prodDir+'/system'));
	await src(['../index.php', '../.htaccess']).pipe(dest('../'+prodDir));
	await src('../public/css/plugins.min.css').pipe(cleanCSS()).pipe(dest('../'+prodDir+'/public/css'));
	await src('../public/js/plugins.min.js')
	.pipe(babel())
	.pipe(uglify().on('error', function(err) {
		gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
		this.emit('end');
	}))
	.pipe(dest('../'+prodDir+'/public/js'));
	
	await src(['../public/js/assets/common.js', '../public/js/assets/functions.js'])
	.pipe(babel())
	.pipe(uglify().on('error', function(err) {
		gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
		this.emit('end');
	}))
	.pipe(dest('../'+prodDir+'/public/js/assets'));
	
	await src('../public/fonts/**/*').pipe(dest('../'+prodDir+'/public/fonts'));
	await src('../public/images/**/*.svg').pipe(dest('../'+prodDir+'/public/images'));
	await src('../public/svg/sprite.svg').pipe(dest('../'+prodDir+'/public/svg'));
	await src('../public/filemanager/**/*').pipe(dest('../'+prodDir+'/public/filemanager'));
	
	
	publicDirs.forEach(function(dir) {
		var dirName = dir.name;
		
		src(['../public/views/'+dirName+'/**/*.tpl']).pipe(dest('../'+prodDir+'/public/views/'+dirName));
		src('../public/css/'+dirName+'.min.css').pipe(cleanCSS()).pipe(dest('../'+prodDir+'/public/css/'));
		src('../public/js/'+dirName+'.js')
		.pipe(babel())
		.pipe(uglify().on('error', function(err) {
			gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
			this.emit('end');
		}))
		.pipe(dest('../'+prodDir+'/public/js'));
	});
}






exports.default 	= series(clearcache, parallel(sassToCss, pluginsCss, pluginsJs, svg), startWatch);
exports.b 			= series(clearcache, removedist, parallel(sassToCss, pluginsCss, pluginsJs, svg, imagemin), build);



//-------------------------------------------------------------------------------------------------------------



  




// REMOVEDIST
async function removedist() {
	return await del.sync('../'+prodDir, {force: true});
}


// CLEARCACHE
function clearcache() {
	return cache.clearAll();
}


// JS Скрипты: css
function pluginsCss() {
	return src(['../public/js/assets/plugins/**/*.css'])
	.pipe(concat('plugins.min.css'))
	.pipe(autoprefixer(['> 1%', 'last 10 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
	.pipe(dest('../public/css'))
	.pipe(browserSync.stream());
}

// JS Скрипты: js
function pluginsJs() {
	return src([
		'../public/js/assets/plugins/jquery/jquery-3.2.1.min.js',
		'../public/js/assets/plugins/jquery/jquery.migrate.js',
		'../public/js/assets/plugins/jquery/ui/**/*.js',
		'../public/js/assets/plugins/jquery/**/*.js',
		'../public/js/assets/plugins/**/*.js'
	])
	.pipe(concat('plugins.min.js'))
	.pipe(babel({compact: false}))
	.pipe(dest('../public/js'))
	.pipe(browserSync.stream());
}





// SASS
function sassToCss(done) {
	let sassFiles = [];
	publicDirs.forEach(function(dir) {sassFiles.push('../public/css/styles/'+dir.name+'.sass');});
	
	return src(sassFiles).on('end', done)
	.pipe(sass({includePaths: bourbon.includePaths}).on("error", notify.onError()))
	.pipe(rename({suffix: '.min', prefix : ''}))
	.pipe(autoprefixer(['> 1%', 'last 10 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
	.pipe(dest('../public/css/'))
	.pipe(browserSync.stream());
	
}


// IMAGES
function imagemin() {
	return src('../public/images/**/*.{png,jpg,jpeg,gif,ico}')
	.pipe(tinypng({
		key: 'aQsAF4hQiCt4tKRrcqo9E32Mm3FCWFef',
		sigFile: '../public/images/.tinypng-sigs',
		parallel: true,
		parallelMax: 50,
		summarize: true,
	}))
	.pipe(dest('../'+prodDir+'/public/images'));
}



// SVG
function svg() {
	return src('../public/svg/icons/**/*.svg')
	.pipe(svgmin({js2svg: {pretty: true}	}))
	.pipe(cheerio({
		run: function($) {
			$('[fill]').removeAttr('fill');	
			$('[stroke]').removeAttr('stroke');	
			$('[style]').removeAttr('style');	
		},
		parserOptions: {xmlMode: true}
	}))
	.pipe(replace('&gt;', '>'))
	.pipe(svgSprite({
		mode: {
			symbol: {
				sprite: '../sprite.svg',
			}
		}	
	}))
	.pipe(dest('../public/svg'))
	.pipe(browserSync.stream());
}