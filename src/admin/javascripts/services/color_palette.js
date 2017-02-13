// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('BBAdmin.Services').factory('ColorPalette', function() {

  let colors = [
    {primary: '#001F3F', secondary: '#80BFFF'}, // Navy
    {primary: '#FF4136', secondary: '#800600'}, // Red
    {primary: '#7FDBFF', secondary: '#004966'}, // Aqua
    {primary: '#3D9970', secondary: '#163728'}, // Olive
    {primary: '#85144B', secondary: '#EB7AB1'}, // Maroon
    {primary: '#2ECC40', secondary: '#0E3E14'}, // Green
    {primary: '#FF851B', secondary: '#663000'} // Orange
  ];

  return {
    setColors(models) {
      return _.each(models, function(model, i) {
        let color = colors[i % colors.length];
        model.color = color.primary;
        return model.textColor = color.secondary;
      });
    }
  };
});

