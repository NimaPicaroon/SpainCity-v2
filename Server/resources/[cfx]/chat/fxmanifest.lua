shared_script '@SpainCityAC/waveshield.lua' --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield

 --this line was automatically written by WaveShield





fx_version "adamant"
game "gta5"

ui_page 'html/index.html'

client_script 'client/*.lua'

server_scripts {
  '@mysql-async/lib/MySQL.lua', 
  'server/*.lua'
}

files {
  'html/*.html',
  'html/*.css',
  'html/*js',
  'html/*.png',
  'html/*.otf',
  'html/*.ttf',
  'html/*.TTF',
  'html/Suggestions.js',
  'html/vendor/vue.2.3.3.min.js',
  'html/vendor/flexboxgrid.6.3.1.min.css',
  'html/vendor/animate.3.5.2.min.css',
  'html/vendor/latofonts.css',
  'html/vendor/fonts/*.woff2',
  'html/vendor/fonts/*.ttf',
}