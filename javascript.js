$( document ).ready(function() {
// Get Full List of States and place in select list
	$.ajax({
		url: 'actions.pl',
		data: {ajaxAction:"get_states"},
		async: false,
		success: function(result) {
			$.each(result, function(index,state) {   
				$('#stateslist')
				.append($("<option></option>")
                    .attr("value",state)
					.attr("id",state)
                    .text(state)
				); 
			});
		}
	});
// Get list of visited and place in table
	$.ajax({
		url: 'actions.pl',
		data: {ajaxAction:"get_visited"},
		success: function(result) {
			buildList(result);
			$.each(result, function(index,state) {   
				$('#'+state).attr("disabled","true"); 
				});
		}
	});

// change display after adding a state	
	var choice = $('#stateslist').val();
		if (choice === "Select A State") {
			$('#astate').css("visibility", "hidden");
		}
	$('#stateslist').on('change', function() {
		var choice = $('#stateslist').val();
		if (choice === "Select A State") {
			$('#astate').css("visibility", "hidden");
		} else {
			$('#astate').css("visibility", "visible");
		}
	});
	
	$('#astate').on('click', function() {
		var choice = $('#stateslist').val();
		if (choice !== "Select A State") {
			$.ajax({
				url: 'actions.pl',
				data: {ajaxAction:"add_state", state:choice},
				success: function(result) {
					buildList(result);
				$('#'+choice).attr("disabled","true");
				}
			});
		}
		$('#stateslist').val("Select A State");
		$('#astate').css("visibility", "hidden");
	});

// change display after removing a state	
	var choice = $('#removelist').val();
		if (choice === "Remove A State") {
			hideRemove();
		}
	$('#removelist').on('change', function() {
		var choice = $('#removelist').val();
		if (choice !== "Remove A State") {
			showRemove();
		} else {
			hideRemove();
		}
	});
	
	$('#rstate').on('click', function() {
		var choice = $('#removelist').val();
		if (choice !== "Remove A State") {
			$.ajax({
				url: 'actions.pl',
				data: {ajaxAction:"remove_state", state:choice},
				success: function(result) {
					buildList(result);
				$('#'+choice).removeAttr("disabled","true");
				}
			});
		}
	});
	$('#cstates').on('click', function() {
		var choice = $('#removelist').val();
		if (choice !== "Remove A State") {
			$("option").removeAttr("disabled","true");
			$.ajax({
				url: 'actions.pl',
				data: {ajaxAction:"clear_visited", state:choice},
				success: function(result) {
					buildList(result);
				}
			});
		}
	});

});




//Custom Made Functions

// buildList -- get list of visited states and display them.

function hideRemove() {
	$('#rstate').css("display", "none");
	$('#cstates').css("visibility", "hidden");
}

function showRemove() {
	$('#rstate').css("display", "initial");
	$('#cstates').css("visibility", "visible");
}

function buildList(result) {
	$('#visitedTable').html('');
	$('#removelist').html('');
	$('#removelist')
		.append($("<option></option>")
            .attr("value","Remove A State")
           .text("Select A State")); 

	if (result.length) {
		$.each(result, function(index,state) {   
			$('#visitedTable')
			.append($("<li></li>")
			.text(state)); 
			$('#removelist')
				.append($("<option></option>")
                    .attr("value",state)
                    .text(state)); 
		});
		$('#lower_display').css("visibility", "visible");
		var choice = $('#removelist').val();
		if (choice !== "Remove A State") {
			showRemove();
		} else {
			hideRemove();
		}

	} else {
		hideRemove();
		$('#lower_display').css("visibility", "hidden");
	}
}


