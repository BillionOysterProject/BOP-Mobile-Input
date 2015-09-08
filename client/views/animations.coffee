angular.module('app.example')
.animation('.slide-left', [
	"$animateCss"
	($animateCss)->
		duration = .25

		return {
			enter: (element, doneFn) ->
				$animateCss element,
					easing: 'ease-out'
					from:
						left:'100%'
					to:
						left:0
					duration: duration

			leave: (element, doneFn) ->
				$animateCss element,
					easing: 'ease-out'
					from:
						left:0
					to:
						left:'100%'
					duration: duration
		}
])

.animation('.slide-right', [
	"$animateCss"
	($animateCss)->
		duration = .25

		return {
			enter: (element, doneFn) ->
				$animateCss element,
					easing: 'ease-out'
					from:
						left:'-100%'
					to:
						left:0
					duration: duration

			leave: (element, doneFn) ->
				$animateCss element,
					easing: 'ease-out'
					from:
						left:0
					to:
						left:'-100%'
					duration: duration
		}
])