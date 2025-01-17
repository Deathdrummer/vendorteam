const domain = 'vendorteam.loc', // прописать домен
  prodDir = '../production/', // директория для продакшн версии
  repoDir = '../../repository/', // директория репозитория
  { src, dest, parallel, series, watch } = require('gulp'),
  browserSync = require('browser-sync').create(),
  order = require('gulp-order'),
  gulpUtil = require('gulp-util'),
  sass = require('gulp-sass')(require('sass')),
  connectPhp = require('gulp-connect-php'),
  concat = require('gulp-concat'),
  uglify = require('gulp-uglify'),
  cleanCSS = require('gulp-clean-css'),
  rename = require('gulp-rename'),
  del = () => import('del'),
  fs = require('fs'),
  cache = require('gulp-cache'),
  autoprefixer = require('gulp-autoprefixer'),
  bourbon = require('node-bourbon').includePaths,
  notify = require('gulp-notify'),
  tinypng = require('gulp-tinypng-compress'),
  cheerio = require('gulp-cheerio'),
  replace = require('gulp-replace'),
  svgSprite = require('gulp-svg-sprite'),
  svgmin = require('gulp-svgmin'),
  babel = require('gulp-babel'),
  args = require('yargs').argv, // gulp t(название функции) --env(переменная) [аргументы]
  dirTree = require('directory-tree'),
  publicDirs = dirTree('../public/views/').children, // директории public
  cssFiles = dirTree('../public/css/').children; // файлы css

sass.compiler = require('node-sass');

// REMOVEDIST
async function removedist() {
  return await del.sync('../' + prodDir, { force: true });
}

// CLEARCACHE
function clearcache() {
  return cache.clearAll();
}

// Отслеживание файлов
function startWatch() {
  var watchDirs = args.dirs != undefined ? args.dirs.split(',') : publicDirs;

  browserSync.init({
    proxy: domain,
    notify: false,
    online: true,
    open: false,
  });

  watch('../public/svg/icons/**/*.svg', svg);

  if (watchDirs) {
    var jsDirs = [];
    watchDirs.forEach(function (dir) {
      var dirName = dir.name || dir;
      watch('../public/css/styles/' + dirName + '.{sass,scss}', sassToCss);
      watch('../public/js/' + dirName + '.js').on('change', browserSync.reload);
      watch(['../public/views/' + dirName + '/**/*.tpl', '!../public/views/' + dirName + '/render/**/*.tpl']).on('change', browserSync.reload);
    });
  } else {
    console.log('startWatch -> Нет директорий для отслеживания файлов!');
  }
}

// Формирование паблик версии
async function build() {
  if (!fs.existsSync(prodDir)) {
    fs.mkdirSync(prodDir);
  }

  fs.writeFileSync(prodDir + 'modifications.json', '');

  src(['../index.php', '../.htaccess']).pipe(dest(prodDir));

  src(['../app/**/*']).pipe(dest(prodDir + '/app'));
  src(['../system/**/*']).pipe(dest(prodDir + '/system'));
  src('../public/css/plugins.min.css').pipe(dest(prodDir + 'public/css'));

  src('../public/js/plugins.min.js').pipe(dest(prodDir + 'public/js'));
  src(['../public/js/assets/common.js', '../public/js/assets/functions.js']).pipe(dest(prodDir + 'public/js/assets'));

  src('../public/fonts/**/*').pipe(dest(prodDir + 'public/fonts'));
  src('../public/images/**/*.svg').pipe(dest(prodDir + 'public/images'));
  src('../public/svg/sprite.svg').pipe(dest(prodDir + 'public/svg'));
  src('../public/filemanager/**/*').pipe(dest(prodDir + 'public/filemanager'));
  

  publicDirs.forEach(function (dir) {
    var dirName = dir.name;
    src(['../public/views/' + dirName + '/**/*.tpl']).pipe(dest(prodDir + 'public/views/' + dirName));
    src('../public/css/' + dirName + '.min.css')
      .pipe(cleanCSS())
      .pipe(dest(prodDir + 'public/css'));
    src('../public/js/' + dirName + '.js')
      .pipe(
        uglify().on('error', function (err) {
          gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
          this.emit('end');
        })
      )
      .pipe(dest(prodDir + 'public/js'));
  });
}

// основные команды: default b repo removedist cfr fr pjr pcr cr afr

exports.default = series(clearcache, parallel(sassToCss, svg), startWatch); // слежение
exports.b = series(clearcache, /*removedist, imagemin,*/ build); // сбилдить в продакшн

exports.repo = buld_from_repository; // сформировать файлы и библиотеки из репозитория

// сформировать отдельные файлы и библиотеки из репозитория
exports.cfr = common_functions_from_repository; // common & functions
exports.fr = fonts_from_repository; // fonts
exports.pjr = plugins_js_from_repository; // plugins js
exports.pcr = plugins_css_from_repository; // plugins css
exports.cr = components_from_repository; // components js
exports.afr = assets_css_from_repository; // assets css

