/**
 * Extension to Array that allows for elements to be removed
 * Developed by John Resig
 */
Array.prototype.remove = function(from, to) {
	// Uses an || statement to check if 'to' is being passed, this allows for 1 or 2 parameters
	// The second || is used if a negative number is given
	var rest = this.slice((to || from) + 1 || this.length);
	this.length = from < 0 ? this.length + from : from;
	return this.push.apply(this, rest);
};

/**
 * Method to update isSilene value in database
 */
function updateSelection(id) {
    $.getJSON('/_update_isSilene', {
        sentValue: $('#id_'+id+' :selected').val(),
        sentId: id
    });
}

/**
 * Gets the arguments within the url
 */
function getUrlVars() {
    var vars = {};
    var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
        function(m, keys, value) {
            vars[keys] = value;
        });
    return vars;
}

