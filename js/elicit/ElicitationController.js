function ElicitationController($scope, DecisionProblem, Jobs) {
    $scope.problem = DecisionProblem;

	var handlers = {
		"ordinal":  new OrdinalElicitationHandler($scope.problem),
		"ratio bound":  new RatioBoundElicitationHandler($scope.problem),
		"choose method": new ChooseMethodHandler(),
		"done": {initialize: function(state) { return _.extend(state, {title: "Done eliciting preferences"}); }  }
	};

    angular.forEach($scope.problem.criteria, function(criterion) { 
        function create(idx1, idx2) {
            return function() { 
				var pvf = criterion.pvf;
                return pvf.type === "linear-increasing" ? pvf.range[idx1] : pvf.range[idx2];
            }
        }
        criterion.worst = create(0, 1);
        criterion.best = create(1, 0);
    });
        
    $scope.currentStep = handlers.ordinal.initialize();

	var previousSteps = [];
	var nextSteps = [];

    $scope.nextStep = function() {
        var currentStep = $scope.currentStep;
        var choice = currentStep.choice;
		var handler = handlers[currentStep.type];
        if(!handler.validChoice(currentStep)) { 
            return false;
        }

		// History handling
		previousSteps.push(angular.copy(currentStep));
		var nextStep = nextSteps.pop();
		if(nextStep && _.isEqual(nextStep.previousChoice, choice)) { 
			$scope.currentStep = nextStep;
			return true;
		} else { 
			nextSteps = [];
		}

		nextStep = handler.nextState(currentStep);
		if (nextStep.type !== currentStep.type) {
			var handler = handlers[nextStep.type];
			nextStep = handler ? handler.initialize(nextStep) : nextStep;
        }
		nextStep.previousChoice = choice;

		$scope.currentStep = nextStep;
        return true;
    }

	$scope.previousStep = function() {
		if (previousSteps.length == 0) return false;
		nextSteps.push(angular.copy($scope.currentStep));
		$scope.currentStep = previousSteps.pop();
		return true;
	}

    $scope.$on('completedAnalysis', function(e, job) {
        $scope.results = job.results;
    });

    $scope.runSMAA = function() {
        var data = { "preferences": {
		  "1": { "type": "ordinal", "criteria": [ "Prox DVT", "Bleed" ] },
		  "2": { "type": "ordinal", "criteria": [ "Bleed", "Dist DVT" ] }
		}}

        var run = function(type) {
            $.ajax({
                url: config.smaaWS + type,
                type: 'POST',
                data: JSON.stringify(data),
                dataType: "json",
                contentType: 'application/json',
                success: function(responseJSON, textStatus, jqXHR) {
                    var job = Jobs.add({
                        data: responseJSON,
                        type: 'run' + type,
                        analysis: 1,
                        broadcast: 'completedAnalysis'
                    });
                    $scope.job = job;
                }
            });
        };
        run('smaa');
    };

	$scope.runSMAA();
};
