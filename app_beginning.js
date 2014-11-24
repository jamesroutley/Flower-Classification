(function() {
  var app = angular.module('classificationDemo', []);

  
  app.controller('tableCtrl', function(){
    this.rows = flowers;
  });
  
  var flowers = 