###
grunt-coffee-redux

Copyright (c) 2013 Moritz Heuser, contributors
Licensed under the MIT license.
###

module.exports = (grunt)->

  grunt.initConfig
    pkg: grunt.file.readJSON("package.json")
    meta:
      version: "<%= pkg.version %>"
      banner: "/*! PROJECT_NAME - v<%= meta.version %> - " +
            "<%= grunt.template.today(\"yyyy-mm-dd\") %>\n" +
            "* http://s-arcadia.wkeya.com/\n" +
            "* Copyright (c) <%= grunt.template.today(\"yyyy\") %> " +
            "yuggr; Licensed MIT */"
    clean:
      tests: [
        'public'
      ]

    less:
      target:["app/styles/app.less"]
      development:
        options:
          paths: ["app/css"]

        files:
          "public/css/app.css":"<%= less.target %>"

      production:
        options:
          paths: ["app/css"]
          yuicompress: true
          optimization:3

        files:
          "public/css/app.min.css":"<%= less.target %>"

    coffee:
      options:
        bare:true
      app:
        expand: true,
        src: '**/*.coffee'
        dest: 'public/js/'
        cwd: 'app/coffee/'
        ext: '.js'

      appAll:
        src:[
            'app/coffee/init.coffee'
            'app/coffee/app.coffee'
            'app/coffee/controllers.coffee'
            'app/coffee/directives.coffee'
            'app/coffee/filters.coffee'
            'app/coffee/services.coffee'
          ]
        dest:'public/js/main.js'

      test:
        expand: true,
        src: '**/*.coffee'
        dest: 'test/unit/'
        cwd: 'test/unit/coffee/'
        ext: '.js'

      e2e:
        expand: true,
        src: '**/*.coffee'
        dest: 'test/e2e/'
        cwd: 'test/e2e/'
        ext: '.js'

    concat:
      options:
        separator: ";"
        stripBanners: true
        banner: "<%= meta.banner %>"

      vendor:
        src:[
          'app/lib/console-helper.js'
          'app/lib/angular/i18n/angular-locale_ja-jp.js'
          'app/lib/angular/angular-cookies.js'
          'app/lib/angular/angular-loader.js'
          'app/lib/angular/angular-resource.js'
          'app/lib/angular/angular-sanitize.js'
          'app/lib/select2.js'
          'app/lib/angular/angular-ui.js'
          'app/lib/sha512.js'
        ]
        dest:'public/lib/vendor.js'

    uglify:
      options:
        sourceMapRoot:'/'
      dist:
        options:
          sourceMap: 'public/js/main.min.js.map'
          sourceMappingURL: '/js/main.min.js.map'
          banner: '/*! <%= pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %> */'

        files:
          'public/js/main.min.js':[
            'public/js/app.js'
            'public/js/controllers.js'
            'public/js/directives.js'
            'public/js/filters.js'
            'public/js/services.js'
            'public/js/init.js'
          ]
        # src: ["<banner:meta.banner>", "<config:concat.app.dest>"]
        # dest: "<%= grunt.config(\"concat\").app.dest.replace(/js$/, \"min.js\") %>"

      vendor:
        options:
          sourceMap: 'public/lib/vendor.min.js.map'
          sourceMappingURL:'/lib/vendor.min.js.map'

        files:
          'public/lib/vendor.min.js':[
            'app/lib/console-helper.js'
            'app/lib/angular/i18n/angular-locale_ja-jp.js'
            'app/lib/angular/angular-cookies.js'
            'app/lib/angular/angular-loader.js'
            'app/lib/angular/angular-resource.js'
            'app/lib/angular/angular-sanitize.js'
            'app/lib/select2.js'
            'app/lib/angular/angular-ui.js'
            'app/lib/sha512.js'
          ]
          # dest: 'public/lib/vendor.min.js'
          # "<%= grunt.config(\"concat\").vendor.dest.replace(/js$/, \"min.js\") %>"

    reload:
      port: 35729
      liveReload:{}
      proxy:
        host: 'search-arcadia.jp'
        port: 9999

    copy:
      html:
        files: [
            {
              expand: true
              cwd: 'app/font/'
              dest:'public/font/',src:['**']
            }
            {
              expand: true
              cwd: 'app/img/'
              dest:'public/img/',src:['**']
            }
            {
              expand: true
              cwd: 'app/partials/'
              dest:'public/partials/'
              src:['**']
            }
            {
              expand: true
              cwd: 'app/data'
              dest:'public/data/',src:['**']
            }
            {
              expand: true
              cwd: 'app/'
              dest:'public/'
              src:[
                'index.html'
                'favicon.ico'
                '.htaccess'
              ]
            }
        ]

      php:
        files: [
            {expand: true, cwd: 'app/php/',src: ['**'], dest: 'public/php/'}
        ]

      lib:
        target:[
          'app/lib/jquery-*.min.js'
          'app/lib/angular/angular.min.js'
          'app/lib/bootstrap/bootstrap.min.js'
        ]
        files:[
          {
            expand: true,
            cwd: 'app/lib/',
            src: [
              'jquery-*.min.js'
              'angular/angular.min.js'
              'bootstrap/bootstrap.min.js'
            ],
            dest: 'public/lib/'
          }
        ]

    watch:
      coffee:
        files: [
          "<%= coffee.appAll.src %>",
        ]
        tasks: "coffee:app"

      coffeeTest:
        files: [
          "<%= coffee.test.cwd %><%= coffee.test.src %>"
        ]
        tasks: "coffee:test"

      coffeeE2E:
        files: [
          "<%= coffee.e2e.cwd %><%= coffee.e2e.src %>"
        ]
        tasks: "coffee:e2e"

      less:
        files: [
          "<%= less.target %>"
          "app/styles/themes/custom/**"
        ]
        tasks: "less"

      copy:
        files:[
          'app/font/**'
          'app/img/**'
          'app/partials/**'
          'app/**.html'
          'app/db/**'
          'app/data/**'
        ]
        tasks: "copy:html"

      php:
        files:[
          'app/php/application/**',
          'app/php/tests/**'
        ]
        tasks: "copy:php"
        options:
          interrupt: true

  grunt.loadNpmTasks task for task in [
    'grunt-contrib-watch'
    'grunt-contrib'
    'grunt-reload'
  ]

  grunt.registerTask 'develop', [
    'clean' , 'coffee' , 'copy' , 'less' ,
    'concat' , 'uglify' , 'reload' ,'watch'
  ]
  grunt.registerTask 'production', [
    'clean' , 'coffee' , 'copy' , 'less' ,
    'concat' , 'uglify'
  ]
  grunt.registerTask 'default', ['develop']
