"use strict";
/*
 * Manage faceted search interface for hoaxed
*/

document.addEventListener('DOMContentLoaded', (e) => {
    /* Attach event listeners to publishers 
       Resubmit the form on every checkbox change, but text input requires manual "Submit" press*/
    var publishers = document.querySelectorAll('#publishers input');
    for (var i = 0, length = publishers.length; i < length; i++) {
        publishers[i].addEventListener('change',process_publisher_check, false);
    }
    document.getElementById('clear-form').addEventListener('click', clear_form, false);
    var ghost_ref_pointers = document.getElementsByClassName('ghost-reference');
    for (var i = 0, length = ghost_ref_pointers.length; i < length; i++) {
        ghost_ref_pointers[i].addEventListener('change', toggle_ref_highlight, false);
    }
},
false);
/*
 * Resubmit form on every publisher check
 */
function process_publisher_check() {
    document.getElementById('submit').click();
}
function clear_checked_children(target) {
    /*
    * Clear all checked children
    * Fire click event to clear instead of just unchecking:
    * https://stackoverflow.com/questions/8206565/check-uncheck-checkbox-with-javascript
    */
    var children = target.parentElement.parentElement.parentElement.querySelectorAll('input');
    for (var i = 0, length = children.length; i < length; i++) {
        children[i].checked = false;
    }
}
function clear_form() {
    window.location.href="search";
}