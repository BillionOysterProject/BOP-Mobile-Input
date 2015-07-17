//ref: http://stackoverflow.com/a/21552131/756177
angular.module('app.example').directive("dynamicName", function($compile) {
  return {
    restrict: "A",
    terminal: true,
    priority: 1000,
    link: function(scope, element, attrs) {
      var name = scope.$eval(attrs.dynamicName);
      if (name) {
        element.attr('name', name);
        element.removeAttr("dynamic-name");
        $compile(element)(scope);
      }
    }
  };
});