// Сформировать файлы и библиотеки из репозитория
function buld_from_repository(done) {
  src([repoDir + 'components/**/*.tpl']).pipe(dest('../public/components'));

  // common & functions
  src([repoDir + 'js/common.js', repoDir + 'js/functions.js'])
    //.pipe(babel({presets: ['@babel/preset-env'], compact: false}))
    .pipe(
      uglify().on('error', function (err) {
        gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
        this.emit('end');
      })
    )
    .pipe(dest('../public/js'));

  // fonts
  src(repoDir + 'fonts/**/*').pipe(dest('../public/fonts'));

  // plugins js
  src(repoDir + 'js/plugins/**/*.js')
    .pipe(order(['jquery/jquery-3.2.1.min.js', 'jquery/jquery.migrate.js', 'jquery/ui/**/*.js', 'jquery/**/*.js', '**/*.js']))
    .pipe(concat('plugins.min.js'))
    //.pipe(babel({presets: ['@babel/preset-env'], compact: false}))
    .pipe(
      uglify().on('error', function (err) {
        gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
        this.emit('end');
      })
    )
    .pipe(dest('../public/js'));

  // plugins css
  src([repoDir + 'js/plugins/**/*.css'])
    .pipe(concat('plugins.min.css'))
    .pipe(autoprefixer(['> 1%', 'last 10 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'));

  // components js
  src([repoDir + 'components/**/*.js'])
    .pipe(concat('components.min.js'))
    //.pipe(babel({presets: ['@babel/preset-env'], compact: false}))
    .pipe(
      uglify().on('error', function (err) {
        gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
        this.emit('end');
      })
    )
    .pipe(dest('../public/js'));

  // components css
  src(repoDir + 'components/**/*.{sass,scss}')
    .on('end', done)
    .pipe(sass({ includePaths: bourbon }).on('error', notify.onError()))
    .pipe(concat('components.min.css'))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'));

  // assets css
  src(repoDir + 'css/assets/assets.{sass,scss}')
    .on('end', done)
    .pipe(sass({ includePaths: bourbon }).on('error', notify.onError()))
    .pipe(rename({ suffix: '.min', prefix: '' }))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'));
}

// common & functions
function common_functions_from_repository() {
  return (
    src([repoDir + 'js/common.js', repoDir + 'js/functions.js'])
      //.pipe(babel({presets: ['@babel/preset-env'], compact: false}))
      .pipe(
        uglify().on('error', function (err) {
          gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
          this.emit('end');
        })
      )
      .pipe(dest('../public/js'))
  );
}

// fonts
function fonts_from_repository() {
  return src(repoDir + 'fonts/**/*').pipe(dest('../public/fonts'));
}

// plugins js
function plugins_js_from_repository() {
  return (
    src(repoDir + 'js/plugins/**/*.js')
      .pipe(order(['jquery/jquery-3.2.1.min.js', 'jquery/jquery.migrate.js', 'jquery/ui/**/*.js', 'jquery/**/*.js', '**/*.js']))
      //.pipe(babel({presets: ['@babel/preset-env'], compact: false}))
      .pipe(concat('plugins.min.js'))
      .pipe(
        uglify().on('error', function (err) {
          gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
          this.emit('end');
        })
      )
      .pipe(dest('../public/js'))
  );
}

// plugins css
function plugins_css_from_repository() {
  return src([repoDir + 'js/plugins/**/*.css'])
    .pipe(concat('plugins.min.css'))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'));
}

// components css js tpl
function components_from_repository(done) {
  return src([repoDir + 'components/**/*.tpl']).pipe(dest('../public/components'));

  src([repoDir + 'components/**/*.js'])
    .pipe(concat('components.min.js'))
    .pipe(
      uglify().on('error', function (err) {
        gulpUtil.log(gulpUtil.colors.red('[Error]'), err.toString());
        this.emit('end');
      })
    )
    .pipe(dest('../public/js'));

  src(repoDir + 'components/**/*.{sass,scss}')
    .on('end', done)
    .pipe(sass({ includePaths: bourbon }).on('error', notify.onError()))
    .pipe(concat('components.min.css'))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'));
}

// assets css
function assets_css_from_repository(done) {
  return src(repoDir + 'css/assets/assets.{sass,scss}')
    .on('end', done)
    .pipe(sass({ includePaths: bourbon }).on('error', notify.onError()))
    .pipe(rename({ suffix: '.min', prefix: '' }))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(cleanCSS())
    .pipe(dest('../public/css'))
    .pipe(browserSync.stream());
}

// SASS
function sassToCss(done) {
  var sassFiles = [],
    watchDirs = args.dirs != undefined ? args.dirs.split(',') : publicDirs;

  watchDirs.forEach(function (dir) {
    var dirName = dir.name || dir;

    sassFiles.push('../public/css/styles/' + dirName + '.{sass,scss}');
  });

  return src(sassFiles)
    .on('end', done)
    .pipe(sass({ includePaths: bourbon }).on('error', notify.onError()))
    .pipe(rename({ suffix: '.min', prefix: '' }))
    .pipe(autoprefixer(['> 1%', 'last 2 versions', 'Firefox >= 20', 'iOS 7', 'ie 9']))
    .pipe(dest('../public/css/'))
    .pipe(browserSync.stream());
}

// IMAGES
function imagemin() {
  return src('../public/images/**/*.{png,jpg,jpeg,gif,ico}')
    .pipe(
      tinypng({
        key: 'aQsAF4hQiCt4tKRrcqo9E32Mm3FCWFef',
        sigFile: '../public/images/.tinypng-sigs',
        summarize: true,
      })
    )
    .pipe(dest(prodDir + 'public/images'));
}

// SVG
function svg() {
  return src('../public/svg/icons/**/*.svg')
    .pipe(
      svgmin({
        js2svg: { pretty: true },
      })
    )
    .pipe(
      cheerio({
        run: function ($) {
          $('[fill]').removeAttr('fill');
          $('[stroke]').removeAttr('stroke');
          $('[style]').removeAttr('style');
        },
        parserOptions: { xmlMode: true },
      })
    )
    .pipe(replace('&gt;', '>'))
    .pipe(
      svgSprite({
        mode: {
          symbol: {
            sprite: '../sprite.svg',
          },
        },
      })
    )
    .pipe(dest('../public/svg'));
}
