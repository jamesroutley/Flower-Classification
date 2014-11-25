(function() {
  var app = angular.module('classificationDemo', []);

  
  app.controller('tableCtrl', function(){
    this.rows = flowers;
  });
  
  var flowers = [ 
{ 
  flower0: "image_0041.jpg", 
  flower1: "image_0002.jpg",  
