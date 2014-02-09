angular.module("myApp.directives", [])
.directive("appVersion", ["version", (version) ->
  (scope, elm, attrs) ->
    elm.text version
])
.directive("fadey",[ ()=>
    return {
      restrict: 'A',
      link: (scope, elm, attrs) ->
          duration = parseInt(attrs.fadey)
          if (isNaN(duration))
              duration = 500;

          elm = jQuery(elm);
          elm.addClass('ui-animate').slideDown(duration, ()=>
            elm.removeClass('ui-animate');
          )
          timeout = 1500
          setTimeout(
            =>
              elm.addClass('ui-animate-out').slideUp(duration)
            ,timeout)
    }
])