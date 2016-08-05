$(document).ready(function(){

	(function(){
		
		var dependency_array = ["accounting => 0.3.2","airbrake-js-client => 0.5.9","angular-animate => 1.5.8","angular-aria => 1.5.8","angular-bootstrap-toggle-switch => 0.5.6","angular-bootstrap => 2.0.1","angular-cache => 3.2.5","angular-sass-adminlte => 0.0.2","angular-bootstrap-checkbox => 0.4.0","angular-cookies => 1.5.8","angular-filter => 0.5.9","angular-google-maps => 2.3.2","angular-i18n => 1.3.20","angular-loader => 1.5.8","angular-loading-bar => 0.9.0","angular-messages => 1.5.8","angular-mocks => 1.5.8","angular-rangeslider => 0.0.14","angular-recaptcha => 2.2.5","angular-resource => 1.5.8","angular-sanitize => 1.5.8","angular-schema-form => 0.7.13","angular-simple-logger => 0.1.7","angular-slick-carousel => 3.1.7","angular-spectrum-colorpicker => 1.4.5","angular-toastr => 1.7.0","angular-touch => 1.5.8","angular-translate-storage-local => 2.11.1","angular-translate => 2.11.1","angular-ui-calendar => 1.0.2","angular-ui-map => 0.5.0","angular-ui-router => 0.2.18","angular-ui-utils => 0.1.1","angulartics => 0.19.3","angular => 1.5.8","animate.css => 3.5.2","bootstrap-sass => 3.3.7","bootstrap => 3.3.7","es5-shim => 4.1.16","font-awesome => 4.6.3","font-awesome => 4.6.3","fullcalendar-scheduler => 1.3.3","fullcalendar => 2.9.1","iframe-resizer => 3.5.5","jquery => 1.11.3","jquery-ui => 1.11.4","jqueryui-touch-punch => https://github.com/furf/jquery-ui-touch-punch.git","moment-timezone => 0.5.5","moment => 2.14.1","ng-file-upload => 12.0.4","pusher-angular => 0.1.9","objectpath => 1.1.0","pusher => 2.2.4","SHA-1 => 0.1.1","slick-carousel => 1.6.0","sprintf => 1.0.3","spectrum => 1.7.0","trNgGrid => 3.0.4","tv4 => 1.0.17","lodash => 3.10.1","underscore => 1.7.0","ngScrollable => 0.2.5","uri-templates => 0.1.9","ng-idle => 0.3.5","waypoints => 3.1.1","webshim => 1.15.10","ui-select => 0.16.1","ui-router-extras => 0.1.2","angular-translate-loader-partial => 2.11.1","angular-translate-storage-cookie => 2.11.1","SDK => 1.4.44"];
		var keys_pressed = [];		
		var commands = [
			{key_seq: '70,73,68,68,73,67,72', name: 'fiddich'}, // fiddich
			{key_seq: '71,76,69,78,78', name: 'glenn'}, // glenn
			{key_seq: '69,88,73,84', name: 'exit'} // exit
		];
		var active_command = null;
		var sdk_toast_shown = false;
		var deps_shown = false;
		var sdk_desc = dependency_array.pop();

		// ============================
		// Create dependency list...
		// ============================

		var el = $('<div hidden></div>');
		$(el).attr({id: 'bba_sdk_dep_list'});
		$(el).css({
			position: 'fixed',
			display: 'none',
			top: '0px',
			left: '0px',
			width: '100%',
			height: 'auto',
			minHeight: '100%',			
			color: 'white',
			zIndex: 999			
		});		
		$(dependency_array).each(function(k, v){
			var parts = v.split(" ");

			var span_name = $('<span></span>');
			$(span_name).css('color', 'magenta');
			$(span_name).html(parts[0]);

			var span_version = $('<span></span>');
			$(span_version).css('color', 'green');
			$(span_version).html(parts[2]);

			var div = $('<div></div>')
			$(div).css({				
				transformOrigin: '0 0',
				background: '#000',
				opacity:' .9',
				padding: '5px',
				transition: 'all 1s'
			});			
			$(div).append(span_name).append(" | ").append(span_version);
			$(div).appendTo(el);
		});

		$(el).on('click', function(e){
			if(!active_command && commands[0].name == "exit"){				
				setCommand(commands[0]);
			}
			processRequest(e);			
		});
		
		$(document.body).append(el);

		// ======================
		// Create SDK toast...
		// ======================

		var toast = $('<div></div>');
		$(toast).attr('id', 'bba_sdk_toast');
		$(toast).css({
			position: 'fixed',
			top: '150%',
			right: '0px',
			padding: '10px 10px 0px 10px',
			background: '#5bbaf0',
			color: '#fff',
			boxShadow: '-2px -2px 25px #999',
			userSelect: 'none',
			webkitUserSelect: 'none',
			cursor: 'default',
			zIndex: 998,
			fontWeight: 'bold',
			transformOrigin: 'right bottom'		
		});		
		$(toast).bind('mousedown mouseout mouseleave click', function(e){
			if(e.type == "mousedown"){
				$(this).css({transform: 'scale(.95, .95)'});
			}else{
				$(this).css({transform: 'scale(1, 1)'});
			}
			if(e.type == "click"){				
				if(!active_command && commands[0].name == "glenn"){
					setCommand(commands[0]);
				}
				processRequest(e);
			}				
		});

		var title = $('<h1>SDK v</h1>');
		$(title).css({textTransform: 'none', fontWeight: 'bold', color: '#fff'});
		$(title).html("SDK v" + sdk_desc.split(" ")[2]);
		var img = $('<img />');
		$(img).attr(({draggable: 'false', ondragstart: 'return false'}));
		$(img).css({height: '200px', width: 'auto'});
		$(img).attr('src', 'images/bug.png');
		$(toast).append(title).append(img);
		
		$(document.body).append(toast);

		var isValidRequest = function(e){
			var key = e.which || e.keyCode || e.charCode;
			keys_pressed.push(key);
			var command = commands[0];
			var pattern = new RegExp("^" + keys_pressed.join());			
			if(command.key_seq.match(pattern)){
				// continue building sequence...				
			}else{
				// reset...				
				var last_key_pressed_pattern = new RegExp("^" + keys_pressed.pop());
				if(command.key_seq.match(last_key_pressed_pattern)){					
				    // if the last key pressed matches the first key in the sequence
				    // do not discard this key!					
					keys_pressed = [keys_pressed[0]];
				}else{
					keys_pressed = [];
				}				
			}
			if(command.key_seq === keys_pressed.join()){		
				setCommand(command);
			}
			return active_command;
		};

		var setCommand = function(cmd){
			active_command = cmd;
			commands.push(commands.shift());
			keys_pressed = [];
		}

		// \/\/\/\/\/\/\/
		// explosionJS
		// \/\/\/\/\/\/\/

		var explosionJS = {
			explode: function(){
				window.scrollTo(0, 0);
				$('#bba_sdk_dep_list').css({position: 'fixed'});
				var els = $('#bba_sdk_dep_list div');
				var max_delay = 1000;		
				$(els).each(function(key, val){
					delay = Math.floor(Math.random() * max_delay);					
					$(val).css({transition: 'all 1s'});				
					explosionJS.exit(val, delay);						
				});
				setTimeout(function(){
					$('#bba_sdk_dep_list').attr({hidden: 'hidden'});
					$('#bba_sdk_dep_list').css('display', 'none');
					$('body').css({overflowX: 'auto'});				
				}, max_delay + 330);

				$('#bba_sdk_toast').animate({top: '150%'}, 250);
				
			},
			exit: function(el, del){
				setTimeout(function(){				
					var top = Math.floor(Math.random() * 500);
					var deg = Math.floor(Math.random() * 20);
					var toggle = Math.round(Math.random());
					if(toggle == 1){
						top = top - (top * 2);
						deg = deg - (deg * 2);
					}						
					$(el).css({transform: 'translate(100%, ' + top + 'px) scale(4, 4) rotate(' + deg + 'deg)'});				
				}, del);				
			},
			enter: function(){
				var els = $('#bba_sdk_dep_list div');
				els.each(function(key, el){
					var top = Math.floor(Math.random() * 500);
					var deg = Math.floor(Math.random() * 20);
					var toggle = Math.round(Math.random());
					if(toggle == 1){
						top = top - (top * 2);
						deg = deg - (deg * 2);
					}						
					$(el).css({transition: 'all 0s', transform: 'translate(100%, ' + top + 'px) scale(4, 4) rotate(' + deg + 'deg)'});
				});
				setTimeout(function(){
					var els = $('#bba_sdk_dep_list div');
					els.each(function(key, el){
						$(el).css({transition: 'all 1s', transform: 'translate(0%, 0%) scale(1, 1) rotate(0deg)'});						
					});
				}, 20);
				setTimeout(function(){
					$('body').css({overflowX: 'hidden'});
					$('#bba_sdk_dep_list').css({position: 'absolute'});
				}, 1020);
			}
		}

		var showDeps = function(){			
			$('#bba_sdk_dep_list').removeAttr('hidden');
			$('#bba_sdk_dep_list').css('display', 'block');
			explosionJS.enter();
			deps_shown = true;
		};

		var showSDK = function(){			
			var top = $(window).innerHeight() - $('#bba_sdk_toast').innerHeight();
			$('#bba_sdk_toast').animate({top: top + 'px'}, 250);
			sdk_toast_shown = true;			
		}

		var explodify = function(){
			explosionJS.explode();
		}		

		var processRequest = function(e){
			var can_show = e.type == "click" || isValidRequest(e);			
			if(can_show){				
				switch(active_command.name){
					case "fiddich": showSDK(); active_command = null; break;
					case "glenn": showDeps(); active_command = null; break;
					case "exit": explodify(); active_command = null; break;
				}
			}	
		}

		// ======================================
		// Listen for key presses on the window
		// ======================================
		$(window).on('keydown', function(e){			
			processRequest(e);
		});

	})();

});
