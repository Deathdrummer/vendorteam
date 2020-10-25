const 	domain			= 'vendorteam.loc', // прописать домен
		prodDir			= 'production', // директория для продакшн версии

		gulp           	= require('gulp'),
		gulpUtil      	= require('gulp-util'),
		sass           	= require('gulp-sass'),
		browserSync    	= require('browser-sync'),
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







// LIVE REMOVEDIST CLEARCACHE
gulp.task('livereload', () => {connectPhp.server({}, function () {browserSync({proxy: domain, notify: false, open: false});});});
gulp.task('removedist', function() { return del.sync('../'+prodDir, {force: true}); });
gulp.task('clearcache', function () { return cache.clearAll(); });




// Отслеживание файлов
gulp.task('watch', ['clearcache', 'livereload', 'plugins.css', 'plugins.js', 'sass', 'svg'], () => {
	var watchDirs = args.dirs != undefined ? args.dirs.split(',') : publicDirs;
	
	gulp.watch('../public/svg/icons/**/*.svg', ['svg']);
	gulp.watch(['../public/css/assets/**/*.{sass,scss}', '../public/css/libraries/**/*.{sass,scss}', '../public/css/styles/*.{sass,scss}'], ['sass']);
	gulp.watch('../public/js/plugins/**/*.css', ['plugins.css']);
	gulp.watch(['../public/js/assets/**/*.js', '!../public/js/assets/plugins.min.js'], ['plugins.js']);
	
	if (watchDirs) {
		var jsDirs = [];
		watchDirs.forEach(function(dir) {
			var dirName = dir.name || dir;
			gulp.watch('../public/js/'+dirName+'.js', browserSync.reload);	
			gulp.watch(['../public/views/'+dirName+'/**/*.tpl'], browserSync.reload);
		});
	} else {
		console.log('Нет директорий для отслеживания файлов!');
	}
});





// Формирование паблик версии
gulp.task('build', ['removedist', 'clearcache', 'imagemin', 'sass', 'plugins.css', 'plugins.js', 'svg'], () => {
	gulp.src(['../app/**/*']).pipe(gulp.dest('../'+prodDir+'/app'));
	gulp.src(['../system/**/*']).pipe(gulp.dest('../'+prodDir+'/system'));
	gulp.src(['../index.php', '../.htaccess']).pipe(gulp.dest('../'+prodDir));
	gulp.src('../public/css/plugins.min.css').pipe(cleanCSS()).pipe(gulp.dest('../'+prodDir+'/public/css'));
	gulp.src('../public/js/plugins.min.js')
	.pipe(uglify().on('error', function(err) {
		gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
		this.emit('end');
	}))
	.pipe(gulp.dest('../'+prodDir+'/public/js'));
	
	gulp.src(['../public/js/assets/common.js', '../public/js/assets/functions.js'])
	.pipe(uglify().on('error', function(err) {
		gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
		this.emit('end');
	}))
	.pipe(gulp.dest('../'+prodDir+'/public/js/assets'));
	
	gulp.src('../public/fonts/**/*').pipe(gulp.dest('../'+prodDir+'/public/fonts'));
	gulp.src('../public/images/**/*.svg').pipe(gulp.dest('../'+prodDir+'/public/images'));
	gulp.src('../public/svg/sprite.svg').pipe(gulp.dest('../'+prodDir+'/public/svg'));
	gulp.src('../public/filemanager/**/*').pipe(gulp.dest('../'+prodDir+'/public/filemanager'));
	
	
	publicDirs.forEach(function(dir) {
		var dirName = dir.name;
		
		gulp.src(['../public/views/'+dirName+'/**/*.tpl']).pipe(gulp.dest('../'+prodDir+'/public/views/'+dirName));
		gulp.src('../public/css/'+dirName+'.min.css').pipe(cleanCSS()).pipe(gulp.dest('../'+prodDir+'/public/css/'));
		gulp.src('../public/js/'+dirName+'.js')
		.pipe(uglify().on('error', function(err) {
			gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
			this.emit('end');
		}))
		.pipe(gulp.dest('../'+prodDir+'/public/js'));
	});
});




gulp.task('b', ['build']);
gulp.task('default', ['watch']);










//-------------------------------------------------------------------------------------------------------------





// JS Скрипты: js
gulp.task('plugins.js', () => {
	return gulp.src([
		'../public/js/assets/plugins/jquery/jquery-3.2.1.min.js',
		'../public/js/assets/plugins/jquery/jquery.migrate.js',
		'../public/js/assets/plugins/jquery/ui/**/*.js',
		'../public/js/assets/plugins/jquery/**/*.js',
		'../public/js/assets/plugins/**/*.js'
	])
	.pipe(concat('plugins.min.js'))
	.pipe(gulp.dest('../public/js'))
	.pipe(browserSync.reload({stream: true}));
});


// JS Скрипты: css
gulp.task('plugins.css', () => {
	return gulp.src([
		'../public/js/assets/plugins/**/*.css'
	])
	.pipe(concat('plugins.min.css'))
	.pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
	.pipe(gulp.dest('../public/css'))
	.pipe(browserSync.reload({stream: true}));
});




// SASS
gulp.task('sass', () => {
	var sassFiles = [];
	publicDirs.forEach(function(dir) {sassFiles.push('../public/css/styles/'+dir.name+'.sass');});	
	
	return gulp.src(sassFiles)
	.pipe(sass({includePaths: bourbon.includePaths}).on("error", notify.onError()))
	.pipe(rename({suffix: '.min', prefix : ''}))
	.pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
	.pipe(gulp.dest('../public/css/'))
	.pipe(browserSync.reload({stream: true}));
});




// IMAGES
gulp.task('imagemin', () => {
	return gulp.src('../public/images/**/*.{png,jpg,jpeg,gif,ico}')
	.pipe(tinypng({
		key: 'aQsAF4hQiCt4tKRrcqo9E32Mm3FCWFef',
		sigFile: '../public/images/.tinypng-sigs',
		summarize: true,
	}))
	.pipe(gulp.dest('../'+prodDir+'/public/images'));
});




// SVG
gulp.task('svg', () => {
	return gulp.src('../public/svg/icons/**/*.svg')
	.pipe(svgmin({
		js2svg: {pretty: true}	
	}))
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
	.pipe(gulp.dest('../public/svg'));
});