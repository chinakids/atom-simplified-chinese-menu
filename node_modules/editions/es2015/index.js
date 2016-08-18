'use strict';

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

/* @flow */
/* eslint no-console:0 */
// Editions Loader

// Helper class to display nested error in a sensible way

var NestedError = function (_Error) {
	_inherits(NestedError, _Error);

	function NestedError(message /* :string */, parent /* :Error */) {
		_classCallCheck(this, NestedError);

		message += ' due to next parent error';

		var _this = _possibleConstructorReturn(this, Object.getPrototypeOf(NestedError).call(this, message));

		_this.stack += '\n\nParent ' + (parent.stack || parent.message || parent).toString();
		return _this;
	}

	return NestedError;
}(Error);

// Cache of which syntax combinations are supported or unsupported, hash of booleans


var syntaxFailures = {};

/**
 * Cycle through the editions for a package and require the correct one
 * @param {string} cwd - the path of the package, used to load package.json:editions and handle relative edition entry points
 * @param {function} _require - the require method of the calling module, used to ensure require paths remain correct
 * @param {string} [customEntry] - an optional override for the entry of an edition, requires the edition to specify a `directory` property
 * @returns {void}
 */
module.exports.requirePackage = function requirePackage(cwd /* :string */, _require /* :function */, customEntry /* :: ?:string */) /* : void */{
	// Fetch the result of the debug value
	// It is here to allow the environment to change it at runtime as needed
	var debug = process && process.env && process.env.DEBUG_BEVRY_EDITIONS;
	// const blacklist = process && process.env && process.env.DEBUG_BEVRY_IGNORE_BLACKLIST

	// Load the package.json file to fetch `name` for debugging and `editions` for loading
	var pathUtil = require('path');
	var packagePath = pathUtil.join(cwd, 'package.json');

	var _require2 = require(packagePath);

	var name = _require2.name;
	var editions = _require2.editions;
	// name:string, editions:array

	if (!editions || editions.length === 0) {
		throw new Error('No editions have been specified for the package [' + name + ']');
	}

	// Note the last error message
	var lastEditionFailure = void 0;

	// Cycle through the editions
	for (var i = 0; i < editions.length; ++i) {
		// Extract relevant parts out of the edition
		// and generate a lower case, sorted, and joined combination of our syntax for caching
		var _editions$i = editions[i];
		var syntaxes = _editions$i.syntaxes;
		var entry = _editions$i.entry;
		var directory = _editions$i.directory;
		// syntaxes:?array, entry:?string, directory:?string

		// Checks with hard failures to alert the developer

		if (customEntry && !directory) {
			throw new Error('The package [' + name + '] has no directory property on its editions which is required when using custom entry point: ' + customEntry);
		} else if (!entry) {
			throw new Error('The package [' + name + '] has no entry property on its editions which is required when using default entry');
		}

		// Get the correct entry path
		var entryPath = customEntry ? pathUtil.resolve(cwd, directory, customEntry) : pathUtil.resolve(cwd, entry);

		// Convert syntaxes into a sorted lowercase string
		var s = syntaxes && syntaxes.map(function (i) {
			return i.toLowerCase();
		}).sort().join(', ');

		// Is this syntax combination unsupported? If so skip it with a soft failure to try the next edition
		if (s && syntaxFailures[s]) {
			var syntaxFailure = syntaxFailures[s];
			lastEditionFailure = new NestedError('Skipped package [' + name + '] edition at [' + entryPath + '] with blacklisted syntax [' + s + ']', syntaxFailure);
			if (debug) console.error('DEBUG: ' + lastEditionFailure.stack);
			continue;
		}

		// Try and load this syntax combination
		try {
			return _require(entryPath);
		} catch (error) {
			// Note the error with more details
			lastEditionFailure = new NestedError('Unable to load package [' + name + '] edition at [' + entryPath + '] with syntax [' + (s || 'no syntaxes specified') + ']', error);
			if (debug) console.error('DEBUG: ' + lastEditionFailure.stack);

			// Blacklist the combination, even if it may have worked before
			// Perhaps in the future note if that if it did work previously, then we should instruct module owners to be more specific with their syntaxes
			if (s) syntaxFailures[s] = lastEditionFailure;
		}
	}

	// No edition was returned, so there is no suitable edition
	if (!lastEditionFailure) lastEditionFailure = new Error('The package [' + name + '] failed without any actual errors...');
	throw new NestedError('The package [' + name + '] has no suitable edition for this environment', lastEditionFailure);
};