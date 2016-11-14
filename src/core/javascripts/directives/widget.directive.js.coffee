'use strict'

###**
* @ngdoc directive
* @name BB.Directives:bbWidget
* @restrict A
* @scope
*   client: '=?'
*   apiUrl: '@?'
*   useParent:'='
* @description
*
* Loads a list of widgets for the currently in scope company
*
* <pre>
* restrict: 'A'
* scope:
*   client: '=?'
*   apiUrl: '@?'
*   useParent:'='
* transclude: true
* </pre>
*
* @param {hash} bbWidget A hash of options
* @property {string} pusher The pusher
* @property {string} pusher_channel The pusher channel
* @property {string} init_params Initialization of basic parameters
### 
angular.module('BB.Directives').directive 'bbWidget', (PathSvc, $http, $log, $templateCache, $compile, $q, AppConfig, $timeout, $bbug, $rootScope, AppService) ->

  ###**
  * @ngdoc method
  * @name getTemplate
  * @methodOf BB.Directives:bbWidget
  * @description
  * Get template
  *
  * @param {object} template The template
  ###
  getTemplate = (template) ->
    partial = if template then template else 'main'
    fromTemplateCache = $templateCache.get(partial)
    if fromTemplateCache
      fromTemplateCache
    else
      src = PathSvc.directivePartial(partial).$$unwrapTrustedValue()
      $http.get(src, {cache: $templateCache}).then (response) ->
        response.data

  ###**
  * @ngdoc method
  * @name updatePartials
  * @methodOf BB.Directives:bbWidget
  * @description
  * Update partials
  *
  * @param {object} prms The parameter
  ###
  updatePartials = (scope, element, prms) ->
    $bbug(i).remove() for i in element.children() when $bbug(i).hasClass('custom_partial')
    appendCustomPartials(scope, element, prms).then () ->
      scope.$broadcast('refreshPage')

  ###**
  * @ngdoc method
  * @name setupPusher
  * @methodOf BB.Directives:bbWidget
  * @description
  * Push setup
  *
  * @param {object} prms The parameter
  ###
  setupPusher = (scope, element, prms) ->
    $timeout () ->
      scope.pusher = new Pusher('c8d8cea659cc46060608')
      scope.pusher_channel = scope.pusher.subscribe("widget_#{prms.design_id}")
      scope.pusher_channel.bind 'update', (data) ->
        updatePartials(scope, element, prms)

  ###**
  * @ngdoc method
  * @name appendCustomPartials
  * @methodOf BB.Directives:bbWidget
  * @description
  * Appent custom partials
  *
  * @param {object} prms The parameter
  ###
  appendCustomPartials = (scope, element, prms) ->
    defer = $q.defer()
    $http.get(prms.custom_partial_url).then (custom_templates) ->
      $compile(custom_templates.data) scope, (custom, scope) ->
        custom.addClass('custom_partial')
        style = (tag for tag in custom when tag.tagName == "STYLE")
        non_style = (tag for tag in custom when tag.tagName != "STYLE")
        $bbug("#widget_#{prms.design_id}").html(non_style)
        element.append(style)
        scope.bb.path_setup = true
        defer.resolve(style)
    defer.promise

  ###**
  * @ngdoc method
  * @name renderTemplate
  * @methodOf BB.Directives:bbWidget
  * @description
  * Render template
  *
  * @param {object} design_mode The design mode
  * @param {object} template The template
  ###
  renderTemplate = (scope, element, design_mode, template) ->
    $q.when(getTemplate(template)).then (template) ->
      element.html(template).show()
      element.append('<style widget_css scoped></style>') if design_mode
      $compile(element.contents())(scope)

  link = (scope, element, attrs, controller, transclude) ->
    scope.client = attrs.member if attrs.member?
    evaluator = scope
    if scope.useParent && scope.$parent?
      evaluator = scope.$parent
    init_params = evaluator.$eval(attrs.bbWidget)
    scope.initWidget(init_params)
    $rootScope.widget_started.then () =>
      prms = scope.bb
      if prms.custom_partial_url
        prms.design_id = prms.custom_partial_url.match(/^.*\/(.*?)$/)[1]
        $bbug("[ng-app='BB']").append("<div id='widget_#{prms.design_id}'></div>")
      if scope.bb.partial_url
        if init_params.partial_url
          AppConfig['partial_url'] = init_params.partial_url
        else
          AppConfig['partial_url'] = scope.bb.partial_url

      transclude scope, (clone) => # if there's content or not whitespace
        scope.has_content = clone.length > 1 || (clone.length == 1 && (!clone[0].wholeText || /\S/.test(clone[0].wholeText)))
        if !scope.has_content
          if prms.custom_partial_url
            appendCustomPartials(scope, element, prms).then (style) ->
              $q.when(getTemplate()).then (template) ->
                element.html(template).show()
                $compile(element.contents())(scope)
                element.append(style)
                setupPusher(scope, element, prms) if prms.update_design
          else if prms.template
            renderTemplate(scope, element, prms.design_mode, prms.template)
          else
            renderTemplate(scope, element, prms.design_mode)
          scope.$on 'refreshPage', () ->
            renderTemplate(scope, element, prms.design_mode)
        else if prms.custom_partial_url
          appendCustomPartials(scope, element, prms)
          setupPusher(scope, element, prms) if prms.update_design
          scope.$on 'refreshPage', () ->
            scope.showPage scope.bb.current_page
        else
          element.html(clone).show()
          element.append('<style widget_css scoped></style>') if prms.design_mode

    notInModal = (p) ->
      if p.length == 0 || p[0].attributes == undefined
        true
      else if p[0].attributes['uib-modal-window'] != undefined
        false
      else
        if p.parent().length == 0
          true
        else
          notInModal(p.parent())

    scope.$watch () ->
      AppService.isModalOpen()
    , (modalOpen) ->
      scope.coveredByModal = modalOpen && notInModal(element.parent())
    return

  return {
    restrict: 'A'
    scope:
      client: '=?'
      apiUrl: '@?'
      useParent: '='
    transclude: true
    controller: 'BBCtrl'
    link: link
  }