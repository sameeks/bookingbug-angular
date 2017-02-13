// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
angular.module('schemaForm').config(function(schemaFormProvider,
    schemaFormDecoratorsProvider, sfPathProvider) {

  let timepicker = function(name, schema, options) {
    if ((schema.type === 'string') && (schema.format === 'time')) {
      let f = schemaFormProvider.stdFormObj(name, schema, options);
      f.key = options.path;
      f.type = 'timepicker';
      options.lookup[sfPathProvider.stringify(options.path)] = f;
      return f;
    }
  };

  schemaFormProvider.defaults.string.unshift(timepicker);

  let datetimepicker = function(name, schema, options) {
    if ((schema.type === 'string') && (schema.format === 'datetime')) {
      let f = schemaFormProvider.stdFormObj(name, schema, options);
      f.key = options.path;
      f.type = 'datetime';
      options.lookup[sfPathProvider.stringify(options.path)] = f;
      return f;
    }
  };

  schemaFormProvider.defaults.string.unshift(datetimepicker);

  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'time',
    'bootstrap_ui_time_form.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'time',
    'bootstrap_ui_time_form.html'
  );

  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'datetime',
    'bootstrap_ui_datetime_form.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'datetime',
    'bootstrap_ui_datetime_form.html'
  );

  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'price',
    'price_form.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'price',
    'price_form.html'
  );

  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'date',
    'date_form.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'date',
    'date_form.html'
  );


  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'radios',
    'radios.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'radios',
    'radios.html'
  );
  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'radios-inline',
    'radios-inline.html'
  );

  schemaFormDecoratorsProvider.createDirective(
    'radios-inline',
    'radios-inline.html'
  );
  schemaFormDecoratorsProvider.addMapping(
    'bootstrapDecorator',
    'radiobuttons',
    'radio-buttons.html'
  );

  return schemaFormDecoratorsProvider.createDirective(
    'radiobuttons',
    'radio-buttons.html'
  );
});

