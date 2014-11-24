(function() {
  var app = angular.module('classificationDemo', []);

  
  app.controller('tableCtrl', function(){
    this.rows = flowers;
  });
  
  var flowers = [
    {
      flower0: "image_0041.jpg", 
      flower1: "image_0001.jpg", 
      flower2: "image_0175.jpg", 
      flower3: "image_0356.jpg", 
      flower4: "image_0265.jpg", 
      flower5: "image_0103.jpg"
    },
    {
      flower0: "image_0042.jpg", 
      flower1: "image_0002.jpg", 
      flower2: "image_0352.jpg", 
      flower3: "image_0198.jpg", 
      flower4: "image_0265.jpg", 
      flower5: "image_0093.jpg" 
    }
  ];
  
                               
})();